-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
/-! # CrystalAstro — Astrophysical integer identities from (2,3) -/
abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := (11 * nC - 2 * chi) / 3
abbrev dColour : Nat := nW * nW * nW
-- Polytropes (cross-multiply)
theorem poly_nr : 3 * nW = nC * 2 := by native_decide
theorem poly_rel : nC = 3 := by native_decide
-- BH & radiation
theorem schwarz : nW = 2 := by native_decide
theorem hawking : dColour = 8 := by native_decide
theorem sb_denom : nC * (chi - 1) = 15 := by native_decide
theorem eddington : nW * nW = 4 := by native_decide
-- Main sequence (cross-multiply)
theorem ms_lum : beta0 = 7 := by native_decide
theorem ms_life : chi - 1 = 5 := by native_decide
-- Structure
theorem virial : nW = 2 := by native_decide
theorem grav_pe : 3 * (chi - 1) = nC * 5 := by native_decide
theorem mu_e : nW = 2 := by native_decide
-- Cross-checks
theorem hawking_edd : dColour * (nW * nW) = 32 := by native_decide
theorem ms_relation : beta0 = nW + (chi - 1) := by native_decide
