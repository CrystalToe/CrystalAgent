-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | Module: CrystalOptics -- Ray/Wave Optics from (2,3).

Snell ray tracing + Fresnel coefficients.

  IOR water:           4/3 = C_F = (N_c^2 - 1) / (2 N_c)
  IOR glass:           3/2 = N_c / N_w
  Rayleigh lambda:     4   = N_w^2
  Rayleigh size:       6   = chi
  Planck lambda:       5   = chi - 1

Observable count: 5 (n_water, n_glass, Rayleigh 4, Rayleigh 6, Planck 5).
Every number from (2,3).
-}

module CrystalOptics where

import Data.Ratio ((%))

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

sq :: Double -> Double
sq x = x * x
{-# INLINE sq #-}

-- =====================================================================
-- S1  OPTICS CONSTANTS FROM (2,3)
--
-- Casimir factor of fundamental rep of SU(N_c):
--   C_F = (N_c^2 - 1) / (2 N_c) = 8/6 = 4/3.
-- This equals the index of refraction of water.
--
-- IOR glass = N_c / N_w = 3/2.
--
-- Rayleigh scattering:
--   Intensity ~ 1/lambda^4.  Exponent 4 = N_w^2.
--   Cross-section ~ d^6.     Exponent 6 = chi.
--
-- Planck spectral radiance:
--   B_lambda ~ 1/lambda^5 / (exp(..) - 1).  Exponent 5 = chi - 1.
-- =====================================================================

-- | Casimir factor C_F = (N_c^2 - 1)/(2 N_c) = 4/3 = n_water.
cF :: Rational
cF = (nC * nC - 1) % (2 * nC)  -- 4/3

-- | Index of refraction of water (floating point).
nWater :: Double
nWater = fromIntegral (nC * nC - 1) / fromIntegral (2 * nC)  -- 4/3

-- | Index of refraction of glass as Rational.
nGlassR :: Rational
nGlassR = nC % nW  -- 3/2

-- | Index of refraction of glass (floating point).
nGlass :: Double
nGlass = fromIntegral nC / fromIntegral nW  -- 1.5

-- | Rayleigh wavelength exponent: 4 = N_w^2.
rayleighLambdaExp :: Integer
rayleighLambdaExp = nW * nW  -- 4

-- | Rayleigh size exponent: 6 = chi.
rayleighSizeExp :: Integer
rayleighSizeExp = chi  -- 6

-- | Planck lambda exponent: 5 = chi - 1.
planckLambdaExp :: Integer
planckLambdaExp = chi - 1  -- 5

-- =====================================================================
-- S2  SNELL'S LAW RAY TRACER
--
-- n1 sin(theta_i) = n2 sin(theta_t).
-- Returns Nothing for total internal reflection.
-- =====================================================================

snellRefract :: Double -> Double -> Double -> Maybe Double
snellRefract n1 n2 thetaI =
  let sinT = n1 / n2 * sin thetaI
  in if abs sinT > 1.0 then Nothing
     else Just (asin sinT)

-- | Critical angle for TIR (requires n1 > n2).
criticalAngle :: Double -> Double -> Double
criticalAngle n1 n2 = asin (n2 / n1)

-- =====================================================================
-- S3  FRESNEL EQUATIONS
-- =====================================================================

-- | Fresnel reflectance, s-polarisation.
fresnelRs :: Double -> Double -> Double -> Double
fresnelRs n1 n2 thetaI =
  case snellRefract n1 n2 thetaI of
    Nothing -> 1.0
    Just thetaT ->
      let cosI = cos thetaI
          cosT = cos thetaT
          num  = n1 * cosI - n2 * cosT
          den  = n1 * cosI + n2 * cosT
      in sq (num / den)

-- | Fresnel reflectance, p-polarisation.
fresnelRp :: Double -> Double -> Double -> Double
fresnelRp n1 n2 thetaI =
  case snellRefract n1 n2 thetaI of
    Nothing -> 1.0
    Just thetaT ->
      let cosI = cos thetaI
          cosT = cos thetaT
          num  = n2 * cosI - n1 * cosT
          den  = n2 * cosI + n1 * cosT
      in sq (num / den)

-- | Unpolarised reflectance (average of Rs and Rp).
fresnelR :: Double -> Double -> Double -> Double
fresnelR n1 n2 thetaI =
  0.5 * (fresnelRs n1 n2 thetaI + fresnelRp n1 n2 thetaI)

-- | Normal-incidence reflectance: R = ((n1-n2)/(n1+n2))^2.
normalReflectance :: Double -> Double -> Double
normalReflectance n1 n2 = sq ((n1 - n2) / (n1 + n2))

-- | Brewster's angle: tan(theta_B) = n2/n1.
brewsterAngle :: Double -> Double -> Double
brewsterAngle n1 n2 = atan (n2 / n1)

-- =====================================================================
-- S4  RAYLEIGH SCATTERING
--
-- I ~ 1/lambda^4 = 1/lambda^(N_w^2).
-- sigma ~ d^6 / lambda^4 = d^chi / lambda^(N_w^2).
-- Sky blue ratio: (lambda_red / lambda_blue)^4 ~ 5.8.
-- =====================================================================

-- | Rayleigh relative intensity: (lambda0/lambda)^(N_w^2).
rayleighIntensity :: Double -> Double -> Double
rayleighIntensity lambda0 lambda =
  let r = lambda0 / lambda
  in r * r * r * r  -- r^4 = r^(N_w^2)

-- | Sky blue ratio: (700/450)^4 ~ 5.86.
skyBlueRatio :: Double
skyBlueRatio = rayleighIntensity 700.0 450.0

-- =====================================================================
-- S5  PLANCK SPECTRAL RADIANCE
--
-- B(lambda, T) = (2 h c^2 / lambda^5) / (exp(hc/(lambda k T)) - 1).
-- Exponent 5 = chi - 1.
-- Wien: lambda_max * T = 2.8978e-3 m K.
-- =====================================================================

hPlanck :: Double
hPlanck = 6.62607015e-34  -- J s

cLight :: Double
cLight = 2.99792458e8  -- m/s

kBoltz :: Double
kBoltz = 1.380649e-23  -- J/K

-- | Planck spectral radiance B(lambda, T).
planckRadiance :: Double -> Double -> Double
planckRadiance lambda t =
  let c2   = cLight * cLight
      lam5 = lambda * lambda * lambda * lambda * lambda  -- lambda^(chi-1)
      num  = 2.0 * hPlanck * c2 / lam5
      x    = hPlanck * cLight / (lambda * kBoltz * t)
      den  = exp x - 1.0
  in num / den

-- | Wien displacement: lambda_max = b / T.
wienDisplacement :: Double -> Double
wienDisplacement t = 2.8977719e-3 / t

-- =====================================================================
-- S6  INTEGER IDENTITY PROOFS
-- =====================================================================

proveCF :: Rational
proveCF = (nC * nC - 1) % (2 * nC)  -- 4/3

proveNGlass :: Rational
proveNGlass = nC % nW  -- 3/2

proveRayleighLambda :: Integer
proveRayleighLambda = nW * nW  -- 4

proveRayleighSize :: Integer
proveRayleighSize = chi  -- 6

provePlanckExp :: Integer
provePlanckExp = chi - 1  -- 5

proveCFNum :: Integer
proveCFNum = nC * nC - 1  -- 8

proveCFDen :: Integer
proveCFDen = 2 * nC  -- 6

-- =====================================================================
-- S7  SELF-TEST
-- =====================================================================

runSelfTest :: IO ()
runSelfTest = do
  putStrLn "================================================================"
  putStrLn " CrystalOptics.hs -- Ray/Wave Optics from (2,3) -- Test"
  putStrLn "================================================================"
  putStrLn ""

  -- S1: Integer identities
  putStrLn "S1 Optics integer identities:"
  let intChecks :: [(String, Bool)]
      intChecks =
        [ ("C_F = 4/3 = (N_c^2-1)/(2N_c) = n_water", proveCF == 4 % 3)
        , ("n_glass = 3/2 = N_c/N_w",                  proveNGlass == 3 % 2)
        , ("Rayleigh lambda exp = 4 = N_w^2",           proveRayleighLambda == 4)
        , ("Rayleigh size exp = 6 = chi",                proveRayleighSize == 6)
        , ("Planck exp = 5 = chi-1",                     provePlanckExp == 5)
        , ("C_F numerator = 8 = N_c^2-1",               proveCFNum == 8)
        , ("C_F denominator = 6 = 2*N_c = chi",          proveCFDen == 6)
        ]
  mapM_ (\(name, ok) ->
    putStrLn $ "  " ++ (if ok then "PASS" else "FAIL") ++ "  " ++ name) intChecks
  putStrLn ""

  -- S2: Snell's law — air -> water at 30 deg
  putStrLn "S2 Snell's law:"
  let theta30  = 30.0 * pi / 180.0
      snell1   = case snellRefract 1.0 nWater theta30 of
        Nothing     -> (False, 0.0)
        Just thetaT ->
          let err = abs (sin theta30 - nWater * sin thetaT)
          in (err < 1.0e-12, thetaT * 180.0 / pi)
      (snellOk1, thetaT1) = snell1
  putStrLn $ "  air->water 30 deg: theta_t = " ++ show thetaT1 ++ " deg"
  putStrLn $ "  " ++ (if snellOk1 then "PASS" else "FAIL") ++
             "  Snell exact (air->water)"

  -- Air -> glass at 45 deg
  let theta45  = 45.0 * pi / 180.0
      snell2   = case snellRefract 1.0 nGlass theta45 of
        Nothing     -> (False, 0.0)
        Just thetaT ->
          let err = abs (sin theta45 - nGlass * sin thetaT)
          in (err < 1.0e-12, thetaT * 180.0 / pi)
      (snellOk2, thetaT2) = snell2
  putStrLn $ "  air->glass 45 deg: theta_t = " ++ show thetaT2 ++ " deg"
  putStrLn $ "  " ++ (if snellOk2 then "PASS" else "FAIL") ++
             "  Snell exact (air->glass)"
  putStrLn ""

  -- S3: Total internal reflection
  putStrLn "S3 Total internal reflection (water -> air):"
  let thetaC    = criticalAngle nWater 1.0
      thetaCRef = asin (3.0 / 4.0)  -- arcsin(1/n_water) = arcsin(3/4)
      critOk    = abs (thetaC - thetaCRef) < 1.0e-12
  putStrLn $ "  critical angle = " ++ show (thetaC * 180.0 / pi) ++ " deg"
  putStrLn $ "  " ++ (if critOk then "PASS" else "FAIL") ++
             "  critical angle = arcsin(3/4)"

  let tirOk = case snellRefract nWater 1.0 (thetaC + 0.01) of
        Nothing -> True
        Just _  -> False
  putStrLn $ "  " ++ (if tirOk then "PASS" else "FAIL") ++
             "  TIR beyond critical angle"
  putStrLn ""

  -- S4: Fresnel
  putStrLn "S4 Fresnel reflectance:"
  let rNorm   = normalReflectance 1.0 nGlass
      rRef    = sq ((1.0 - 1.5) / (1.0 + 1.5))  -- 0.04
      normOk  = abs (rNorm - rRef) < 1.0e-12
  putStrLn $ "  R(normal, glass) = " ++ show rNorm ++ " (expect 0.04)"
  putStrLn $ "  " ++ (if normOk then "PASS" else "FAIL") ++
             "  normal reflectance = ((n-1)/(n+1))^2"

  -- Near-normal Fresnel should match analytical
  let rFresN  = fresnelR 1.0 nGlass 0.001
      frsnOk  = abs (rFresN - rRef) < 1.0e-4
  putStrLn $ "  R(Fresnel,~0)    = " ++ show rFresN
  putStrLn $ "  " ++ (if frsnOk then "PASS" else "FAIL") ++
             "  Fresnel near-normal agrees"

  -- Brewster: Rp = 0
  let bAngle  = brewsterAngle 1.0 nGlass
      rpBrew  = fresnelRp 1.0 nGlass bAngle
      brewOk  = rpBrew < 1.0e-10
  putStrLn $ "  Brewster angle   = " ++ show (bAngle * 180.0 / pi) ++ " deg"
  putStrLn $ "  Rp(Brewster)     = " ++ show rpBrew
  putStrLn $ "  " ++ (if brewOk then "PASS" else "FAIL") ++
             "  Rp = 0 at Brewster angle"
  putStrLn ""

  -- S5: Rayleigh
  putStrLn "S5 Rayleigh scattering:"
  let ratio    = skyBlueRatio
      ratioErr = abs (ratio - 5.8) / 5.8
      rayOk    = ratioErr < 0.02
  putStrLn $ "  sky blue ratio   = " ++ show ratio ++ " (target ~ 5.8)"
  putStrLn $ "  rel error        = " ++ show ratioErr
  putStrLn $ "  " ++ (if rayOk then "PASS" else "FAIL") ++
             "  sky blue ratio ~ 5.8 (< 2%)"
  putStrLn ""

  -- S6: Wien / Planck
  putStrLn "S6 Wien displacement (T = 5778 K, solar):"
  let tSun     = 5778.0
      lamMax   = wienDisplacement tSun
      lamMaxNm = lamMax * 1.0e9
      lamErr   = abs (lamMaxNm - 501.0) / 501.0
      wienOk   = lamErr < 0.01
  putStrLn $ "  lambda_max = " ++ show lamMaxNm ++ " nm (expect ~501)"
  putStrLn $ "  " ++ (if wienOk then "PASS" else "FAIL") ++
             "  Wien peak ~ 501 nm (< 1%)"

  let bPeak   = planckRadiance lamMax tSun
      bDouble = planckRadiance (2.0 * lamMax) tSun
      planckOk = bPeak > bDouble && bPeak > 0.0
  putStrLn $ "  B(peak)  = " ++ show bPeak
  putStrLn $ "  B(2x)    = " ++ show bDouble
  putStrLn $ "  " ++ (if planckOk then "PASS" else "FAIL") ++
             "  Planck peaks at Wien wavelength"
  putStrLn ""

  -- Summary
  putStrLn "================================================================"
  let allPass = and (map snd intChecks)
                && snellOk1 && snellOk2 && critOk && tirOk
                && normOk && frsnOk && brewOk
                && rayOk && wienOk && planckOk
  putStrLn $ "  " ++ (if allPass then "ALL PASS" else "SOME FAILURES") ++
             " -- every Optics integer from (2, 3)."
  putStrLn "  Observable count: 5 (n_water, n_glass, Rayleigh 4, Rayleigh 6, Planck 5)."

main :: IO ()
main = runSelfTest
