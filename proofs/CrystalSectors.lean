-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # CrystalSectors — Component 3: The four irreps and state space.
  All integer relations proven by native_decide. -/

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev d1 : Nat := 1
abbrev d2 : Nat := nW * nW - 1
abbrev d3 : Nat := nC * nC - 1
abbrev d4 : Nat := (nW * nW - 1) * (nC * nC - 1)
abbrev sigmaD : Nat := d1 + d2 + d3 + d4

-- Sector dimensions
theorem d1_val : d1 = 1 := by native_decide
theorem d2_val : d2 = 3 := by native_decide
theorem d3_val : d3 = 8 := by native_decide
theorem d4_val : d4 = 24 := by native_decide
theorem sigmaD_val : sigmaD = 36 := by native_decide
theorem partition : d1 + d2 + d3 + d4 = 36 := by native_decide

-- Mixed = weak x colour
theorem mixed_tensor : d2 * d3 = d4 := by native_decide
theorem d4_alt : nC * d3 = d4 := by native_decide

-- Sector boundaries
theorem start_1 : d1 = 1 := by native_decide
theorem start_2 : d1 + d2 = 4 := by native_decide
theorem start_3 : d1 + d2 + d3 = 12 := by native_decide
theorem start_end : d1 + d2 + d3 + d4 = 36 := by native_decide

-- Block sizes
theorem block_01 : d1 * d2 = 3 := by native_decide
theorem block_02 : d1 * d3 = 8 := by native_decide
theorem block_03 : d1 * d4 = 24 := by native_decide
theorem block_12 : d2 * d3 = 24 := by native_decide
theorem block_13 : d2 * d4 = 72 := by native_decide
theorem block_23 : d3 * d4 = 192 := by native_decide

-- Matrix dimension
theorem matrix_dim : sigmaD * sigmaD = 1296 := by native_decide

-- Structure
theorem colour_pairs : d3 / 2 = 4 := by native_decide
theorem mixed_groups : d4 / d3 = 3 := by native_decide
theorem mixed_groups_eq_d2 : d4 / d3 = d2 := by native_decide
theorem colour_half : 4 + 4 = d3 := by native_decide
theorem mixed_half : 12 + 12 = d4 := by native_decide
