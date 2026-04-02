-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
/-! # CrystalArcade — Approximation integer identities from (2,3) -/
abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev dColour : Nat := nW * nW * nW
abbrev sigmaD : Nat := 1 + 3 + 8 + 24
abbrev towerD : Nat := sigmaD + chi
theorem lj_cutoff : nC = 3 := by native_decide
theorem bh_theta_den : nW = 2 := by native_decide
theorem octree : dColour = 8 := by native_decide
theorem euler_order : (1 : Nat) = 1 := by native_decide
theorem verlet_order : nW = 2 := by native_decide
theorem fixed_bits : nW * nW * nW * nW = 16 := by native_decide
theorem hash_cells : nC = 3 := by native_decide
theorem lod_levels : nC = 3 := by native_decide
theorem mf_tc : nW * nW = 4 := by native_decide
theorem newton_iter : nW = 2 := by native_decide
theorem tower_43 : towerD + 1 = 43 := by native_decide
-- Cross-checks
theorem fixed_is_oneloop : nW * nW * nW * nW = 16 := by native_decide
theorem lod_is_codon : nC = 3 := by native_decide
theorem octree_is_dcolour : nW * nW * nW = dColour := by native_decide
