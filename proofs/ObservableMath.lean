-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := 7
abbrev gauss : Nat := nC * nC + nW * nW
abbrev towerD : Nat := 1 + 3 + (nC * nC - 1) + (nW * nW - 1) * (nC * nC - 1) + chi

theorem euler_numer : gauss + chi = 19 := by native_decide
theorem phi_numer : gauss = 13 := by native_decide
theorem phi_denom : nW * nW * nW = 8 := by native_decide
theorem phi_corr : gauss * nW * beta0 = 182 := by native_decide
theorem catalan_denom : towerD + chi = 48 := by native_decide
theorem bekenstein : nW * nW = 4 := by native_decide
theorem lagrange : chi - 1 = 5 := by native_decide
theorem r_cross : nC * chi = 2 * (nC * nC) := by native_decide
