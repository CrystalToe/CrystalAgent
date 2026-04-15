-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev gauss : Nat := nC * nC + nW * nW

theorem water_numer : nC * nC - 1 = 8 := by native_decide
theorem water_denom : 2 * nC = 6 := by native_decide
theorem water_cross : (nC * nC - 1) * 3 = 2 * nC * 4 := by native_decide
theorem glass_cross : nC * 2 = nW * 3 := by native_decide
theorem diamond_numer : 2 * gauss + nC = 29 := by native_decide
