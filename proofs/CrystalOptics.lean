-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # CrystalOptics — Ray/Wave Optics integer identities from (2,3)

All optics constants traced to A_F atoms nW=2, nC=3.
-/

-- S0: A_F atoms
abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC               -- 6
abbrev gauss : Nat := nC * nC + nW * nW   -- 13
abbrev sigmaD : Nat := 1 + 3 + 8 + 24    -- 36
abbrev towerD : Nat := sigmaD + chi       -- 42

-- Atom sanity
theorem nW_val : nW = 2 := by native_decide
theorem nC_val : nC = 3 := by native_decide
theorem chi_val : chi = 6 := by native_decide
theorem gauss_val : gauss = 13 := by native_decide

-- S1: Casimir factor C_F = (N_c^2 - 1)/(2 N_c) = 4/3
-- Numerator: N_c^2 - 1 = 8
theorem cF_num : nC * nC - 1 = 8 := by native_decide
-- Denominator: 2 * N_c = 6
theorem cF_den : 2 * nC = 6 := by native_decide
-- C_F denominator equals chi
theorem cF_den_is_chi : 2 * nC = chi := by native_decide
-- C_F numerator equals N_w^3
theorem cF_num_is_dColour : nC * nC - 1 = nW * nW * nW := by native_decide

-- S2: IOR glass = N_c / N_w = 3/2
theorem glass_num : nC = 3 := by native_decide
theorem glass_den : nW = 2 := by native_decide

-- S3: Rayleigh exponents
-- Lambda exponent: 4 = N_w^2
theorem rayleigh_lambda : nW * nW = 4 := by native_decide
-- Size exponent: 6 = chi
theorem rayleigh_size : chi = 6 := by native_decide

-- S4: Planck exponent: 5 = chi - 1
theorem planck_exp : chi - 1 = 5 := by native_decide

-- S5: Cross-checks
-- 4/3 reduces correctly: gcd(N_c^2-1, 2*N_c) divides both
-- 4 * 6 = 8 * 3 (cross-multiply check for 4/3 = 8/6)
theorem cF_cross_multiply : 4 * (2 * nC) = (nC * nC - 1) * nC := by native_decide
-- N_c^2 - 1 = N_w^3 = 8
theorem casimir_colour : nC * nC - 1 = nW * nW * nW := by native_decide
-- chi - 1 = N_w^2 + 1
theorem chi_m1_decompose : chi - 1 = nW * nW + 1 := by native_decide
-- Weight cross-check: 4 * 9 = 36 = sigmaD
theorem weight_cross : (nW * nW) * (nC * nC) = sigmaD := by native_decide
