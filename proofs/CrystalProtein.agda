-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{-# OPTIONS --safe #-}

-- CrystalProtein.agda — Tower Force Field Integer Proofs
-- Session 13: D=0..D=38. All by refl.
-- LICENSE: AGPL-3.0

module CrystalProtein where

open import Data.Nat using (ℕ; zero; suc; _+_; _*_; _∸_)
open import Relation.Binary.PropositionalEquality using (_≡_; refl)

-- ══════════════════════════════════════════════════════
-- D=0..4  TOWER INTEGERS
-- ══════════════════════════════════════════════════════

N_c : ℕ
N_c = 3

N_w : ℕ
N_w = 2

χ : ℕ
χ = 6

β₀ : ℕ
β₀ = 7

gauss : ℕ
gauss = 13

Σd : ℕ
Σd = 36

D : ℕ
D = 42

-- ══════════════════════════════════════════════════════
-- DERIVED INTEGERS (11 proofs)
-- ══════════════════════════════════════════════════════

-- N_c² = 9 (VdW log argument)
N_c² : N_c * N_c ≡ 9
N_c² = refl

-- N_w² = 4 (helix contact factor)
N_w² : N_w * N_w ≡ 4
N_w² = refl

-- N_c − 1 = 2 (Pauli repulsion exponent, Schwarzschild)
rep-exp : N_c ∸ 1 ≡ 2
rep-exp = refl

-- N_c + 1 = 4 (London C₆ denominator)
london : N_c + 1 ≡ 4
london = refl

-- χ − 1 = 5 (cooling numerator, helix denominator)
chi-1 : χ ∸ 1 ≡ 5
chi-1 = refl

-- N_w + N_c = 5 (Flory denominator)
flory-den : N_w + N_c ≡ 5
flory-den = refl

-- N_c × χ = 18 (helix numerator)
helix-num : N_c * χ ≡ 18
helix-num = refl

-- N_w⁴ = 16 (Einstein prefactor)
N_w⁴ : N_w * N_w * N_w * N_w ≡ 16
N_w⁴ = refl

-- Total dimension
D-check : N_c * (gauss + 1) ≡ 42
D-check = refl

-- gauss = 13 (MERA layers)
gauss-13 : gauss ≡ 13
gauss-13 = refl

-- d_colour = 8
d-colour : N_c + N_c + N_w ≡ 8
d-colour = refl

-- ══════════════════════════════════════════════════════
-- D=22 VDW: INTEGER STRUCTURE
-- ══════════════════════════════════════════════════════

-- Valence electron counts
N_val_H : ℕ
N_val_H = 1

N_val_C : ℕ
N_val_C = 4

N_val_N : ℕ
N_val_N = 5

N_val_O : ℕ
N_val_O = 6

N_val_S : ℕ
N_val_S = 6

-- N_val² (in log argument)
nv²-H : N_val_H * N_val_H ≡ 1
nv²-H = refl

nv²-C : N_val_C * N_val_C ≡ 16
nv²-C = refl

nv²-N : N_val_N * N_val_N ≡ 25
nv²-N = refl

nv²-O : N_val_O * N_val_O ≡ 36
nv²-O = refl

nv²-S : N_val_S * N_val_S ≡ 36
nv²-S = refl

-- Principal quantum numbers
n_H : ℕ
n_H = 1

n_C : ℕ
n_C = 2

n_S : ℕ
n_S = 3

-- n² (in log argument denominator)
n²-H : n_H * n_H ≡ 1
n²-H = refl

n²-C : n_C * n_C ≡ 4
n²-C = refl

n²-S : n_S * n_S ≡ 9
n²-S = refl

-- ══════════════════════════════════════════════════════
-- D=24 WATER: INTEGER STRUCTURE
-- ══════════════════════════════════════════════════════

-- Water angle argument: −1/N_w² → N_w² = 4
water-denom : N_w * N_w ≡ 4
water-denom = refl

-- Burial factor: N_c² = 9 water molecules released
burial-factor : N_c * N_c ≡ 9
burial-factor = refl

-- ══════════════════════════════════════════════════════
-- D=32 HELIX: 18/5
-- ══════════════════════════════════════════════════════

-- 18 = N_c × χ
helix-18 : N_c * χ ≡ 18
helix-18 = refl

-- 5 = χ − 1
helix-5 : χ ∸ 1 ≡ 5
helix-5 = refl

-- ══════════════════════════════════════════════════════
-- D=33 FLORY: 2/5
-- ══════════════════════════════════════════════════════

-- numerator = N_w = 2
flory-num : N_w ≡ 2
flory-num = refl

-- denominator = N_w + N_c = 5
flory-denom : N_w + N_c ≡ 5
flory-denom = refl

-- ══════════════════════════════════════════════════════
-- D=38 GRAVITY: INTEGERS
-- ══════════════════════════════════════════════════════

-- Polarization count = N_c − 1 = 2
pol-count : N_c ∸ 1 ≡ 2
pol-count = refl

-- Einstein 16 = N_w⁴
einstein : N_w * N_w * N_w * N_w ≡ 16
einstein = refl

-- 32/5 = N_w⁵/(χ−1)
nw5 : N_w * N_w * N_w * N_w * N_w ≡ 32
nw5 = refl

-- ══════════════════════════════════════════════════════
-- COOLING τ = 5/36
-- ══════════════════════════════════════════════════════

-- numerator = χ − 1 = 5
tau-num : χ ∸ 1 ≡ 5
tau-num = refl

-- denominator = Σd = 36
tau-den : Σd ≡ 36
tau-den = refl

-- ══════════════════════════════════════════════════════
-- DIELECTRIC ε_r = N_w²(N_c+1) = 16
-- ══════════════════════════════════════════════════════

dielectric : N_w * N_w * (N_c + 1) ≡ 16
dielectric = refl

-- ══════════════════════════════════════════════════════
-- 208 = χ³ − d_colour
-- ══════════════════════════════════════════════════════

const-208 : χ * χ * χ ∸ (N_c + N_c + N_w) ≡ 208
const-208 = refl

-- ══════════════════════════════════════════════════════
-- FORCE FIELD: 13 MERA LAYERS = 13
-- ══════════════════════════════════════════════════════

-- Layers 1-6 = hard constraints (6 = χ)
hard-layers : χ ≡ 6
hard-layers = refl

-- Layers 7-13 = soft constraints (7 = β₀)
soft-layers : β₀ ≡ 7
soft-layers = refl

-- Total = gauss = χ + β₀ = 13
total-layers : χ + β₀ ≡ 13
total-layers = refl
