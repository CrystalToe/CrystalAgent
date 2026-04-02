-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
/-! # CrystalNuclear — Nuclear integer identities from (2,3) -/
abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := (11 * nC - 2 * chi) / 3
abbrev sigmaD : Nat := 1 + 3 + 8 + 24
abbrev towerD : Nat := sigmaD + chi
abbrev dColour : Nat := nW * nW * nW
-- Magic numbers
theorem magic_2 : nW = 2 := by native_decide
theorem magic_8 : dColour = 8 := by native_decide
theorem magic_20 : nW * nW * (chi - 1) = 20 := by native_decide
theorem magic_28 : nW * nW * beta0 = 28 := by native_decide
theorem magic_50 : nW * (chi - 1) * (chi - 1) = 50 := by native_decide
theorem magic_82 : nW * (towerD - 1) = 82 := by native_decide
theorem magic_126 : nW * beta0 * (nC * nC) = 126 := by native_decide
-- SEMF exponents (cross-multiply)
theorem surface_exp : 2 * nC = nW * 3 := by native_decide
theorem coulomb_exp : nC = 3 := by native_decide
theorem coulomb_pre : nC * (chi - 1) = 3 * (chi - 1) := by native_decide
theorem pairing_exp : nW = 2 := by native_decide
-- Structure
theorem isospin : nW = 2 := by native_decide
theorem alpha_a : nW * nW = 4 := by native_decide
theorem iron_peak : dColour * beta0 = 56 := by native_decide
theorem he4_binding : nW * nW * beta0 = 28 := by native_decide
-- Cross-checks
theorem magic_diff : nW * nW * beta0 - nW * nW * (chi - 1) = dColour := by native_decide
