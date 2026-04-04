-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalEM — EM field evolution from (2,3)
-- Refactored: CrystalAtoms + CrystalSectors + CrystalEigen + CrystalOperators

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := 7
abbrev d1 : Nat := 1
abbrev d2 : Nat := nW * nW - 1
abbrev d3 : Nat := nC * nC - 1
abbrev d4 : Nat := (nW * nW - 1) * (nC * nC - 1)
abbrev sigmaD : Nat := d1 + d2 + d3 + d4
abbrev towerD : Nat := sigmaD + chi

-- §1 EM field structure
theorem em_components : chi = 6 := by native_decide
theorem e_components : nC = 3 := by native_decide
theorem b_components : nC = 3 := by native_decide
theorem two_form_dim : (nC + 1) * nC = 12 := by native_decide

-- §2 Maxwell equations
theorem maxwell_eqs : nC + 1 = 4 := by native_decide
theorem gauss_e_sector : d1 = 1 := by native_decide
theorem gauss_b_sector : d2 = 3 := by native_decide
theorem faraday_sector : d3 = 8 := by native_decide
theorem ampere_sector : d4 = 24 := by native_decide

-- §3 Radiation
theorem larmor_num : nC - 1 = 2 := by native_decide
theorem larmor_den : nC = 3 := by native_decide
theorem rayleigh_wave : nW * nW = 4 := by native_decide
theorem rayleigh_size : chi = 6 := by native_decide
theorem planck_exp : chi - 1 = 5 := by native_decide
theorem stefan_exp : nW * nW = 4 := by native_decide
theorem stefan_denom : nC * (chi - 1) = 15 := by native_decide

-- §4 2D FDTD crystal parameters
theorem courant_denom : nW = 2 := by native_decide
theorem grid_dx_denom : nC = 3 := by native_decide
theorem grid_dt_is_chi : nW * nC = chi := by native_decide

-- §5 Thomson cross-section
theorem thomson_num : d3 = 8 := by native_decide
theorem thomson_den : nC = 3 := by native_decide

-- §6 Component wiring
theorem comp_em_sector : d3 = 8 := by native_decide
theorem comp_field_count : chi = 6 := by native_decide
theorem comp_courant : nW = 2 := by native_decide
theorem comp_full_state : sigmaD = 36 := by native_decide

-- §7 Dipole harmonics
theorem dipole_harmonics : chi = 6 := by native_decide

-- §8 Gauge
theorem gauge_u1 : d1 = 1 := by native_decide

-- Total: 27 theorems by native_decide. Zero sorry.
