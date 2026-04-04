-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # CrystalAudit — Naturality constraints and mass ratios from (2,3)
Imports CrystalAxiom only. No CrystalEngine.
-/

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev sigmaD : Nat := 1 + 3 + 8 + 24
abbrev towerD : Nat := sigmaD + chi
abbrev d4 : Nat := nW * nW * nW * nC

-- §1 Naturality denominators
theorem vus_denom : sigmaD + nW * nW = 40 := by native_decide
theorem vus_num : nC * nC = 9 := by native_decide
theorem s23_denom : 2 * chi - 1 = 11 := by native_decide
theorem s23_num : chi = 6 := by native_decide
theorem s13_denom : sigmaD + nC * nC = 45 := by native_decide

-- §2 Endomorphism counts
theorem mixed_endos : d4 * d4 = 576 := by native_decide
theorem total_endos : 1 + 9 + 64 + 576 = 650 := by native_decide

-- §3 Mass ratio integers
theorem ms_mud : nC * nC * nC = 27 := by native_decide
theorem mb_ms : nC * nC * nC * nW = 54 := by native_decide
theorem mu_md_num : chi - 1 = 5 := by native_decide
theorem mu_md_denom : 2 * chi - 1 = 11 := by native_decide
theorem nc_fifth : nC * nC * nC * nC * nC = 243 := by native_decide

-- §4 Tower and structure
theorem tower : towerD = 42 := by native_decide
theorem sigma : sigmaD = 36 := by native_decide
theorem chi_sq_is_sigma : chi * chi = sigmaD := by native_decide
