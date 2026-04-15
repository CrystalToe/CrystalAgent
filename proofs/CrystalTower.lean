-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # CrystalTower — Component 6: Tower identities.
  All integer relations proven by native_decide. -/

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := 7
abbrev d1 : Nat := 1
abbrev d2 : Nat := nW * nW - 1
abbrev d3 : Nat := nC * nC - 1
abbrev d4 : Nat := d2 * d3
abbrev sigmaD : Nat := d1 + d2 + d3 + d4
abbrev towerD : Nat := sigmaD + chi

-- Tower depth
theorem tower_is_42 : towerD = 42 := by native_decide
theorem tower_from_sigma_chi : sigmaD + chi = 42 := by native_decide

-- Coarse-graining factor
theorem chi_is_6 : chi = 6 := by native_decide

-- Staircase steps
theorem steps_43 : towerD + 1 = 43 := by native_decide
theorem tower_minus_1 : towerD - 1 = 41 := by native_decide

-- VEV numerator
theorem vev_numer : sigmaD - 1 = 35 := by native_decide

-- VEV denominator base
theorem vev_denom_base : (towerD + 1) * sigmaD = 1548 := by native_decide

-- VEV exponent
theorem vev_exponent : towerD + d3 - 1 = 49 := by native_decide

-- Lost DOF
theorem lost_dof : sigmaD - d1 = 35 := by native_decide

-- chi powers
theorem chi_sq : chi * chi = 36 := by native_decide
theorem chi_cubed : chi * chi * chi = 216 := by native_decide

-- Implosion
theorem implosion_numer : sigmaD - 1 = 35 := by native_decide
theorem implosion_denom : (towerD + 1) * sigmaD * (towerD + d3 - 1) = 75852 := by native_decide

-- Tower cross-identities
theorem tower_cross : towerD * chi = sigmaD * beta0 := by native_decide
theorem tower_cross_val : towerD * chi = 252 := by native_decide
theorem sigma_times_beta : sigmaD * beta0 = 252 := by native_decide
theorem lost_times_beta : (sigmaD - 1) * beta0 = 245 := by native_decide

-- Sector dims
theorem sector_sum : d1 + d2 + d3 + d4 = 36 := by native_decide
theorem mixed_product : d2 * d3 = d4 := by native_decide
theorem d4_is_24 : d4 = 24 := by native_decide

-- D x (D+1)
theorem d_times_steps : towerD * (towerD + 1) = 1806 := by native_decide
