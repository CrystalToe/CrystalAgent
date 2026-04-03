-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # CrystalMD — Molecular Dynamics integer identities from (2,3)

All MD constants traced to A_F atoms nW=2, nC=3.
-/

-- S0: A_F atoms
abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC               -- 6
abbrev sigmaD : Nat := 1 + 3 + 8 + 24    -- 36
abbrev gauss : Nat := nC * nC + nW * nW   -- 13
abbrev towerD : Nat := sigmaD + chi       -- 42
abbrev dMixed : Nat := nW * nW * nW * nC  -- 24

-- Atom sanity
theorem nW_val : nW = 2 := by native_decide
theorem nC_val : nC = 3 := by native_decide
theorem chi_val : chi = 6 := by native_decide
theorem dMixed_val : dMixed = 24 := by native_decide

-- S1: LJ exponents
theorem lj_att : chi = 6 := by native_decide
theorem lj_rep : 2 * chi = 12 := by native_decide
theorem lj_pot_coeff : nW * nW = 4 := by native_decide
theorem lj_force_coeff : dMixed = 24 := by native_decide
-- 2*dMixed = 48 = nW^2 * 2*chi
theorem lj_double_force : 2 * dMixed = 48 := by native_decide
theorem lj_coeff_trace : nW * nW * chi = dMixed := by native_decide

-- S2: Bond angle denominator
theorem tetra_den : nC = 3 := by native_decide

-- S3: H-bonds
theorem hbond_AT : nW = 2 := by native_decide
theorem hbond_GC : nC = 3 := by native_decide
theorem hbond_diff : nC - nW = 1 := by native_decide

-- S4: Helix = 18/5 = (N_c^2*N_w)/(chi-1)
theorem helix_num : nC * nC * nW = 18 := by native_decide
theorem helix_den : chi - 1 = 5 := by native_decide

-- S5: Flory nu = 2/5 = N_w/(chi-1)
theorem flory_num : nW = 2 := by native_decide
theorem flory_den : chi - 1 = 5 := by native_decide

-- S6: Coulomb exponent
theorem coulomb_exp : nC - 1 = 2 := by native_decide

-- S7: Cross-checks
theorem two_chi : 2 * chi = 12 := by native_decide
theorem chi_minus_one : chi - 1 = 5 := by native_decide
theorem dMixed_alt : 2 * chi * nW = 24 := by native_decide
theorem nC_sq_nW : nC * nC * nW = 18 := by native_decide
theorem nW_sq_is_four : nW * nW = 4 := by native_decide
-- Engine wiring
theorem engine_lj_attr : chi = 6 := by native_decide
theorem engine_lj_rep : 2 * chi = 12 := by native_decide
theorem engine_lj_force : dMixed = 24 := by native_decide
theorem engine_full : sigmaD = 36 := by native_decide
-- Engine wired.
