-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-
  CrystalHierarchy.lean
  Session 9: Five a₄ LOOSE closures — dual route identity proofs.

  THE AXIOM: A_F = C + M2(C) + M3(C)
  All atoms from N_w=2, N_c=3. Zero sorry. All by native_decide.
-/

-- ══════════════════════════════════════════════════
-- Algebra Atoms
-- ══════════════════════════════════════════════════

def N_w : Nat := 2
def N_c : Nat := 3
def chi : Nat := N_w * N_c                    -- 6
def beta0 : Nat := (11 * N_c - 2 * chi) / 3  -- 7
def d₁ : Nat := 1
def d₂ : Nat := 3
def d₃ : Nat := 8
def d₄ : Nat := 24
def sigma_d : Nat := d₁ + d₂ + d₃ + d₄       -- 36
def sigma_d2 : Nat := d₁^2 + d₂^2 + d₃^2 + d₄^2  -- 650
def gauss : Nat := N_c^2 + N_w^2              -- 13
def towerD : Nat := sigma_d + chi             -- 42

-- ══════════════════════════════════════════════════
-- §0  Atom Verification
-- ══════════════════════════════════════════════════

theorem chi_eq : chi = 6 := by native_decide
theorem beta0_eq : beta0 = 7 := by native_decide
theorem sigma_d_eq : sigma_d = 36 := by native_decide
theorem sigma_d2_eq : sigma_d2 = 650 := by native_decide
theorem gauss_eq : gauss = 13 := by native_decide
theorem towerD_eq : towerD = 42 := by native_decide

-- ══════════════════════════════════════════════════
-- §1  m_ω (omega meson): inherited from ρ correction
--     Shared denominator 12 = 2·χ = Σd/N_c
-- ══════════════════════════════════════════════════

theorem omega_denom_a : 2 * chi = 12 := by native_decide
theorem omega_denom_b : sigma_d / N_c = 12 := by native_decide
theorem omega_dual_route : 2 * chi = sigma_d / N_c := by native_decide
theorem omega_69_eq : 70 - 1 = 69 := by native_decide
theorem omega_simplify : 69 / 3 = 23 := by native_decide
theorem omega_denom_simplify : 12 / 3 = 4 := by native_decide

-- ══════════════════════════════════════════════════
-- §2  m_η (eta meson): −1/75
--     Route A: N_c · (χ−1)² = 3 · 25 = 75
--     Route B: N_w · Σd + N_c = 72 + 3 = 75
-- ══════════════════════════════════════════════════

theorem eta_chi_minus_1 : chi - 1 = 5 := by native_decide
theorem eta_chi_minus_1_sq : (chi - 1)^2 = 25 := by native_decide
theorem eta_route_a : N_c * (chi - 1)^2 = 75 := by native_decide
theorem eta_route_b : N_w * sigma_d + N_c = 75 := by native_decide
theorem eta_dual_route : N_c * (chi - 1)^2 = N_w * sigma_d + N_c := by native_decide
theorem eta_route_a_expand : N_c * (N_w * N_c - 1)^2 = 75 := by native_decide
theorem eta_corr_num : 75 - 1 = 74 := by native_decide

-- ══════════════════════════════════════════════════
-- §3  M_Z (Z boson): −1/215
--     Route A: (D+1) · (χ−1) = 43 · 5 = 215
--     Route B: (Σd+χ+1) · (N_w·N_c−1) = 43 · 5 = 215
-- ══════════════════════════════════════════════════

theorem mz_d_plus_1 : towerD + 1 = 43 := by native_decide
theorem mz_route_a : (towerD + 1) * (chi - 1) = 215 := by native_decide
theorem mz_route_b : (sigma_d + chi + 1) * (N_w * N_c - 1) = 215 := by native_decide
theorem mz_dual_route :
    (towerD + 1) * (chi - 1) = (sigma_d + chi + 1) * (N_w * N_c - 1) := by native_decide
theorem mz_corr_num : 3 * 215 - 8 = 637 := by native_decide
theorem mz_corr_den : 8 * 215 = 1720 := by native_decide
theorem mz_43_decompose : sigma_d + chi + 1 = 43 := by native_decide

-- ══════════════════════════════════════════════════
-- §4  Δm_dec (decuplet spacing): −2/169
--     Route A: gauss² = 169
--     Route B: (N_c² + N_w²)² = 169
-- ══════════════════════════════════════════════════

theorem dec_gauss_sq : gauss^2 = 169 := by native_decide
theorem dec_route_b : (N_c^2 + N_w^2)^2 = 169 := by native_decide
theorem dec_dual_route : gauss^2 = (N_c^2 + N_w^2)^2 := by native_decide
theorem dec_corr_num : 169 - N_w = 167 := by native_decide
theorem dec_13_sq : 13^2 = 169 := by native_decide

-- ══════════════════════════════════════════════════
-- §5  m_μ (muon): −1/88
--     Route A: d₈ · (2χ−1) = 8 · 11 = 88
--     Route B: N_w⁴·(χ−1) + d₈ = 16·5 + 8 = 88
-- ══════════════════════════════════════════════════

theorem muon_d8 : N_c^2 - 1 = 8 := by native_decide
theorem muon_2chi_m1 : 2 * chi - 1 = 11 := by native_decide
theorem muon_route_a : (N_c^2 - 1) * (2 * chi - 1) = 88 := by native_decide
theorem muon_route_b : N_w^4 * (chi - 1) + (N_c^2 - 1) = 88 := by native_decide
theorem muon_dual_route :
    (N_c^2 - 1) * (2 * chi - 1) = N_w^4 * (chi - 1) + (N_c^2 - 1) := by native_decide
theorem muon_nw4 : N_w^4 = 16 := by native_decide
theorem muon_nw4_times_chi_m1 : N_w^4 * (chi - 1) = 80 := by native_decide
theorem muon_80_plus_8 : 80 + 8 = 88 := by native_decide
theorem muon_corr_num : 88 - 1 = 87 := by native_decide

-- ══════════════════════════════════════════════════
-- §6  Cross-correction identities
-- ══════════════════════════════════════════════════

theorem shared_atom_2chi_m1 : 2 * chi - 1 = 11 := by native_decide
theorem shared_atom_chi_m1 : chi - 1 = 5 := by native_decide
theorem cross_130 : gauss * (gauss - N_c) = 130 := by native_decide
theorem cross_75 : N_c * (chi - 1)^2 = 75 := by native_decide

theorem denoms_distinct :
    12 ≠ 75 ∧ 12 ≠ 215 ∧ 12 ≠ 169 ∧ 12 ≠ 88 ∧
    75 ≠ 215 ∧ 75 ≠ 169 ∧ 75 ≠ 88 ∧
    215 ≠ 169 ∧ 215 ≠ 88 ∧
    169 ≠ 88 := by native_decide
