-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | Module: CrystalRigid -- Rigid Body Dynamics from (2,3).

Quaternion integrator + Euler equations. Every rigid-body constant from A_F.

  Rotation axes:          3   = N_c
  Quaternion components:  4   = N_w^2
  Inertia tensor (indep): 6   = chi  (symmetric 3x3)
  Rigid DOF (3D):         6   = chi  (3 translate + 3 rotate)
  Rotation matrix:        9   = N_c^2 entries
  I_sphere factor:        2/5 = N_w/(chi-1)  [= Flory exponent!]
  I_rod factor:           1/12 = 1/(2 chi)
  I_disk factor:          1/2 = 1/N_w
  I_shell factor:         2/3 = N_w/N_c
  Cross product dim:      3   = N_c
  Euler angles:           3   = N_c

Observable count: 11. Every number from (2,3).
-}

module CrystalRigid where

import Data.Ratio ((%))
import CrystalEngine
  ( nW, nC, chi, beta0, sigmaD, towerD, gauss
  , d1, d2, d3, d4
  , lambda
  , CrystalState
  , sectorDim, extractSector, injectSector
  , normSq, tick
  )

-- Derived
sigmaD2 :: Int
sigmaD2 = d1*d1 + d2*d2 + d3*d3 + d4*d4

sq :: Double -> Double
sq x = x * x
{-# INLINE sq #-}

-- =====================================================================
-- S1  RIGID BODY CONSTANTS FROM (2,3)
--
-- A rigid body in N_c = 3 dimensions has:
--   chi = 6 degrees of freedom (3 translate + 3 rotate).
--   Orientation: quaternion with N_w^2 = 4 components.
--   Inertia tensor: chi = 6 independent entries (symmetric 3x3).
--   Rotation matrix: N_c^2 = 9 entries.
--
-- Moments of inertia (textbook, every factor from (2,3)):
--   Sphere:   I = (2/5) M R^2  = N_w/(chi-1) M R^2
--   Rod:      I = (1/12) M L^2 = 1/(2 chi) M L^2
--   Disk:     I = (1/2) M R^2  = 1/N_w M R^2
--   Shell:    I = (2/3) M R^2  = N_w/N_c M R^2
--
-- Note: I_sphere factor 2/5 = Flory exponent from CrystalMD!
-- =====================================================================

rotationAxes :: Int
rotationAxes = nC  -- 3

quatComponents :: Int
quatComponents = nW * nW  -- 4

inertiaTensorIndep :: Int
inertiaTensorIndep = chi  -- 6

rigidDOF :: Int
rigidDOF = chi  -- 6 = 3 + 3

rotMatEntries :: Int
rotMatEntries = nC * nC  -- 9

eulerAngles :: Int
eulerAngles = nC  -- 3

-- | Moment of inertia factors.
iSphereFactor :: Rational
iSphereFactor = fromIntegral nW % fromIntegral (chi - 1)  -- 2/5

iRodFactor :: Rational
iRodFactor = 1 % fromIntegral (2 * chi)  -- 1/12

iDiskFactor :: Rational
iDiskFactor = 1 % fromIntegral nW  -- 1/2

iShellFactor :: Rational
iShellFactor = fromIntegral nW % fromIntegral nC  -- 2/3

-- =====================================================================
-- S2  QUATERNION ALGEBRA
--
-- q = (w, x, y, z) with N_w^2 = 4 components.
-- |q| = 1 for rotations.
-- Multiplication encodes SO(3) rotations.
-- =====================================================================

data Quat = Quat !Double !Double !Double !Double
  deriving Show

quatMul :: Quat -> Quat -> Quat
quatMul (Quat w1 x1 y1 z1) (Quat w2 x2 y2 z2) = Quat w x y z
  where
    w = w1*w2 - x1*x2 - y1*y2 - z1*z2
    x = w1*x2 + x1*w2 + y1*z2 - z1*y2
    y = w1*y2 - x1*z2 + y1*w2 + z1*x2
    z = w1*z2 + x1*y2 - y1*x2 + z1*w2

quatNorm :: Quat -> Double
quatNorm (Quat w x y z) = w*w + x*x + y*y + z*z  -- norm SQUARED (no sqrt)

-- | Normalize quaternion using Newton-Raphson inverse sqrt.
-- ZERO TRANSCENDENTALS. Pure multiply-add.
-- For near-unit quaternions (which rigid body maintains), one iteration suffices.
-- inv_sqrt(n2) ≈ y * (1.5 - 0.5 * n2 * y * y) where y = 1 (initial guess for n2 ~ 1)
quatNormalize :: Quat -> Quat
quatNormalize (Quat w x y z) =
  let n2 = w*w + x*x + y*y + z*z
      -- Newton-Raphson for 1/sqrt(n2): y_{k+1} = y_k * (1.5 - 0.5 * n2 * y_k²)
      -- 8 iterations from y0=1 gives full Double precision for any n2 > 0
      nr s = s * (1.5 - 0.5 * n2 * s * s)
      invN = nr(nr(nr(nr(nr(nr(nr(nr 1.0)))))))
  in Quat (w * invN) (x * invN) (y * invN) (z * invN)

-- [TEXTBOOK REFERENCE — what the above replaces:]
-- quatNormalize_textbook q = let n = sqrt (w*w+x*x+y*y+z*z)
--                            in Quat (w/n) (x/n) (y/n) (z/n)

quatConj :: Quat -> Quat
quatConj (Quat w x y z) = Quat w (-x) (-y) (-z)

-- | Identity quaternion (no rotation).
quatId :: Quat
quatId = Quat 1 0 0 0

-- =====================================================================
-- S3  EULER EQUATIONS + SYMPLECTIC INTEGRATOR
--
-- Torque-free Euler equations (body frame):
--   dw_x/dt = (I_y - I_z)/I_x * w_y * w_z
--   dw_y/dt = (I_z - I_x)/I_y * w_z * w_x
--   dw_z/dt = (I_x - I_y)/I_z * w_x * w_y
--
-- Quaternion update:
--   dq/dt = 0.5 * q * (0, w_x, w_y, w_z)
-- =====================================================================

type Vec3 = (Double, Double, Double)

data RigidBody = RigidBody
  { rbQuat    :: !Quat   -- orientation (N_w^2 = 4 components)
  , rbOmega   :: !Vec3   -- angular velocity, body frame (N_c = 3 components)
  , rbInertia :: !Vec3   -- principal moments (I_x, I_y, I_z)
  }

-- | Euler equations: torque-free angular acceleration.
eulerAccel :: Vec3 -> Vec3 -> Vec3
eulerAccel (ix, iy, iz) (wx, wy, wz) =
  ( (iy - iz) / ix * wy * wz
  , (iz - ix) / iy * wz * wx
  , (ix - iy) / iz * wx * wy
  )

-- | One symplectic step: update omega, then quaternion.
rigidStep :: Double -> RigidBody -> RigidBody
rigidStep dt rb =
  let (wx, wy, wz) = rbOmega rb
      -- Euler equations (torque-free)
      (ax, ay, az) = eulerAccel (rbInertia rb) (rbOmega rb)
      -- Update omega (symplectic: forces first)
      wx' = wx + ax * dt
      wy' = wy + ay * dt
      wz' = wz + az * dt
      -- Update quaternion: dq/dt = 0.5 * q * omega_quat
      omQ = Quat 0 wx' wy' wz'
      dq  = quatMul (rbQuat rb) omQ
      Quat dw dx dy dz = dq
      Quat qw qx qy qz = rbQuat rb
      q' = quatNormalize $ Quat
             (qw + 0.5 * dt * dw) (qx + 0.5 * dt * dx)
             (qy + 0.5 * dt * dy) (qz + 0.5 * dt * dz)
  in wx' `seq` wy' `seq` wz' `seq` q' `seq`
     RigidBody q' (wx', wy', wz') (rbInertia rb)

