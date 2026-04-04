-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev d3 : Nat := nC * nC - 1
abbrev sigmaD : Nat := 1 + 3 + d3 + (nW * nW - 1) * d3
abbrev towerD : Nat := sigmaD + nW * nC

theorem vev_numer : sigmaD - 1 = 35 := by native_decide
theorem vev_staircase : towerD + 1 = 43 := by native_decide
theorem vev_sigma : sigmaD = 36 := by native_decide
theorem vev_exp : towerD + d3 = 50 := by native_decide
theorem vev_denom : (towerD + 1) * sigmaD = 1548 := by native_decide
