-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-
  CrystalFundamentals.lean — Lean 4 Proof · Fundamental Observables · March 2026
  14 new observables: 181 → 195. Zero free parameters.
  Every integer identity proved by native_decide.
-/

def nW : Nat := 2
def nC : Nat := 3
def chi : Nat := nW * nC
def beta0 : Nat := chi + 1
def towerD : Nat := chi * beta0
def sigmaD : Nat := 1 + nC + (nC^2 - 1) + nW^3 * nC
def sigmaD2 : Nat := 1 + 9 + 64 + 576
def gauss : Nat := nW^2 + nC^2

-- ═══════════════════════════════════════════════════════════════
-- §16  PHASE 1 — EASY 5
-- ═══════════════════════════════════════════════════════════════

-- #179: N_eff = N_c + κ/D
-- Integer identity: D·N_c = 126 (denominator of correction)
theorem neff_denom : towerD * nC = 126 := by native_decide

-- #180: Ω_b/Ω_m = N_c/(gauss + χ) = 3/19
theorem ob_om_num : nC = 3 := by native_decide
theorem ob_om_den : gauss + chi = 19 := by native_decide

-- #181: sin²θ_W(0) = 3/13 + 1/126
-- Running correction denominator = D·χ = 252, but N_w/(D·χ) = 2/252 = 1/126
theorem sw0_base_den : gauss = 13 := by native_decide
theorem sw0_corr_den : towerD * chi = 252 := by native_decide
theorem sw0_corr_simplify : towerD * chi / nW = 126 := by native_decide

-- #182: Y_p = 1/4 − 1/(χ·D) = 1/4 − 1/252
theorem yp_corr_den : chi * towerD = 252 := by native_decide

-- #183: μ_p/μ_n = −(N_c/N_w)(1 − 1/Σd) = −35/24
-- Base: N_c/N_w = 3/2. Correction: (Σd−1)/Σd = 35/36
-- Product: 3 × 35 = 105, 2 × 36 = 72. Reduced: 35/24.
theorem moment_ratio_num : nC * (sigmaD - 1) = 105 := by native_decide
theorem moment_ratio_den : nW * sigmaD = 72 := by native_decide
theorem moment_ratio_reduced_num : 105 / 3 = 35 := by native_decide
theorem moment_ratio_reduced_den : 72 / 3 = 24 := by native_decide

-- ═══════════════════════════════════════════════════════════════
-- §17  PHASE 2 — MEDIUM 5
-- ═══════════════════════════════════════════════════════════════

-- #184: m_c/m_s = 12 × 49/50
-- Base: N_w²·N_c = 12
theorem mcms_base : nW^2 * nC = 12 := by native_decide
-- Alternative: gauss − 1 = 12
theorem mcms_base_alt : gauss - 1 = 12 := by native_decide
-- Alternative: Σd/N_c = 12
theorem mcms_base_alt2 : sigmaD / nC = 12 := by native_decide
-- Alternative: D/N_c − N_w = 12
theorem mcms_base_alt3 : towerD / nC - nW = 12 := by native_decide
-- Correction numerator: D + β₀ = 49
theorem mcms_corr_num : towerD + beta0 = 49 := by native_decide
-- Correction denominator: D + β₀ + 1 = 50
theorem mcms_corr_den : towerD + beta0 + 1 = 50 := by native_decide
-- Denominator = Σd²/gauss: 650/13 = 50
theorem mcms_den_route2 : sigmaD2 / gauss = 50 := by native_decide
-- Product: 12 × 49 = 588
theorem mcms_product : 12 * 49 = 588 := by native_decide

-- #185: m_b/m_τ = β₀/N_c + 1/(χ·β₀) = 7/3 + 1/42
-- 1/(χ·β₀) = 1/42 = 1/D
theorem mbtau_base_num : beta0 = 7 := by native_decide
theorem mbtau_base_den : nC = 3 := by native_decide
theorem mbtau_corr_den : chi * beta0 = 42 := by native_decide
theorem mbtau_corr_is_D : chi * beta0 = towerD := by native_decide
-- Common denominator: 7/3 + 1/42 = 98/42 + 1/42 = 99/42
theorem mbtau_combined_num : 7 * 14 + 1 = 99 := by native_decide
theorem mbtau_combined_den : 3 * 14 = 42 := by native_decide

