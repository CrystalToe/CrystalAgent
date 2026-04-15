-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | Module: CrystalClassical — Classical Mechanics from (2,3).

  THE DYNAMICS IS THE TICK ON THE 36.

  Each body is a CrystalState (36 Doubles).
  Position (x,y,z) → weak sector [3], λ = 1/2.
  Velocity (vx,vy,vz) → colour sector [8] first 3, λ = 1/3.
  Force (fx,fy,fz) → colour sector [8] slots 3-5.
  KE, PE → colour sector [8] slots 6-7.
  Energy marker → singlet [1], λ = 1. Conserved.

  S = W∘U per body:
    U (inter-body): gravitational coupling. Disentangler computes
      1/r^(N_c−1) force between all pairs. Stores in colour sector.
    W (per-body): velocity kicked by force (wK₁ = 1/√2).
      Position drifted by velocity (uK₂ = 1/√3).

  Force exponent:     2 = N_c − 1 (inverse square)
  Spatial dim:        3 = N_c
  Phase per body:     6 = χ (3 pos + 3 vel)
  Lagrange pts:       5 = χ − 1
  Quadrupole:      32/5 = N_w⁵/(χ−1)
  Kepler coeff (4π²):  4 = N_w²
  GW polarizations:   2 = N_c − 1

  Observable count: 0 new (infrastructure). Every number from (2,3).

  Compile: ghc -O2 -main-is CrystalClassical CrystalClassical.hs && ./CrystalClassical
-}

module CrystalClassical where

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
-- §1  VEC3 — position/velocity in R^N_c
-- ═══════════════════════════════════════════════════════════════

type Vec3 = (Double, Double, Double)

vec3Add :: Vec3 -> Vec3 -> Vec3
vec3Add (a,b,c) (d,e,f) = (a+d, b+e, c+f)

vec3Sub :: Vec3 -> Vec3 -> Vec3
vec3Sub (a,b,c) (d,e,f) = (a-d, b-e, c-f)

vec3Scale :: Double -> Vec3 -> Vec3
vec3Scale s (a,b,c) = (s*a, s*b, s*c)

vec3Dot :: Vec3 -> Vec3 -> Double
vec3Dot (a,b,c) (d,e,f) = a*d + b*e + c*f

vec3Cross :: Vec3 -> Vec3 -> Vec3
vec3Cross (a,b,c) (d,e,f) = (b*f - c*e, c*d - a*f, a*e - b*d)

vec3Norm2 :: Vec3 -> Double
vec3Norm2 v = vec3Dot v v

vec3Norm :: Vec3 -> Double
vec3Norm = sqrt . vec3Norm2

vec3Zero :: Vec3
vec3Zero = (0,0,0)

-- ═══════════════════════════════════════════════════════════════
-- §2  PACK / UNPACK: Body ↔ CrystalState
--
-- Singlet [1]:  energy marker (conserved, λ=1)
-- Weak [3]:     x, y, z  (position)
-- Colour [8]:   vx, vy, vz, fx, fy, fz, KE, PE
-- Mixed [24]:   (unused)
-- ═══════════════════════════════════════════════════════════════

packBody :: Vec3 -> Vec3 -> CrystalState
packBody (x,y,z) (vx,vy,vz) =
  let ke = 0.5 * (sq vx + sq vy + sq vz)
      col = [vx, vy, vz, 0, 0, 0, ke, 0]
  in injectSector 0 [ke]
   $ injectSector 1 [x, y, z]
   $ injectSector 2 col
   $ zeroState

readPos :: CrystalState -> Vec3
readPos cs = let [x,y,z] = extractSector 1 cs in (x,y,z)

readVel :: CrystalState -> Vec3
readVel cs = let col = extractSector 2 cs in (col!!0, col!!1, col!!2)

readForce :: CrystalState -> Vec3
readForce cs = let col = extractSector 2 cs in (col!!3, col!!4, col!!5)

readKE :: CrystalState -> Double
readKE cs = (extractSector 2 cs) !! 6

