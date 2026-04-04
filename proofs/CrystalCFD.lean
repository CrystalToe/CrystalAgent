-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev d3 : Nat := nC * nC - 1
abbrev d4 : Nat := (nW * nW - 1) * (nC * nC - 1)
abbrev sigmaD : Nat := 1 + 3 + 8 + 24

theorem d2q9 : nC * nC = 9 := by native_decide
theorem colour_fits : d3 = 8 := by native_decide
theorem kolm_num : chi - 1 = 5 := by native_decide
theorem kolm_den : nC = 3 := by native_decide
theorem stokes : d4 = 24 := by native_decide
theorem blasius_den : nW * nW = 4 := by native_decide
theorem karman_num : nW = 2 := by native_decide
theorem karman_den : chi - 1 = 5 := by native_decide
theorem w_rest_num : nW * nW = 4 := by native_decide
theorem w_rest_den : nC * nC = 9 := by native_decide
theorem w_diag_den : sigmaD = 36 := by native_decide
theorem cs2_den : nC = 3 := by native_decide
-- Total: 12 theorems by native_decide.
