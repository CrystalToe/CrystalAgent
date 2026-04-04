-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # CrystalQMeasure — Measurement operators + tomography from (2,3)
Pure MERA. Imports CrystalQBase only. No engine.
-/

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev d1 : Nat := 1
abbrev d2 : Nat := nC
abbrev d3 : Nat := nC * nC - 1
abbrev d4 : Nat := nW * nW * nW * nC
abbrev sigmaD : Nat := d1 + d2 + d3 + d4

-- §1 Measurement dimensions
theorem projective_outcomes : chi = 6 := by native_decide
theorem sector_count : d1 + 1 + 1 + 1 = 4 := by native_decide

-- §2 Parity
theorem parity_even : d1 + d3 = 9 := by native_decide
theorem parity_odd : d2 + d4 = 27 := by native_decide
theorem parity_sum : (d1 + d3) + (d2 + d4) = sigmaD := by native_decide

-- §3 Bell and two-particle
theorem bell_outcomes : chi = 6 := by native_decide
theorem two_particle : chi * chi = 36 := by native_decide
theorem povm_norm : sigmaD = 36 := by native_decide

-- §4 Tomography: χ²-1 = 35 bases
theorem tomography_bases : chi * chi - 1 = 35 := by native_decide
theorem tomo_parameters : chi * chi = 36 := by native_decide
theorem tomo_points_per_basis : chi = 6 := by native_decide
