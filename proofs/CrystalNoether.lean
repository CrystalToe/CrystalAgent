-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := 7
abbrev d1 : Nat := 1
abbrev d2 : Nat := nC
abbrev d3 : Nat := nC * nC - 1
abbrev d4 : Nat := nC * nC * nC - nC
abbrev sigmaD : Nat := d1 + d2 + d3 + d4
abbrev towerD : Nat := sigmaD + chi
abbrev gauss : Nat := nC * nC + nW * nW

theorem gauge_total : 1 + (nW * nW - 1) + d3 = 12 := by native_decide
theorem lorentz_chi : nC * (nC + 1) = 2 * chi := by native_decide
theorem solvable : gauss - nC = 10 := by native_decide
theorem algebra_dim : 1 + nW * nW + nC * nC = 14 := by native_decide
theorem carnot : 5 * chi = (chi - 1) * chi := by native_decide
theorem stefan : nW * nC * (gauss + beta0) = 120 := by native_decide
theorem lattice : sigmaD = chi * chi := by native_decide
theorem neutron : towerD * towerD = 882 * nW := by native_decide
theorem karman : nW * 5 = 2 * (chi - 1) := by native_decide
theorem casimir : d3 * 3 = 4 * (2 * nC) := by native_decide
theorem codons : (nW * nW) * (nW * nW) * (nW * nW) = 64 := by native_decide
theorem amino : nC * beta0 = 21 := by native_decide
theorem depth : (1 + nW * nW + nC * nC) * nC = towerD := by native_decide
theorem sd2 : d1 * d1 + d2 * d2 + d3 * d3 + d4 * d4 = 650 := by native_decide
