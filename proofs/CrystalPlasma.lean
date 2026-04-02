-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # CrystalPlasma — MHD integer identities from (2,3) -/

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC               -- 6
abbrev dColour : Nat := nW * nW * nW      -- 8
abbrev sigmaD : Nat := 1 + 3 + 8 + 24    -- 36
abbrev gauss : Nat := nC * nC + nW * nW   -- 13
abbrev towerD : Nat := sigmaD + chi       -- 42

-- Atom sanity
theorem nW_val : nW = 2 := by native_decide
theorem nC_val : nC = 3 := by native_decide
theorem chi_val : chi = 6 := by native_decide
theorem dColour_val : dColour = 8 := by native_decide

-- MHD wave classification
theorem wave_types : nC = 3 := by native_decide
theorem prop_modes : 2 * nC = chi := by native_decide
theorem non_prop : nW = 2 := by native_decide
theorem total_modes : chi + nW = dColour := by native_decide
theorem total_is_8 : chi + nW = 8 := by native_decide

-- State variables
theorem state_vars : nW * nW * nW = 8 := by native_decide

-- Pressure factors
theorem mag_pressure : nW = 2 := by native_decide
theorem plasma_beta : nW = 2 := by native_decide

-- EM + CFD heritage
theorem em_components : chi = 6 := by native_decide
theorem cfd_d2q9 : nC * nC = 9 := by native_decide

-- Cross-checks
theorem chi_plus_nW : chi + nW = 8 := by native_decide
theorem two_nC_is_chi : 2 * nC = chi := by native_decide
theorem nW_cubed : nW * nW * nW = dColour := by native_decide