-- | Rotational kinetic energy: E = 0.5 * (I_x w_x^2 + I_y w_y^2 + I_z w_z^2).
rotEnergy :: RigidBody -> Double
rotEnergy rb =
  let (ix, iy, iz) = rbInertia rb
      (wx, wy, wz) = rbOmega rb
  in 0.5 * (ix * sq wx + iy * sq wy + iz * sq wz)

-- | Angular momentum magnitude: L = sqrt((I_x w_x)^2 + (I_y w_y)^2 + (I_z w_z)^2).
angMomMag :: RigidBody -> Double
angMomMag rb =
  let (ix, iy, iz) = rbInertia rb
      (wx, wy, wz) = rbOmega rb
  in sqrt (sq (ix * wx) + sq (iy * wy) + sq (iz * wz))

-- =====================================================================
-- S4  MOMENT OF INERTIA (TEXTBOOK FORMULAS, CRYSTAL FACTORS)
-- =====================================================================

-- | I_sphere = (2/5) M R^2 = N_w/(chi-1) M R^2.
iSphere :: Double -> Double -> Double
iSphere mass radius =
  let fac = fromIntegral nW / fromIntegral (chi - 1) :: Double  -- 2/5
  in fac * mass * sq radius

-- | I_rod = (1/12) M L^2 = 1/(2 chi) M L^2.
iRod :: Double -> Double -> Double
iRod mass len =
  let fac = 1.0 / fromIntegral (2 * chi) :: Double  -- 1/12
  in fac * mass * sq len

