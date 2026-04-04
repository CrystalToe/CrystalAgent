-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | ObservableMixing.hs — Component 7 (Mixing): CKM + PMNS + Weinberg

  Every formula is f(VEV). Called with v_crystal AND v_pdg.
  Mixing observables are dimensionless: f(_) ignores VEV, Shift=0.
  Gap = |Expt - f(v_pdg)| / Expt. Status follows Gap.

  Compile: ghc -O2 -main-is ObservableMixing ObservableMixing.hs && ./ObservableMixing
-}

module ObservableMixing (allMixing, main) where

import CrystalAtoms hiding (main)
import ObservableType
import Numeric (showFFloat)

-- =====================================================================
-- FOUR-COLUMN OBSERVABLE (same type as ObservableGauge)
-- =====================================================================

-- =====================================================================
-- CKM MATRIX ELEMENTS (all dimensionless, Shift = 0)
-- =====================================================================

obsVus :: Obs
obsVus = mk "|V_us|" "N_c^2/(Sd+N_w^2) = 9/40"
  (\_ -> fromIntegral (nC * nC) / fromIntegral (sigmaD + nW * nW))
  0.22500 ExactRational

obsADagger :: Obs
obsADagger = mk "A+" "A*Sd/(Sd-1) = 144/175"
  (\_ -> fromIntegral (nW * nW) / fromIntegral (nC + nW)
       * fromIntegral sigmaD / fromIntegral (sigmaD - 1))
  0.826 ExactRational

obsVcb :: Obs
obsVcb = mk "|V_cb|" "A*lam^2 = 81/2000"
  (\_ -> let a   = fromIntegral (nW * nW) / fromIntegral (nC + nW)
             lam = fromIntegral (nC * nC) / fromIntegral (sigmaD + nW * nW)
         in a * lam * lam)
  0.04050 ExactRational

obsVub :: Obs
obsVub = mk "|V_ub|" "A*lam^3/sqrt(chi)"
  (\_ -> let a   = fromIntegral (nW * nW) / fromIntegral (nC + nW)
             lam = fromIntegral (nC * nC) / fromIntegral (sigmaD + nW * nW)
         in a * lam * lam * lam / sqrt chi_d)
  0.00369 ExactRational

obsJarlskog :: Obs
obsJarlskog = mk "J (Jarlskog)" "(N_w+N_c)/(N_w^3*N_c^5) = 5/1944"
  (\_ -> fromIntegral (nW + nC) / fromIntegral (nW ^ (3::Int) * nC ^ (5::Int)))
  2.57e-3 ExactRational

obsDeltaCKM :: Obs
obsDeltaCKM = mk "d_CKM (deg)" "arctan(d3/d2) = arctan(8/3)"
  (\_ -> atan (d3_d / d2_d) * 180.0 / pi)
  69.2 ExactRational

-- =====================================================================
-- PMNS NEUTRINO MIXING
-- =====================================================================

obsSinSq12 :: Obs
obsSinSq12 = mk "sin^2 th_12" "N_c/pi^2 = 3/pi^2"
  (\_ -> nC_d / (pi * pi))
  0.307 SinglePi

obsSinSq23 :: Obs
obsSinSq23 = mk "sin^2 th_23" "chi/(2chi-1) = 6/11"
  (\_ -> chi_d / (2.0 * chi_d - 1.0))
  0.547 ExactRational

obsSinSq13 :: Obs
obsSinSq13 = mk "sin^2 th_13" "(2chi-1)/(N_w^2*(chi-1)^3) = 11/500"
  (\_ -> (2.0 * chi_d - 1.0) / (nW_d * nW_d * (chi_d - 1.0) ^ (3::Int)))
  0.0220 Implosion

obsDeltaPMNS :: Obs
obsDeltaPMNS = mk "d_PMNS (deg)" "pi+arctan(1/3)"
  (\_ -> (pi + atan (d1_d / d2_d)) * 180.0 / pi)
  197.0 ExactRational

