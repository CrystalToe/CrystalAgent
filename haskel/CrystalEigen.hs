-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | CrystalEigen.hs — Component 4: The Four Eigenvalues

  Four contraction rates, one per sector: {1, 1/2, 1/3, 1/6}.
  Not chosen. Forced by the algebra: lambda_k = 1/denom_k where
  denom = {1, N_w, N_c, chi}.

  Also: W and U half-steps. W contracts sqrt(lambda_k) per sector
  (vertical isometry). U contracts sqrt(lambda_k) per sector
  (horizontal disentangler). S = W o U gives lambda_k (the tick).

  The sqrt values here are the ONLY sqrt in the entire codebase.
  Evaluated once at module load. Never in the tick loop.

  This module imports CrystalAtoms only. It knows nothing about
  sectors or operators.

  Compile: ghc -O2 -main-is CrystalEigen CrystalEigen.hs && ./CrystalEigen
-}

module CrystalEigen
  ( -- Eigenvalues
    lambda

    -- W and U half-steps
  , wK, uK

    -- Self-test
  , main
  ) where

import CrystalAtoms hiding (main)

-- ═══════════════════════════════════════════════════════════════
-- EIGENVALUES
--
-- lambda_k = 1/denom_k. Denominators: 1, N_w, N_c, chi.
-- Product: 1 x 2 x 3 x 6 = 36 = Sigma_d.
-- ═══════════════════════════════════════════════════════════════

-- | Sector eigenvalue (contraction per tick)
lambda :: Int -> Double
lambda 0 = 1.0                           -- singlet: immortal
lambda 1 = 1.0 / nW_d                    -- weak: 1/2
lambda 2 = 1.0 / nC_d                    -- colour: 1/3
lambda 3 = 1.0 / chi_d                   -- mixed: 1/6
lambda _ = 0.0

-- ═══════════════════════════════════════════════════════════════
-- W AND U HALF-STEPS
--
-- W: isometry (vertical, contracts sqrt(lambda_k) per sector)
-- U: disentangler (horizontal, contracts sqrt(lambda_k) per sector)
-- S = W o U gives lambda_k per sector (the full tick).
--
-- These are the ONLY sqrt in the codebase. Computed once.
-- ═══════════════════════════════════════════════════════════════

-- | W contraction (vertical, isometry)
wK :: Int -> Double
wK 0 = 1.0
wK 1 = 0.7071067811865476  -- 1/sqrt(2)
wK 2 = 0.5773502691896258  -- 1/sqrt(3)
wK 3 = 0.4082482904638631  -- 1/sqrt(6)
wK _ = 0.0

-- | U contraction (horizontal, disentangler)
uK :: Int -> Double
uK = wK  -- same eigenvalues: sqrt(lambda_k) = sqrt(lambda_k)

-- ═══════════════════════════════════════════════════════════════
-- SELF-TEST
-- ═══════════════════════════════════════════════════════════════

check :: String -> Bool -> IO ()
check name True  = putStrLn $ "  PASS  " ++ name
check name False = putStrLn $ "  FAIL  " ++ name

main :: IO ()
main = do
  putStrLn "================================================================"
  putStrLn " CrystalEigen.hs — Component 4: The Four Eigenvalues"
  putStrLn "================================================================"
  putStrLn ""

  putStrLn "Eigenvalues:"
  check "lambda_0 = 1 (singlet)" (lambda 0 == 1.0)
  check "lambda_1 = 1/2 (weak)" (abs (lambda 1 - 0.5) < 1e-14)
  check "lambda_2 = 1/3 (colour)" (abs (lambda 2 - 1.0/3.0) < 1e-14)
  check "lambda_3 = 1/6 (mixed)" (abs (lambda 3 - 1.0/6.0) < 1e-14)
  check "lambda_mixed = lambda_weak x lambda_colour" (abs (lambda 3 - lambda 1 * lambda 2) < 1e-14)
  putStrLn ""

  putStrLn "W half-steps (sqrt of eigenvalues):"
  check "wK 0 = 1" (wK 0 == 1.0)
  check "wK 1 = 1/sqrt(2)" (abs (wK 1 * wK 1 - lambda 1) < 1e-14)
  check "wK 2 = 1/sqrt(3)" (abs (wK 2 * wK 2 - lambda 2) < 1e-14)
  check "wK 3 = 1/sqrt(6)" (abs (wK 3 * wK 3 - lambda 3) < 1e-14)
  putStrLn ""

  putStrLn "W o U = lambda (tick factorisation):"
  check "wK 0 * uK 0 = lambda 0" (abs (wK 0 * uK 0 - lambda 0) < 1e-14)
  check "wK 1 * uK 1 = lambda 1" (abs (wK 1 * uK 1 - lambda 1) < 1e-14)
  check "wK 2 * uK 2 = lambda 2" (abs (wK 2 * uK 2 - lambda 2) < 1e-14)
  check "wK 3 * uK 3 = lambda 3" (abs (wK 3 * uK 3 - lambda 3) < 1e-14)
  putStrLn ""

  putStrLn "Integer identities:"
  check "denominators: 1 x 2 x 3 x 6 = 36 = Sigma_d" (1 * nW * nC * chi == sigmaD)
  check "sum of reciprocals: 6+3+2+1 = 12" (chi + nC + nW + 1 == 12)
  putStrLn ""

  putStrLn "================================================================"
  putStrLn " Four rates: {1, 1/2, 1/3, 1/6}. From N_w and N_c. That is it."
  putStrLn "================================================================"