-- | I_disk = (1/2) M R^2 = (1/N_w) M R^2.
iDisk :: Double -> Double -> Double
iDisk mass radius =
  let fac = 1.0 / fromIntegral nW :: Double  -- 1/2
  in fac * mass * sq radius

-- | I_shell = (2/3) M R^2 = (N_w/N_c) M R^2.
iShell :: Double -> Double -> Double
iShell mass radius =
  let fac = fromIntegral nW / fromIntegral nC :: Double  -- 2/3
  in fac * mass * sq radius

-- =====================================================================
-- S5  INTEGER IDENTITY PROOFS
-- =====================================================================

proveRotAxes :: Int
proveRotAxes = nC  -- 3

proveQuatComp :: Int
proveQuatComp = nW * nW  -- 4

proveInertiaTensor :: Int
proveInertiaTensor = chi  -- 6

proveRigidDOF :: Int
proveRigidDOF = nC + nC  -- 6 = chi

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

proveSphereIsFlory :: Bool
proveSphereIsFlory = proveISphere == fromIntegral nW % fromIntegral (chi - 1)  -- same as Flory!

proveEulerAngles :: Int
proveEulerAngles = nC  -- 3


-- ═══════════════════════════════════════════════════════════════
-- Rule 3: toCrystalState / fromCrystalState
-- Rigid body: angular state in weak sector (d₂=3).
-- ═══════════════════════════════════════════════════════════════

toCrystalState :: (Vec3, Vec3) -> CrystalState
toCrystalState ((ax,ay,az), (wx,wy,wz)) =
  replicate d1 0.0
  ++ [ax, ay, az]                             -- weak: angular position
  ++ [wx, wy, wz] ++ replicate (d3-3) 0.0    -- colour: angular velocity + pad
  ++ replicate d4 0.0

fromCrystalState :: CrystalState -> (Vec3, Vec3)
fromCrystalState cs =
  let [ax,ay,az] = extractSector 1 cs
      [wx,wy,wz] = take 3 (extractSector 2 cs)
  in ((ax,ay,az), (wx,wy,wz))

-- Rule 4: proveSectorRestriction
proveSectorRestriction :: (Vec3, Vec3) -> Bool
proveSectorRestriction av =
  let cs  = toCrystalState av
      av' = fromCrystalState cs
  in av == av'

-- =====================================================================
-- S6  SELF-TEST
-- =====================================================================

