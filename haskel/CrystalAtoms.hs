-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | CrystalAtoms.hs — Component 2: Building Blocks

  The 15 derived quantities from N_w = 2 and N_c = 3.
  These are the VOCABULARY of all physics. Every observable,
  every coupling, every operator entry is a rational expression
  over these atoms.

  This module imports NOTHING. It is the root of the dependency tree.

  The ONLY external input in the entire Crystal Topos is VEV = 246.22 GeV.
  It is optional. Without it, all observables are dimensionless ratios.
  With it, ratios become physical masses and energies.

  Compile: ghc -O2 -main-is CrystalAtoms CrystalAtoms.hs && ./CrystalAtoms
-}

module CrystalAtoms
  ( -- §0 The two primes
    nW, nC

    -- §1 Derived integers
  , chi, beta0
  , d1, d2, d3, d4
  , sigmaD, sigmaD2, towerD
  , gauss, fermat3

    -- §2 Derived rationals
  , cF, tF, kappa

    -- §3 The single optional input
  , vev

    -- §4 Double-precision atoms (for operator construction)
  , nW_d, nC_d, chi_d, beta0_d
  , d1_d, d2_d, d3_d, d4_d
  , sigmaD_d, sigmaD2_d, towerD_d
  , gauss_d, fermat3_d

    -- §5 Self-test
  , main
  ) where

-- ═══════════════════════════════════════════════════════════════
-- §0 THE TWO PRIMES
--
-- N_w = 2 from M₂(ℂ) — weak isospin
-- N_c = 3 from M₃(ℂ) — colour
--
-- Everything else is derived. No choices. No parameters.
-- ═══════════════════════════════════════════════════════════════

nW, nC :: Int
nW = 2
nC = 3

-- ═══════════════════════════════════════════════════════════════
-- §1 DERIVED INTEGERS
--
-- All from N_w = 2 and N_c = 3. Computed once.
-- These are the WORDS of the physics language.
-- ═══════════════════════════════════════════════════════════════

-- | Internal dimension χ = N_w × N_c = 6
chi :: Int
chi = nW * nC

-- | QCD beta function coefficient β₀ = (11N_c − 2χ)/3 = 7
beta0 :: Int
beta0 = (11 * nC - 2 * chi) `div` 3

-- | Sector dimensions from Wedderburn decomposition of A_F
d1, d2, d3, d4 :: Int
d1 = 1                                   -- singlet
d2 = nW * nW - 1                         -- 3, weak adjoint
d3 = nC * nC - 1                         -- 8, colour adjoint
d4 = (nW * nW - 1) * (nC * nC - 1)      -- 24, mixed = weak ⊗ colour

-- | Total state space dimension Σd = d₁ + d₂ + d₃ + d₄ = 36
sigmaD :: Int
sigmaD = d1 + d2 + d3 + d4

-- | Quadratic Casimir sum Σd² = d₁² + d₂² + d₃² + d₄² = 650
sigmaD2 :: Int
sigmaD2 = d1*d1 + d2*d2 + d3*d3 + d4*d4

-- | Tower depth D = Σd + χ = 42
towerD :: Int
towerD = sigmaD + chi

-- | Gauss integer = N_w² + N_c² = 13
gauss :: Int
gauss = nW * nW + nC * nC

-- | Third Fermat prime F₃ = 2^(2^N_c) + 1 = 257
fermat3 :: Int
fermat3 = 257

-- ═══════════════════════════════════════════════════════════════
-- §2 DERIVED RATIONALS
--
-- Three non-integer atoms. Two are exact rationals.
-- One (κ = ln3/ln2) is the ONLY irrational from (2,3).
-- ═══════════════════════════════════════════════════════════════

-- | Fundamental Casimir C_F = (N_c² − 1)/(2N_c) = 4/3
cF :: Double
cF = fromIntegral (nC * nC - 1) / fromIntegral (2 * nC)

-- | Fundamental index T_F = 1/N_w = 1/2
tF :: Double
tF = 1.0 / fromIntegral nW

-- | The only irrational: κ = ln(N_c)/ln(N_w) = ln3/ln2 ≈ 1.58496
kappa :: Double
kappa = log (fromIntegral nC) / log (fromIntegral nW)

-- ═══════════════════════════════════════════════════════════════
-- §3 THE SINGLE OPTIONAL INPUT
--
-- VEV = 246.22 GeV. The Higgs vacuum expectation value.
-- This is the ONE AND ONLY measured input. If you use it,
-- dimensionless ratios become physical units (GeV, metres, etc).
-- If you don't use it, everything is a pure ratio from (2,3).
-- ═══════════════════════════════════════════════════════════════