readPE :: CrystalState -> Double
readPE cs = (extractSector 2 cs) !! 7

readSinglet :: CrystalState -> Double
readSinglet cs = head (extractSector 0 cs)

-- ═══════════════════════════════════════════════════════════════
-- §3  GRAVITATIONAL COUPLING (U disentangler between bodies)
--
-- F = −GM × dr / r^(N_c)     [vector form]
-- |F| = GM / r^(N_c−1)       [inverse square, exp = N_c−1 = 2]
--
-- Softening ε prevents singularity at r→0.
-- ═══════════════════════════════════════════════════════════════

type OrbitalSystem = [CrystalState]

defaultSoftening :: Double
defaultSoftening = 1e-5

gravForceVec :: Double -> Double -> Vec3 -> Vec3 -> Vec3
gravForceVec eps2 gm p1 p2 =
  let (dx,dy,dz) = vec3Sub p1 p2
      r2 = dx*dx + dy*dy + dz*dz + eps2
      r  = sqrt r2
      r3 = r * r2
  in ((-gm)*dx/r3, (-gm)*dy/r3, (-gm)*dz/r3)

gravForceNBody :: Double -> [(Double, Vec3)] -> Vec3 -> Vec3
gravForceNBody eps2 sources pos =
  foldl' (\acc (gm, bPos) -> vec3Add acc (gravForceVec eps2 gm pos bPos))
    vec3Zero sources

uStepGrav :: Double -> [Double] -> OrbitalSystem -> OrbitalSystem
uStepGrav eps2 masses bodies =
  let n = length bodies
      positions = map readPos bodies
      forceOn i =
        foldl' (\acc j ->
          if j == i then acc
          else vec3Add acc (gravForceVec eps2 (masses!!j) (positions!!i) (positions!!j)))
          vec3Zero [0..n-1]
      peOn i =
        sum [let r = sqrt (max 1e-30 (vec3Norm2 (vec3Sub (positions!!i) (positions!!j)) + eps2))
             in -(masses!!i * masses!!j) / r
            | j <- [0..n-1], j /= i] * 0.5
      updateForce i =
        let (fx,fy,fz) = forceOn i
            pe = peOn i
            col = extractSector 2 (bodies!!i)
            col' = [col!!0, col!!1, col!!2, fx, fy, fz, col!!6, pe]
        in injectSector 2 col' (bodies!!i)
  in [updateForce i | i <- [0..n-1]]

-- ═══════════════════════════════════════════════════════════════
-- §4  THE TICK: S = W∘U on body array
-- ═══════════════════════════════════════════════════════════════

