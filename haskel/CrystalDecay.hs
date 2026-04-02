-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | Module: CrystalDecay -- Particle Decay from (2,3).

Monte Carlo phase-space integrator for particle decays.

  Beta constant:       192 = d_mixed * d_colour = 24 * 8
  Weinberg angle:      sin^2 theta_W = 3/13 = N_c / gauss
  PMNS theta_12:       sin^2 theta_12 = 3/pi^2
  PMNS theta_23:       sin^2 theta_23 = 6/11 = chi / (2chi - 1)
  Phase space dim:     3N - 4 = N_c*N - (N_c + 1)

Observable count: 5 (beta 192, Weinberg, theta_12, theta_23, phase dim).
Every number from (2,3).
-}

module CrystalDecay where

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
-- S1  DECAY CONSTANTS FROM (2,3)
--
-- d_colour = N_w^3 = 8  (colour factor for quarks/gluons)
-- d_mixed  = N_w^3 * N_c = 24
-- Beta constant 192 = d_mixed * d_colour = 24 * 8.
--   Appears in muon decay: Gamma_mu = G_F^2 * m_mu^5 / (192 pi^3).
--
-- Weinberg angle: sin^2 theta_W = N_c / gauss = 3/13 ~ 0.2308.
--   gauss = N_c^2 + N_w^2 = 13.
--
-- PMNS mixing:
--   sin^2 theta_12 = N_c / pi^2 = 3/pi^2 ~ 0.3040.
--   sin^2 theta_23 = chi / (2chi - 1) = 6/11 ~ 0.5455.
--   sin^2(2 theta_23) = 4*(6/11)*(5/11) = 120/121.
--
-- Phase space: dim = 3N - 4 = N_c*N - (N_c + 1) for N final-state particles.
-- =====================================================================

dColour :: Integer
dColour = nW * nW * nW  -- 8

dMixed :: Integer
dMixed = nW * nW * nW * nC  -- 24

betaConst :: Integer
betaConst = dMixed * dColour  -- 192

sin2ThetaW :: Rational
sin2ThetaW = nC % gauss  -- 3/13

sin2Theta12 :: Double
sin2Theta12 = fromIntegral nC / sq pi  -- 3/pi^2 ~ 0.3040

sin2Theta23 :: Rational
sin2Theta23 = chi % (2 * chi - 1)  -- 6/11

sin22Theta23 :: Rational
sin22Theta23 = 4 * (chi % (2 * chi - 1)) * ((chi - 1) % (2 * chi - 1))  -- 120/121

phaseSpaceDim :: Integer -> Integer
phaseSpaceDim n = nC * n - (nC + 1)  -- 3N - 4

-- =====================================================================
-- S2  PHASE SPACE INTEGRATOR (SIMPSON QUADRATURE)
--
-- Numerical integration for the Fermi beta-decay integral.
-- Simpson's 1/3 rule with strict accumulator.
-- =====================================================================

simpson :: Int -> Double -> Double -> (Double -> Double) -> Double
simpson nPts a b f =
  let n  = if odd nPts then nPts + 1 else nPts
      h  = (b - a) / fromIntegral n
      go :: Int -> Double -> Double
      go i acc
        | i > n     = acc
        | i == 0    = let v = f a in v `seq` go 1 v
        | i == n    = let v = f (a + fromIntegral i * h) in acc + v
        | even i    = let v = f (a + fromIntegral i * h)
                      in v `seq` go (i + 1) (acc + 2.0 * v)
        | otherwise = let v = f (a + fromIntegral i * h)
                      in v `seq` go (i + 1) (acc + 4.0 * v)
  in go 0 0.0 * h / 3.0

-- =====================================================================
-- S3  MUON DECAY AND G_F EXTRACTION
--
-- Gamma_mu = G_F^2 * m_mu^5 / (betaConst * pi^3)
-- => G_F^2 = betaConst * pi^3 / (tau_mu_natural * m_mu^5)
--
-- betaConst = 192 = d_mixed * d_colour.
-- tau_mu_natural = tau_mu_seconds / hbar.
-- =====================================================================

hbar :: Double
hbar = 6.582119569e-25  -- GeV * s

mMu :: Double
mMu = 0.1056583755  -- GeV

tauMuExp :: Double
tauMuExp = 2.1969811e-6  -- seconds

