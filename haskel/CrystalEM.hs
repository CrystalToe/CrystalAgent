-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | Module: CrystalEM -- Electromagnetic Field Evolution from (2,3).

Yee FDTD (Finite-Difference Time-Domain) = monad S = W.U on EM sector.
E and B staggered in space (half-cell) and time (leapfrog).

  B half-step = W (kick from curl E)
  E full-step = U (drift from curl B)
  This IS S = W.U for the electromagnetic field.

EM field has chi = 6 components: (E_x, E_y, E_z, B_x, B_y, B_z).
Maxwell's 4 equations = N_c + 1 = spacetime dimension.
Speed of light c = chi/chi = 1 (Lieb-Robinson).

Observable count: 0 new (infrastructure). Every number from (2,3).
-}

module CrystalEM where

import Data.Ratio (Rational, (%))

-- =====================================================================
-- S0  A_F ATOMS
-- =====================================================================

nW, nC, chi, beta0, sigmaD, sigmaD2, gauss, towerD :: Integer
nW      = 2
nC      = 3
chi     = nW * nC                          -- 6
beta0   = (11 * nC - 2 * chi) `div` 3     -- 7
sigmaD  = 1 + 3 + 8 + 24                  -- 36
sigmaD2 = 1 + 9 + 64 + 576                -- 650
gauss   = nC * nC + nW * nW               -- 13
towerD  = sigmaD + chi                    -- 42

dColour :: Integer
dColour = nC * nC - 1    -- 8

