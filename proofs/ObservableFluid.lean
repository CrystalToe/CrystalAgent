-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := 7
abbrev sigmaD : Nat := 1 + 3 + (nC * nC - 1) + (nW * nW - 1) * (nC * nC - 1)
abbrev gauss : Nat := nC * nC + nW * nW
abbrev towerD : Nat := sigmaD + chi

theorem kolmo_cross : (nC + nW) * 3 = nC * 5 := by native_decide
theorem kolmo_micro : nW * nW = 4 := by native_decide
theorem karman_cross : nW * 5 = (nC + nW) * nW := by native_decide
theorem reynolds : towerD * (towerD + gauss) = 2310 := by native_decide
theorem prandtl_first : gauss - nC = 10 := by native_decide
theorem prandtl_second : gauss * gauss - nW = 167 := by native_decide
theorem blasius : nC + 1 = 4 := by native_decide
theorem planck : chi - 1 = 5 := by native_decide
theorem rayleigh_size : chi = 6 := by native_decide
theorem rayleigh_lam : nW * nW = 4 := by native_decide