-- | G_F^2 extracted from muon lifetime via betaConst = 192.
gFermiSq :: Double
gFermiSq =
  let bc   = fromIntegral betaConst  -- 192
      tauN = tauMuExp / hbar         -- lifetime in natural units
      mm5  = mMu * mMu * mMu * mMu * mMu
  in bc * pi * pi * pi / (tauN * mm5)

gFermi :: Double
gFermi = sqrt gFermiSq

-- =====================================================================
-- S4  NEUTRON BETA DECAY
--
-- n -> p + e^- + nu_e_bar
-- tau_n = 2 pi^3 hbar / (G_F^2 * V_ud^2 * m_e^5 * (1+3 lambda^2) * f * (1+delta_R))
--
-- Fermi integral f = int_1^E0 F(Z,E) * p * E * (E0 - E)^2 dE
-- with Fermi function for Coulomb correction.
-- =====================================================================

mElectron :: Double
mElectron = 0.00051099895  -- GeV

mNeutron :: Double
mNeutron = 0.93956542052  -- GeV

mProton :: Double
mProton = 0.93827208816  -- GeV

-- | Q value of neutron beta decay.
qValue :: Double
qValue = mNeutron - mProton  -- ~1.293 MeV

-- | Endpoint energy in electron mass units.
e0 :: Double
e0 = qValue / mElectron  -- ~2.531

-- | CKM matrix element |V_ud|.
vUd :: Double
vUd = 0.97373

-- | Axial coupling ratio |g_A / g_V|.
gAxial :: Double
gAxial = 1.2764

-- | Fine structure constant.
alphaEM :: Double
alphaEM = 1.0 / 137.035999084

-- | Inner radiative correction.
deltaR :: Double
deltaR = 0.02467

-- | Fermi function for Coulomb correction (Z=1 daughter).
fermiFunc :: Double -> Double
fermiFunc e =
  let p       = sqrt (sq e - 1.0)
      eta     = alphaEM * e / p
      twoPiE  = 2.0 * pi * eta
  in if p < 1.0e-15 then 1.0
     else twoPiE / (1.0 - exp (- twoPiE))

-- | Beta spectrum integrand: F(Z,E) * p * E * (E0 - E)^2.
betaIntegrand :: Double -> Double
betaIntegrand e =
  let p  = sqrt (sq e - 1.0)
      ff = fermiFunc e
  in ff * p * e * sq (e0 - e)

-- | Fermi integral f (phase space with Coulomb correction).
fermiIntegral :: Double
fermiIntegral = simpson 10000 1.00001 (e0 - 0.00001) betaIntegrand

-- | Neutron lifetime in seconds.
neutronLifetime :: Double
neutronLifetime =
  let me5    = mElectron * mElectron * mElectron * mElectron * mElectron
      lam2   = sq gAxial
      factor = gFermiSq * sq vUd * me5 * (1.0 + 3.0 * lam2)
               * fermiIntegral * (1.0 + deltaR)
      tauNat = 2.0 * pi * pi * pi / factor
  in tauNat * hbar

-- =====================================================================
-- S5  PMNS NEUTRINO OSCILLATION
--
-- Two-flavor approximation:
-- P(nu_a -> nu_b) = sin^2(2 theta) * sin^2(1.267 * Dm^2 * L / E)
-- where Dm^2 in eV^2, L in km, E in GeV.
--
-- sin^2(2 theta_23) = 120/121 from chi = 6.
-- =====================================================================

-- | Two-flavor oscillation probability.
oscillProb :: Double -> Double -> Double -> Double
oscillProb sin22th dm2 lOverE =
  let arg = 1.267 * dm2 * lOverE
  in sin22th * sq (sin arg)

-- | Atmospheric oscillation at L/E ~ 500 km/GeV, Dm^2_32 ~ 2.5e-3 eV^2.
atmosOscillation :: Double
atmosOscillation =
  let s22  = 120.0 / 121.0   -- sin^2(2 theta_23)
      dm2  = 2.5e-3           -- eV^2
      loe  = 500.0            -- km/GeV (T2K-like)
  in oscillProb s22 dm2 loe

-- =====================================================================
-- S6  BETA SPECTRUM SHAPE
-- =====================================================================

-- | Beta spectrum value at electron kinetic energy T (MeV).
betaSpectrum :: Double -> Double
betaSpectrum tMeV =
  let e = tMeV / (mElectron * 1000.0) + 1.0
  in if e >= e0 || e <= 1.0 then 0.0
     else betaIntegrand e

