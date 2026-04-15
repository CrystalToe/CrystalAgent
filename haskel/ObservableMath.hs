-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | ObservableMath.hs — Component 7 (Math): Constants from (2,3)

  Mathematical constants derived or approximated from the crystal.
  ALL dimensionless (Shift = 0). No corrections.

  Compile: ghc -O2 -main-is ObservableMath ObservableMath.hs && ./ObservableMath
-}

module ObservableMath (allMath, main) where

import CrystalAtoms hiding (main)
import ObservableType
import Numeric (showFFloat)

-- =====================================================================
-- FOUR-COLUMN OBSERVABLE
-- =====================================================================

-- =====================================================================
-- IRRATIONAL CONSTANTS (exact from basis)
-- =====================================================================

-- | sqrt(2) = sqrt(N_w) — basis element, exact
obsSqrt2 :: Obs
obsSqrt2 = mk "sqrt(2)" "sqrt(N_w)"
  (\_ -> sqrt nW_d) (sqrt 2.0) ExactRational

-- | ln(2) — basis element, exact
obsLn2 :: Obs
obsLn2 = mk "ln(2)" "ln(N_w)"
  (\_ -> log nW_d) (log 2.0) ExactRational

-- | pi^2/6 = Basel sum = zeta(2) = pi^2/chi
obsBasel :: Obs
obsBasel = mk "pi^2/6 (Basel)" "pi^2/chi"
  (\_ -> pi * pi / chi_d) (pi * pi / 6.0) ExactRational

-- | kappa = ln(3)/ln(2) = log_2(3)
obsKappa :: Obs
obsKappa = mk "kappa" "ln(Nc)/ln(Nw) = log2(3)"
  (\_ -> log nC_d / log nW_d) (log 3.0 / log 2.0) KappaOrLn

-- =====================================================================
-- RATIONAL APPROXIMATIONS
-- =====================================================================

-- | e (Euler) ≈ (gauss+chi)/beta0 = 19/7 = 2.7143
obsEuler :: Obs
obsEuler = mk "e (Euler)" "(gauss+chi)/b0 = 19/7"
  (\_ -> (gauss_d + chi_d) / beta0_d) (exp 1.0) ExactRational

-- | phi (golden) = gauss/N_w^3 - 1/(gauss*N_w*b0) = 13/8 - 1/182
obsPhi :: Obs
obsPhi = mk "phi (golden)" "13/8 - 1/182"
  (\_ -> gauss_d / (nW_d ** 3)
       - 1.0 / (gauss_d * nW_d * beta0_d))
  ((1.0 + sqrt 5.0) / 2.0) KappaOrLn

-- | zeta(3) Apery = chi/(chi-1) = 6/5
obsZeta3 :: Obs
obsZeta3 = mk "zeta(3) Apery" "chi/(chi-1) = 6/5"
  (\_ -> chi_d / (chi_d - 1.0)) 1.2021 ExactRational

-- | Catalan G = 1 - N_w^2/(D+chi) = 11/12
obsCatalan :: Obs
obsCatalan = mk "Catalan G" "1-Nw^2/(D+chi) = 11/12"
  (\_ -> 1.0 - nW_d * nW_d / (towerD_d + chi_d)) 0.9160 ExactRational

-- | Euler-Mascheroni gamma = 7/12 - 1/167
obsGamma :: Obs
obsGamma = mk "gamma (E-M)" "b0/(gauss-1) - 1/(gauss^2-Nw)"
  (\_ -> beta0_d / (gauss_d - 1.0)
       - 1.0 / (gauss_d * gauss_d - nW_d))
  0.5772 KappaOrLn

-- =====================================================================
-- STRUCTURAL INTEGERS
-- =====================================================================

-- | Bekenstein area quantum = N_w^2 = 4
obsBekenstein :: Obs
obsBekenstein = mk "Bekenstein" "N_w^2 = 4"
  (\_ -> nW_d * nW_d) 4.0 ExactInteger

-- | Lagrange points = chi - 1 = 5
obsLagrange :: Obs
obsLagrange = mk "Lagrange pts" "chi-1 = 5"
  (\_ -> chi_d - 1.0) 5.0 ExactInteger

-- | 3-body phase space = N_c * chi = 18
obs3Body :: Obs
obs3Body = mk "3-body DOF" "Nc*chi = 18"
  (\_ -> nC_d * chi_d) 18.0 ExactInteger

-- | R (e+e- -> hadrons, uds) = N_c * sum(Q_i^2) = 3*(4/9+1/9+1/9) = 2
obsRRatio :: Obs
obsRRatio = mk "R(e+e-,uds)" "Nc*sum(Qi^2) = 2"
  (\_ -> nC_d * (4.0/9.0 + 1.0/9.0 + 1.0/9.0)) 2.0 ExactRational

-- =====================================================================
-- ALL
-- =====================================================================

allMath :: [Obs]
allMath =
  -- Irrational (exact basis)
  [ obsSqrt2, obsLn2, obsBasel, obsKappa
  -- Rational approximations
  , obsEuler, obsPhi, obsZeta3, obsCatalan, obsGamma
  -- Structural integers
  , obsBekenstein, obsLagrange, obs3Body, obsRRatio
  ]

-- =====================================================================
-- OUTPUT
-- =====================================================================


main :: IO ()
main = do
  putStrLn "=================================================================="
  putStrLn " ObservableMath.hs -- Component 7 (Math)"
  putStrLn " Constants from (2,3). Dimensionless."
  putStrLn "=================================================================="
  putStrLn ""
  putStrLn $ "  " ++ pr 20 "Name" ++ pr 30 "Formula"
           ++ pr 14 "Crystal" ++ pr 14 "CrystalPdg" ++ pr 14 "Expt"
           ++ pl 10 "Shift" ++ pl 10 "Gap" ++ "  Status"
  putStrLn $ "  " ++ replicate 122 '-'

  putStrLn "  --- Irrational (basis elements) ---"
  mapM_ row (take 4 allMath)
  putStrLn "  --- Rational Approximations ---"
  mapM_ row (take 5 (drop 4 allMath))
  putStrLn "  --- Structural Integers ---"
  mapM_ row (drop 9 allMath)
  putStrLn ""

  check "sqrt(2) exact" (abs (oCry obsSqrt2 - sqrt 2.0) < 1e-14)
  check "ln(2) exact" (abs (oCry obsLn2 - log 2.0) < 1e-14)
  check "Basel = pi^2/6" (abs (oCry obsBasel - pi*pi/6.0) < 1e-14)
  check "zeta(3) = 6/5" (abs (oCry obsZeta3 - 1.2) < 1e-14)
  check "Catalan = 11/12" (abs (oCry obsCatalan - 11.0/12.0) < 1e-14)
  check "e ~ 19/7" (abs (oCry obsEuler - 19.0/7.0) < 1e-14)
  check "R = 2" (abs (oCry obsRRatio - 2.0) < 1e-10)
  check "All Shift = 0" (all (\o -> shiftPct o < 1e-10) allMath)
  putStrLn ""

  let gs = map gapPct allMath
  putStrLn $ "  " ++ show (length gs) ++ " obs"
           ++ " | mean gap " ++ showFFloat (Just 3) (sum gs / fromIntegral (length gs)) "%"
           ++ " | max " ++ showFFloat (Just 3) (maximum gs) "%"
           ++ " | <1%: " ++ show (length (filter (< 1.0) gs))
           ++ "/" ++ show (length gs)
  putStrLn "=================================================================="
