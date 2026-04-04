-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # CrystalQBase — Shared quantum types and constants from (2,3)
Standalone: no engine, no imports. Pure types and constants.
-/

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := (11 * nC - 2 * chi) / 3
abbrev d1 : Nat := 1
abbrev d2 : Nat := nC
abbrev d3 : Nat := nC * nC - 1
abbrev d4 : Nat := nW * nW * nW * nC
abbrev sigmaD : Nat := d1 + d2 + d3 + d4
abbrev towerD : Nat := sigmaD + chi
abbrev gauss : Nat := nW * nW + nC * nC

-- §0 Core atom values
theorem nW_val : nW = 2 := by native_decide
theorem nC_val : nC = 3 := by native_decide
theorem chi_val : chi = 6 := by native_decide
theorem beta0_val : beta0 = 7 := by native_decide

-- §1 Sector dimensions
theorem d1_val : d1 = 1 := by native_decide
theorem d2_val : d2 = 3 := by native_decide
theorem d3_val : d3 = 8 := by native_decide
theorem d4_val : d4 = 24 := by native_decide

-- §2 Derived integers
theorem sigmaD_val : sigmaD = 36 := by native_decide
theorem towerD_val : towerD = 42 := by native_decide
theorem gauss_val : gauss = 13 := by native_decide

-- §3 Cross-checks
theorem sector_sum : d1 + d2 + d3 + d4 = 36 := by native_decide
theorem dims_sum : 1 + 3 + 8 + 24 = 36 := by native_decide
theorem endomorphisms : 1 + 9 + 64 + 576 = 650 := by native_decide
theorem sigmaD2 : 1 * 1 + 3 * 3 + 8 * 8 + 24 * 24 = 650 := by native_decide
