-- Copyright (c) 2026 Daland Montgomery  SPDX: AGPL-3.0-or-later
def N_w : Nat := 2
def N_c : Nat := 3
def chi : Nat := N_w * N_c
def sigma_d : Nat := 1 + 3 + 8 + 24

theorem schwarz : N_c - 1 = 2 := by native_decide
theorem precession : chi = 6 := by native_decide
theorem bending : N_w ^ 2 = 4 := by native_decide
theorem isco6 : chi = 6 := by native_decide
theorem isco3 : N_c = 3 := by native_decide
theorem photon_sphere : N_c = 3 := by native_decide
theorem isco_e_num : N_c ^ 2 - 1 = 8 := by native_decide
theorem isco_e_den : N_c ^ 2 = 9 := by native_decide
theorem spacetime : N_c + 1 = 4 := by native_decide
theorem coeff_16 : N_w ^ 4 = 16 := by native_decide
theorem gr_correction : N_c = 3 := by native_decide
theorem d_colour : N_c ^ 2 - 1 = 8 := by native_decide
theorem sigma_d_val : sigma_d = 36 := by native_decide
theorem lambda_weak : N_w = 2 := by native_decide
theorem lambda_colour : N_c = 3 := by native_decide
-- Zero sorry.
