-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
/-! # CrystalBio — Biological integer identities from (2,3) -/
abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
-- Genetic code
theorem bases : nW * nW = 4 := by native_decide
theorem codon_len : nC = 3 := by native_decide
theorem total_codons : nW * nW * (nW * nW) * (nW * nW) = 64 := by native_decide
theorem amino_acids : nW * nW * (chi - 1) = 20 := by native_decide
theorem stop_codons : nC = 3 := by native_decide
-- DNA
theorem strands : nW = 2 := by native_decide
theorem hbond_at : nW = 2 := by native_decide
theorem hbond_gc : nC = 3 := by native_decide
theorem bp_per_turn : nW * (chi - 1) = 10 := by native_decide
-- Protein (cross-multiply for rationals)
theorem helix_cross : (nC * nC * nW) * 5 = 18 * (chi - 1) := by native_decide
theorem flory_cross : nW * 5 = 2 * (chi - 1) := by native_decide
theorem bilayer : nW = 2 := by native_decide
-- Allometric (cross-multiply)
theorem kleiber_cross : nC * 4 = 3 * (nW * nW) := by native_decide
theorem heart_cross : 1 * (nW * nW) = 1 * 4 := by native_decide
theorem surface_cross : nW * 3 = 2 * nC := by native_decide
-- Cross-checks
theorem bases_bell : nW * nW = 4 := by native_decide
theorem codons_pow : 4 * 4 * 4 = 64 := by native_decide
