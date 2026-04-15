-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
-- CrystalMagicNumbers — Unified magic-number formula with prime-structural gating
--
-- Proves that
--   M(n) = N_w · [C(n,1)+C(n,2)+C(n,3)] + N_w · C(n,2) · 𝟙(n ≤ N_c)
-- with (N_w, N_c) = (2, 3) reproduces {2, 8, 20, 28, 50, 82, 126}
-- at n = 1..7, predicts M(8) = 184, and that every observed magic
-- number factors into the blessed prime set
-- B = {2, 3, 5, 7, 11, 19, 41, 43, 67, 163}.

module CrystalMagicNumbers where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)
open import Agda.Builtin.Bool

-- ============================================================
-- RECTANGLE INPUTS
-- ============================================================

nW : ℕ
nW = 2

nC : ℕ
nC = 3

-- ============================================================
-- BINOMIAL COEFFICIENT
-- ============================================================

binom : ℕ → ℕ → ℕ
binom _ 0 = 1
binom 0 (suc _) = 0
binom (suc n) (suc k) = binom n k + binom n (suc k)

-- Smoke tests
binom-4-1 : binom 4 1 ≡ 4
binom-4-1 = refl

binom-4-2 : binom 4 2 ≡ 6
binom-4-2 = refl

binom-4-3 : binom 4 3 ≡ 4
binom-4-3 = refl

binom-7-3 : binom 7 3 ≡ 35
binom-7-3 = refl

-- ============================================================
-- IVERSON BRACKET  𝟙(n ≤ m)
-- ============================================================

_≤?_ : ℕ → ℕ → Bool
zero   ≤? _       = true
suc _  ≤? zero    = false
suc n  ≤? suc m   = n ≤? m

iverson : ℕ → ℕ → ℕ
iverson n m with n ≤? m
... | true  = 1
... | false = 0

-- ============================================================
-- THE UNIFIED MAGIC-NUMBER FORMULA
-- ============================================================
-- M(n) = N_w · [ C(n,1) + C(n,2) + C(n,3) + C(n,2) · 𝟙(n ≤ N_c) ]

M : ℕ → ℕ
M n = nW * (binom n 1 + binom n 2 + binom n 3)
    + nW * binom n 2 * iverson n nC

-- ============================================================
-- THE SEVEN OBSERVED MAGIC NUMBERS
-- ============================================================

magic-1 : M 1 ≡ 2
magic-1 = refl

magic-2 : M 2 ≡ 8
magic-2 = refl

magic-3 : M 3 ≡ 20
magic-3 = refl

magic-4 : M 4 ≡ 28
magic-4 = refl

magic-5 : M 5 ≡ 50
magic-5 = refl

magic-6 : M 6 ≡ 82
magic-6 = refl

magic-7 : M 7 ≡ 126
magic-7 = refl

-- ============================================================
-- PREDICTED CEILING AND BREAK STRUCTURE
-- ============================================================

magic-8-predicted : M 8 ≡ 184
magic-8-predicted = refl

M-9  : M 9  ≡ 258
M-9  = refl

M-10 : M 10 ≡ 350
M-10 = refl

M-11 : M 11 ≡ 462
M-11 = refl

M-12 : M 12 ≡ 596
M-12 = refl

M-13 : M 13 ≡ 754
M-13 = refl

-- ============================================================
-- BASE / BONUS DECOMPOSITION
-- ============================================================

Mbase : ℕ → ℕ
Mbase n = nW * (binom n 1 + binom n 2 + binom n 3)

Mbonus : ℕ → ℕ
Mbonus n = nW * binom n 2 * iverson n nC

-- Base values (simplex skeleton, Wigner formula)
base-1 : Mbase 1 ≡ 2
base-1 = refl

base-2 : Mbase 2 ≡ 6
base-2 = refl

base-3 : Mbase 3 ≡ 14
base-3 = refl

base-4 : Mbase 4 ≡ 28
base-4 = refl

base-5 : Mbase 5 ≡ 50
base-5 = refl

base-6 : Mbase 6 ≡ 82
base-6 = refl

base-7 : Mbase 7 ≡ 126
base-7 = refl

base-8 : Mbase 8 ≡ 184
base-8 = refl

-- Bonus active for n ≤ N_c
bonus-1 : Mbonus 1 ≡ 0
bonus-1 = refl

bonus-2 : Mbonus 2 ≡ 2
bonus-2 = refl

bonus-3 : Mbonus 3 ≡ 6
bonus-3 = refl

-- Bonus vanishes for n > N_c = 3
bonus-off-4 : Mbonus 4 ≡ 0
bonus-off-4 = refl

bonus-off-5 : Mbonus 5 ≡ 0
bonus-off-5 = refl

bonus-off-8 : Mbonus 8 ≡ 0
bonus-off-8 = refl

-- ============================================================
-- PIECEWISE FORM (OEIS A018226 equivalence)
-- ============================================================
-- n ≤ 3: M(n) = n(n+1)(n+2) / 3   ↔   3 · M(n) = n(n+1)(n+2)
-- n ≥ 4: M(n) = n(n² + 5) / 3     ↔   3 · M(n) = n(n² + 5)
-- Stated as multiplicative identities (Builtin.Nat lacks division).

piecewise-eq-1 : 1 * (1 + 1) * (1 + 2) ≡ 3 * M 1
piecewise-eq-1 = refl

