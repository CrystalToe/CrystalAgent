-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # ObservableNuclear — Component 7 (Nuclear): magic + SEMF identities.
  All integer relations proven by native_decide. -/

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := 7
abbrev d3 : Nat := nC * nC - 1
abbrev sigmaD : Nat := 1 + 3 + d3 + (nW * nW - 1) * d3
abbrev gauss : Nat := nC * nC + nW * nW
abbrev towerD : Nat := sigmaD + chi

-- Magic numbers
theorem magic_2 : nW = 2 := by native_decide
theorem magic_8 : d3 = 8 := by native_decide
theorem magic_20 : gauss + beta0 = 20 := by native_decide
theorem magic_28 : nW * nW * beta0 = 28 := by native_decide
theorem magic_50 : towerD + d3 = 50 := by native_decide
theorem magic_82 : nW * (towerD - 1) = 82 := by native_decide
theorem magic_126 : nW * beta0 * (nC * nC) = 126 := by native_decide

-- Proton moment
theorem mu_p_numer : nW * beta0 = 14 := by native_decide
theorem mu_p_denom : chi - 1 = 5 := by native_decide

-- Neutron moment
theorem mu_n_cross : 91 * nW - nW * nW * nW = 174 := by native_decide
theorem mu_n_denom : gauss * beta0 = 91 := by native_decide

-- Neutron lifetime
theorem d_sq : towerD * towerD = 1764 := by native_decide
theorem tau_n_cross : 878 * nW + nW * nW * nW = towerD * towerD := by native_decide

-- Iron peak
theorem iron : d3 * beta0 = 56 := by native_decide

-- SEMF
theorem semf_surf : nW * 3 = nC * 2 := by native_decide
theorem semf_coul_pre : nC * 5 = 3 * (chi - 1) := by native_decide

-- Deuteron/Alpha
theorem deut_numer : gauss = 13 := by native_decide
theorem alpha_int : towerD + gauss = 55 := by native_decide

-- Proton radius
theorem rp_zeroth : nW * nW = 4 := by native_decide
theorem rp_corr_denom : gauss * beta0 = 91 := by native_decide
