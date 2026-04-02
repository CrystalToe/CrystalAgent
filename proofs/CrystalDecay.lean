-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # CrystalDecay — Particle Decay integer identities from (2,3)

All decay constants traced to A_F atoms nW=2, nC=3.
-/

-- S0: A_F atoms
abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC               -- 6
abbrev gauss : Nat := nC * nC + nW * nW   -- 13
abbrev sigmaD : Nat := 1 + 3 + 8 + 24    -- 36
abbrev towerD : Nat := sigmaD + chi       -- 42

-- S1: Decay-specific constants
abbrev dColour : Nat := nW * nW * nW          -- 8
abbrev dMixed : Nat := nW * nW * nW * nC      -- 24
abbrev betaConst : Nat := dMixed * dColour     -- 192

-- Atom sanity
theorem nW_val : nW = 2 := by native_decide
theorem nC_val : nC = 3 := by native_decide
theorem chi_val : chi = 6 := by native_decide
theorem gauss_val : gauss = 13 := by native_decide

-- S2: Beta constant 192
theorem dColour_val : dColour = 8 := by native_decide
theorem dMixed_val : dMixed = 24 := by native_decide
theorem betaConst_val : betaConst = 192 := by native_decide
theorem beta_product : dMixed * dColour = 192 := by native_decide
theorem beta_decompose : 24 * 8 = 192 := by native_decide

-- S3: Weinberg angle sin^2 theta_W = N_c / gauss = 3/13
theorem weinberg_num : nC = 3 := by native_decide
theorem weinberg_den : gauss = 13 := by native_decide

-- S4: PMNS theta_23 = chi / (2*chi - 1) = 6/11
theorem theta23_num : chi = 6 := by native_decide
theorem theta23_den : 2 * chi - 1 = 11 := by native_decide

-- sin^2(2 theta_23) = 120/121
theorem sin22_num : 4 * chi * (chi - 1) = 120 := by native_decide
theorem sin22_den : (2 * chi - 1) * (2 * chi - 1) = 121 := by native_decide

-- S5: Phase space dimension 3N - 4 = nC*N - (nC + 1)
theorem phase_dim_2 : nC * 2 - (nC + 1) = 2 := by native_decide
theorem phase_dim_3 : nC * 3 - (nC + 1) = 5 := by native_decide
theorem phase_dim_4 : nC * 4 - (nC + 1) = 8 := by native_decide
theorem phase_dim_4_is_dColour : nC * 4 - (nC + 1) = dColour := by native_decide

-- S6: Cross-checks
theorem dColour_is_nW_cubed : nW * nW * nW = 8 := by native_decide
theorem dMixed_alt : 2 * chi * nW = 24 := by native_decide
theorem gauss_decompose : nC * nC + nW * nW = 13 := by native_decide
theorem chi_minus_one : chi - 1 = 5 := by native_decide
theorem beta_factor_colour : dMixed * dColour = betaConst := by native_decide
theorem beta_factor_mixed : dColour * dMixed = betaConst := by native_decide