piecewise-eq-2 : 2 * (2 + 1) * (2 + 2) ≡ 3 * M 2
piecewise-eq-2 = refl

piecewise-eq-3 : 3 * (3 + 1) * (3 + 2) ≡ 3 * M 3
piecewise-eq-3 = refl

piecewise-eq-4 : 4 * (4 * 4 + 5) ≡ 3 * M 4
piecewise-eq-4 = refl

piecewise-eq-5 : 5 * (5 * 5 + 5) ≡ 3 * M 5
piecewise-eq-5 = refl

piecewise-eq-6 : 6 * (6 * 6 + 5) ≡ 3 * M 6
piecewise-eq-6 = refl

piecewise-eq-7 : 7 * (7 * 7 + 5) ≡ 3 * M 7
piecewise-eq-7 = refl

piecewise-eq-8 : 8 * (8 * 8 + 5) ≡ 3 * M 8
piecewise-eq-8 = refl

-- ============================================================
-- BLESSED-PRIME FACTORISATIONS
-- ============================================================
-- Blessed set B = {2, 3, 5, 7, 11, 17, 19, 41, 43, 67, 163}
-- Unified definition: B = { p prime : p ∈ H or 4p−1 ∈ H }
--   where H = {1, 2, 3, 7, 11, 19, 43, 67, 163}.
-- 17 enters because 4·17−1 = 67 ∈ H (via Euler's lucky primes).

-- M(1) = 2
factor-1 : M 1 ≡ 2
factor-1 = refl

-- M(2) = 2³
factor-2 : M 2 ≡ 2 * 2 * 2
factor-2 = refl

-- M(3) = 2²·5
factor-3 : M 3 ≡ 2 * 2 * 5
factor-3 = refl

-- M(4) = 2²·7
factor-4 : M 4 ≡ 2 * 2 * 7
factor-4 = refl

-- M(5) = 2·5²
factor-5 : M 5 ≡ 2 * 5 * 5
factor-5 = refl

-- M(6) = 2·41
factor-6 : M 6 ≡ 2 * 41
factor-6 = refl

-- M(7) = 2·3²·7
factor-7 : M 7 ≡ 2 * 3 * 3 * 7
factor-7 = refl

-- ============================================================
-- THE BREAK: M(8) = 2³·23 with 23 ∉ B
-- ============================================================

factor-8-break : M 8 ≡ 2 * 2 * 2 * 23
factor-8-break = refl

-- ============================================================
-- PARTIAL RECOVERY AT n = 9, 10, 11
-- ============================================================

factor-9-recover : M 9 ≡ 2 * 3 * 43
factor-9-recover = refl

factor-10-recover : M 10 ≡ 2 * 5 * 5 * 7
factor-10-recover = refl

factor-11-recover : M 11 ≡ 2 * 3 * 7 * 11
factor-11-recover = refl

-- ============================================================
-- PERMANENT BREAK AT n ≥ 12
-- ============================================================

factor-12-break : M 12 ≡ 2 * 2 * 149
factor-12-break = refl

factor-13-break : M 13 ≡ 2 * 13 * 29
factor-13-break = refl

-- ============================================================
-- RECTANGLE INVARIANTS USED IN MAGIC NUMBERS
-- ============================================================

chi : ℕ
chi = nW * nC

beta0 : ℕ
beta0 = 7      -- (11·N_c − 2·χ)/3 = (33-12)/3 = 7

towerD : ℕ
towerD = chi * (chi + 1)

chi-6 : chi ≡ 6
chi-6 = refl

towerD-42 : towerD ≡ 42
towerD-42 = refl

-- Twin primes flanking D
lower-twin : towerD - 1 ≡ 41
lower-twin = refl

upper-twin : towerD + 1 ≡ 43
upper-twin = refl

-- Rectangle-native identities for key magic numbers:
-- Magic 28 = N_w·N_w·β₀
magic28-via-beta0 : M 4 ≡ nW * nW * beta0
magic28-via-beta0 = refl

-- Magic 82 = N_w·(D-1) — Rabinowitz twin
magic82-via-twin : M 6 ≡ nW * (towerD - 1)
magic82-via-twin = refl

-- Magic 126 = N_w·N_c²·β₀
magic126-via-rect : M 7 ≡ nW * (nC * nC) * beta0
magic126-via-rect = refl

-- ============================================================
-- SUMMARY
-- ============================================================
--
-- Verified by reflexivity (refl):
--
--   1. M(n) reproduces the seven observed magic numbers
--      {2, 8, 20, 28, 50, 82, 126} at n = 1..7.
--
--   2. The unified formula's base term alone reproduces the
--      Wigner spherical-nucleus values at n = 4..8;
--      the kissing bonus 2·C(n,2)·𝟙(n ≤ N_c) completes the
--      low-n regime.
--
--   3. M(8) = 184 = 2³·23 introduces the foreign prime 23,
--      which fails the class-number-one criterion: Q(√-23)
--      has class number 3, and 4·23−1 = 91 ∉ H. This is the
--      predicted break.
--
--   4. M(9,10,11) ∈ {258, 350, 462} all factor into B
--      (partial recovery). M(12) = 596 = 2²·149 and
--      M(13) = 754 = 2·13·29 introduce new foreign primes
--      (permanent break).
--
--   5. Magic 28, 82, 126 admit rectangle-native identities
--      through β₀ = 7, the twin prime 41, and N_c = 3.
--
-- All equalities checked at compile time by Agda's refl.
