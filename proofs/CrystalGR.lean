-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/- CrystalGR.lean — GR integer identities from (N_w, N_c) = (2, 3). -/

def N_w : Nat := 2
def N_c : Nat := 3
def chi : Nat := N_w * N_c
def gauss : Nat := N_c ^ 2 + N_w ^ 2

-- Schwarzschild
theorem schwarzschild_2 : N_c - 1 = 2 := by native_decide
-- Perihelion precession coefficient
theorem precession_6 : chi = 6 := by native_decide
theorem precession_6_decomp : N_w * N_c = 6 := by native_decide
-- Light bending
theorem light_bending_4 : N_w ^ 2 = 4 := by native_decide
-- ISCO
theorem isco_6 : chi = 6 := by native_decide
theorem isco_3 : N_c = 3 := by native_decide
theorem isco_energy_num : N_c ^ 2 - 1 = 8 := by native_decide  -- d_colour
theorem isco_energy_den : N_c ^ 2 = 9 := by native_decide
-- Shapiro
theorem shapiro_coeff : N_c - 1 = 2 := by native_decide
theorem shapiro_log : N_w ^ 2 = 4 := by native_decide
-- Spacetime
theorem spacetime_dim : N_c + 1 = 4 := by native_decide
-- Einstein field equation
theorem einstein_16piG : N_w ^ 4 = 16 := by native_decide
theorem einstein_8piG : N_c ^ 2 - 1 = 8 := by native_decide
-- GW
theorem gw_polarizations : N_c - 1 = 2 := by native_decide
theorem quadrupole_num : N_w ^ 5 = 32 := by native_decide
theorem quadrupole_den : chi - 1 = 5 := by native_decide
-- Equivalence principle
theorem equiv_principle : 1 + 9 + 64 + 576 = 650 := by native_decide
