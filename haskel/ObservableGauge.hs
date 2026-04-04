-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | ObservableGauge.hs — Component 7 (Gauge): Couplings + EW Masses

  Uses CrystalImplosion for M_Z correction (v*637/1720).
  M_W and widths use UNCORRECTED M_Z = v*3/8 (matching Main.hs).
  The implosion correction only applies to the M_Z mass itself.

  Compile: ghc -O2 -main-is ObservableGauge ObservableGauge.hs && ./ObservableGauge
-}

module ObservableGauge (allGauge, main) where

import CrystalAtoms hiding (main)
import CrystalImplosion (mzBosonImplosion, impResult)
import ObservableType
import Numeric (showFFloat)

-- =====================================================================
-- FOUR-COLUMN OBSERVABLE
-- =====================================================================

-- Helper: uncorrected M_Z = v * 3/8
mzBase :: Double -> Double
mzBase v = v * fromIntegral nC / fromIntegral (nC * nC - 1)

-- Helper: M_W = M_Z(uncorrected) * sqrt(1 - sin^2 theta_W)
mwBase :: Double -> Double
mwBase v = mzBase v * sqrt (1.0 - nC_d / gauss_d)

-- =====================================================================
-- DIMENSIONLESS (Crystal = CrystalPdg)
-- =====================================================================

obsAlphaInv :: Obs
obsAlphaInv = mk "alpha^-1" "(D+1)pi+ln(b0) = 43pi+ln7"
  (\_ -> fromIntegral (towerD + 1) * pi + log beta0_d)
  137.036 SinglePi

obsSin2W_OS :: Obs
obsSin2W_OS = mk "sin^2 th_W(OS)" "N_w/N_c^2 = 2/9"
  (\_ -> nW_d / (nC_d * nC_d))
  0.22305 ExactRational

obsSin2W_MS :: Obs
obsSin2W_MS = mk "sin^2 th_W(MS)" "N_c/(N_w^2+N_c^2) = 3/13"
  (\_ -> nC_d / gauss_d)
  0.23122 ExactRational

obsAlphaS :: Obs
obsAlphaS = mk "alpha_s(M_Z)" "N_w/(N_c^2+d_col) = 2/17"
  (\_ -> nW_d / fromIntegral (nC * nC + d3))
  0.1180 ExactRational

obsKoide :: Obs
obsKoide = mk "Koide Q" "1-lam_col = 2/3"
  (\_ -> 1.0 - 1.0 / nC_d)
  0.66670 ExactRational

obsGA :: Obs
obsGA = mk "g_A" "N_c^2/b0 = 9/7"
  (\_ -> nC_d * nC_d / beta0_d)
  1.2756 ExactRational

obsAlphaMZ :: Obs
obsAlphaMZ = mk "alpha(M_Z)^-1" "gauss^2-D+1/kap"
  (\_ -> gauss_d * gauss_d - towerD_d + 1.0 / kappa)
  127.951 KappaOrLn

obsNGen :: Obs
obsNGen = mk "N_gen" "N_w^2-1 = 3"
  (\_ -> nW_d * nW_d - 1.0)
  3.000 ExactInteger

-- =====================================================================
-- DIMENSIONFUL (Crystal /= CrystalPdg)
-- =====================================================================

obsVEV :: Obs
obsVEV = mk "v (GeV)" "M_Pl*35/(43*36*2^50)"
  (\v -> v) 246.22 ExactRational

obsHiggs :: Obs
obsHiggs = mk "m_H (GeV)" "v*sqrt(N_w*N_c/e^pi)"
  (\v -> v * sqrt (nW_d * nC_d / exp pi))
  125.09 SinglePi

-- M_Z: uses IMPLOSION correction v*637/1720
obsMZ :: Obs
obsMZ = mk "M_Z (GeV)" "v*637/1720 (implosion)"
  (\v -> impResult (mzBosonImplosion v))
  91.1876 Implosion

-- M_W: uses UNCORRECTED M_Z = v*3/8, then * sqrt(10/13)
obsMW :: Obs
obsMW = mk "M_W (GeV)" "M_Z*sqrt(1-sin^2 th_W)"
  (\v -> mwBase v)
  80.3692 ExactRational

