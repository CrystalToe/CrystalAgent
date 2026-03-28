-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalAlphaProton.agda
-- Algebraic identity proofs for alpha_inv and mp_me formulas
-- All atoms from A_F = C + M2(C) + M3(C)
-- Zero sorry. All by refl.

module CrystalAlphaProton where

open import Data.Nat using (ℕ; zero; suc; _+_; _*_; _∸_)
open import Relation.Binary.PropositionalEquality using (_≡_; refl)

-- ══════════════════════════════════════════════════
-- Algebra Atoms
-- ══════════════════════════════════════════════════

N-w : ℕ
N-w = 2

N-c : ℕ
N-c = 3

chi : ℕ
chi = N-w * N-c

d1 : ℕ
d1 = 1

d2 : ℕ
d2 = 3

d3 : ℕ
d3 = 8

d4 : ℕ
d4 = 24

sigma-d : ℕ
sigma-d = d1 + d2 + d3 + d4

gauss : ℕ
gauss = N-c * N-c + N-w * N-w

towerD : ℕ
towerD = sigma-d + chi

-- ══════════════════════════════════════════════════
-- Helper: exponentiation
-- ══════════════════════════════════════════════════

_^_ : ℕ → ℕ → ℕ
_ ^ zero = 1
b ^ (suc e) = b * (b ^ e)

-- ══════════════════════════════════════════════════
-- Atom Identity Proofs
-- ══════════════════════════════════════════════════

chi-eq : chi ≡ 6
chi-eq = refl

sigma-d-eq : sigma-d ≡ 36
sigma-d-eq = refl

gauss-eq : gauss ≡ 13
gauss-eq = refl

towerD-eq : towerD ≡ 42
towerD-eq = refl

-- ══════════════════════════════════════════════════
-- alpha_inv SINDy: rational numerator
-- 2 * (gauss^2 + d4) = 386
-- ══════════════════════════════════════════════════

gauss-sq : gauss ^ 2 ≡ 169
gauss-sq = refl

alpha-sindy-sum : gauss ^ 2 + d4 ≡ 193
alpha-sindy-sum = refl

alpha-sindy-rational : 2 * (gauss ^ 2 + d4) ≡ 386
alpha-sindy-rational = refl

-- ══════════════════════════════════════════════════
-- mp_me SINDy: rational part
-- towerD^2 + sigma_d = 1800
-- 2 * 1800 / 8 = 450
-- ══════════════════════════════════════════════════

towerD-sq : towerD ^ 2 ≡ 1764
towerD-sq = refl

mp-sindy-numerator : towerD ^ 2 + sigma-d ≡ 1800
mp-sindy-numerator = refl

-- 2 * 1800 = 3600, 3600 / 8 = 450
mp-sindy-double : 2 * (towerD ^ 2 + sigma-d) ≡ 3600
mp-sindy-double = refl

-- ══════════════════════════════════════════════════
-- mp_me SINDy: transcendental numerator
-- gauss^N_c = 13^3 = 2197
-- ══════════════════════════════════════════════════

gauss-cubed : gauss ^ N-c ≡ 2197
gauss-cubed = refl

gauss-cubed-alt : gauss ^ 3 ≡ 2197
gauss-cubed-alt = refl

-- ══════════════════════════════════════════════════
-- HMC correction denominator
-- 2 * towerD * (d1^2 + d2^2 + d3^2 + d4^2) = 54600
-- ══════════════════════════════════════════════════

sigma-d2-eq : d1 ^ 2 + d2 ^ 2 + d3 ^ 2 + d4 ^ 2 ≡ 650
sigma-d2-eq = refl

-- ══════════════════════════════════════════════════
-- magic_82 (preserved from Session 3)
-- ══════════════════════════════════════════════════

magic-82 : N-c * N-c * N-c * N-c + 1 ≡ 82
magic-82 = refl

magic-82-alt : (towerD ∸ 1) * N-w ≡ 82
magic-82-alt = refl
