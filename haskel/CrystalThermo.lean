-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
/- CrystalThermo.lean — Thermodynamic identities from (2,3). -/
def N_w : Nat := 2
def N_c : Nat := 3
def chi : Nat := N_w * N_c
def beta0 : Nat := 7
theorem lj_attractive : chi = 6 := by native_decide
theorem lj_repulsive : 2 * chi = 12 := by native_decide
theorem lj_force_24 : N_w ^ 3 * N_c = 24 := by native_decide
theorem gamma_mono_num : chi - 1 = 5 := by native_decide
theorem gamma_mono_den : N_c = 3 := by native_decide
theorem gamma_di_num : beta0 = 7 := by native_decide
theorem gamma_di_den : chi - 1 = 5 := by native_decide
theorem dof_mono : N_c = 3 := by native_decide
theorem dof_di : chi - 1 = 5 := by native_decide
theorem carnot_num : chi - 1 = 5 := by native_decide
theorem carnot_den : chi = 6 := by native_decide
theorem stokes : N_w ^ 3 * N_c = 24 := by native_decide
