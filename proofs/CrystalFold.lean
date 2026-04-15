-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := 7
abbrev sigmaD : Nat := 1 + 3 + 8 + 24
abbrev d3 : Nat := nC * nC - 1
abbrev d4 : Nat := (nW * nW - 1) * (nC * nC - 1)

theorem tile_dof : sigmaD = 36 := by native_decide
theorem mixed_is_4chi : d4 = 4 * chi := by native_decide
theorem helix_num : nC * nC * nW = 18 := by native_decide
theorem helix_den : chi - 1 = 5 := by native_decide
theorem flory_num : nW = 2 := by native_decide
theorem flory_den : chi - 1 = 5 := by native_decide
theorem amino_acids : nW * nW * (chi - 1) = 20 := by native_decide
theorem contact_cutoff : d3 = 8 := by native_decide
theorem residues_per_tile : nW * nW = 4 := by native_decide
theorem dof_per_residue : nC * nC = 9 := by native_decide
-- Total: 10 theorems by native_decide.
