-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # ObservableCosmo — Component 7 (Cosmo): cosmological identities.
  All integer relations proven by native_decide. -/

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := 7
abbrev d3 : Nat := nC * nC - 1
abbrev sigmaD : Nat := 1 + 3 + d3 + (nW * nW - 1) * d3
abbrev gauss : Nat := nC * nC + nW * nW
abbrev towerD : Nat := sigmaD + chi

-- Omega sum
theorem omega_sum : gauss + chi = 19 := by native_decide
theorem omega_l : gauss = 13 := by native_decide
theorem omega_m : chi = 6 := by native_decide

-- 100*theta denominator
theorem theta_denom : nW * (towerD + chi) = 96 := by native_decide

-- T_CMB
theorem tcmb_numer : gauss + chi = 19 := by native_decide
theorem tcmb_denom : beta0 = 7 := by native_decide

-- Age
theorem age_numer : gauss * beta0 + chi = 97 := by native_decide

-- Omega_DM implosion
theorem dm_implosion : gauss * (gauss - nC) = 130 := by native_decide
theorem dm_dual : nW * (chi - 1) * gauss = 130 := by native_decide

-- DM/baryon
theorem dm_baryon_numer : nW * nW * nC = 12 := by native_decide

-- Amplitude
theorem amplitude : nC * beta0 = 21 := by native_decide

-- Tower
theorem tower_depth : towerD = 42 := by native_decide

-- Neutrino corrections
theorem nu3_corr_numer : 2 * chi - 2 = 10 := by native_decide
theorem nu3_corr_denom : 2 * chi - 1 = 11 := by native_decide
theorem nu2_corr_numer : gauss - 1 = 12 := by native_decide
theorem chi_sq : chi * chi = 36 := by native_decide

-- Omega_b
theorem omega_b_denom : nC * (gauss + beta0) + 1 = 61 := by native_decide