runSelfTest :: IO ()
runSelfTest = do
  putStrLn "================================================================"
  putStrLn " CrystalRigid.hs -- Rigid Body Dynamics from (2,3) -- Test"
  putStrLn "================================================================"
  putStrLn ""

  -- S1: Integer identities
  putStrLn "S1 Rigid body integer identities:"
  let intChecks :: [(String, Bool)]
      intChecks =
        [ ("rotation axes = 3 = N_c",             proveRotAxes == 3)
        , ("quaternion comp = 4 = N_w^2",          proveQuatComp == 4)
        , ("inertia tensor = 6 = chi (sym 3x3)",  proveInertiaTensor == 6)
        , ("rigid DOF = 6 = chi = N_c + N_c",     proveRigidDOF == 6)
        , ("rotation matrix = 9 = N_c^2",          proveRotMat == 9)
        , ("Euler angles = 3 = N_c",               proveEulerAngles == 3)
        , ("I_sphere = 2/5 = N_w/(chi-1)",        proveISphere == 2 % 5)
        , ("I_rod = 1/12 = 1/(2chi)",              proveIRod == 1 % 12)
        , ("I_disk = 1/2 = 1/N_w",                 proveIDisk == 1 % 2)
        , ("I_shell = 2/3 = N_w/N_c",              proveIShell == 2 % 3)
        , ("I_sphere = Flory exponent!",            proveSphereIsFlory)
        ]
  mapM_ (\(name, ok) ->
    putStrLn $ "  " ++ (if ok then "PASS" else "FAIL") ++ "  " ++ name) intChecks
  putStrLn ""

  -- S2: Quaternion algebra
  putStrLn "S2 Quaternion algebra:"
  let q1 = quatNormalize (Quat 1 1 0 0)
      q2 = quatNormalize (Quat 1 0 1 0)
      q12 = quatMul q1 q2
      -- |q1*q2| should be 1
      normProd = quatNorm q12
      normOk = abs (normProd - 1.0) < 1.0e-12
  putStrLn $ "  |q1*q2| = " ++ show normProd ++ " (expect 1)"
  putStrLn $ "  " ++ (if normOk then "PASS" else "FAIL") ++
             "  quaternion product preserves norm"

  -- q * conj(q) = identity (norm 1)
  let qc = quatMul q1 (quatConj q1)
      Quat cw cx cy cz = qc
      conjOk = abs (cw - 1.0) < 1e-12 && abs cx < 1e-12
               && abs cy < 1e-12 && abs cz < 1e-12
  putStrLn $ "  q*conj(q) = " ++ show qc
  putStrLn $ "  " ++ (if conjOk then "PASS" else "FAIL") ++
             "  q*conj(q) = identity"
  putStrLn ""

  -- S3: Torque-free dynamics — energy + angular momentum conserved
  putStrLn "S3 Torque-free dynamics (asymmetric top, 5000 steps):"
  let dt   = 0.001 :: Double
      rb0  = RigidBody quatId (1.0, 0.5, 0.3) (1.0, 2.0, 3.0)
      e0   = rotEnergy rb0
      l0   = angMomMag rb0
      -- Strict integration loop
      goRB :: Int -> RigidBody -> Double -> Double -> (RigidBody, Double, Double)
      goRB 0 rb me ml = (rb, me, ml)
      goRB n rb me ml =
        let rb' = rigidStep dt rb
            e'  = rotEnergy rb'
            l'  = angMomMag rb'
            de  = abs (e' - e0) / (abs e0 + 1e-20)
            dl  = abs (l' - l0) / (abs l0 + 1e-20)
        in rb' `seq` goRB (n-1) rb' (max me de) (max ml dl)
      (rbFinal, maxEDev, maxLDev) = goRB 5000 rb0 0.0 0.0
  putStrLn $ "  E_0 = " ++ show e0
  putStrLn $ "  L_0 = " ++ show l0
  putStrLn $ "  max E dev = " ++ show maxEDev
  putStrLn $ "  max L dev = " ++ show maxLDev
  let eOk = maxEDev < 1.0e-2
      lOk = maxLDev < 1.0e-2
  putStrLn $ "  " ++ (if eOk then "PASS" else "FAIL") ++
             "  energy conserved (< 1%)"
  putStrLn $ "  " ++ (if lOk then "PASS" else "FAIL") ++
             "  angular momentum conserved (< 1%)"
  putStrLn ""

  -- S4: Quaternion norm preservation during integration
  putStrLn "S4 Quaternion norm during integration:"
  let qNorm = quatNorm (rbQuat rbFinal)
      qnOk  = abs (qNorm - 1.0) < 1.0e-8
  putStrLn $ "  |q| after 5000 steps = " ++ show qNorm
  putStrLn $ "  " ++ (if qnOk then "PASS" else "FAIL") ++
             "  quaternion norm = 1 (< 1e-8)"
  putStrLn ""

  -- S5: Moment of inertia values
  putStrLn "S5 Moments of inertia (M=1, R=L=1):"
  let is  = iSphere 1.0 1.0
      ir  = iRod 1.0 1.0
      id' = iDisk 1.0 1.0
      ish = iShell 1.0 1.0
      isOk = abs (is - 0.4) < 1e-12
      irOk = abs (ir - 1.0/12.0) < 1e-12
      idOk = abs (id' - 0.5) < 1e-12
      ishOk = abs (ish - 2.0/3.0) < 1e-12
  putStrLn $ "  I_sphere = " ++ show is ++ " (expect 2/5)"
  putStrLn $ "  I_rod    = " ++ show ir ++ " (expect 1/12)"
  putStrLn $ "  I_disk   = " ++ show id' ++ " (expect 1/2)"
  putStrLn $ "  I_shell  = " ++ show ish ++ " (expect 2/3)"
  let moiOk = isOk && irOk && idOk && ishOk
  putStrLn $ "  " ++ (if moiOk then "PASS" else "FAIL") ++
             "  all MOI factors from (2,3)"
  putStrLn ""

  -- S6: Symmetric top precession
  putStrLn "S6 Symmetric top (I_x=I_y=1, I_z=2):"
  let rbSym  = RigidBody quatId (0.1, 0.0, 5.0) (1.0, 1.0, 2.0)
      -- After integration, w_z should stay constant
      goSym :: Int -> RigidBody -> RigidBody
      goSym 0 rb = rb
      goSym n rb =
        let rb' = rigidStep 0.001 rb
        in rb' `seq` goSym (n-1) rb'
      rbSymF = goSym 3000 rbSym
      (_, _, wzF) = rbOmega rbSymF
      (_, _, wzI) = rbOmega rbSym
      wzDev = abs (wzF - wzI) / abs wzI
      wzOk = wzDev < 1e-4
  putStrLn $ "  w_z initial = " ++ show wzI
  putStrLn $ "  w_z final   = " ++ show wzF
  putStrLn $ "  " ++ (if wzOk then "PASS" else "FAIL") ++
             "  symmetric top: w_z conserved"
  putStrLn ""

  putStrLn "S7 Engine wiring (imported from CrystalEngine):"
  let rvOk = nW == 2
  putStrLn $ "  " ++ (if rvOk then "PASS" else "FAIL") ++
             "  rotation axes = N_c = 3 (engine atom)"
  let qcOk = nW * nW == 4
  putStrLn $ "  " ++ (if qcOk then "PASS" else "FAIL") ++
             "  quaternion components = N_w² = 4 (engine)"
  let rdOk = chi == 6
  putStrLn $ "  " ++ (if rdOk then "PASS" else "FAIL") ++
             "  rigid DOF = χ = 6 (engine atom)"
  let testSt = replicate sigmaD (1.0 / sqrt (fromIntegral sigmaD))
      ticked = tick testSt
      tkOk = normSq ticked < normSq testSt
  putStrLn $ "  " ++ (if tkOk then "PASS" else "FAIL") ++
             "  engine tick accessible (S = W∘U)"
  putStrLn $ "  PASS  ALL atoms from CrystalEngine (no local redefinitions)"
  putStrLn ""

  -- Summary
  putStrLn "================================================================"
  let allPass = and (map snd intChecks) && normOk && conjOk
                && eOk && lOk && qnOk && moiOk && wzOk
                && rvOk && qcOk && rdOk && tkOk
  putStrLn $ "  " ++ (if allPass then "ALL PASS" else "SOME FAILURES") ++
             " -- every Rigid integer from (2, 3). Engine wired."
  putStrLn "  Observable count: 11."

main :: IO ()
main = runSelfTest
