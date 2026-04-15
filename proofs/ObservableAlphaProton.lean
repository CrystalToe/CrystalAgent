-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := 7
abbrev d1 : Nat := 1
abbrev d2 : Nat := 3
abbrev d3 : Nat := 8
abbrev d4 : Nat := 24
abbrev sigmaD : Nat := d1 + d2 + d3 + d4
abbrev gauss : Nat := nC * nC + nW * nW
abbrev towerD : Nat := sigmaD + chi
abbrev sigmaD2 : Nat := d1*d1 + d2*d2 + d3*d3 + d4*d4

theorem sigmaD2_val : sigmaD2 = 650 := by native_decide
theorem gauss_sq : gauss * gauss = 169 := by native_decide
theorem sindy_sum : gauss * gauss + d4 = 193 := by native_decide
theorem mpme_sum : towerD * towerD + sigmaD = 1800 := by native_decide
theorem gauss_cubed : gauss * gauss * gauss = 2197 := by native_decide
theorem alpha_corr : chi * d4 * sigmaD2 * towerD = 3931200 := by native_decide
theorem mpme_corr : nW * chi * sigmaD2 * towerD = 327600 := by native_decide
theorem sin2_corr : d4 * sigmaD2 = 15600 := by native_decide
theorem corr_ratio : 12 * 327600 = 3931200 := by native_decide
theorem d4_over_nw : d4 = 12 * nW := by native_decide
theorem staircase : towerD + 1 = 43 := by native_decide