obsTau :: Obs
obsTau = mk "m_tau (GeV)" "v*e^(-pi^2/2)"
  (\v -> v * exp (-(pi * pi) / 2.0))
  1.777 SinglePi

obsTop :: Obs
obsTop = mk "m_t (GeV)" "v/sqrt(N_w)"
  (\v -> v / sqrt nW_d)
  172.57 ExactRational

-- Gamma_W: uses UNCORRECTED M_W
obsGammaW :: Obs
obsGammaW = mk "Gamma_W (GeV)" "GF*MW^3/(6pi*s2)*N_c^2"
  (\v -> let mw = mwBase v
             gf = 1.0 / (v * v * sqrt 2.0)
         in gf * mw ** 3 / (6.0 * pi * sqrt 2.0) * nC_d * nC_d)
  2.085 OneLoop

-- Gamma_Z: uses UNCORRECTED M_Z
obsGammaZ :: Obs
obsGammaZ = mk "Gamma_Z (GeV)" "GF*MZ^3/(6pi*s2)*S(v2+a2)"
  (\v -> let mz  = mzBase v
             gf  = 1.0 / (v * v * sqrt 2.0)
             sw2 = nC_d / gauss_d
             nu  = 3.0 * (0.25 + 0.25)
             el  = 3.0 * ((-0.5 + 2*sw2)**2 + 0.25)
             up  = 2.0 * nC_d * ((0.5 - 4.0/3.0*sw2)**2 + 0.25)
             dn  = 3.0 * nC_d * ((-0.5 + 2.0/3.0*sw2)**2 + 0.25)
         in gf * mz ** 3 / (6.0 * pi * sqrt 2.0) * (nu+el+up+dn))
  2.4952 OneLoop

-- =====================================================================
-- ALL
-- =====================================================================

allGauge :: [Obs]
allGauge =
  [ obsAlphaInv, obsSin2W_OS, obsSin2W_MS, obsAlphaS
  , obsKoide, obsGA, obsAlphaMZ, obsNGen
  , obsVEV, obsHiggs, obsMZ, obsMW, obsTau, obsTop
  , obsGammaW, obsGammaZ
  ]

-- =====================================================================
-- OUTPUT
-- =====================================================================

main :: IO ()
main = do
  putStrLn "=================================================================="
  putStrLn " ObservableGauge.hs -- Component 7 (Gauge)"
  putStrLn " Couplings + EW masses. Implosion for M_Z. f(VEV) x2."
  putStrLn "=================================================================="
  putStrLn ""
  putStrLn $ "  v_crystal = " ++ show vCry ++ " GeV"
  putStrLn $ "  v_pdg     = " ++ show vPdg ++ " GeV"
  putStrLn ""
  putStrLn $ "  " ++ pr 22 "Name" ++ pr 34 "Formula"
           ++ pr 14 "Crystal" ++ pr 14 "CrystalPdg" ++ pr 14 "Expt"
           ++ pl 10 "Shift" ++ pl 10 "Gap" ++ "  Status"
  putStrLn $ "  " ++ replicate 128 '-'
  mapM_ row allGauge
  putStrLn ""

  check "alpha^-1 ~ 137.034" (abs (oCry obsAlphaInv - 137.034) < 0.01)
  check "sin^2 th_W(MS) = 3/13" (abs (oCry obsSin2W_MS - 3.0/13.0) < 1e-14)
  check "alpha_s = 2/17" (abs (oCry obsAlphaS - 2.0/17.0) < 1e-14)
  check "M_Z uses implosion (637/1720)" (abs (oCryPdg obsMZ - 91.187) < 0.01)
  check "M_W uses uncorrected MZ" (abs (oCryPdg obsMW - 80.98) < 0.1)
  check "v_pdg = 246.22" (abs (oCryPdg obsVEV - 246.22) < 0.01)
  putStrLn ""

  let ps = map gapPct allGauge
  putStrLn $ "  " ++ show (length ps) ++ " obs"
           ++ " | mean " ++ showFFloat (Just 3) (sum ps / fromIntegral (length ps)) "%"
           ++ " | max " ++ showFFloat (Just 3) (maximum ps) "%"
           ++ " | <1%: " ++ show (length (filter (< 1.0) ps))
           ++ "/" ++ show (length ps)
  putStrLn "=================================================================="
