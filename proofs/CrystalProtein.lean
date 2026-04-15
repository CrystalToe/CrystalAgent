-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := 7
abbrev d1 : Nat := 1
abbrev d2 : Nat := 3
abbrev d3 : Nat := 8
abbrev d4 : Nat := 24
abbrev sigmaD : Nat := d1 + d2 + d3 + d4
abbrev gauss : Nat := nC * nC + nW * nW
abbrev towerD : Nat := sigmaD + chi
abbrev sigmaD2 : Nat := d1*d1 + d2*d2 + d3*d3 + d4*d4

theorem staircase : towerD + 1 = 43 := by native_decide
theorem shared_core : sigmaD2 * towerD = 27300 := by native_decide
theorem rama_denom : nW * nW * (nW * nW) * (nW * nW) = 64 := by native_decide
theorem rama_numer : sigmaD = 36 := by native_decide
theorem helix_numer : nC * chi = 18 := by native_decide
theorem helix_denom : chi - 1 = 5 := by native_decide
theorem dof_tile : 4 * 9 = sigmaD := by native_decide
theorem imp_hbond : gauss - 1 = 12 := by native_decide
theorem imp_vdw_dist : d4 * d4 = 576 := by native_decide
theorem imp_hb_dist : nC * nC * nC * nW = 54 := by native_decide
theorem sin2_corr : d4 * sigmaD2 = 15600 := by native_decide
theorem epsilon_r : nW * nW * nW * nW = 16 := by native_decide
theorem cosmo_split : 29 + 11 + 2 = towerD := by native_decide
theorem cooling_cross : 5 * sigmaD = 36 * (chi - 1) := by native_decide
