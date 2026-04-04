-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev d3 : Nat := nC * nC - 1

theorem quad_num : nW * nW * nW * nW * nW = 32 := by native_decide
theorem quad_den : chi - 1 = 5 := by native_decide
theorem decay_num : nW * nW * nW * nW * nW * nW = 64 := by native_decide
theorem polarizations : nC - 1 = 2 := by native_decide
theorem amplitude : nW * nW = 4 := by native_decide
theorem gw_doubling : nW = 2 := by native_decide
theorem isco : chi = 6 := by native_decide
theorem chirp_num : nC = 3 := by native_decide
theorem chirp_den : chi - 1 = 5 := by native_decide
theorem freq_num : nC - 1 = 2 := by native_decide
theorem freq_den : nC = 3 := by native_decide
theorem colour_dim : d3 = 8 := by native_decide
-- Total: 12 theorems by native_decide.
