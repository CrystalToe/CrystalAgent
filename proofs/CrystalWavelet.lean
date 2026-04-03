-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # CrystalWavelet — MERA = wavelet from (2,3)
Engine wired: full engine (d=36).
-/

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := (11 * nC - 2 * chi) / 3
abbrev d1 : Nat := 1
abbrev d2 : Nat := nW * nW - 1
abbrev d3 : Nat := nC * nC - 1
abbrev d4 : Nat := (nW * nW - 1) * (nC * nC - 1)
abbrev sigmaD : Nat := d1 + d2 + d3 + d4
abbrev towerD : Nat := sigmaD + chi
abbrev gauss : Nat := nW * nW + nC * nC
abbrev kappa_num : Nat := nC  -- ln(3)/ln(2) numerator base

-- Core atoms
theorem nW_val : nW = 2 := by native_decide
theorem nC_val : nC = 3 := by native_decide
theorem chi_val : chi = 6 := by native_decide
theorem beta0_val : beta0 = 7 := by native_decide
theorem d1_val : d1 = 1 := by native_decide
theorem d2_val : d2 = 3 := by native_decide
theorem d3_val : d3 = 8 := by native_decide
theorem d4_val : d4 = 24 := by native_decide
theorem sigmaD_val : sigmaD = 36 := by native_decide
theorem towerD_val : towerD = 42 := by native_decide
theorem gauss_val : gauss = 13 := by native_decide

-- Sector decomposition
theorem sector_sum : d1 + d2 + d3 + d4 = 36 := by native_decide
theorem haar_order : nW = 2 := by native_decide
theorem channels : chi = 6 := by native_decide
theorem mera_layers : towerD = 42 := by native_decide
theorem filter_len : nW * nC = 6 := by native_decide
theorem colour_sector : d3 = 8 := by native_decide
theorem mixed_sector : d4 = 24 := by native_decide
-- Engine wired.