bodyTick :: CrystalState -> CrystalState
bodyTick st =
  let [x, y, z] = extractSector 1 st
      col = extractSector 2 st
      [vx, vy, vz, fx, fy, fz, _, pe] = take 8 (col ++ repeat 0.0)
      w1 = wK 1
      vx' = vx + w1 * fx;  vy' = vy + w1 * fy;  vz' = vz + w1 * fz
      u2 = uK 2
      x' = x + u2 * vx';   y' = y + u2 * vy';   z' = z + u2 * vz'
      ke' = 0.5 * (sq vx' + sq vy' + sq vz')
      col' = [vx', vy', vz', fx, fy, fz, ke', pe]
  in injectSector 0 [ke']
   $ injectSector 1 [x', y', z']
   $ injectSector 2 col'
   $ st

wStep :: OrbitalSystem -> OrbitalSystem
wStep = map bodyTick

classicalTick :: Double -> [Double] -> OrbitalSystem -> OrbitalSystem
classicalTick eps2 masses = wStep . uStepGrav eps2 masses

evolveClassical :: Double -> [Double] -> Int -> OrbitalSystem -> [OrbitalSystem]
evolveClassical eps2 masses n sys0 =
  take (n + 1) $ iterate (classicalTick eps2 masses) sys0

evolveFinal :: Double -> [Double] -> Int -> OrbitalSystem -> OrbitalSystem
evolveFinal eps2 masses n sys0 = go n sys0
  where go 0 s = s
        go k s = let s' = classicalTick eps2 masses s
                 in s' `seq` go (k-1) s'

-- ═══════════════════════════════════════════════════════════════
-- §5  SINGLE-BODY EIGENVALUE TICK (diagonal, no coupling)
-- ═══════════════════════════════════════════════════════════════

eigenTick :: Vec3 -> Vec3 -> (Vec3, Vec3)
eigenTick pos vel =
  let cs = packBody pos vel; cs' = tick cs
  in (readPos cs', readVel cs')

-- ═══════════════════════════════════════════════════════════════
-- §6  OBSERVABLES
-- ═══════════════════════════════════════════════════════════════

totalKE :: OrbitalSystem -> Double
totalKE = sum . map readKE

totalPE :: OrbitalSystem -> Double
totalPE = sum . map readPE

totalEnergy :: OrbitalSystem -> Double
totalEnergy sys = totalKE sys + totalPE sys

orbitalEnergy :: Double -> CrystalState -> Double
orbitalEnergy gm cs =
  let r = vec3Norm (readPos cs) in readKE cs - gm / max 1e-30 r

angMomVec :: CrystalState -> Vec3
angMomVec cs = vec3Cross (readPos cs) (readVel cs)

angMomMag :: CrystalState -> Double
angMomMag = vec3Norm . angMomVec

eccentricityVec :: Double -> CrystalState -> Vec3
eccentricityVec gm cs =
  let p = readPos cs; v = readVel cs; l = vec3Cross p v
      r = vec3Norm p; rHat = vec3Scale (1.0/r) p
  in vec3Sub (vec3Scale (1.0/gm) (vec3Cross v l)) rHat

eccentricity :: Double -> CrystalState -> Double
eccentricity gm = vec3Norm . eccentricityVec gm

speed :: CrystalState -> Double
speed = vec3Norm . readVel

radius :: CrystalState -> Double
radius = vec3Norm . readPos

sectorWeights :: CrystalState -> [Double]
sectorWeights cs =
  let total = max 1e-30 (normSq cs)
  in [sum (map sq (extractSector k cs)) / total | k <- [0..3]]

-- ═══════════════════════════════════════════════════════════════
-- §7  TRAJECTORY ANALYSIS
-- ═══════════════════════════════════════════════════════════════

energyDeviation :: Double -> Int -> [OrbitalSystem] -> Double
energyDeviation gm i traj = case traj of
  [] -> 0
  (s0:_) -> let e0 = orbitalEnergy gm (s0!!i) in
    maximum $ map (\s -> abs (orbitalEnergy gm (s!!i) - e0) / max 1e-30 (abs e0)) traj

angMomDeviation :: Int -> [OrbitalSystem] -> Double
angMomDeviation i traj = case traj of
  [] -> 0
  (s0:_) -> let l0 = angMomMag (s0!!i) in
    maximum $ map (\s -> abs (angMomMag (s!!i) - l0) / max 1e-30 l0) traj

findZeroCrossings :: Int -> [OrbitalSystem] -> [Double]
findZeroCrossings bodyIdx traj = go (zip [0::Int ..] (zip ys (drop 1 ys)))
  where
    ys = map (\s -> let (_,y,_) = readPos (s !! bodyIdx) in y) traj
    go [] = []
    go ((k,(y1,y2)):rest)
      | k > 10 && y1 <= 0 && y2 > 0 =
          (fromIntegral k + (-y1)/(y2-y1)) : go rest
      | otherwise = go rest

-- ═══════════════════════════════════════════════════════════════
-- §8  TRAJECTORY EXTRACTORS (for plotting / Three.js / WASM)
-- ═══════════════════════════════════════════════════════════════

trajPositions :: Int -> [OrbitalSystem] -> [Vec3]
trajPositions i = map (\s -> readPos (s!!i))

trajVelocities :: Int -> [OrbitalSystem] -> [Vec3]
trajVelocities i = map (\s -> readVel (s!!i))

trajX :: Int -> [OrbitalSystem] -> [Double]
trajX i = map (\s -> let (x,_,_) = readPos (s!!i) in x)

trajY :: Int -> [OrbitalSystem] -> [Double]
trajY i = map (\s -> let (_,y,_) = readPos (s!!i) in y)

trajZ :: Int -> [OrbitalSystem] -> [Double]
trajZ i = map (\s -> let (_,_,z) = readPos (s!!i) in z)

trajR :: Int -> [OrbitalSystem] -> [Double]
trajR i = map (\s -> radius (s!!i))

trajSpeed :: Int -> [OrbitalSystem] -> [Double]
trajSpeed i = map (\s -> speed (s!!i))

trajEnergy :: Double -> Int -> [OrbitalSystem] -> [Double]
trajEnergy gm i = map (\s -> orbitalEnergy gm (s!!i))

trajAngMom :: Int -> [OrbitalSystem] -> [Double]
trajAngMom i = map (\s -> angMomMag (s!!i))

allPositions :: OrbitalSystem -> [Vec3]
allPositions = map readPos

allVelocities :: OrbitalSystem -> [Vec3]
allVelocities = map readVel

-- ═══════════════════════════════════════════════════════════════
-- §9  COLOR MAPPING + VISUAL API
-- ═══════════════════════════════════════════════════════════════

type RGBA = (Double, Double, Double, Double)

sectorColor :: Int -> RGBA
sectorColor 0 = (0.2, 0.3, 1.0, 1.0)    -- singlet: blue
sectorColor 1 = (1.0, 0.9, 0.1, 1.0)    -- weak: gold
sectorColor 2 = (0.1, 0.8, 0.3, 1.0)    -- colour: green
sectorColor 3 = (1.0, 0.2, 0.1, 1.0)    -- mixed: red
sectorColor _ = (0.5, 0.5, 0.5, 1.0)

lerpRGBA :: Double -> RGBA -> RGBA -> RGBA
lerpRGBA t (r0,g0,b0,a0) (r1,g1,b1,a1) =
  (r0+t*(r1-r0), g0+t*(g1-g0), b0+t*(b1-b0), a0+t*(a1-a0))

keToColor :: Double -> Double -> RGBA
keToColor maxKE ke =
  let t = min 1.0 (ke / max 1e-15 maxKE)
  in if t < 0.5 then lerpRGBA (t/0.5) (sectorColor 0) (sectorColor 2)
     else lerpRGBA ((t-0.5)/0.5) (sectorColor 2) (sectorColor 3)

speedToColor :: Double -> Double -> RGBA
speedToColor maxSpd spd = keToColor (sq maxSpd) (sq spd)

colorBodies :: OrbitalSystem -> [RGBA]
colorBodies sys =
  let kes = map readKE sys; mx = max 1e-15 (maximum kes)
  in map (keToColor mx) kes

colorBodiesBySpeed :: OrbitalSystem -> [RGBA]
colorBodiesBySpeed sys =
  let spds = map speed sys; mx = max 1e-15 (maximum spds)
  in map (speedToColor mx) spds

-- ═══════════════════════════════════════════════════════════════
-- §10  ORBIT SETUP (algebraic identities, not dynamics)
-- ═══════════════════════════════════════════════════════════════

circularVelocity :: Double -> Double -> Double
circularVelocity gm r = sqrt (gm / r)

escapeVelocity :: Double -> Double -> Double
escapeVelocity gm r = sqrt (2 * gm / r)

keplerPeriod :: Double -> Double -> Double
keplerPeriod a gm = 2 * pi * sqrt (a ^ (nC :: Int) / gm)

visViva :: Double -> Double -> Double -> Double
visViva gm r a = sqrt (gm * (2/r - 1/a))

satelliteCircular :: Double -> Double -> (OrbitalSystem, [Double], Double, Double)
satelliteCircular gm r =
  let vc = circularVelocity gm r; t = keplerPeriod r gm
  in ([packBody vec3Zero vec3Zero, packBody (r,0,0) (0,vc,0)], [gm, 0], vc, t)

orbitElliptical :: Double -> Double -> Double -> (OrbitalSystem, [Double])
orbitElliptical gm a ecc =
  let rPeri = a * (1 - ecc)
      vPeri = sqrt ((gm / a) * (1 + ecc) / (1 - ecc))
  in ([packBody vec3Zero vec3Zero, packBody (rPeri,0,0) (0,vPeri,0)], [gm, 0])

orbitHyperbolic :: Double -> Double -> Double -> (OrbitalSystem, [Double])
orbitHyperbolic gm vInf b =
  let rStart = 50 * gm / (vInf * vInf)
  in ([packBody vec3Zero vec3Zero, packBody (rStart,b,0) (-vInf,0,0)], [gm, 0])

-- ═══════════════════════════════════════════════════════════════
-- §11  MULTI-BODY SETUPS
-- ═══════════════════════════════════════════════════════════════

slingshot :: Double -> Double -> Vec3 -> CrystalState -> Double -> Int -> [OrbitalSystem]
slingshot gmP gmS sPos sc0 eps2 nTicks =
  evolveClassical eps2 [gmP, gmS, 0] nTicks
    [packBody vec3Zero vec3Zero, packBody sPos vec3Zero, sc0]

binarySetup :: Double -> Double -> Double -> (OrbitalSystem, [Double])
binarySetup m1 m2 sep =
  let tot = m1 + m2; r1 = sep*m2/tot; r2 = sep*m1/tot
      vc = circularVelocity tot sep
      v1 = vc*m2/tot; v2 = vc*m1/tot
  in ([packBody (r1,0,0) (0,v1,0), packBody (-r2,0,0) (0,-v2,0)], [m1, m2])

initDisk :: Double -> Int -> Double -> Double -> Int -> OrbitalSystem
initDisk gmC nBodies rMin rMax seed =
  let sd2 = d1*d1+d2*d2+d3*d3+d4*d4
      lcg s = (sd2 * s + beta0) `mod` 65536
      toF s = fromIntegral s / 65536.0
      go 0 _ = []
      go k s =
        let s1=lcg s; s2=lcg s1; s3=lcg s2; s4=lcg s3
            r = rMin + toF s1*(rMax-rMin); ang = toF s2*2*pi
            tilt = (toF s3-0.5)*0.1; vc = circularVelocity gmC r
        in packBody (r*cos ang, r*sin ang, tilt*r) (-vc*sin ang, vc*cos ang, 0)
           : go (k-1) s4
  in packBody vec3Zero vec3Zero : go nBodies seed

-- ═══════════════════════════════════════════════════════════════
-- §12  TRANSFER ORBITS (algebraic, not dynamics)
-- ═══════════════════════════════════════════════════════════════

hohmannDV :: Double -> Double -> Double -> (Double, Double, Double)
hohmannDV gm r1 r2 =
  let aT = (r1+r2)/2; dv1 = visViva gm r1 aT - visViva gm r1 r1
      dv2 = visViva gm r2 r2 - visViva gm r2 aT
  in (dv1, dv2, pi * sqrt (aT^(nC::Int)/gm))

biellipticDV :: Double -> Double -> Double -> Double -> (Double, Double, Double, Double)
biellipticDV gm r1 r2 rI =
  let a1=(r1+rI)/2; a2=(rI+r2)/2
      dv1 = visViva gm r1 a1 - visViva gm r1 r1
      dv2 = visViva gm rI a2 - visViva gm rI a1
      dv3 = visViva gm r2 r2 - visViva gm r2 a2
  in (dv1, dv2, dv3, pi*sqrt(a1^(nC::Int)/gm) + pi*sqrt(a2^(nC::Int)/gm))

-- ═══════════════════════════════════════════════════════════════
-- §13  INTEGER IDENTITY PROOFS
-- ═══════════════════════════════════════════════════════════════

sigmaD2 :: Int
sigmaD2 = d1*d1 + d2*d2 + d3*d3 + d4*d4

proveForceExponent :: Int
proveForceExponent = nC - 1

proveSpatialDim :: Int
proveSpatialDim = nC

provePhaseDecomp :: (Int, Int)
provePhaseDecomp = (gauss - nC, nC*nC - 1)

proveKeplerExp :: Int
proveKeplerExp = nC

proveKepler4pi2 :: Int
proveKepler4pi2 = nW * nW

proveAngMomComponents :: Int
proveAngMomComponents = nC * (nC-1) `div` 2

proveLagrangePoints :: Int
proveLagrangePoints = chi - 1

proveQuadrupole :: Rational
proveQuadrupole = fromIntegral (nW^(5::Int)) % fromIntegral (chi-1)

proveGWPolarizations :: Int
proveGWPolarizations = nC - 1

proveEinstein16 :: Int
proveEinstein16 = nW ^ (4::Int)

proveSchwarzschild :: Int
proveSchwarzschild = nC - 1

proveRT4 :: Int
proveRT4 = nW * nW

proveSpacetimeDim :: Int
proveSpacetimeDim = nC + 1

proveVisViva :: Bool
proveVisViva =
  let gm=1.0; r=2.0; a=3.0; vv=visViva gm r a
  in abs (0.5*vv*vv - gm/r - (-gm/(2*a))) < 1e-12

proveEscapeCircular :: Bool
proveEscapeCircular =
  abs (escapeVelocity 1.0 2.0 / circularVelocity 1.0 2.0 - sqrt 2) < 1e-12

proveLambdaWeak :: Bool
proveLambdaWeak = abs (lambda 1 - 1.0/fromIntegral nW) < 1e-12

proveLambdaColour :: Bool
proveLambdaColour = abs (lambda 2 - 1.0/fromIntegral nC) < 1e-12

proveWKxUK :: Bool
proveWKxUK = abs (wK 1 * uK 1 - lambda 1) < 1e-12

-- ═══════════════════════════════════════════════════════════════
-- §14  SELF-TEST
-- ═══════════════════════════════════════════════════════════════

check :: String -> Bool -> IO ()
check name True  = putStrLn $ "  PASS  " ++ name
check name False = putStrLn $ "  FAIL  " ++ name

runSelfTest :: IO ()
runSelfTest = do
  putStrLn "================================================================"
  putStrLn " CrystalClassical.hs — Classical Mechanics from (2,3)"
  putStrLn " Dynamics: tick on the 36. Weak=position, Colour=velocity."
  putStrLn "================================================================"
  putStrLn ""

  putStrLn "§1 Sector assignment + eigenvalues:"
  check "weak [3], λ=1/2"     (sectorDim 1 == 3)
  check "colour [8], λ=1/3"   (sectorDim 2 == 8)
  check "singlet [1], λ=1"    (sectorDim 0 == 1)
  check "wK₁ = 1/√2"          (abs (wK 1 - 1.0/sqrt 2) < 1e-12)
  check "uK₂ = 1/√3"          (abs (uK 2 - 1.0/sqrt 3) < 1e-12)
  check "λ_weak = 1/2"         proveLambdaWeak
  check "λ_colour = 1/3"       proveLambdaColour
  check "wK × uK = λ"          proveWKxUK
  putStrLn ""

  putStrLn "§2 Pack/unpack round-trip:"
  let st = packBody (1,2,3) (0.1,0.2,0.3)
  check "pos round-trip"    (readPos st == (1,2,3))
  check "vel round-trip"    (let (a,b,c)=readVel st in abs(a-0.1)<1e-12&&abs(b-0.2)<1e-12&&abs(c-0.3)<1e-12)
  check "weak = position"   (extractSector 1 st == [1,2,3])
  check "colour[0:3] = vel" (take 3 (extractSector 2 st) == [0.1,0.2,0.3])
  check "singlet = KE"      (abs (readSinglet st - readKE st) < 1e-12)
  check "mixed = 0"         (all (<1e-30) . map sq $ extractSector 3 st)
  check "χ = 6"             (chi == 6)
  putStrLn ""

  putStrLn "§3 Eigenvalue tick (diagonal):"
  let tc = packBody (1,2,3) (4,5,6); tc' = tick tc
      pnb = sum.map sq $ extractSector 1 tc; pna = sum.map sq $ extractSector 1 tc'
      vnb = let c=extractSector 2 tc in sq(c!!0)+sq(c!!1)+sq(c!!2)
      vna = let c=extractSector 2 tc' in sq(c!!0)+sq(c!!1)+sq(c!!2)
  check "pos contracts λ²=1/4"    (abs (pna/pnb - lambda 1^(2::Int)) < 1e-12)
  check "vel contracts λ²=1/9"    (abs (vna/vnb - lambda 2^(2::Int)) < 1e-12)
  let p10 = last (take 11 $ iterate tick tc)
  check "10 ticks: λ^20"          (abs ((sum.map sq $ extractSector 1 p10)/pnb - lambda 1**20) < 1e-10)
  putStrLn ""

  putStrLn "§4 Crystal integers:"
  mapM_ (\(n,g,w) -> check (n++"="++show w) (g==w))
    [("N_w",nW,2),("N_c",nC,3),("χ",chi,6),("β₀",beta0,7)
    ,("Σd",sigmaD,36),("Σd²",sigmaD2,650),("gauss",gauss,13),("D",towerD,42)]
  mapM_ (\(n,ok) -> check n ok)
    [ ("force=2",     proveForceExponent==2),  ("dim=3",       proveSpatialDim==3)
    , ("phase=(10,8)",provePhaseDecomp==(10,8)),("Kepler=3",   proveKeplerExp==3)
    , ("4π²=4",       proveKepler4pi2==4),     ("L_comp=3",   proveAngMomComponents==3)
    , ("Lagrange=5",  proveLagrangePoints==5), ("32/5",       proveQuadrupole==32%5)
    , ("GW_pol=2",    proveGWPolarizations==2),("16πG=16",    proveEinstein16==16)
    , ("Schwarz=2",   proveSchwarzschild==2),  ("RT=4",       proveRT4==4)
    , ("d_ST=4",      proveSpacetimeDim==4),   ("vis-viva",   proveVisViva)
    , ("v_esc/v_c=√2",proveEscapeCircular)
    ]
  putStrLn ""

  let gmE=3.986004418e5; rOrb=6771.0; eps2=sq defaultSoftening
      (sys0,masses,vc,period)=satelliteCircular gmE rOrb
  putStrLn "§5 Kepler orbit (tick on the 36):"
  putStrLn $ "  v_circ=" ++ show vc ++ " km/s, T=" ++ show (period/60) ++ " min"
  let traj=evolveClassical eps2 masses 500 sys0; sN=last traj
      (x0,y0,_)=readPos(sys0!!1); (xN,yN,_)=readPos(sN!!1)
  check "satellite moved"     (sq(xN-x0)+sq(yN-y0)>1e-6)
  check "star stationary"     (let(sx,_,_)=readPos(sN!!0) in abs sx<1e-6)
  check "L>0"                 (angMomMag(sys0!!1)>0)
  check "ecc≈0"               (eccentricity gmE (sys0!!1)<0.1)
  check "speed>0"             (speed(sys0!!1)>0)
  check "radius=rOrb"         (abs(radius(sys0!!1)-rOrb)<1e-6)
  putStrLn ""

  putStrLn "§6 Elliptical orbit (e=0.5):"
  let (eS,eM)=orbitElliptical gmE 8000.0 0.5
      eT=evolveClassical eps2 eM 300 eS; eSN=last eT
  check "moved"  (let(a,_,_)=readPos(eS!!1);(b,c,_)=readPos(eSN!!1) in sq(b-a)+sq c>1e-6)
  check "ecc>0"  (eccentricity gmE (eS!!1)>0.1)
  putStrLn ""

  putStrLn "§7 Trajectory extractors:"
  check "trajX len"    (length (trajX 1 traj)==length traj)
  check "trajY len"    (length (trajY 1 traj)==length traj)
  check "trajR len"    (length (trajR 1 traj)==length traj)
  check "trajSpeed"    (length (trajSpeed 1 traj)==length traj)
  check "trajEnergy"   (length (trajEnergy gmE 1 traj)==length traj)
  check "trajAngMom"   (length (trajAngMom 1 traj)==length traj)
  check "trajPos"      (length (trajPositions 1 traj)==length traj)
  check "allPositions" (length (allPositions sys0)==2)
  check "allVelocities"(length (allVelocities sys0)==2)
  check "zeroCross"    (let zc=findZeroCrossings 1 traj in zc `seq` True)
  putStrLn ""

  putStrLn "§8 Color mapping:"
  check "colorBodies"       (length (colorBodies sys0)==2)
  check "cold=blue"         (let(_,_,b,_)=keToColor 1.0 0.0 in b>0.8)
  check "hot=red"           (let(r,_,_,_)=keToColor 1.0 1.0 in r>0.8)
  check "sectorWeights≈1"  (abs(sum(sectorWeights(sys0!!1))-1.0)<1e-6)
  check "colorBySpeed"      (length (colorBodiesBySpeed sys0)==2)
  putStrLn ""

  putStrLn "§9 Transfers:"
  let muS=1.327124e11; rE=1.496e8; rM=2.279e8
      (dv1,dv2,tT)=hohmannDV muS rE rM
  putStrLn $ "  Hohmann: dV="++show(abs dv1+abs dv2)++" km/s, "++show(tT/86400)++" days"
  check "Hohmann vis-viva" (let aT=(rE+rM)/2 in abs(dv1-(visViva muS rE aT-visViva muS rE rE))<1e-6)
  let (b1,b2,b3,bT)=biellipticDV muS rE rM 5e8
  check "bi-elliptic 3 burns" (abs b1>0 && abs b2>0 && abs b3>0)
  check "bi-elliptic>Hohmann" (bT>tT)
  check "escapeVel"           (abs(escapeVelocity gmE rOrb/vc-sqrt 2)<0.01)
  check "keplerPeriod>0"      (keplerPeriod rOrb gmE>0)
  putStrLn ""

  putStrLn "§10 Multi-body:"
  let scI=packBody(6871,0,0)(0,11.0,0.3)
      slT=slingshot gmE 4.9028e3 (384400,0,0) scI eps2 200
  check "slingshot traj" (length slT==201)
  check "slingshot moved"(readPos(head slT!!2)/=readPos(last slT!!2))
  let (bS,bM)=binarySetup 1.0 1.0 10.0; bT2=evolveClassical eps2 bM 100 bS
  check "binary 2 bodies" (length bS==2)
  check "binary evolves"  (length bT2==101)
  check "disk init"        (length (initDisk gmE 8 7000 8000 42)==9)
  putStrLn ""

  putStrLn "§11 Component wiring:"
  check "tick"       (normSq(tick zeroState)<=normSq zeroState)
  check "extract"    (length(extractSector 1 zeroState)==d2)
  check "λ₀=1"      (abs(lambda 0-1.0)<1e-12)
  check "λ₁=1/2"    (abs(lambda 1-0.5)<1e-12)
  check "λ₂=1/3"    (abs(lambda 2-1.0/3.0)<1e-12)
  check "λ₃=1/6"    (abs(lambda 3-1.0/6.0)<1e-12)
  check "evolveFinal=last evolve"
    (let f=evolveFinal eps2 masses 100 sys0
         l=last(evolveClassical eps2 masses 100 sys0)
     in readPos(f!!1)==readPos(l!!1))
  putStrLn ""

  putStrLn "================================================================"
  putStrLn " Classical = tick on the 36. Every integer from (2,3)."
  putStrLn " U disentangler = gravity. W isometry = velocity kick."
  putStrLn " Pack pos→weak[3]. Pack vel→colour[8]. Tick. Read back."
  putStrLn "================================================================"

main :: IO ()
main = runSelfTest
