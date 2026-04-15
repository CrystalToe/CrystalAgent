-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # ObservableMixing — Component 7 (Mixing): CKM+PMNS identities.
  All integer relations proven by native_decide. -/

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev d1 : Nat := 1
abbrev d2 : Nat := nW * nW - 1
abbrev d3 : Nat := nC * nC - 1
abbrev d4 : Nat := d2 * d3
abbrev sigmaD : Nat := d1 + d2 + d3 + d4
abbrev gauss : Nat := nC * nC + nW * nW
abbrev towerD : Nat := sigmaD + chi

-- V_us
theorem vus_denom : sigmaD + nW * nW = 40 := by native_decide
theorem vus_numer : nC * nC = 9 := by native_decide

-- Wolfenstein A
theorem wolf_a_denom : nC + nW = 5 := by native_decide
theorem wolf_a_numer : nW * nW = 4 := by native_decide

-- V_cb = 81/2000
theorem vcb_numer : 4 * 81 = 324 := by native_decide
theorem vcb_denom : 5 * 1600 = 8000 := by native_decide

-- Jarlskog
theorem jarl_numer : nW + nC = 5 := by native_decide
theorem jarl_denom : nW * nW * nW * (nC * nC * nC * nC * nC) = 1944 := by native_decide

-- sin^2 theta_23
theorem sinSq23_denom : 2 * chi - 1 = 11 := by native_decide
theorem sinSq23_numer : chi = 6 := by native_decide

-- sin^2 theta_13 corrected
theorem sinSq13_numer : 2 * chi - 1 = 11 := by native_decide
theorem sinSq13_denom : nW * nW * ((chi - 1) * (chi - 1) * (chi - 1)) = 500 := by native_decide

-- sin^2 theta_W
theorem sinSqW_denom : gauss = 13 := by native_decide

-- cos(2 delta_PMNS) = 4/5
theorem cos2_numer : d2 * d2 - d1 * d1 = 8 := by native_decide
theorem cos2_denom : d2 * d2 + d1 * d1 = 10 := by native_decide
theorem cos2_simplify : 8 * 5 = 4 * 10 := by native_decide

-- Dual route for sin^2 theta_13
theorem sinSq13_dual_a : (towerD + nW * nW - 1) * (nW * nW) * ((chi - 1) * (chi - 1)) = 4500 := by native_decide
theorem sinSq13_dual_b : sigmaD * ((chi - 1) * (chi - 1) * (chi - 1)) = 4500 := by native_decide

-- Berry phase vectors
theorem ckm_real : d2 = 3 := by native_decide
theorem ckm_imag : d3 = 8 := by native_decide
theorem pmns_imag : d1 = 1 := by native_decide
