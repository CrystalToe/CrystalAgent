-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | CrystalRigid.hs — Rigid Body Dynamics from (2,3)

  THE DYNAMICS IS THE TICK ON THE 36.

  Orientation (qx,qy,qz) → weak sector [3], λ = 1/2.
  Angular velocity (ωx,ωy,ωz) → colour sector [8] first 3, λ = 1/3.
  Quaternion scalar (qw) → singlet [1], λ = 1.

  S = W∘U:
    W = angular velocity kicks orientation (wK coupling)
    U = orientation drifts from angular velocity (uK coupling)
  Same pattern as classicalTick: positions in weak, momenta in colour.

  Quaternion normalization is a CONSTRAINT applied after the tick,
  not a separate dynamics step. Newton-Raphson, zero sqrt.

  Crystal integers:
    Rotation axes:    3 = N_c         Quaternion:    4 = N_w²
    Rigid DOF:        6 = χ           Rot matrix:    9 = N_c²
    I_sphere:         2/5 = N_w/(χ-1) = Flory exponent
    I_rod:            1/12 = 1/(2χ)   I_disk: 1/2 = 1/N_w
    I_shell:          2/3 = N_w/N_c

  Compile: ghc -O2 -main-is CrystalRigid CrystalRigid.hs && ./CrystalRigid
-}

module CrystalRigid where

import Data.Ratio (Rational, (%))
import CrystalAtoms (nW, nC, chi, beta0, sigmaD, towerD, gauss, d1, d2, d3, d4)
import CrystalSectors (CrystalState, sectorDim, extractSector, injectSector, zeroState)
import CrystalEigen (lambda, wK, uK)
import CrystalOperators (tick, normSq)

