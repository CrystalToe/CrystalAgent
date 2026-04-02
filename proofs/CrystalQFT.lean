-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
/-! # CrystalQFT — Quantum Field Dynamics integer identities from (2,3) -/

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := (11 * nC - 2 * chi) / 3
abbrev sigmaD : Nat := 1 + 3 + 8 + 24
abbrev towerD : Nat := sigmaD + chi
abbrev gauss : Nat := nC * nC + nW * nW
abbrev dColour : Nat := nW * nW * nW
abbrev d3 : Nat := nC * nC - 1

-- Spacetime structure
theorem spacetime_dim : nW * nW = 4 := by native_decide
theorem lorentz_gen : nW * nW * (nW * nW - 1) / 2 = 6 := by native_decide
theorem lorentz_is_chi : nW * nW * (nW * nW - 1) / 2 = chi := by native_decide
theorem dirac_gammas : nW * nW = 4 := by native_decide
theorem spinor_comp : nW = 2 := by native_decide

-- Gauge structure
theorem photon_pol : nC - 1 = 2 := by native_decide
theorem gluon_colours : nC * nC - 1 = 8 := by native_decide
theorem gluons_is_d3 : d3 = dColour := by native_decide
theorem qcd_beta0 : beta0 = 7 := by native_decide
theorem n_flavours : chi = 6 := by native_decide
theorem one_loop : nW * nW * nW * nW = 16 := by native_decide

-- Cross-section structure
theorem thomson_num : dColour = 8 := by native_decide
theorem thomson_den : nC = 3 := by native_decide
theorem ee_mumu_num : nW * nW = 4 := by native_decide
theorem ee_mumu_den : nC = 3 := by native_decide
theorem propagator_exp : nC - 1 = 2 := by native_decide
theorem pair_factor : nW = 2 := by native_decide
theorem ps_2body : dColour = 8 := by native_decide

-- Fine structure
theorem tower_plus_1 : towerD + 1 = 43 := by native_decide
theorem beta0_val : beta0 = 7 := by native_decide

-- Cross-checks
theorem ps_3body : nC * 3 - (nC + 1) = chi - 1 := by native_decide
theorem ps_4body : nC * 4 - (nC + 1) = dColour := by native_decide
theorem d3_eq_dColour : nC * nC - 1 = nW * nW * nW := by native_decide
