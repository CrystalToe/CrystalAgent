-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # CrystalCorrections — Component 8: Correction level identities.
  All integer relations proven by native_decide. -/

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev d3 : Nat := nC * nC - 1
abbrev d4 : Nat := (nW * nW - 1) * d3
abbrev sigmaD : Nat := 1 + 3 + d3 + d4
abbrev towerD : Nat := sigmaD + chi
abbrev beta0 : Nat := 7

-- Beta function: beta_1 numerator
theorem beta1_numer : 34 * (nC * nC) - 10 * nC * chi + 3 * chi = 144 := by native_decide

-- beta_1 = 48 (144/3)
theorem beta1_check : 48 * 3 = 144 := by native_decide

-- beta_0 x beta_1 = 336
theorem beta_product : beta0 * 48 = 336 := by native_decide

-- beta_0^2 = 49
theorem beta0_sq : beta0 * beta0 = 49 := by native_decide

-- One-loop denominator: N_w^4 = 16
theorem oneloop_denom : nW * nW * nW * nW = 16 := by native_decide

-- Staircase steps
theorem staircase_steps : towerD + 1 = 43 := by native_decide

-- d_3 = 8
theorem d3_is_8 : d3 = 8 := by native_decide

-- N_c^2 = 9
theorem nc_sq : nC * nC = 9 := by native_decide

-- beta_0 derivation
theorem beta0_numer : 11 * nC - 2 * chi = 3 * beta0 := by native_decide
theorem beta0_deriv : 3 * beta0 = 11 * nC - 2 * chi := by native_decide

-- 11 N_c = 33
theorem eleven_nc : 11 * nC = 33 := by native_decide

-- 2 chi = 12
theorem two_chi : 2 * chi = 12 := by native_decide

-- Observable count
theorem obs_total : 60 + 45 + 35 + 20 + 15 + 10 + 8 + 55 = 248 := by native_decide
