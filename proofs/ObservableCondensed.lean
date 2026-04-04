-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := 7
abbrev d3 : Nat := nC * nC - 1
abbrev sigmaD : Nat := 1 + 3 + d3 + (nW * nW - 1) * d3
abbrev gauss : Nat := nC * nC + nW * nW
abbrev towerD : Nat := sigmaD + chi

theorem em_first : gauss - 1 = 12 := by native_decide
theorem em_second : gauss * gauss - nW = 167 := by native_decide
theorem ising_beta : nW * nW * nW = 8 := by native_decide
theorem stefan : nW * nC * (gauss + beta0) = 120 := by native_decide
theorem thermal_numer : chi * chi * (chi - 1) = 180 := by native_decide
theorem thermal_denom : sigmaD = 36 := by native_decide
theorem chandrasekhar : gauss + chi = 19 := by native_decide
theorem feigenbaum_cross : 14 * (nC * nC) = nC * towerD := by native_decide
theorem routh_denom : gauss + beta0 + chi = 26 := by native_decide
theorem phi_numer : gauss = 13 := by native_decide
theorem phi_corr : gauss * nW * beta0 = 182 := by native_decide
theorem catalan_denom : towerD + chi = 48 := by native_decide
theorem carnot : chi - 1 = 5 := by native_decide
theorem cubic_z : chi = 6 := by native_decide