-- | Endpoint kinetic energy in MeV.
betaEndpoint :: Double
betaEndpoint = (e0 - 1.0) * mElectron * 1000.0

-- =====================================================================
-- S7  INTEGER IDENTITY PROOFS
-- =====================================================================

proveDColour :: Integer
proveDColour = nW * nW * nW  -- 8

proveDMixed :: Integer
proveDMixed = nW * nW * nW * nC  -- 24

proveBetaConst :: Integer
proveBetaConst = dMixed * dColour  -- 192

proveWeinberg :: Rational
proveWeinberg = nC % gauss  -- 3/13

proveTheta23 :: Rational
proveTheta23 = chi % (2 * chi - 1)  -- 6/11

proveSin22Theta23 :: Rational
proveSin22Theta23 = sin22Theta23  -- 120/121

provePhaseSpace2 :: Integer
provePhaseSpace2 = phaseSpaceDim 2  -- 2

provePhaseSpace3 :: Integer
provePhaseSpace3 = phaseSpaceDim 3  -- 5

provePhaseSpace4 :: Integer
provePhaseSpace4 = phaseSpaceDim 4  -- 8

-- =====================================================================
-- S8  SELF-TEST
-- =====================================================================

runSelfTest :: IO ()
runSelfTest = do
  putStrLn "================================================================"
  putStrLn " CrystalDecay.hs -- Particle Decay from (2,3) -- Test"
  putStrLn "================================================================"
  putStrLn ""

  -- S1: Integer identities
  putStrLn "S1 Decay integer identities:"
  let intChecks :: [(String, Bool)]
      intChecks =
        [ ("d_colour = 8 = N_w^3",                proveDColour == 8)
        , ("d_mixed = 24 = N_w^3*N_c",            proveDMixed == 24)
        , ("beta 192 = d_mixed*d_colour",          proveBetaConst == 192)
        , ("sin^2 theta_W = 3/13 = N_c/gauss",    proveWeinberg == 3 % 13)
        , ("sin^2 theta_23 = 6/11 = chi/(2chi-1)", proveTheta23 == 6 % 11)
        , ("sin^2(2 theta_23) = 120/121",          proveSin22Theta23 == 120 % 121)
        , ("phase dim(N=2) = 2",                   provePhaseSpace2 == 2)
        , ("phase dim(N=3) = 5",                   provePhaseSpace3 == 5)
        , ("phase dim(N=4) = 8 = d_colour",        provePhaseSpace4 == 8)
        ]
  mapM_ (\(name, ok) ->
    putStrLn $ "  " ++ (if ok then "PASS" else "FAIL") ++ "  " ++ name) intChecks
  putStrLn ""

  -- S2: G_F extraction from muon decay via 192
  putStrLn "S2 G_F from muon decay (192 = betaConst):"
  let gfRef = 1.1663788e-5 :: Double
      gfErr = abs (gFermi - gfRef) / gfRef
  putStrLn $ "  betaConst     = " ++ show betaConst
  putStrLn $ "  G_F extracted = " ++ show gFermi ++ " GeV^-2"
  putStrLn $ "  G_F PDG       = " ++ show gfRef
  putStrLn $ "  rel error     = " ++ show gfErr
  let gfOk = gfErr < 0.005
  putStrLn $ "  " ++ (if gfOk then "PASS" else "FAIL") ++
             "  G_F from 192*pi^3 (< 0.5%)"
  putStrLn ""

  -- S3: Neutron lifetime
  putStrLn "S3 Neutron lifetime:"
  putStrLn $ "  Fermi integral f = " ++ show fermiIntegral
  putStrLn $ "  tau_n predicted  = " ++ show neutronLifetime ++ " s"
  let tauTarget = 878.0 :: Double
      tauErr = abs (neutronLifetime - tauTarget) / tauTarget
  putStrLn $ "  tau_n target     ~ " ++ show tauTarget ++ " s"
  putStrLn $ "  rel error        = " ++ show tauErr
  let tauOk = tauErr < 0.05
  putStrLn $ "  " ++ (if tauOk then "PASS" else "FAIL") ++
             "  neutron lifetime ~ 878 s (< 5%)"
  putStrLn ""

  -- S4: Weinberg angle
  putStrLn "S4 Weinberg angle:"
  let sw2C = fromIntegral nC / fromIntegral gauss :: Double
      sw2E = 0.23122 :: Double
      sw2D = abs (sw2C - sw2E)
  putStrLn $ "  sin^2 theta_W crystal = " ++ show sw2C ++ " (3/13)"
  putStrLn $ "  sin^2 theta_W PDG     = " ++ show sw2E
  putStrLn $ "  abs difference        = " ++ show sw2D
  let swOk = sw2D < 0.002
  putStrLn $ "  " ++ (if swOk then "PASS" else "FAIL") ++
             "  Weinberg angle 3/13 ~ 0.231 (< 0.002)"
  putStrLn ""

  -- S5: PMNS mixing angles
  putStrLn "S5 PMNS mixing angles:"
  let s23C = fromIntegral chi / fromIntegral (2 * chi - 1) :: Double
      s23E = 0.545 :: Double
      s23Err = abs (s23C - s23E) / s23E
  putStrLn $ "  sin^2 theta_23 crystal = " ++ show s23C ++ " (6/11)"
  putStrLn $ "  sin^2 theta_23 exp     = " ++ show s23E
  putStrLn $ "  rel error              = " ++ show s23Err
  let s23Ok = s23Err < 0.01
  putStrLn $ "  " ++ (if s23Ok then "PASS" else "FAIL") ++
             "  theta_23 = 6/11 ~ 0.545 (< 1%)"

  let s12E = 0.307 :: Double
      s12Err = abs (sin2Theta12 - s12E) / s12E
  putStrLn $ "  sin^2 theta_12 crystal = " ++ show sin2Theta12 ++ " (3/pi^2)"
  putStrLn $ "  sin^2 theta_12 exp     = " ++ show s12E
  putStrLn $ "  rel error              = " ++ show s12Err
  let s12Ok = s12Err < 0.02
  putStrLn $ "  " ++ (if s12Ok then "PASS" else "FAIL") ++
             "  theta_12 = 3/pi^2 ~ 0.304 (< 2%)"

  -- sin^2(2 theta_23) floating-point cross-check
  let s22F  = 4.0 * s23C * (1.0 - s23C)
      s22Ex = 120.0 / 121.0
      s22Err = abs (s22F - s22Ex)
  putStrLn $ "  sin^2(2 theta_23) = " ++ show s22F ++ " (120/121)"
  let s22Ok = s22Err < 1.0e-12
  putStrLn $ "  " ++ (if s22Ok then "PASS" else "FAIL") ++
             "  sin^2(2 theta_23) = 120/121"
  putStrLn ""

  -- S6: Atmospheric oscillation
  putStrLn "S6 Atmospheric oscillation (T2K-like):"
  let pOsc = atmosOscillation
  putStrLn $ "  P(nu_mu -> nu_tau) = " ++ show pOsc
  let oscOk = pOsc > 0.0 && pOsc <= 1.0
  putStrLn $ "  " ++ (if oscOk then "PASS" else "FAIL") ++
             "  oscillation probability in [0,1]"
  putStrLn ""

  -- S7: Beta spectrum shape
  putStrLn "S7 Beta spectrum shape:"
  let endPt  = betaEndpoint
      specNE = betaSpectrum (endPt * 0.001)       -- near threshold
      specMd = betaSpectrum (endPt * 0.4)          -- mid-range
      specHi = betaSpectrum (endPt - 0.001)        -- near endpoint
  putStrLn $ "  endpoint = " ++ show endPt ++ " MeV"
  putStrLn $ "  spec(near 0) = " ++ show specNE
  putStrLn $ "  spec(0.4 max) = " ++ show specMd
  putStrLn $ "  spec(near end) = " ++ show specHi
  let specOk = specMd > specNE && specMd > specHi && specHi < specMd * 0.05
  putStrLn $ "  " ++ (if specOk then "PASS" else "FAIL") ++
             "  beta spectrum: peak in middle, vanishes at endpoint"
  putStrLn ""

  -- Summary
  putStrLn "================================================================"
  let allPass = and (map snd intChecks) && gfOk && tauOk && swOk
                && s23Ok && s12Ok && s22Ok && oscOk && specOk
  putStrLn $ "  " ++ (if allPass then "ALL PASS" else "SOME FAILURES") ++
             " -- every Decay integer from (2, 3)."
  putStrLn "  Observable count: 5 (beta 192, Weinberg, theta_12, theta_23, phase dim)."

main :: IO ()
main = runSelfTest
