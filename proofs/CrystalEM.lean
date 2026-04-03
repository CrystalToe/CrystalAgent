-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
/- CrystalEM.lean — EM integer identities from (N_w, N_c) = (2, 3). -/
def N_w : Nat := 2
def N_c : Nat := 3
def chi : Nat := N_w * N_c
theorem em_components : chi = 6 := by native_decide
theorem e_components : N_c = 3 := by native_decide
theorem b_components : N_c = 3 := by native_decide
theorem two_form_dim : (N_c + 1) * N_c / 2 = 6 := by native_decide
theorem maxwell_eqs : N_c + 1 = 4 := by native_decide
theorem larmor_num : N_c - 1 = 2 := by native_decide
theorem larmor_den : N_c = 3 := by native_decide
theorem rayleigh_wave : N_w ^ 2 = 4 := by native_decide
theorem rayleigh_size : chi = 6 := by native_decide
theorem planck_exp : chi - 1 = 5 := by native_decide
theorem stefan_exp : N_w ^ 2 = 4 := by native_decide
theorem stefan_denom : N_c * (chi - 1) = 15 := by native_decide
theorem gauge_u1 : 1 = 1 := by native_decide
theorem gauss_e_sector : 1 = 1 := by native_decide
theorem gauss_b_sector : N_c = 3 := by native_decide
theorem faraday_sector : N_c ^ 2 - 1 = 8 := by native_decide
theorem ampere_sector : N_w ^ 3 * N_c = 24 := by native_decide
-- Engine wiring
abbrev sigmaD : Nat := 1 + 3 + 8 + 24
abbrev dColour : Nat := N_c * N_c - 1
theorem engine_em_sector : dColour = 8 := by native_decide
theorem engine_field_comp : chi = 6 := by native_decide
theorem engine_courant : N_w = 2 := by native_decide
theorem engine_full : sigmaD = 36 := by native_decide
-- Engine wired.