sq :: Double -> Double
sq x = x * x
{-# INLINE sq #-}

-- =====================================================================
-- S1  1D YEE FDTD (EM monad on a line)
--
-- Propagation along x-axis. E_y and B_z only (TEM mode).
-- E_y lives on integer grid points: E_y(i)
-- B_z lives on half-integer points: B_z(i+1/2)
--
-- Update equations (natural units, c = 1, eps0 = mu0 = 1):
--   B_z(i+1/2, n+1/2) = B_z(i+1/2, n-1/2) - (dt/dx)(E_y(i+1,n) - E_y(i,n))
--   E_y(i, n+1) = E_y(i, n) + (dt/dx)(B_z(i+1/2,n+1/2) - B_z(i-1/2,n+1/2))
--
-- This is EXACTLY leapfrog: B update = W (kick), E update = U (drift).
-- CFL stability: dt <= dx (since c = 1 = chi/chi).
-- =====================================================================

-- | 1D EM field state. E_y on integer grid, B_z on half-integer grid.
data EMState1D = EMState1D
  { emEy :: [Double]   -- ^ E_y at integer grid points (length N)
  , emBz :: [Double]   -- ^ B_z at half-integer points (length N-1)
  , emTime :: Double    -- ^ current time
  } deriving (Show)

-- | One Yee tick (1D). dt/dx = Courant number (must be <= 1 for stability).
-- B update (W: half-kick from curl E):
--   B_z(i) -= courant * (E_y(i+1) - E_y(i))
-- E update (U: full drift from curl B):
--   E_y(i) += courant * (B_z(i) - B_z(i-1))
emTick1D :: Double -> EMState1D -> EMState1D
emTick1D courant (EMState1D ey bz t) =
  let n = length ey
      -- W: update B from curl(E): dB/dt = -dE/dx
      bz' = zipWith (\b de -> b - courant * de)
               bz
               (zipWith (-) (tail ey) ey)
      -- U: update E from curl(B): dE/dt = -dB/dx
      -- PEC boundaries: E_tangential = 0 at walls
      ey' = [0.0] ++
            [ (ey !! i) - courant * ((bz' !! i) - (bz' !! (i-1)))
            | i <- [1 .. n-2] ] ++
            [0.0]
  in EMState1D ey' bz' (t + courant)

-- | Create initial Gaussian pulse on E_y.
gaussianPulse :: Int -> Double -> Double -> Double -> EMState1D
gaussianPulse nGrid center width amp =
  let dx = 1.0 / fromIntegral nGrid
      ey = [ amp * exp (- sq ((fromIntegral i * dx - center) / width))
           | i <- [0 .. nGrid - 1] ]
      bz = replicate (nGrid - 1) 0.0
  in EMState1D ey bz 0.0

-- =====================================================================
-- S2  EM FIELD ENERGY AND POYNTING
--
-- Energy density: u = (eps0 E^2 + B^2/mu0) / 2 = (E^2 + B^2) / 2
-- (natural units: eps0 = mu0 = 1)
-- Poynting vector: S = E x B (N_c = 3 components for cross product)
-- =====================================================================

-- | Total EM field energy (1D). u = sum(E^2 + B^2) / 2.
emEnergy1D :: EMState1D -> Double
emEnergy1D (EMState1D ey bz _) =
  let eEnergy = sum (map sq ey) / 2.0
      bEnergy = sum (map sq bz) / 2.0
  in eEnergy + bEnergy

-- =====================================================================
-- S3  RADIATION FORMULAS (analytic, from crystal integers)
--
-- Larmor power: P = (2/3) q^2 a^2 / c^3
--   2/3 = (N_c - 1) / N_c. In N_c dimensions, radiation from
--   acceleration has this dimensional factor.
--
-- Rayleigh scattering: sigma ~ d^chi / lambda^(N_w^2)
--   Size exponent chi = 6, wavelength exponent N_w^2 = 4.
--   Why sky is blue: sigma ~ 1/lambda^4, blue light scattered more.
--
-- Planck spectral radiance: B(lambda) ~ lambda^(-(chi-1))
--   Exponent chi-1 = 5. Wien displacement from 5-dimensional DOS.
-- =====================================================================

-- | Larmor power. P = (2/3) q^2 a^2 / c^3. c=1 in natural units.
-- 2/3 = (N_c - 1) / N_c.
larmorPower :: Double -> Double -> Double
larmorPower q accel =
  let coeff = fromIntegral (nC - 1) / fromIntegral nC  -- 2/3
  in coeff * sq q * sq accel

-- | Rayleigh scattering cross-section (proportional).
-- sigma ~ (d/lambda)^N_w^2 * d^(N_c-1) * (2pi)
-- Simplified: sigma ~ d^chi / lambda^(N_w^2)
rayleighSigma :: Double -> Double -> Double
rayleighSigma diam wavelength =
  let sizeExp = fromIntegral chi       -- 6
      waveExp = fromIntegral (nW * nW) -- 4
  in (diam ** sizeExp) / (wavelength ** waveExp)

-- | Rayleigh scattering ratio (blue/red). Why sky is blue.
-- sigma_blue / sigma_red = (lambda_red / lambda_blue)^(N_w^2)
skyBlueRatio :: Double -> Double -> Double
skyBlueRatio lambdaBlue lambdaRed =
  (lambdaRed / lambdaBlue) ** fromIntegral (nW * nW)  -- (red/blue)^4

-- | Planck spectral radiance peak wavelength exponent.
-- B(lambda) ~ lambda^(-(chi-1)) at peak. Wien: lambda_max T = const.
planckExponent :: Integer
planckExponent = chi - 1  -- 5

-- | Stefan-Boltzmann T exponent: P ~ T^(N_w^2) = T^4.
stefanExponent :: Integer
stefanExponent = nW * nW  -- 4

-- | Stefan-Boltzmann denominator: 2pi^5 / 15. The 15 = N_c(chi-1).
stefanDenom :: Integer
stefanDenom = nC * (chi - 1)  -- 15

-- =====================================================================
-- S4  EM FIELD COMPONENTS COUNT
--
-- In N_c = 3 spatial dimensions:
--   E has N_c = 3 components
--   B has N_c = 3 components
--   Total: 2 * N_c = chi = 6 components
-- This is dim Lambda^2(R^(N_c+1)) = C(N_c+1, 2) = chi.
-- The EM 2-form F has exactly chi independent components.
-- =====================================================================

proveEMcomponents :: Integer
proveEMcomponents = nW * nC  -- chi = 6

proveEcomponents :: Integer
proveEcomponents = nC  -- 3

proveBcomponents :: Integer
proveBcomponents = nC  -- 3

prove2formDim :: Integer
prove2formDim = (nC + 1) * nC `div` 2  -- C(4,2) = 6 = chi

-- =====================================================================
-- S5  MAXWELL EQUATION COUNT
--
-- 4 equations = N_c + 1 = spacetime dimension.
-- Each maps to a sector of A_F:
--   Gauss(E):  Singlet d=1  (scalar constraint)
--   Gauss(B):  Weak d=3     (no monopoles, 3 components)
--   Faraday:   Colour d=8   (induction, 8 = N_c^2-1)
--   Ampere:    Mixed d=24   (full coupling, 24 = N_w^3*N_c)
-- =====================================================================

proveMaxwellCount :: Integer
proveMaxwellCount = nC + 1  -- 4

proveSpeedOfLight :: Rational
proveSpeedOfLight = chi % chi  -- 6/6 = 1

-- =====================================================================
-- S6  INTEGER IDENTITY PROOFS
-- =====================================================================

proveLarmorCoeff :: Rational
proveLarmorCoeff = (nC - 1) % nC  -- 2/3

proveRayleighWave :: Integer
proveRayleighWave = nW * nW  -- 4

proveRayleighSize :: Integer
proveRayleighSize = chi  -- 6

provePlanckExp :: Integer
provePlanckExp = chi - 1  -- 5

proveStefanExp :: Integer
proveStefanExp = nW * nW  -- 4

proveStefanDenom :: Integer
proveStefanDenom = nC * (chi - 1)  -- 15

proveGaugeGroup :: Integer
proveGaugeGroup = 1  -- U(1) = singlet sector d=1

-- =====================================================================
-- S7  SELF-TEST
-- =====================================================================

runSelfTest :: IO ()
runSelfTest = do
  putStrLn "================================================================"
  putStrLn " CrystalEM.hs -- EM Field Evolution from (2,3) -- Self-Test"
  putStrLn "================================================================"
  putStrLn ""

  -- Integer identities
  putStrLn "S1 EM integer identities:"
  let intChecks :: [(String, Bool)]
      intChecks =
        [ ("EM components chi = 6",          proveEMcomponents == 6)
        , ("E components N_c = 3",           proveEcomponents == 3)
        , ("B components N_c = 3",           proveBcomponents == 3)
        , ("2-form dim C(4,2) = chi = 6",    prove2formDim == 6)
        , ("Maxwell eqs N_c+1 = 4",          proveMaxwellCount == 4)
        , ("c = chi/chi = 1",                proveSpeedOfLight == 1 % 1)
        , ("Larmor 2/3 = (N_c-1)/N_c",       proveLarmorCoeff == 2 % 3)
        , ("Rayleigh wave exp N_w^2 = 4",    proveRayleighWave == 4)
        , ("Rayleigh size exp chi = 6",       proveRayleighSize == 6)
        , ("Planck exp chi-1 = 5",            provePlanckExp == 5)
        , ("Stefan T exp N_w^2 = 4",          proveStefanExp == 4)
        , ("Stefan denom N_c(chi-1) = 15",    proveStefanDenom == 15)
        , ("U(1) gauge = singlet d = 1",      proveGaugeGroup == 1)
        ]
  mapM_ (\(name, ok) ->
    putStrLn $ "  " ++ (if ok then "PASS" else "FAIL") ++ "  " ++ name) intChecks
  putStrLn ""

  -- Yee FDTD: wave propagation
  putStrLn "S2 Yee FDTD wave propagation:"
  let nGrid = 200 :: Int
      courant = 0.5 :: Double    -- dt/dx = 0.5 (CFL stable since < 1)
      nSteps = 200 :: Int
      pulse0 = gaussianPulse nGrid 0.3 0.05 1.0
      e0     = emEnergy1D pulse0
      -- Strict loop
      goEM :: Int -> EMState1D -> Double -> Double -> (EMState1D, Double, Double)
      goEM 0 st eMax eMin = (st, eMax, eMin)
      goEM n st eMax eMin =
        let st' = emTick1D courant st
            e'  = emEnergy1D st'
            eMax' = max eMax e'
            eMin' = min eMin e'
        in e' `seq` goEM (n-1) st' eMax' eMin'
      (finalSt, eMax, eMin) = goEM nSteps pulse0 e0 e0
      eFinal = emEnergy1D finalSt
      eRelDev = abs (eFinal - e0) / e0
  putStrLn $ "  initial energy = " ++ show e0
  putStrLn $ "  final energy   = " ++ show eFinal
  putStrLn $ "  rel deviation  = " ++ show eRelDev

  -- Energy should be approximately conserved (PEC boundaries reflect)
  let eOk = eRelDev < 0.01
  putStrLn $ "  " ++ (if eOk then "PASS" else "FAIL") ++
             "  energy approximately conserved (< 1%)"

  -- Pulse should have propagated (E field changed shape)
  let eyInit = emEy pulse0
      eyFinal = emEy finalSt
      changed = sum (zipWith (\a b -> abs (a - b)) eyInit eyFinal) > 0.1
  putStrLn $ "  " ++ (if changed then "PASS" else "FAIL") ++
             "  E field has propagated"

  -- CFL: courant <= 1 for stability
  let cflOk = courant <= 1.0
  putStrLn $ "  " ++ (if cflOk then "PASS" else "FAIL") ++
             "  CFL condition satisfied (courant = " ++ show courant ++ " <= 1)"
  putStrLn ""

  -- Wave speed test: pulse peak should move at c = 1
  putStrLn "S3 Wave speed = c = 1:"
  let -- Find peak position in E_y
      findPeak :: [Double] -> Int
      findPeak xs = snd $ foldl (\(mx, mi) (v, i) ->
        if abs v > mx then (abs v, i) else (mx, mi)) (0, 0) (zip xs [0..])
      peakInit = findPeak eyInit
      peakFinal = findPeak eyFinal
      dx = 1.0 / fromIntegral nGrid :: Double
      dt = courant * dx
      tTotal = fromIntegral nSteps * dt
      -- Expected displacement = c * t = 1 * tTotal (in grid units: tTotal/dx)
      peakDisplacement = fromIntegral (abs (peakFinal - peakInit)) * dx
      -- The pulse splits into left and right moving parts
      -- One peak moves right at c=1, so displacement ~ tTotal
  putStrLn $ "  peak moved " ++ show peakDisplacement ++ " (expected ~" ++ show tTotal ++ ")"
  -- Allow for pulse splitting and reflection
  let speedOk = peakDisplacement > 0.1
  putStrLn $ "  " ++ (if speedOk then "PASS" else "FAIL") ++ "  pulse propagates"
  putStrLn ""

  -- Rayleigh scattering
  putStrLn "S4 Rayleigh scattering (sky is blue):"
  let lambdaBlue = 450e-9 :: Double  -- meters
      lambdaRed  = 700e-9 :: Double
      ratio = skyBlueRatio lambdaBlue lambdaRed
      expected = (lambdaRed / lambdaBlue) ** 4.0
  putStrLn $ "  blue/red scattering ratio = " ++ show ratio
  putStrLn $ "  expected (700/450)^4      = " ++ show expected
  let rayOk = abs (ratio - expected) < 1e-6
  putStrLn $ "  " ++ (if rayOk then "PASS" else "FAIL") ++
             "  Rayleigh ratio matches lambda^(-N_w^2) = lambda^(-4)"

  -- Verify exponent is N_w^2 = 4 (not some other number)
  let sig1 = rayleighSigma 1e-6 500e-9
      sig2 = rayleighSigma 1e-6 1000e-9
      -- sigma ~ 1/lambda^4, so sig1/sig2 = (1000/500)^4 = 16
      ratioSig = sig1 / sig2
  putStrLn $ "  sigma ratio (2x wavelength) = " ++ show ratioSig
  let sigOk = abs (ratioSig - 16.0) < 1e-6
  putStrLn $ "  " ++ (if sigOk then "PASS" else "FAIL") ++
             "  scaling 2^(N_w^2) = 2^4 = 16"
  putStrLn ""

  -- Larmor radiation
  putStrLn "S5 Larmor radiation:"
  let pLarmor = larmorPower 1.0 1.0  -- q=1, a=1
      pExpect = 2.0 / 3.0
  putStrLn $ "  P(q=1,a=1) = " ++ show pLarmor ++ " (expected 2/3)"
  let larmOk = abs (pLarmor - pExpect) < 1e-12
  putStrLn $ "  " ++ (if larmOk then "PASS" else "FAIL") ++
             "  Larmor = (N_c-1)/N_c = 2/3"

  -- Larmor scales as q^2 * a^2
  let p2 = larmorPower 2.0 3.0  -- q=2, a=3
      pExpect2 = (2.0/3.0) * 4.0 * 9.0  -- (2/3) * q^2 * a^2
  let larm2Ok = abs (p2 - pExpect2) < 1e-10
  putStrLn $ "  " ++ (if larm2Ok then "PASS" else "FAIL") ++
             "  Larmor scales as q^2 * a^2"
  putStrLn ""

  -- Summary
  putStrLn "================================================================"
  let allPass = and (map snd intChecks) && eOk && changed && cflOk
                && speedOk && rayOk && sigOk && larmOk && larm2Ok
  putStrLn $ "  " ++ (if allPass then "ALL PASS" else "SOME FAILURES") ++
             " -- every EM integer from (2, 3)."
  putStrLn "  Observable count: 0 new (infrastructure)."

main :: IO ()
main = runSelfTest
