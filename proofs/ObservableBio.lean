-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # ObservableBio — Component 7 (Bio): genetic code + chemistry identities. -/

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := 7
abbrev d3 : Nat := nC * nC - 1
abbrev sigmaD : Nat := 1 + 3 + d3 + (nW * nW - 1) * d3
abbrev gauss : Nat := nC * nC + nW * nW
abbrev towerD : Nat := sigmaD + chi

theorem dna_bases : nW * nW = 4 := by native_decide
theorem codons : nW * nW * (nW * nW) * (nW * nW) = 64 := by native_decide
theorem amino : gauss + beta0 = 20 := by native_decide
theorem signals : nC * beta0 = 21 := by native_decide
theorem redundancy : 64 - 21 = towerD + 1 := by native_decide
theorem groove_numer : 2 * chi - 1 = 11 := by native_decide
theorem helix_numer : nC * chi = 18 := by native_decide
theorem helix_denom : chi - 1 = 5 := by native_decide
theorem d_orbital : nW * (chi - 1) = 10 := by native_decide
theorem f_orbital : nW * beta0 = 14 := by native_decide
theorem lattice_lock : sigmaD = chi * chi := by native_decide
theorem sigma_val : sigmaD = 36 := by native_decide
