-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
/-! # CrystalQInfo — Quantum Information integer identities from (2,3) -/
abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := (11 * nC - 2 * chi) / 3
abbrev sigmaD : Nat := 1 + 3 + 8 + 24
abbrev towerD : Nat := sigmaD + chi
-- Qubit structure
theorem qubit : nW = 2 := by native_decide
theorem pauli : nC = 3 := by native_decide
theorem pauli_group : nW * nW = 4 := by native_decide
theorem bell_states : nW * nW = 4 := by native_decide
theorem toffoli : nC = 3 := by native_decide
-- Error correction
theorem steane_n : beta0 = 7 := by native_decide
theorem steane_hamming : nW * nW * nW - 1 = beta0 := by native_decide
theorem steane_d : nC = 3 := by native_decide
theorem steane_corrects : (nC - 1) / 2 = 1 := by native_decide
theorem shor_n : nC * nC = 9 := by native_decide
-- MERA
theorem mera_bond : chi = 6 := by native_decide
theorem mera_depth : towerD = 42 := by native_decide
-- Information
theorem teleport : nW = 2 := by native_decide
-- Heyting
theorem coprime : Nat.gcd nW nC = 1 := by native_decide
theorem uncertainty_denom : nW * nC = chi := by native_decide
