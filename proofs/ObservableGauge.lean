-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # ObservableGauge — Component 7 (Gauge): coupling + mass identities.
  All integer relations proven by native_decide. -/

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := 7
abbrev d1 : Nat := 1
abbrev d2 : Nat := nW * nW - 1
abbrev d3 : Nat := nC * nC - 1
abbrev d4 : Nat := d2 * d3
abbrev sigmaD : Nat := d1 + d2 + d3 + d4
abbrev gauss : Nat := nC * nC + nW * nW
abbrev towerD : Nat := sigmaD + chi

-- Staircase steps
theorem staircase : towerD + 1 = 43 := by native_decide

-- sin^2 theta_W denominators
theorem sin2w_os_denom : nC * nC = 9 := by native_decide
theorem sin2w_ms_denom : gauss = 13 := by native_decide

-- alpha_s = 2/17
theorem alpha_s_denom : nC * nC + d3 = 17 := by native_decide

-- g_A = 9/7
theorem ga_numer : nC * nC = 9 := by native_decide
theorem ga_denom : beta0 = 7 := by native_decide

-- alpha(M_Z)^-1: gauss^2 - D = 127
theorem alpha_mz_gauss_sq : gauss * gauss = 169 := by native_decide
theorem alpha_mz_diff : gauss * gauss - towerD = 127 := by native_decide

-- N_gen = 3
theorem ngen : nW * nW - 1 = 3 := by native_decide

-- VEV
theorem vev_exp : towerD + d3 = 50 := by native_decide
theorem vev_numer : sigmaD - 1 = 35 := by native_decide
theorem vev_denom : (towerD + 1) * sigmaD = 1548 := by native_decide

-- M_Z implosion
theorem mz_implosion : (towerD + 1) * (chi - 1) = 215 := by native_decide
theorem mz_corr_numer : 3 * 215 - 8 = 637 := by native_decide
theorem mz_corr_denom : 8 * 215 = 1720 := by native_decide

-- M_W: cos^2 = 10/13
theorem mw_cos2_numer : gauss - nC = 10 := by native_decide

-- Gamma factors
theorem gamma_w_factor : nC * nC = 9 := by native_decide
theorem oneloop : nW * nW * nW * nW = 16 := by native_decide

-- Hierarchy
theorem hierarchy : towerD + d3 = 50 := by native_decide

-- beta_0
theorem beta0_check : 3 * beta0 = 11 * nC - 2 * chi := by native_decide