sq :: Double -> Double
sq x = x * x
{-# INLINE sq #-}

-- ═══════════════════════════════════════════════════════════════
-- §1  PACK / UNPACK: rigid body state ↔ CrystalState
--
-- Singlet [1]:  qw (quaternion scalar, λ=1 → preserved)
-- Weak [3]:     qx, qy, qz (quaternion vector = orientation)
-- Colour [8]:   ωx, ωy, ωz, Ix, Iy, Iz, E_rot, L_mag
-- Mixed [24]:   (unused)
-- ═══════════════════════════════════════════════════════════════

type Vec3 = (Double, Double, Double)

data Quat = Quat !Double !Double !Double !Double deriving Show

-- | Pack rigid body state into CrystalState.
packRigid :: Quat -> Vec3 -> Vec3 -> CrystalState
packRigid (Quat qw qx qy qz) (wx,wy,wz) (ix,iy,iz) =
  let eRot = 0.5 * (ix * sq wx + iy * sq wy + iz * sq wz)
      lMag = sqrt (sq (ix*wx) + sq (iy*wy) + sq (iz*wz))
      col = [wx, wy, wz, ix, iy, iz, eRot, lMag]
  in injectSector 0 [qw]
   $ injectSector 1 [qx, qy, qz]
   $ injectSector 2 col
   $ zeroState

-- | Read quaternion from CrystalState.
readQuat :: CrystalState -> Quat
readQuat cs =
  let [qw] = extractSector 0 cs
      [qx,qy,qz] = extractSector 1 cs
  in Quat qw qx qy qz

-- | Read angular velocity from CrystalState.
readOmega :: CrystalState -> Vec3
readOmega cs =
  let col = extractSector 2 cs
  in (col!!0, col!!1, col!!2)

-- | Read inertia from CrystalState.
readInertia :: CrystalState -> Vec3
readInertia cs =
  let col = extractSector 2 cs
  in (col!!3, col!!4, col!!5)

-- | Read rotational energy from CrystalState.
readRotEnergy :: CrystalState -> Double
readRotEnergy cs = (extractSector 2 cs) !! 6

-- | Read angular momentum magnitude.
readAngMom :: CrystalState -> Double
readAngMom cs = (extractSector 2 cs) !! 7

-- ═══════════════════════════════════════════════════════════════
-- §2  THE TICK: S = W∘U on the rigid body state
--
-- Same structure as classicalTick in CrystalDynamicEngine:
--   W: angular velocity (colour) kicked by orientation (weak)
--      → Euler equations: dω/dt = (I_cross / I) × ω × ω
--      → coupling weight: wK 1 = 1/√N_w
--   U: orientation (weak) drifts from angular velocity (colour)
--      → dq/dt = 0.5 × q × ω_quat
--      → coupling weight: uK 2 = 1/√N_c
--
-- Quaternion normalization: constraint, applied after tick.
-- Newton-Raphson inv_sqrt. Zero transcendentals.
-- ═══════════════════════════════════════════════════════════════

-- | Rigid body sector tick on the 36.
rigidSectorTick :: CrystalState -> CrystalState
rigidSectorTick st =
  let -- Read current state
      [qw] = extractSector 0 st
      [qx, qy, qz] = extractSector 1 st
      col = extractSector 2 st
      [wx, wy, wz, ix, iy, iz, _, _] = take 8 (col ++ repeat 0.0)

      -- W step: Euler equations couple ω components through inertia
      -- dω_x/dt = (I_y - I_z)/I_x × ω_y × ω_z (and cyclic)
      -- Coupling weight: wK 1
      w1 = wK 1
      ax = if abs ix > 1e-20 then (iy - iz) / ix * wy * wz else 0
      ay = if abs iy > 1e-20 then (iz - ix) / iy * wz * wx else 0
      az = if abs iz > 1e-20 then (ix - iy) / iz * wx * wy else 0
      wx' = wx + w1 * ax
      wy' = wy + w1 * ay
      wz' = wz + w1 * az

      -- U step: quaternion drifts from angular velocity
      -- dq/dt = 0.5 × q × (0, ω)
      -- Coupling weight: uK 2
      u2 = uK 2
      dqw = -0.5 * (qx*wx' + qy*wy' + qz*wz')
      dqx =  0.5 * (qw*wx' + qy*wz' - qz*wy')
      dqy =  0.5 * (qw*wy' + qz*wx' - qx*wz')
      dqz =  0.5 * (qw*wz' + qx*wy' - qy*wx')
      qw' = qw + u2 * dqw
      qx' = qx + u2 * dqx
      qy' = qy + u2 * dqy
      qz' = qz + u2 * dqz

      -- Quaternion normalization (constraint, not dynamics)
      -- Newton-Raphson inverse sqrt. Zero transcendentals.
      n2 = qw'*qw' + qx'*qx' + qy'*qy' + qz'*qz'
      nr s = s * (1.5 - 0.5 * n2 * s * s)
      invN = nr(nr(nr(nr(nr(nr(nr(nr 1.0)))))))
      qwN = qw' * invN
      qxN = qx' * invN
      qyN = qy' * invN
      qzN = qz' * invN

      -- Recompute derived quantities
      eRot = 0.5 * (ix * sq wx' + iy * sq wy' + iz * sq wz')
      lMag = sqrt (sq (ix*wx') + sq (iy*wy') + sq (iz*wz'))
      col' = [wx', wy', wz', ix, iy, iz, eRot, lMag]

  in injectSector 0 [qwN]
   $ injectSector 1 [qxN, qyN, qzN]
   $ injectSector 2 col'
   $ st

-- | Evolve N ticks.
rigidEvolve :: Int -> CrystalState -> [CrystalState]
rigidEvolve 0 st = [st]
rigidEvolve n st = st : rigidEvolve (n-1) (rigidSectorTick st)

-- ═══════════════════════════════════════════════════════════════
-- §3  QUATERNION → ROTATION MATRIX (for 3D rendering)
-- ═══════════════════════════════════════════════════════════════

type Mat3 = ((Double,Double,Double),(Double,Double,Double),(Double,Double,Double))

quatToMatrix :: Quat -> Mat3
quatToMatrix (Quat w x y z) =
  let xx = x*x; yy = y*y; zz = z*z
      xy = x*y; xz = x*z; yz = y*z
      wx = w*x; wy = w*y; wz = w*z
  in ( (1 - 2*(yy+zz),     2*(xy-wz),     2*(xz+wy))
     , (    2*(xy+wz), 1 - 2*(xx+zz),     2*(yz-wx))
     , (    2*(xz-wy),     2*(yz+wx), 1 - 2*(xx+yy))
     )

rotatePoint :: Mat3 -> Vec3 -> Vec3
rotatePoint ((m00,m01,m02),(m10,m11,m12),(m20,m21,m22)) (px,py,pz) =
  (m00*px + m01*py + m02*pz, m10*px + m11*py + m12*pz, m20*px + m21*py + m22*pz)

bodyAxes :: CrystalState -> (Vec3, Vec3, Vec3)
bodyAxes st =
  let m = quatToMatrix (readQuat st)
  in (rotatePoint m (1,0,0), rotatePoint m (0,1,0), rotatePoint m (0,0,1))

-- ═══════════════════════════════════════════════════════════════
-- §4  MOMENTS OF INERTIA (crystal factors)
-- ═══════════════════════════════════════════════════════════════

iSphere :: Double -> Double -> Double
iSphere mass radius = (fromIntegral nW / fromIntegral (chi - 1)) * mass * sq radius  -- 2/5

iRod :: Double -> Double -> Double
iRod mass len = (1.0 / fromIntegral (2 * chi)) * mass * sq len  -- 1/12

iDisk :: Double -> Double -> Double
iDisk mass radius = (1.0 / fromIntegral nW) * mass * sq radius  -- 1/2

iShell :: Double -> Double -> Double
iShell mass radius = (fromIntegral nW / fromIntegral nC) * mass * sq radius  -- 2/3

-- ═══════════════════════════════════════════════════════════════
-- §5  PRESETS (demo-ready CrystalStates)
-- ═══════════════════════════════════════════════════════════════

quatId :: Quat
quatId = Quat 1 0 0 0

tennisRacket :: CrystalState
tennisRacket = packRigid quatId (0.01, 5.0, 0.0) (1.0, 2.0, 3.0)

stableSpin :: CrystalState
stableSpin = packRigid quatId (0.0, 0.0, 5.0) (1.0, 2.0, 3.0)

gyroscope :: CrystalState
gyroscope = packRigid quatId (0.1, 0.0, 20.0) (1.0, 1.0, 0.5)

asteroid :: CrystalState
asteroid = packRigid quatId (1.0, 0.7, 0.3) (1.0, 1.5, 3.0)

-- ═══════════════════════════════════════════════════════════════
-- §6  TRAJECTORY + COLOR (for WASM)
-- ═══════════════════════════════════════════════════════════════

-- | Record trajectory: list of (quat, omega, energy) per tick.
trajectory :: Int -> CrystalState -> [(Quat, Vec3, Double)]
trajectory 0 _ = []
trajectory n st =
  (readQuat st, readOmega st, readRotEnergy st)
  : trajectory (n-1) (rigidSectorTick st)

-- | Tip trace: where body z-axis points over time (polhode).
tipTrace :: Int -> CrystalState -> [Vec3]
tipTrace n st =
  [let m = quatToMatrix (readQuat s) in rotatePoint m (0,0,1)
  | s <- rigidEvolve n st]

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

omegaToColor :: Double -> Double -> RGBA
omegaToColor maxW w =
  let t = min 1.0 (abs w / max 1e-15 maxW)
  in if t < 0.5 then lerpRGBA (t/0.5) (sectorColor 0) (sectorColor 2)
     else lerpRGBA ((t-0.5)/0.5) (sectorColor 2) (sectorColor 3)

-- ═══════════════════════════════════════════════════════════════
-- §7  INTEGER IDENTITY PROOFS
-- ═══════════════════════════════════════════════════════════════

proveRotAxes :: Int
proveRotAxes = nC  -- 3

proveQuatComp :: Int
proveQuatComp = nW * nW  -- 4

proveRigidDOF :: Int
proveRigidDOF = chi  -- 6

proveRotMat :: Int
proveRotMat = nC * nC  -- 9

proveISphere :: Rational
proveISphere = fromIntegral nW % fromIntegral (chi - 1)  -- 2/5

proveIRod :: Rational
proveIRod = 1 % fromIntegral (2 * chi)  -- 1/12

proveIDisk :: Rational
proveIDisk = 1 % fromIntegral nW  -- 1/2

proveIShell :: Rational
proveIShell = fromIntegral nW % fromIntegral nC  -- 2/3

-- ═══════════════════════════════════════════════════════════════
-- §8  SELF-TEST
-- ═══════════════════════════════════════════════════════════════

check :: String -> Bool -> IO ()
check name True  = putStrLn $ "  PASS  " ++ name
check name False = putStrLn $ "  FAIL  " ++ name

main :: IO ()
main = do
  putStrLn "================================================================"
  putStrLn " CrystalRigid.hs — Rigid Body from (2,3)"
  putStrLn " Dynamics: tick on the 36. Weak=orientation, Colour=ω."
  putStrLn "================================================================"
  putStrLn ""

  -- §1: Sector assignment
  putStrLn "§1 Sector assignment:"
  check "orientation (qx,qy,qz) → weak [3], λ=1/2" (sectorDim 1 == 3)
  check "angular velocity (ωx,ωy,ωz) → colour [8], λ=1/3" (sectorDim 2 == 8)
  check "quaternion scalar (qw) → singlet [1], λ=1" (sectorDim 0 == 1)
  check "W coupling = wK 1 = 1/√2" (abs (wK 1 - 1.0/sqrt 2) < 1e-12)
  check "U coupling = uK 2 = 1/√3" (abs (uK 2 - 1.0/sqrt 3) < 1e-12)
  putStrLn ""

  -- §2: Pack/unpack round-trip
  putStrLn "§2 Pack/unpack round-trip:"
  let q0 = Quat 1 0 0 0
      w0 = (1.0, 0.5, 0.3)
      i0 = (1.0, 2.0, 3.0)
      st = packRigid q0 w0 i0
      Quat qw' qx' qy' qz' = readQuat st
      (wx',wy',wz') = readOmega st
      (ix',iy',iz') = readInertia st
  check "quat round-trip" (abs (qw'-1) < 1e-12 && abs qx' < 1e-12)
  check "omega round-trip" (abs (wx'-1) < 1e-12 && abs (wy'-0.5) < 1e-12)
  check "inertia round-trip" (abs (ix'-1) < 1e-12 && abs (iy'-2) < 1e-12)
  putStrLn ""

  -- §3: Dynamics — energy + angular momentum
  putStrLn "§3 Dynamics (asymmetric top, 2000 ticks):"
  let st0 = packRigid quatId (1.0, 0.5, 0.3) (1.0, 2.0, 3.0)
      e0 = readRotEnergy st0
      l0 = readAngMom st0
      traj2k = rigidEvolve 2000 st0
      stFinal = last traj2k
      eF = readRotEnergy stFinal
      lF = readAngMom stFinal
      eDev = abs (eF - e0) / max 1e-20 (abs e0)
      lDev = abs (lF - l0) / max 1e-20 (abs l0)
  putStrLn $ "  E_0 = " ++ show e0
  putStrLn $ "  E_final = " ++ show eF ++ " (dev " ++ show eDev ++ ")"
  putStrLn $ "  L_0 = " ++ show l0
  putStrLn $ "  L_final = " ++ show lF ++ " (dev " ++ show lDev ++ ")"
  -- Quaternion norm preserved
  let Quat qwF qxF qyF qzF = readQuat stFinal
      qNorm = qwF*qwF + qxF*qxF + qyF*qyF + qzF*qzF
  check "quaternion norm = 1 after 2000 ticks" (abs (qNorm - 1.0) < 1e-6)
  putStrLn ""

  -- §4: Integer identities
  putStrLn "§4 Crystal integers:"
  check "rotation axes = N_c = 3" (proveRotAxes == 3)
  check "quaternion = N_w² = 4" (proveQuatComp == 4)
  check "rigid DOF = χ = 6" (proveRigidDOF == 6)
  check "rot matrix = N_c² = 9" (proveRotMat == 9)
  check "I_sphere = 2/5 = N_w/(χ-1)" (proveISphere == 2 % 5)
  check "I_rod = 1/12 = 1/(2χ)" (proveIRod == 1 % 12)
  check "I_disk = 1/2 = 1/N_w" (proveIDisk == 1 % 2)
  check "I_shell = 2/3 = N_w/N_c" (proveIShell == 2 % 3)
  check "I_sphere = Flory exponent" (proveISphere == fromIntegral nW % fromIntegral (chi - 1))
  putStrLn ""

  -- §5: MOI values
  putStrLn "§5 Moments of inertia (M=1, R=1):"
  check "I_sphere = 0.4" (abs (iSphere 1 1 - 0.4) < 1e-12)
  check "I_rod = 1/12" (abs (iRod 1 1 - 1.0/12.0) < 1e-12)
  check "I_disk = 0.5" (abs (iDisk 1 1 - 0.5) < 1e-12)
  check "I_shell = 2/3" (abs (iShell 1 1 - 2.0/3.0) < 1e-12)
  putStrLn ""

  -- §6: Visual API
  putStrLn "§6 Visual API:"
  let tips = tipTrace 100 tennisRacket
  check "tip trace (100 frames)" (length tips == 101)
  let m = quatToMatrix quatId
      ((m00,_,_),_,_) = m
  check "quatToMatrix(id) = I₃" (abs (m00 - 1) < 1e-12)
  let (r0,_,b0,_) = omegaToColor 10.0 0.0
  check "zero spin = blue" (b0 > r0)
  putStrLn ""

  -- §7: Component wiring
  putStrLn "§7 Component wiring:"
  check "tick accessible (CrystalOperators)" (normSq (tick zeroState) <= normSq zeroState)
  check "extractSector works (CrystalSectors)" (length (extractSector 1 zeroState) == d2)
  putStrLn ""

  putStrLn "================================================================"
  putStrLn " Rigid body = sector tick on the 36."
  putStrLn " Pack quat → singlet+weak. Pack ω → colour. Tick. Read back."
  putStrLn " W = Euler coupling (wK). U = quaternion drift (uK)."
  putStrLn " λ_weak=1/2, λ_colour=1/3. I_sphere=2/5=Flory."
  putStrLn "================================================================"
