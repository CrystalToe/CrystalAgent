-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalAlphaProton.lean
-- Algebraic identity proofs for the alpha_inv and mp_me formulas
-- All atoms from A_F = C + M2(C) + M3(C)
-- Zero sorry. All by native_decide or omega.

-- ══════════════════════════════════════════════════
-- Algebra Atoms
-- ══════════════════════════════════════════════════

def N_w : Nat := 2
def N_c : Nat := 3
def chi : Nat := N_w * N_c
def beta0 : Nat := (11 * N_c - 2 * chi) / 3
def d₁ : Nat := 1
def d₂ : Nat := 3
def d₃ : Nat := 8
def d₄ : Nat := 24
def sigma_d : Nat := d₁ + d₂ + d₃ + d₄
def sigma_d2 : Nat := d₁^2 + d₂^2 + d₃^2 + d₄^2
def gauss : Nat := N_c^2 + N_w^2
def towerD : Nat := sigma_d + chi

-- ══════════════════════════════════════════════════
-- Atom Identity Proofs
-- ══════════════════════════════════════════════════

theorem chi_eq : chi = 6 := by native_decide
theorem beta0_eq : beta0 = 7 := by native_decide
theorem sigma_d_eq : sigma_d = 36 := by native_decide
theorem sigma_d2_eq : sigma_d2 = 650 := by native_decide
theorem gauss_eq : gauss = 13 := by native_decide
theorem towerD_eq : towerD = 42 := by native_decide

-- ══════════════════════════════════════════════════
-- alpha_inv SINDy: rational numerator
-- 2 * (gauss^2 + d₄) = 386
-- ══════════════════════════════════════════════════

theorem alpha_sindy_rational_num :
    2 * (gauss ^ 2 + d₄) = 386 := by native_decide

theorem gauss_sq : gauss ^ 2 = 169 := by native_decide

theorem alpha_sindy_sum : gauss ^ 2 + d₄ = 193 := by native_decide

-- ══════════════════════════════════════════════════
-- mp_me SINDy: rational part
-- 2 * (towerD^2 + sigma_d) / d₃ = 450
-- (as integer division, exact because 1800/8 = 225, *2 = 450)
-- ══════════════════════════════════════════════════

theorem towerD_sq : towerD ^ 2 = 1764 := by native_decide

theorem mp_sindy_numerator :
    towerD ^ 2 + sigma_d = 1800 := by native_decide

theorem mp_sindy_rational :
    2 * (towerD ^ 2 + sigma_d) / d₃ = 450 := by native_decide

-- ══════════════════════════════════════════════════
-- mp_me SINDy: transcendental numerator
-- gauss^N_c = 2197
-- ══════════════════════════════════════════════════

theorem gauss_cubed : gauss ^ N_c = 2197 := by native_decide

theorem gauss_cubed_alt : gauss ^ 3 = 2197 := by native_decide

-- ══════════════════════════════════════════════════
-- Cross-domain: both formulas share gauss and d₃
-- ══════════════════════════════════════════════════

theorem cross_domain_gauss_alpha :
    gauss ^ 2 + d₄ = 193 := by native_decide

theorem cross_domain_gauss_mp :
    gauss ^ N_c = 2197 := by native_decide

-- ══════════════════════════════════════════════════
-- HMC refined correction denominator
-- 2 * towerD * sigma_d2 = 54600
-- ══════════════════════════════════════════════════

theorem hmc_corr_denom :
    2 * towerD * sigma_d2 = 54600 := by native_decide

-- ══════════════════════════════════════════════════
-- magic_82 (preserved from Session 3)
-- ══════════════════════════════════════════════════

theorem magic_82 : N_c ^ 4 + 1 = 82 := by native_decide
theorem magic_82_alt : (towerD - 1) * N_w = 82 := by native_decide
theorem magic_82_identity : N_c ^ 4 + 1 = (towerD - 1) * N_w := by native_decide
