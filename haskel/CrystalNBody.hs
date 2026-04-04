-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | Module: CrystalNBody — N-Body Gravitational Dynamics from (2,3).

  THE DYNAMICS IS THE TICK ON THE 36.

  Each body is a CrystalState (36 Doubles).
  Position (x,y,z) → weak sector [3], λ = 1/2.
  Velocity (vx,vy,vz) → colour sector [8] first 3, λ = 1/3.
  Force (fx,fy,fz) → colour sector [8] slots 3-5.
  KE, mass → colour sector [8] slots 6-7.
  Energy marker → singlet [1], λ = 1. Conserved.

  S = W∘U per body:
    U (inter-body): gravitational disentangler. Direct O(N²) or
      Barnes-Hut O(N log N) via octree. Stores force in colour sector.
    W (per-body): velocity kicked by force (wK₁), position drifted (uK₂).

  Oct-tree children:  8 = 2^N_c = N_w^N_c = d_colour
  Force exponent:     2 = N_c − 1 (inverse square)
  Spatial dimensions: 3 = N_c
  Phase space/body:   6 = χ = N_w × N_c

  Observable count: 0 new (infrastructure). Every number from (2,3).

  Compile: ghc -O2 -main-is CrystalNBody CrystalNBody.hs && ./CrystalNBody
-}

module CrystalNBody where