-- =====================================================================
-- ELECTROWEAK + BERRY PHASE
-- =====================================================================

obsSinSqW :: Obs
obsSinSqW = mk "sin^2 th_W(MS)" "N_c/(N_w^2+N_c^2) = 3/13"
  (\_ -> nC_d / gauss_d)
  0.23122 ExactRational

obsCos2PMNS :: Obs
obsCos2PMNS = mk "cos(2d_PMNS)" "(d2^2-d1^2)/(d2^2+d1^2) = 4/5"
  (\_ -> (d2_d * d2_d - d1_d * d1_d) / (d2_d * d2_d + d1_d * d1_d))
  0.800 ExactRational

obsAdjAngle :: Obs
obsAdjAngle = mk "Adj angle (deg)" "pi+atan(1/3)-atan(8/3)"
  (\_ -> (pi + atan (d1_d / d2_d) - atan (d3_d / d2_d)) * 180.0 / pi)
  128.97 ExactRational

-- =====================================================================
-- ALL
-- =====================================================================

allMixing :: [Obs]
allMixing =
  [ obsVus, obsVcb, obsVub, obsJarlskog
  , obsDeltaCKM, obsADagger
  , obsSinSq12, obsSinSq23, obsSinSq13, obsDeltaPMNS
  , obsSinSqW, obsCos2PMNS, obsAdjAngle
  ]

-- =====================================================================
-- OUTPUT (identical format to ObservableGauge)
-- =====================================================================


main :: IO ()
main = do
  putStrLn "=================================================================="
  putStrLn " ObservableMixing.hs -- Component 7 (Mixing)"
  putStrLn " CKM + PMNS + Weinberg. All dimensionless. f(VEV) x2."
  putStrLn "=================================================================="
  putStrLn ""
  putStrLn $ "  v_crystal = " ++ show vCry ++ " GeV"
  putStrLn $ "  v_pdg     = " ++ show vPdg ++ " GeV"
  putStrLn ""
  putStrLn $ "  " ++ pr 22 "Name" ++ pr 34 "Formula"
           ++ pr 14 "Crystal" ++ pr 14 "CrystalPdg" ++ pr 14 "Expt"
           ++ pl 10 "Shift" ++ pl 10 "Gap" ++ "  Status"
  putStrLn $ "  " ++ replicate 128 '-'
  mapM_ row allMixing
  putStrLn ""

  check "|V_us| = 9/40" (abs (oCry obsVus - 9.0/40.0) < 1e-14)
  check "|V_cb| = 81/2000" (abs (oCry obsVcb - 81.0/2000.0) < 1e-14)
  check "A+ = 144/175" (abs (oCry obsADagger - 144.0/175.0) < 1e-14)
  check "sin^2 th_23 = 6/11" (abs (oCry obsSinSq23 - 6.0/11.0) < 1e-14)
  check "sin^2 th_13 = 11/500" (abs (oCry obsSinSq13 - 11.0/500.0) < 1e-14)
  check "sin^2 th_W = 3/13" (abs (oCry obsSinSqW - 3.0/13.0) < 1e-14)
  check "cos(2d_PMNS) = 4/5" (abs (oCry obsCos2PMNS - 4.0/5.0) < 1e-14)
  check "J = 5/1944" (abs (oCry obsJarlskog - 5.0/1944.0) < 1e-14)
  check "All Shift = 0 (dimensionless)"
    (all (\o -> shiftPct o < 1e-10) allMixing)
  putStrLn ""

  let gs = map gapPct allMixing
  putStrLn $ "  " ++ show (length gs) ++ " obs"
           ++ " | mean gap " ++ showFFloat (Just 3) (sum gs / fromIntegral (length gs)) "%"
           ++ " | max " ++ showFFloat (Just 3) (maximum gs) "%"
           ++ " | <1%: " ++ show (length (filter (< 1.0) gs))
           ++ "/" ++ show (length gs)
  putStrLn "=================================================================="
