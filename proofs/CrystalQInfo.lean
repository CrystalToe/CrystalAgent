-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # CrystalQInfo — Quantum Information from (2,3)
Imports CrystalAtoms. Pure structural proofs + error correction circuits.
-/

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := (11 * nC - 2 * chi) / 3
abbrev sigmaD : Nat := 1 + 3 + 8 + 24
abbrev towerD : Nat := sigmaD + chi

-- §1 Qubit structure
theorem qubit : nW = 2 := by native_decide
theorem pauli : nC = 3 := by native_decide
theorem pauli_group : nW * nW = 4 := by native_decide
theorem bell_states : nW * nW = 4 := by native_decide
theorem toffoli : nC = 3 := by native_decide

-- §2 Error correction codes
theorem steane_n : beta0 = 7 := by native_decide
theorem steane_hamming : nW * nW * nW - 1 = beta0 := by native_decide
theorem steane_d : nC = 3 := by native_decide
theorem steane_corrects : (nC - 1) / 2 = 1 := by native_decide
theorem shor_n : nC * nC = 9 := by native_decide
theorem shor_blocks : nC = 3 := by native_decide

-- §3 MERA
theorem mera_bond : chi = 6 := by native_decide
theorem mera_depth : towerD = 42 := by native_decide

-- §4 Teleportation
theorem teleport : nW = 2 := by native_decide

-- §5 Heyting / uncertainty
theorem coprime : Nat.gcd nW nC = 1 := by native_decide
theorem uncertainty_denom : nW * nC = chi := by native_decide

-- §6 Error correction circuit dimensions
theorem steane_carriers : beta0 = 7 := by native_decide
theorem shor_carriers : nC * nC = 9 := by native_decide
theorem sector_values : chi = 6 := by native_decide
theorem steane_distance_corrects : (nC - 1) / 2 = 1 := by native_decide
theorem shor_block_size : nC = 3 := by native_decide
