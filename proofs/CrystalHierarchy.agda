-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalHierarchy.agda
-- Session 9: Five a₄ LOOSE closures — dual route identity proofs.
--
-- THE AXIOM: A_F = C + M2(C) + M3(C)
-- All atoms from N_w=2, N_c=3. Zero postulates. All by refl.

module CrystalHierarchy where

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
chi = N-w * N-c  -- 6

d1 : ℕ
d1 = 1

d2 : ℕ
d2 = 3

d3 : ℕ
d3 = 8

d4 : ℕ
d4 = 24

sigma-d : ℕ
sigma-d = d1 + d2 + d3 + d4  -- 36

gauss : ℕ
gauss = N-c * N-c + N-w * N-w  -- 13

towerD : ℕ
towerD = sigma-d + chi  -- 42

-- Helper: exponentiation
_^_ : ℕ → ℕ → ℕ
_ ^ zero = 1
b ^ (suc e) = b * (b ^ e)

-- ══════════════════════════════════════════════════
-- §0  Atom Verification
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
-- §1  m_ω (omega meson): inherited from ρ correction
--     Shared denominator 12 = 2·χ
-- ══════════════════════════════════════════════════

omega-denom : 2 * chi ≡ 12
omega-denom = refl

omega-multiplier-69 : 70 ∸ 1 ≡ 69
omega-multiplier-69 = refl

-- ══════════════════════════════════════════════════
-- §2  m_η (eta meson): −1/75
--     Route A: N_c · (χ−1)² = 3 · 25 = 75
--     Route B: N_w · Σd + N_c = 72 + 3 = 75
-- ══════════════════════════════════════════════════

eta-chi-minus-1 : chi ∸ 1 ≡ 5
eta-chi-minus-1 = refl

eta-chi-minus-1-sq : (chi ∸ 1) ^ 2 ≡ 25
eta-chi-minus-1-sq = refl

eta-route-a : N-c * ((chi ∸ 1) ^ 2) ≡ 75
eta-route-a = refl

eta-route-b : N-w * sigma-d + N-c ≡ 75
eta-route-b = refl

eta-dual-route : N-c * ((chi ∸ 1) ^ 2) ≡ N-w * sigma-d + N-c
eta-dual-route = refl

eta-corr-num : 75 ∸ 1 ≡ 74
eta-corr-num = refl

-- ══════════════════════════════════════════════════
-- §3  M_Z (Z boson): −1/215
--     Route A: (D+1) · (χ−1) = 43 · 5 = 215
--     Route B: (Σd+χ+1) · (N_w·N_c−1) = 43 · 5 = 215
-- ══════════════════════════════════════════════════

mz-d-plus-1 : towerD + 1 ≡ 43
mz-d-plus-1 = refl

mz-route-a : (towerD + 1) * (chi ∸ 1) ≡ 215
mz-route-a = refl

mz-route-b : (sigma-d + chi + 1) * (N-w * N-c ∸ 1) ≡ 215
mz-route-b = refl

mz-dual-route : (towerD + 1) * (chi ∸ 1) ≡ (sigma-d + chi + 1) * (N-w * N-c ∸ 1)
mz-dual-route = refl

mz-corr-num : 3 * 215 ∸ 8 ≡ 637
mz-corr-num = refl

mz-corr-den : 8 * 215 ≡ 1720
mz-corr-den = refl

mz-43-decompose : sigma-d + chi + 1 ≡ 43
mz-43-decompose = refl

-- ══════════════════════════════════════════════════
-- §4  Δm_dec (decuplet spacing): −2/169
--     Route A: gauss² = 169
--     Route B: (N_c² + N_w²)² = 169
-- ══════════════════════════════════════════════════

dec-gauss-sq : gauss ^ 2 ≡ 169
dec-gauss-sq = refl

dec-route-b : (N-c ^ 2 + N-w ^ 2) ^ 2 ≡ 169
dec-route-b = refl

dec-dual-route : gauss ^ 2 ≡ (N-c ^ 2 + N-w ^ 2) ^ 2
dec-dual-route = refl

dec-corr-num : 169 ∸ N-w ≡ 167
dec-corr-num = refl

-- ══════════════════════════════════════════════════
-- §5  m_μ (muon): −1/88
--     Route A: d₈ · (2χ−1) = 8 · 11 = 88
--     Route B: N_w⁴·(χ−1) + d₈ = 16·5 + 8 = 88
-- ══════════════════════════════════════════════════

muon-d8 : N-c ^ 2 ∸ 1 ≡ 8
muon-d8 = refl

muon-2chi-m1 : 2 * chi ∸ 1 ≡ 11
muon-2chi-m1 = refl

muon-route-a : (N-c ^ 2 ∸ 1) * (2 * chi ∸ 1) ≡ 88
muon-route-a = refl

muon-route-b : N-w ^ 4 * (chi ∸ 1) + (N-c ^ 2 ∸ 1) ≡ 88
muon-route-b = refl

muon-dual-route : (N-c ^ 2 ∸ 1) * (2 * chi ∸ 1) ≡ N-w ^ 4 * (chi ∸ 1) + (N-c ^ 2 ∸ 1)
muon-dual-route = refl

muon-nw4 : N-w ^ 4 ≡ 16
muon-nw4 = refl

muon-corr-num : 88 ∸ 1 ≡ 87
muon-corr-num = refl

-- ══════════════════════════════════════════════════
-- §6  Cross-correction shared atoms
-- ══════════════════════════════════════════════════

shared-2chi-m1 : 2 * chi ∸ 1 ≡ 11
shared-2chi-m1 = refl

shared-chi-m1 : chi ∸ 1 ≡ 5
shared-chi-m1 = refl

cross-130 : gauss * (gauss ∸ N-c) ≡ 130
cross-130 = refl

cross-75 : N-c * ((chi ∸ 1) ^ 2) ≡ 75
cross-75 = refl