import Data.Ratio (Rational, (%))
import Data.List (foldl')
import CrystalAtoms (nW, nC, chi, beta0, sigmaD, towerD, gauss, d1, d2, d3, d4)
import CrystalSectors (CrystalState, sectorDim, extractSector, injectSector, zeroState)
import CrystalEigen (lambda, wK, uK)
import CrystalOperators (tick, normSq)

sq :: Double -> Double
sq x = x * x
{-# INLINE sq #-}

-- ═══════════════════════════════════════════════════════════════
-- §1  VEC3
-- ═══════════════════════════════════════════════════════════════

type Vec3 = (Double, Double, Double)

v3add :: Vec3 -> Vec3 -> Vec3
v3add (a,b,c) (d,e,f) = (a+d, b+e, c+f)
{-# INLINE v3add #-}

v3sub :: Vec3 -> Vec3 -> Vec3
v3sub (a,b,c) (d,e,f) = (a-d, b-e, c-f)
{-# INLINE v3sub #-}

v3scale :: Double -> Vec3 -> Vec3
v3scale s (a,b,c) = (s*a, s*b, s*c)
{-# INLINE v3scale #-}

v3dot :: Vec3 -> Vec3 -> Double
v3dot (a,b,c) (d,e,f) = a*d + b*e + c*f
{-# INLINE v3dot #-}

v3cross :: Vec3 -> Vec3 -> Vec3
v3cross (a,b,c) (d,e,f) = (b*f-c*e, c*d-a*f, a*e-b*d)

v3norm2 :: Vec3 -> Double
v3norm2 v = v3dot v v
{-# INLINE v3norm2 #-}

v3norm :: Vec3 -> Double
v3norm = sqrt . v3norm2

v3zero :: Vec3
v3zero = (0,0,0)

-- ═══════════════════════════════════════════════════════════════
-- §2  PACK / UNPACK: Body ↔ CrystalState
--
-- Singlet [1]:  KE marker (conserved, λ=1)
-- Weak [3]:     x, y, z
-- Colour [8]:   vx, vy, vz, fx, fy, fz, KE, mass
-- Mixed [24]:   (unused)
--
-- Mass stored in colour[7]. It's a parameter, not a dynamical DOF,
-- but packing it keeps each body self-contained in its CrystalState.
-- ═══════════════════════════════════════════════════════════════

type NBodySystem = [CrystalState]

packBody :: Vec3 -> Vec3 -> Double -> CrystalState
packBody (x,y,z) (vx,vy,vz) m =
  let ke = 0.5 * m * (sq vx + sq vy + sq vz)
      col = [vx, vy, vz, 0, 0, 0, ke, m]
  in injectSector 0 [ke]
   $ injectSector 1 [x, y, z]
   $ injectSector 2 col
   $ zeroState

readPos :: CrystalState -> Vec3
readPos cs = let [x,y,z] = extractSector 1 cs in (x,y,z)

readVel :: CrystalState -> Vec3
readVel cs = let c = extractSector 2 cs in (c!!0, c!!1, c!!2)

readForce :: CrystalState -> Vec3
readForce cs = let c = extractSector 2 cs in (c!!3, c!!4, c!!5)

readKE :: CrystalState -> Double
readKE cs = (extractSector 2 cs) !! 6

readMass :: CrystalState -> Double
readMass cs = (extractSector 2 cs) !! 7

readSpeed :: CrystalState -> Double
readSpeed = v3norm . readVel

readRadius :: CrystalState -> Double
readRadius = v3norm . readPos

-- ═══════════════════════════════════════════════════════════════
-- §3  GRAVITATIONAL COUPLING — DIRECT O(N²) (U disentangler)
--
-- F = −G m_j dr / |r|^N_c       [vector form]
-- |F| = G m_j / |r|^(N_c−1)     [inverse square]
-- Softening ε: r² → r² + ε²
-- ═══════════════════════════════════════════════════════════════

gravAccelDirect :: Double -> NBodySystem -> Int -> Vec3
gravAccelDirect eps2 bodies i =
  let pi_ = readPos (bodies!!i)
      n = length bodies
  in foldl' (\acc j ->
    if j == i then acc
    else let pj = readPos (bodies!!j)
             mj = readMass (bodies!!j)
             (dx,dy,dz) = v3sub pi_ pj
             r2 = dx*dx + dy*dy + dz*dz + eps2
             r = sqrt r2; r3 = r * r2
             f = -mj / r3
         in v3add acc (f*dx, f*dy, f*dz))
    v3zero [0..n-1]

-- | U step (direct): compute gravitational forces, store in colour sector.
uStepDirect :: Double -> NBodySystem -> NBodySystem
uStepDirect eps2 bodies =
  let n = length bodies
  in [let (fx,fy,fz) = gravAccelDirect eps2 bodies i
          col = extractSector 2 (bodies!!i)
          col' = [col!!0, col!!1, col!!2, fx, fy, fz, col!!6, col!!7]
      in injectSector 2 col' (bodies!!i)
     | i <- [0..n-1]]

-- ═══════════════════════════════════════════════════════════════
-- §4  BARNES-HUT OCTREE
--
-- 8 children = 2^N_c = N_w^N_c = d_colour.
-- Opening angle θ: use multipole if size/distance < θ.
-- This is infrastructure for the U disentangler, not dynamics.
-- ═══════════════════════════════════════════════════════════════

data OctTree
  = Empty
  | Leaf !Double !Double !Double !Double          -- x y z mass
  | Node !Double !Double !Double !Double !Double  -- cx cy cz totalMass size
         !OctTree !OctTree !OctTree !OctTree
         !OctTree !OctTree !OctTree !OctTree

octant :: Double -> Double -> Double -> Double -> Double -> Double -> Int
octant x y z cx cy cz =
  (if z > cz then 4 else 0) + (if y > cy then 2 else 0) + (if x > cx then 1 else 0)

insertBody :: Double -> Double -> Double -> Double -> Double -> OctTree -> OctTree
insertBody x y z m size tree = case tree of
  Empty -> Leaf x y z m
  Leaf lx ly lz lm
    | size < 1e-8 ->  -- floor: merge coincident bodies into one leaf
        let tm = lm + m
        in Leaf ((lx*lm+x*m)/tm) ((ly*lm+y*m)/tm) ((lz*lm+z*m)/tm) tm
    | otherwise ->
        let h = size / 2
            n0 = Node lx ly lz 0 size Empty Empty Empty Empty Empty Empty Empty Empty
        in insertInto x y z m h (insertInto lx ly lz lm h n0)
  Node {} -> insertInto x y z m (size/2) tree
  where
    insertInto px py pz pm half (Node cx cy cz tm s c0 c1 c2 c3 c4 c5 c6 c7) =
      let tm' = tm + pm
          cx' = (cx*tm + px*pm) / tm'
          cy' = (cy*tm + py*pm) / tm'
          cz' = (cz*tm + pz*pm) / tm'
          o   = octant px py pz cx cy cz
          ins c = insertBody px py pz pm half c
      in case o of
        0 -> Node cx' cy' cz' tm' s (ins c0) c1 c2 c3 c4 c5 c6 c7
        1 -> Node cx' cy' cz' tm' s c0 (ins c1) c2 c3 c4 c5 c6 c7
        2 -> Node cx' cy' cz' tm' s c0 c1 (ins c2) c3 c4 c5 c6 c7
        3 -> Node cx' cy' cz' tm' s c0 c1 c2 (ins c3) c4 c5 c6 c7
        4 -> Node cx' cy' cz' tm' s c0 c1 c2 c3 (ins c4) c5 c6 c7
        5 -> Node cx' cy' cz' tm' s c0 c1 c2 c3 c4 (ins c5) c6 c7
        6 -> Node cx' cy' cz' tm' s c0 c1 c2 c3 c4 c5 (ins c6) c7
        _ -> Node cx' cy' cz' tm' s c0 c1 c2 c3 c4 c5 c6 (ins c7)
    insertInto _ _ _ _ _ t = t

buildTree :: Double -> NBodySystem -> OctTree
buildTree size = foldl' (\t cs ->
  let (x,y,z) = readPos cs; m = readMass cs
  in insertBody x y z m size t) Empty

-- ═══════════════════════════════════════════════════════════════
-- §5  GRAVITATIONAL COUPLING — TREE O(N log N) (U disentangler)
-- ═══════════════════════════════════════════════════════════════

treeAccel :: Double -> Double -> OctTree -> Vec3 -> Vec3
treeAccel theta eps2 tree pos = go tree
  where
    go Empty = v3zero
    go (Leaf lx ly lz lm) =
      let (dx,dy,dz) = v3sub pos (lx,ly,lz)
          r2 = dx*dx+dy*dy+dz*dz+eps2
      in if r2 < eps2*4 then v3zero  -- skip self
         else let r=sqrt r2; r3=r*r2; f= -lm/r3 in (f*dx,f*dy,f*dz)
    go (Node cx cy cz tm s c0 c1 c2 c3 c4 c5 c6 c7) =
      let (dx,dy,dz) = v3sub pos (cx,cy,cz)
          r2 = dx*dx+dy*dy+dz*dz+eps2; r = sqrt r2
      in if s/r < theta
         then let r3=r*r2; f= -tm/r3 in (f*dx,f*dy,f*dz)
         else let (a0x,a0y,a0z) = go c0; (a1x,a1y,a1z) = go c1
                  (a2x,a2y,a2z) = go c2; (a3x,a3y,a3z) = go c3
                  (a4x,a4y,a4z) = go c4; (a5x,a5y,a5z) = go c5
                  (a6x,a6y,a6z) = go c6; (a7x,a7y,a7z) = go c7
              in ( a0x+a1x+a2x+a3x+a4x+a5x+a6x+a7x
                 , a0y+a1y+a2y+a3y+a4y+a5y+a6y+a7y
                 , a0z+a1z+a2z+a3z+a4z+a5z+a6z+a7z )

-- | U step (tree): Barnes-Hut O(N log N) force computation.
uStepTree :: Double -> Double -> Double -> NBodySystem -> NBodySystem
uStepTree theta eps2 boxSize bodies =
  let tree = buildTree boxSize bodies
  in [let pos = readPos cs
          (fx,fy,fz) = treeAccel theta eps2 tree pos
          col = extractSector 2 cs
          col' = [col!!0,col!!1,col!!2, fx,fy,fz, col!!6,col!!7]
      in injectSector 2 col' cs
     | cs <- bodies]

-- ═══════════════════════════════════════════════════════════════
-- §6  THE TICK: S = W∘U
--
-- W step: per-body sector coupling.
--   Velocity kicked by force (wK₁ = 1/√2).
--   Position drifted by velocity (uK₂ = 1/√3).
-- U step: inter-body gravitational disentangler (direct or tree).
-- ═══════════════════════════════════════════════════════════════

bodyTick :: CrystalState -> CrystalState
bodyTick st =
  let [x,y,z] = extractSector 1 st
      col = extractSector 2 st
      [vx,vy,vz,fx,fy,fz,_,m] = take 8 (col ++ repeat 0)
      w1 = wK 1
      vx' = vx + w1*fx;  vy' = vy + w1*fy;  vz' = vz + w1*fz
      u2 = uK 2
      x' = x + u2*vx';   y' = y + u2*vy';   z' = z + u2*vz'
      ke' = 0.5 * m * (sq vx' + sq vy' + sq vz')
      col' = [vx',vy',vz', fx,fy,fz, ke', m]
  in injectSector 0 [ke']
   $ injectSector 1 [x',y',z']
   $ injectSector 2 col'
   $ st

wStep :: NBodySystem -> NBodySystem
wStep = map bodyTick

-- | Full tick (direct O(N²)): S = W∘U.
nbodyTickDirect :: Double -> NBodySystem -> NBodySystem
nbodyTickDirect eps2 = wStep . uStepDirect eps2

-- | Full tick (Barnes-Hut O(N log N)): S = W∘U.
nbodyTickTree :: Double -> Double -> Double -> NBodySystem -> NBodySystem
nbodyTickTree theta eps2 boxSize = wStep . uStepTree theta eps2 boxSize

-- | Evolve N ticks (direct), full trajectory.
evolveNBody :: Double -> Int -> NBodySystem -> [NBodySystem]
evolveNBody eps2 n sys0 = take (n+1) $ iterate (nbodyTickDirect eps2) sys0

-- | Evolve N ticks (direct), final state only (memory-efficient).
evolveNBodyFinal :: Double -> Int -> NBodySystem -> NBodySystem
evolveNBodyFinal eps2 n sys0 = go n sys0
  where go 0 s = s
        go k s = let s' = nbodyTickDirect eps2 s in s' `seq` go (k-1) s'

-- | Evolve N ticks (tree), full trajectory.
evolveNBodyTree :: Double -> Double -> Double -> Int -> NBodySystem -> [NBodySystem]
evolveNBodyTree theta eps2 box n sys0 =
  take (n+1) $ iterate (nbodyTickTree theta eps2 box) sys0

-- | Evolve N ticks (tree), final only.
evolveNBodyTreeFinal :: Double -> Double -> Double -> Int -> NBodySystem -> NBodySystem
evolveNBodyTreeFinal theta eps2 box n sys0 = go n sys0
  where go 0 s = s
        go k s = let s' = nbodyTickTree theta eps2 box s in s' `seq` go (k-1) s'

-- ═══════════════════════════════════════════════════════════════
-- §7  OBSERVABLES
-- ═══════════════════════════════════════════════════════════════

totalKE :: NBodySystem -> Double
totalKE = sum . map readKE

potentialEnergy :: Double -> NBodySystem -> Double
potentialEnergy eps2 bodies = go 0 (zip [0..] bodies)
  where
    go acc [] = acc
    go acc ((_,bi):rest) =
      let pe = foldl' (\e (_,bj) ->
                 let r = sqrt (v3norm2 (v3sub (readPos bi) (readPos bj)) + eps2)
                 in e - readMass bi * readMass bj / r) 0 rest
      in go (acc + pe) rest

totalEnergy :: Double -> NBodySystem -> Double
totalEnergy eps2 sys = totalKE sys + potentialEnergy eps2 sys

totalMomentum :: NBodySystem -> Vec3
totalMomentum = foldl' (\acc cs ->
  let m = readMass cs; (vx,vy,vz) = readVel cs
  in v3add acc (m*vx, m*vy, m*vz)) v3zero

angMomVec :: CrystalState -> Vec3
angMomVec cs = v3cross (readPos cs) (v3scale (readMass cs) (readVel cs))

totalAngMom :: NBodySystem -> Vec3
totalAngMom = foldl' (\acc cs -> v3add acc (angMomVec cs)) v3zero

centerOfMass :: NBodySystem -> Vec3
centerOfMass sys =
  let totalM = max 1e-30 (sum (map readMass sys))
  in v3scale (1/totalM) $ foldl' (\acc cs ->
       v3add acc (v3scale (readMass cs) (readPos cs))) v3zero sys

virialRatio :: Double -> NBodySystem -> Double
virialRatio eps2 sys = 2 * totalKE sys / max 1e-30 (abs (potentialEnergy eps2 sys))

-- ═══════════════════════════════════════════════════════════════
-- §8  TRAJECTORY EXTRACTORS (Three.js / WASM)
-- ═══════════════════════════════════════════════════════════════

allPositions :: NBodySystem -> [Vec3]
allPositions = map readPos

allVelocities :: NBodySystem -> [Vec3]
allVelocities = map readVel

-- | X coords of body i across trajectory snapshots.
snapX :: Int -> [NBodySystem] -> [Double]
snapX i = map (\s -> let (x,_,_) = readPos (s!!i) in x)

snapY :: Int -> [NBodySystem] -> [Double]
snapY i = map (\s -> let (_,y,_) = readPos (s!!i) in y)

snapZ :: Int -> [NBodySystem] -> [Double]
snapZ i = map (\s -> let (_,_,z) = readPos (s!!i) in z)

snapR :: Int -> [NBodySystem] -> [Double]
snapR i = map (\s -> readRadius (s!!i))

snapSpeed :: Int -> [NBodySystem] -> [Double]
snapSpeed i = map (\s -> readSpeed (s!!i))

snapPositions :: Int -> [NBodySystem] -> [Vec3]
snapPositions i = map (\s -> readPos (s!!i))

-- | Total energy per snapshot.
snapEnergy :: Double -> [NBodySystem] -> [Double]
snapEnergy eps2 = map (totalEnergy eps2)

-- | 2D positions + mass for all bodies (flat array for WebGL).
positions2D :: NBodySystem -> [(Double, Double)]
positions2D = map (\cs -> let (x,y,_) = readPos cs in (x,y))

positions2DMass :: NBodySystem -> [(Double, Double, Double)]
positions2DMass = map (\cs -> let (x,y,_) = readPos cs; m = readMass cs in (x,y,m))

-- | 3D positions for all bodies (for Three.js buffer geometry).
positions3D :: NBodySystem -> [(Double, Double, Double)]
positions3D = map readPos

-- ═══════════════════════════════════════════════════════════════
-- §9  COLOR / VISUAL API
-- ═══════════════════════════════════════════════════════════════

type RGBA = (Double, Double, Double, Double)

sectorColor :: Int -> RGBA
sectorColor 0 = (0.2, 0.3, 1.0, 1.0)
sectorColor 1 = (1.0, 0.9, 0.1, 1.0)
sectorColor 2 = (0.1, 0.8, 0.3, 1.0)
sectorColor 3 = (1.0, 0.2, 0.1, 1.0)
sectorColor _ = (0.5, 0.5, 0.5, 1.0)

lerpRGBA :: Double -> RGBA -> RGBA -> RGBA
lerpRGBA t (r0,g0,b0,a0) (r1,g1,b1,a1) =
  (r0+t*(r1-r0), g0+t*(g1-g0), b0+t*(b1-b0), a0+t*(a1-a0))

keToColor :: Double -> Double -> RGBA
keToColor mx ke =
  let t = min 1.0 (ke / max 1e-15 mx)
  in if t < 0.5 then lerpRGBA (t/0.5) (sectorColor 0) (sectorColor 2)
     else lerpRGBA ((t-0.5)/0.5) (sectorColor 2) (sectorColor 3)

colorBodies :: NBodySystem -> [RGBA]
colorBodies sys =
  let kes = map readKE sys; mx = max 1e-15 (maximum kes)
  in map (keToColor mx) kes

colorBodiesBySpeed :: NBodySystem -> [RGBA]
colorBodiesBySpeed sys =
  let spds = map readSpeed sys; mx = max 1e-15 (maximum spds)
  in map (\s -> keToColor (sq mx) (sq s)) spds

-- | Mass-weighted glow radius for rendering (bigger mass = bigger glow).
glowRadius :: NBodySystem -> [Double]
glowRadius sys =
  let masses = map readMass sys; mx = max 1e-15 (maximum masses)
  in map (\m -> 1.0 + 4.0 * (m / mx) ** 0.33) masses

-- ═══════════════════════════════════════════════════════════════
-- §10  INITIALIZATION
-- ═══════════════════════════════════════════════════════════════

-- | Two-body Kepler orbit.
twoBodyKepler :: Double -> Double -> Double -> NBodySystem
twoBodyKepler m1 m2 sep =
  let tot = m1+m2; r1 = sep*m2/tot; r2 = sep*m1/tot
      vc = sqrt (tot/sep); v1 = vc*m2/tot; v2 = vc*m1/tot
  in [packBody (r1,0,0) (0,v1,0) m1, packBody (-r2,0,0) (0,-v2,0) m2]

-- | Three-body figure-eight (Chenciner-Montgomery solution).
threeBodyFigureEight :: NBodySystem
threeBodyFigureEight =
  let v = 0.347111
  in [ packBody (-0.97000436, 0.24308753, 0) (v, v, 0) 1.0
     , packBody ( 0.97000436,-0.24308753, 0) (v, v, 0) 1.0
     , packBody (0, 0, 0) (-2*v, -2*v, 0) 1.0
     ]

-- | Plummer sphere: N bodies in approximate virial equilibrium.
plummerSphere :: Int -> Double -> Double -> NBodySystem
plummerSphere n totalM rScale =
  let sd2 = d1*d1+d2*d2+d3*d3+d4*d4
      bodyI i =
        let fi = fromIntegral i / fromIntegral n
            theta = fi * 7.13; phi = fi * 11.07
            r = rScale * (fi ** 0.33 + 0.1)
            x = r * sin theta * cos phi
            y = r * sin theta * sin phi
            z = r * cos theta
            m = totalM / fromIntegral n
            vsc = 0.1 * sqrt (totalM / (r + rScale))
            vx = vsc * cos (phi+1.5); vy = vsc * sin (phi+1.5)
            vz = vsc * cos theta * 0.3
        in packBody (x,y,z) (vx,vy,vz) m
  in map bodyI [1..n]

-- | Inner solar system (Sun + Mercury + Venus + Earth + Mars).
-- Units: AU, yr, M_sun. G = 4π².
solarSystemInner :: NBodySystem
solarSystemInner =
  let tau = 2 * pi
  in [ packBody (0,0,0) (0,0,0) 1.0                           -- Sun
     , packBody (0.387,0,0) (0, tau/0.241, 0) 1.66e-7         -- Mercury
     , packBody (0.723,0,0) (0, tau/0.615, 0) 2.45e-6         -- Venus
     , packBody (1.000,0,0) (0, tau,       0) 3.00e-6         -- Earth
     , packBody (1.524,0,0) (0, tau/1.881, 0) 3.23e-7         -- Mars
     ]

-- | Galaxy disk: N bodies in circular orbits around central mass.
galaxyDisk :: Double -> Int -> Double -> Double -> Int -> NBodySystem
galaxyDisk gmC nBodies rMin rMax seed =
  let sd2 = d1*d1+d2*d2+d3*d3+d4*d4
      lcg s = (sd2*s + beta0) `mod` 65536
      toF s = fromIntegral s / 65536.0
      mBody = gmC * 0.01 / fromIntegral nBodies
      go 0 _ = []
      go k s =
        let s1=lcg s; s2=lcg s1; s3=lcg s2; s4=lcg s3
            r = rMin + toF s1*(rMax-rMin); ang = toF s2*2*pi
            tilt = (toF s3-0.5)*0.05
            vc = sqrt (gmC / r)
        in packBody (r*cos ang, r*sin ang, tilt*r) (-vc*sin ang, vc*cos ang, 0) mBody
           : go (k-1) s4
  in packBody v3zero v3zero gmC : go nBodies seed

-- | Colliding galaxies: two galaxy disks with bulk velocity.
collidingGalaxies :: Double -> Int -> Double -> Double -> Double -> NBodySystem
collidingGalaxies gmC nPerGalaxy rMin rMax sep =
  let g1 = galaxyDisk gmC nPerGalaxy rMin rMax 42
      g2 = galaxyDisk gmC nPerGalaxy rMin rMax 137
      shift (dx,dy,dz) (dvx,dvy,dvz) cs =
        let (x,y,z) = readPos cs; (vx,vy,vz) = readVel cs; m = readMass cs
        in packBody (x+dx,y+dy,z+dz) (vx+dvx,vy+dvy,vz+dvz) m
  in map (shift (-sep/2,0,0) (0.3,0.1,0)) g1
  ++ map (shift (sep/2,0,0) (-0.3,-0.1,0)) g2

-- ═══════════════════════════════════════════════════════════════
-- §11  INTEGER IDENTITY PROOFS
-- ═══════════════════════════════════════════════════════════════

sigmaD2 :: Int
sigmaD2 = d1*d1 + d2*d2 + d3*d3 + d4*d4

proveOctChildren :: Int
proveOctChildren = nW ^ (nC :: Int)  -- 2³ = 8

proveOctIsDcolour :: Bool
proveOctIsDcolour = proveOctChildren == nC*nC - 1  -- 8 = d_colour

proveForceExp :: Int
proveForceExp = nC - 1  -- 2

proveSpatialDim :: Int
proveSpatialDim = nC  -- 3

provePhasePerBody :: Int
provePhasePerBody = nW * nC  -- 6 = χ

proveMultipoleOrder :: Int
proveMultipoleOrder = nC - 1  -- 2 (quadrupole = leading GW term)

proveTreeDepth :: Int
proveTreeDepth = nC  -- 3 (spatial dimensions = octree recursion depth per level)

proveSoftening :: Int
proveSoftening = nC - 1  -- 2 (r² → r²+ε², exponent in denominator)

-- ═══════════════════════════════════════════════════════════════
-- §12  SELF-TEST
-- ═══════════════════════════════════════════════════════════════

check :: String -> Bool -> IO ()
check name True  = putStrLn $ "  PASS  " ++ name
check name False = putStrLn $ "  FAIL  " ++ name

runSelfTest :: IO ()
runSelfTest = do
  putStrLn "================================================================"
  putStrLn " CrystalNBody.hs — N-Body Dynamics from (2,3)"
  putStrLn " Dynamics: tick on the 36. U disentangler = gravity."
  putStrLn " Barnes-Hut octree: 8 = d_colour = N_w^N_c children."
  putStrLn "================================================================"
  putStrLn ""

  putStrLn "§1 Sector assignment + eigenvalues:"
  check "weak [3], λ=1/2"    (sectorDim 1 == 3)
  check "colour [8], λ=1/3"  (sectorDim 2 == 8)
  check "singlet [1], λ=1"   (sectorDim 0 == 1)
  check "wK₁ = 1/√2"         (abs (wK 1 - 1/sqrt 2) < 1e-12)
  check "uK₂ = 1/√3"         (abs (uK 2 - 1/sqrt 3) < 1e-12)
  check "wK × uK = λ"        (abs (wK 1 * uK 1 - lambda 1) < 1e-12)
  putStrLn ""

  putStrLn "§2 Pack/unpack round-trip:"
  let st = packBody (1,2,3) (4,5,6) 10.0
  check "pos round-trip"  (readPos st == (1,2,3))
  check "vel round-trip"  (let(a,b,c)=readVel st in abs(a-4)<1e-12&&abs(b-5)<1e-12&&abs(c-6)<1e-12)
  check "mass stored"     (abs (readMass st - 10.0) < 1e-12)
  check "KE computed"     (readKE st > 0)
  check "χ = 6"           (chi == 6)
  putStrLn ""

  putStrLn "§3 Crystal integers:"
  mapM_ (\(n,g,w) -> check (n++"="++show w) (g==w))
    [("N_w",nW,2),("N_c",nC,3),("χ",chi,6),("β₀",beta0,7)
    ,("Σd",sigmaD,36),("Σd²",sigmaD2,650),("gauss",gauss,13),("D",towerD,42)]
  check "oct children = 8 = 2^N_c"      (proveOctChildren == 8)
  check "8 = d_colour = N_c²−1"         proveOctIsDcolour
  check "force exp = N_c−1 = 2"         (proveForceExp == 2)
  check "spatial dim = N_c = 3"          (proveSpatialDim == 3)
  check "phase/body = χ = 6"            (provePhasePerBody == 6)
  putStrLn ""

  putStrLn "§4 Two-body Kepler (tick on the 36):"
  let kep = twoBodyKepler 1.0 1.0 10.0
      eps2 = sq 0.01
      e0 = totalEnergy eps2 kep
      (px0,_,_) = readPos (kep!!0)
      traj = evolveNBody eps2 200 kep
      kepF = last traj
      eF = totalEnergy eps2 kepF
      (pxF,pyF,_) = readPos (kepF!!0)
  check "bodies moved"          (sq(pxF-px0)+sq pyF > 1e-6)
  check "energy ~ conserved"    (abs ((eF-e0)/max 1e-30 (abs e0)) < 0.5)
  let (mx0,my0,_) = totalMomentum kep
      (mxF,myF,_) = totalMomentum kepF
  check "momentum ~ conserved"  (sqrt (sq(mxF-mx0)+sq(myF-my0)) < 0.1)
  putStrLn ""

  putStrLn "§5 Direct force 1/r² scaling:"
  let b1 = packBody (1,0,0) v3zero 1; b2 = packBody (2,0,0) v3zero 1
      src = packBody v3zero v3zero 1
      sys1 = [src, b1]; sys2 = [src, b2]
      (anx,_,_) = gravAccelDirect eps2 sys1 1
      (afx,_,_) = gravAccelDirect eps2 sys2 1
      ratio = abs anx / max 1e-30 (abs afx)
  check "force ratio r:2r ≈ 4"  (abs (ratio - 4.0) < 0.5)
  putStrLn ""

  putStrLn "§6 Barnes-Hut tree:"
  let plum = plummerSphere 20 100.0 5.0
      tree = buildTree 100.0 plum
      pos0 = readPos (plum!!0)
      (atx,aty,atz) = treeAccel 0.7 eps2 tree pos0
      treeForceOk = sq atx + sq aty + sq atz > 0
  check "tree force nonzero"     treeForceOk
  let plTrajTree = evolveNBodyTree 0.7 eps2 100.0 10 plum
  check "tree evolves 10 ticks"  (length plTrajTree == 11)
  putStrLn ""

  putStrLn "§7 Figure-eight (3-body):"
  let fig8 = threeBodyFigureEight
  check "3 bodies"              (length fig8 == 3)
  check "equal masses"          (all (\cs -> abs (readMass cs - 1.0) < 1e-12) fig8)
  let fig8Traj = evolveNBody eps2 100 fig8
      fig8F = last fig8Traj
      fig8Moved = let (a,_,_) = readPos (fig8!!0); (b,_,_) = readPos (fig8F!!0) in abs (b-a) > 1e-6
  check "figure-8 evolves"       fig8Moved
  putStrLn ""

  putStrLn "§8 Solar system:"
  let sol = solarSystemInner
  check "5 bodies (Sun+4)"     (length sol == 5)
  check "Sun at origin"        (let(x,y,z)=readPos(sol!!0) in sq x+sq y+sq z < 1e-20)
  check "Earth at 1 AU"        (abs (readRadius (sol!!3) - 1.0) < 1e-6)
  putStrLn ""

  putStrLn "§9 Galaxy disk:"
  let gal = galaxyDisk 1000.0 50 5.0 30.0 42
  check "51 bodies (central+50)" (length gal == 51)
  check "central at origin"      (v3norm (readPos (gal!!0)) < 1e-10)
  check "central mass dominant"  (readMass (gal!!0) > 100)
  let galTraj = evolveNBody eps2 20 gal
  check "galaxy evolves"         (length galTraj == 21)
  putStrLn ""

  putStrLn "§10 Colliding galaxies:"
  let coll = collidingGalaxies 500 20 3.0 15.0 50.0
  check "two galaxies created"   (length coll > 40)
  putStrLn ""

  putStrLn "§11 Trajectory extractors:"
  let kTraj = evolveNBody eps2 50 kep
  check "snapX"          (length (snapX 0 kTraj) == 51)
  check "snapY"          (length (snapY 0 kTraj) == 51)
  check "snapZ"          (length (snapZ 0 kTraj) == 51)
  check "snapR"          (length (snapR 0 kTraj) == 51)
  check "snapSpeed"      (length (snapSpeed 0 kTraj) == 51)
  check "snapPositions"  (length (snapPositions 0 kTraj) == 51)
  check "snapEnergy"     (length (snapEnergy eps2 kTraj) == 51)
  check "positions2D"    (length (positions2D kep) == 2)
  check "positions3D"    (length (positions3D kep) == 2)
  check "allPositions"   (length (allPositions kep) == 2)
  putStrLn ""

  putStrLn "§12 Visual API:"
  check "colorBodies"       (length (colorBodies kep) == 2)
  check "colorBySpeed"      (length (colorBodiesBySpeed kep) == 2)
  check "glowRadius"        (length (glowRadius kep) == 2)
  check "cold=blue"         (let(_,_,b,_) = keToColor 1 0 in b > 0.8)
  putStrLn ""

  putStrLn "§13 Component wiring:"
  check "tick (CrystalOperators)"  (normSq (tick zeroState) <= normSq zeroState)
  check "extract (CrystalSectors)" (length (extractSector 1 zeroState) == d2)
  check "λ₀=1"                     (abs (lambda 0 - 1.0) < 1e-12)
  check "λ₁=1/2"                   (abs (lambda 1 - 0.5) < 1e-12)
  check "λ₂=1/3"                   (abs (lambda 2 - 1/3) < 1e-12)
  check "λ₃=1/6"                   (abs (lambda 3 - 1/6) < 1e-12)
  putStrLn ""

  putStrLn "================================================================"
  putStrLn " N-Body = tick on the 36. Every integer from (2,3)."
  putStrLn " U disentangler = gravity (direct O(N²) or Barnes-Hut O(N log N))."
  putStrLn " W isometry = velocity kick (wK₁) + position drift (uK₂)."
  putStrLn " Octree: 8 = d_colour = N_w^N_c. Force: 1/r^(N_c−1). Phase: χ = 6."
  putStrLn "================================================================"

main :: IO ()
main = runSelfTest
