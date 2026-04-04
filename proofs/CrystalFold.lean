-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev d1 : Nat := 1
abbrev d2 : Nat := 3
abbrev d3 : Nat := 8
abbrev d4 : Nat := 24
abbrev sigmaD : Nat := d1 + d2 + d3 + d4

theorem state_dim : sigmaD = 36 := by native_decide
theorem tile_dof : 4 * 9 = sigmaD := by native_decide
theorem helix_numer : nC * nC * nW = 18 := by native_decide
theorem helix_denom : chi - 1 = 5 := by native_decide
theorem lattice_lock : sigmaD = chi * chi := by native_decide
theorem mixed_dominance : d4 = d3 + d2 + d1 + 12 := by native_decide