-- | Higgs vacuum expectation value in GeV.
-- The single optional input. PDG 2024: 246.22 ± 0.01 GeV.
vev :: Double
vev = 246.22

-- ═══════════════════════════════════════════════════════════════
-- §4 DOUBLE-PRECISION ATOMS
--
-- Same values as §1, pre-converted to Double for use in
-- operator construction (avoiding repeated fromIntegral).
-- ═══════════════════════════════════════════════════════════════

nW_d, nC_d, chi_d, beta0_d :: Double
nW_d    = fromIntegral nW
nC_d    = fromIntegral nC
chi_d   = fromIntegral chi
beta0_d = fromIntegral beta0

d1_d, d2_d, d3_d, d4_d :: Double
d1_d = fromIntegral d1
d2_d = fromIntegral d2
d3_d = fromIntegral d3
d4_d = fromIntegral d4

sigmaD_d, sigmaD2_d, towerD_d :: Double
sigmaD_d  = fromIntegral sigmaD
sigmaD2_d = fromIntegral sigmaD2
towerD_d  = fromIntegral towerD

gauss_d, fermat3_d :: Double
gauss_d   = fromIntegral gauss
fermat3_d = fromIntegral fermat3

-- ═══════════════════════════════════════════════════════════════
-- §5 SELF-TEST
-- ═══════════════════════════════════════════════════════════════

check :: String -> Bool -> IO ()
check name True  = putStrLn $ "  PASS  " ++ name
check name False = putStrLn $ "  FAIL  " ++ name

main :: IO ()
main = do
  putStrLn "╔══════════════════════════════════════════════════════════════╗"
  putStrLn "║  CrystalAtoms.hs — The 15 Building Blocks from (2,3)       ║"
  putStrLn "╚══════════════════════════════════════════════════════════════╝"
  putStrLn ""

  putStrLn "§0 The two primes:"
  check "N_w = 2" (nW == 2)
  check "N_c = 3" (nC == 3)
  putStrLn ""

  putStrLn "§1 Derived integers:"
  check "χ = N_w × N_c = 6" (chi == 6)
  check "β₀ = (11N_c − 2χ)/3 = 7" (beta0 == 7)
  check "d₁ = 1" (d1 == 1)
  check "d₂ = N_w² − 1 = 3" (d2 == 3)
  check "d₃ = N_c² − 1 = 8" (d3 == 8)
  check "d₄ = (N_w²−1)(N_c²−1) = 24" (d4 == 24)
  check "Σd = 36" (sigmaD == 36)
  check "Σd² = 650" (sigmaD2 == 650)
  check "D = 42" (towerD == 42)
  check "gauss = 13" (gauss == 13)
  check "F₃ = 257" (fermat3 == 257)
  putStrLn ""

  putStrLn "§2 Derived rationals:"
  check "C_F = 4/3" (abs (cF - 4.0/3.0) < 1e-14)
  check "T_F = 1/2" (abs (tF - 0.5) < 1e-14)
  check "κ = ln3/ln2 ≈ 1.585" (abs (kappa - 1.58496) < 1e-4)
  putStrLn ""

  putStrLn "§3 Key identities (all from 2 and 3):"
  check "d₄ = d₂ × d₃ (mixed = weak ⊗ colour)" (d4 == d2 * d3)
  check "Σd = d₁ + d₂ + d₃ + d₄" (sigmaD == d1 + d2 + d3 + d4)
  check "D = Σd + χ" (towerD == sigmaD + chi)
  check "gauss = N_w² + N_c²" (gauss == nW*nW + nC*nC)
  check "β₀ × Σd² = 4550" (beta0 * sigmaD2 == 4550)
  check "d₃ × d₄ = 192" (d3 * d4 == 192)
  check "192 = 2⁶ × 3" (2^(6::Int) * 3 == 192)
  check "gauss + N_w² = 17" (gauss + nW*nW == 17)
  check "D × F₃ × Σd = 388584" (towerD * fermat3 * sigmaD == 388584)
  putStrLn ""

  putStrLn "§4 VEV (the single optional input):"
  putStrLn $ "  VEV = " ++ show vev ++ " GeV"
  check "VEV = 246.22" (abs (vev - 246.22) < 0.01)
  putStrLn ""

  putStrLn "╔══════════════════════════════════════════════════════════════╗"
  putStrLn "║  15 atoms, all from 2 and 3. 1 optional input (VEV).       ║"
  putStrLn "║  Root of the dependency tree. Imports nothing.              ║"
  putStrLn "╚══════════════════════════════════════════════════════════════╝"
