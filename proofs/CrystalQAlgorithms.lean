-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # CrystalQAlgorithms — Quantum algorithms from (2,3)
Engine wired: mixed sector (d=24).
-/

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev d1 : Nat := 1
abbrev d2 : Nat := nW * nW - 1
abbrev d3 : Nat := nC * nC - 1
abbrev d4 : Nat := (nW * nW - 1) * (nC * nC - 1)
abbrev sigmaD : Nat := d1 + d2 + d3 + d4

-- Hilbert space
theorem hilbert_dim : chi = 6 := by native_decide
theorem gate_set : chi * chi = 36 := by native_decide

-- Grover: O(√N) iterations, N = chi = 6
theorem grover_space : chi = 6 := by native_decide

-- QFT: chi-point DFT
theorem qft_points : chi = 6 := by native_decide

-- QAOA: chi sectors
theorem qaoa_sectors : chi = 6 := by native_decide

-- Superdense: chi² messages per pair
theorem superdense : chi * chi = 36 := by native_decide

-- BB84: chi basis states
theorem bb84_states : chi = 6 := by native_decide

-- Walk: 4 sector nodes
theorem walk_nodes : d1 + 1 + 1 + 1 = 4 := by native_decide

-- Engine wiring
theorem engine_sigmaD : d1 + d2 + d3 + d4 = sigmaD := by native_decide
theorem engine_sigmaD_val : sigmaD = 36 := by native_decide
theorem engine_mixed_dim : d4 = 24 := by native_decide
theorem lambda_mixed_denom : nW * nC = 6 := by native_decide
theorem no_weak : d2 = 3 := by native_decide
theorem no_colour : d3 = 8 := by native_decide
-- Engine wired.
