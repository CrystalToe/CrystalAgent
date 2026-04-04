-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # CrystalBenchmark — Trp-cage (1L2Y) protein folding benchmark
Imports CrystalFold only. All (2,3) derivations in CrystalFold.
-/

abbrev trpCageResidues : Nat := 20
abbrev refCoords : Nat := 20
abbrev benchConfigs : Nat := 5

theorem residue_count : trpCageResidues = 20 := by native_decide
theorem ref_count : refCoords = 20 := by native_decide
theorem config_count : benchConfigs = 5 := by native_decide
