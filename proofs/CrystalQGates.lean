-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # CrystalQGates — Quantum gates from End(A_F)
Pure MERA. Imports CrystalQBase only. No engine, no time evolution.
-/

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC

-- §0 Gate space dimensions
theorem single_dim : chi = 6 := by native_decide
theorem two_particle_dim : chi * chi = 36 := by native_decide
theorem three_particle_dim : chi * chi * chi = 216 := by native_decide
theorem process_matrix_dim : chi * chi * chi * chi = 1296 := by native_decide

-- §1 Pauli structure from (2,3)
theorem pauli_non_trivial : nC = 3 := by native_decide
theorem pauli_group_size : nW * nW = 4 := by native_decide
theorem givens_pairs : chi * (chi - 1) = 30 := by native_decide

-- §2 Tensor product = algebra dimension
theorem tensor_is_sigmaD : chi * chi = 1 + 3 + 8 + 24 := by native_decide

-- §3 Gate counts (from source)
-- 12 single-particle: I, X, Y, Z, H, S, T, Rx, Ry, Rz, U3, SX
-- 14 multi-particle: CNOT, CZ, SWAP, iSWAP, √SWAP, Toffoli, CSWAP,
--                    XX, YY, ZZ, ECR, Givens, fSWAP, Matchgate
-- 2 application helpers: applySingle, applyTwo