-- #186: m_t/v = 7/10 + 1/650
-- Base: β₀/(gauss − N_c) = 7/10
theorem yt_base_num : beta0 = 7 := by native_decide
theorem yt_base_den : gauss - nC = 10 := by native_decide
-- Correction: 1/Σd² = 1/650
theorem yt_corr_den : sigmaD2 = 650 := by native_decide

-- #187: ⟨r²⟩_π: coefficient = N_c²/(gauss + β₀) = 9/20
theorem rpi_num : nC^2 = 9 := by native_decide
theorem rpi_den : gauss + beta0 = 20 := by native_decide

-- #188: Δα_had = 1/Σd = 1/36
theorem dalpha_den : sigmaD = 36 := by native_decide

-- ═══════════════════════════════════════════════════════════════
-- §18  PHASE 3 — HARD 4
-- ═══════════════════════════════════════════════════════════════

-- #189: σ_πN correction: (D+1)/D = 43/42
theorem sigma_corr_num : towerD + 1 = 43 := by native_decide
theorem sigma_corr_den : towerD = 42 := by native_decide
-- Same 43 as in α⁻¹ = 43π + ln 7
theorem sigma_same_43 : towerD + 1 = sigmaD + chi + 1 := by native_decide

-- #190: Δm²₂₁ (direct) — denominator: 2^D · gauss
-- D = 42 (tower height), gauss = 13 (EW mixing norm)
-- N_w = 2 (numerator coefficient)
theorem dm21_tower : towerD = 42 := by native_decide
theorem dm21_gauss : gauss = 13 := by native_decide

-- #191: Δm²₃₂ — correction factors
-- ν₃: 10/11 = (2χ−2)/(2χ−1)
theorem dm32_nu3_num : 2 * chi - 2 = 10 := by native_decide
theorem dm32_nu3_den : 2 * chi - 1 = 11 := by native_decide
-- ν₂: N_w/gauss = 2/13
theorem dm32_nu2_num : nW = 2 := by native_decide
theorem dm32_nu2_den : gauss = 13 := by native_decide
-- Split ratio: χ⁴/(χ⁴−1) = 1296/1295
theorem split_ratio_num : chi^4 = 1296 := by native_decide
theorem split_ratio_den : chi^4 - 1 = 1295 := by native_decide

-- #192: G_N coupling — hierarchy integers
-- M_Pl/v denominator: β₀·(χ−1) = 7·5 = 35
theorem grav_hierarchy_den : beta0 * (chi - 1) = 35 := by native_decide
-- m_p/v numerator: D + gauss − N_w = 53
theorem grav_mp_num : towerD + gauss - nW = 53 := by native_decide
-- m_p/v denominator factor: D + gauss − N_w + 1 = 54
theorem grav_mp_den : towerD + gauss - nW + 1 = 54 := by native_decide
-- 2^(2^N_c) = 256
theorem grav_fermat : 2^(2^nC) = 256 := by native_decide

-- ═══════════════════════════════════════════════════════════════
-- §19  CROSS-CHECKS
-- ═══════════════════════════════════════════════════════════════

-- The cosmological partition 19 = gauss + χ = 13 + 6
theorem partition_19 : gauss + chi = 19 := by native_decide
-- gauss + β₀ = 20 (amino acids = EW+QCD partition)
theorem partition_20 : gauss + beta0 = 20 := by native_decide
-- D + β₀ + 1 = 50 = Σd²/gauss
theorem partition_50 : towerD + beta0 + 1 = sigmaD2 / gauss := by native_decide
-- 43 = D + 1 = Σd + χ + 1 (same 43 in α and σ_πN)
theorem the_43 : towerD + 1 = 43 := by native_decide
-- χ⁴ = 1296 = 6⁴ (neutrino suppression factor)
theorem chi4 : chi^4 = 1296 := by native_decide
-- Fermat: 2^8 + 1 = 257
theorem fermat_prime : 2^(2^nC) + 1 = 257 := by native_decide
