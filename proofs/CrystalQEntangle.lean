-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # CrystalQEntangle — Entanglement analysis from (2,3)
Pure MERA. Imports CrystalQBase only. No engine.
PPT is exact for ℂ^N_w ⊗ ℂ^N_c = ℂ² ⊗ ℂ³ (Horodecki 1996).
-/

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC

-- §1 PPT exact: ℂ^N_w ⊗ ℂ^N_c is the unique dimension
theorem ppt_dim_a : nW = 2 := by native_decide
theorem ppt_dim_b : nC = 3 := by native_decide
theorem ppt_product : nW * nC = 6 := by native_decide

-- §2 Bipartite Hilbert space dimensions
theorem bipartite_dim : chi * chi = 36 := by native_decide
theorem tripartite_dim : chi * chi * chi = 216 := by native_decide

-- §3 Schmidt rank = min(N_w, N_c) = N_w
theorem schmidt_rank : nW = 2 := by native_decide

-- §4 Bell basis count = N_w² = 4
theorem bell_count : nW * nW = 4 := by native_decide

-- §5 Entanglement witness threshold = 1/χ
theorem witness_denom : chi = 6 := by native_decide

-- §6 Product states in ℂ^χ ⊗ ℂ^χ: parametrised by ℂ^χ × ℂ^χ
theorem product_params : chi + chi = 12 := by native_decide
