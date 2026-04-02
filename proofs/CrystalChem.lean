-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
/-! # CrystalChem — Chemistry integer identities from (2,3) -/
abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := (11 * nC - 2 * chi) / 3
abbrev sigmaD : Nat := 1 + 3 + 8 + 24
-- Orbital capacities
theorem s_cap : nW = 2 := by native_decide
theorem p_cap : nW * nC = 6 := by native_decide
theorem p_is_chi : nW * nC = chi := by native_decide
theorem d_cap : nW * (chi - 1) = 10 := by native_decide
theorem f_cap : nW * beta0 = 14 := by native_decide
theorem shell1 : nW * 1 = 2 := by native_decide
theorem shell2 : nW * 4 = 8 := by native_decide
theorem shell3 : nW * 9 = 18 := by native_decide
-- Noble gases
theorem he_z : nW = 2 := by native_decide
theorem ne_z : nW * (chi - 1) = 10 := by native_decide
theorem ar_z : nW * (nC * nC) = 18 := by native_decide
theorem kr_z : sigmaD = 36 := by native_decide
-- Chemistry
theorem neutral_ph : beta0 = 7 := by native_decide
theorem dielectric : nW * nW * (nC + 1) = 16 := by native_decide
theorem bohr_factor : nW = 2 := by native_decide
-- Cross-checks
theorem f_is_2beta0 : nW * beta0 = 14 := by native_decide
theorem shell2_is_dcolour : nW * nW * nW = 8 := by native_decide
theorem ne_eq_dcap : nW * (chi - 1) = 10 := by native_decide
