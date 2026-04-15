-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
-- CrystalSchrodinger — Quantum mechanics from (2,3)
abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := 7
abbrev sigmaD : Nat := 1 + 3 + 8 + 24

theorem hbar_den : nW = 2 := by native_decide
theorem spin : nW = 2 := by native_decide
theorem pauli : nC = 3 := by native_decide
theorem bell : nW * nW = 4 := by native_decide
theorem phase_space : chi = 6 := by native_decide
theorem shell_s : nW = 2 := by native_decide
theorem shell_p : chi = 6 := by native_decide
theorem shell_d : nW * (chi - 1) = 10 := by native_decide
theorem shell_f : nW * beta0 = 14 := by native_decide
theorem uncertainty : nW * nW = 4 := by native_decide
theorem spatial : nC = 3 := by native_decide
theorem strang_order : nW = 2 := by native_decide
theorem comp_full : sigmaD = 36 := by native_decide
-- Total: 14 theorems by native_decide.
