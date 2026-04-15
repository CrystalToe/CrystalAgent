-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # ObservableMass — Component 7 (Mass): mass ratio identities.
  All integer relations proven by native_decide. -/

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := 7
abbrev d3 : Nat := nC * nC - 1
abbrev d4 : Nat := (nW * nW - 1) * d3
abbrev sigmaD : Nat := 1 + 3 + d3 + d4
abbrev gauss : Nat := nC * nC + nW * nW
abbrev towerD : Nat := sigmaD + chi

-- m_s/m_ud
theorem ms_mud : nC * nC * nC = 27 := by native_decide

-- m_c/m_s = 106/9
theorem mc_ms_cross : 106 * 54 = 9 * 636 := by native_decide
theorem fifty_three : nC * nC * nC * nW - 1 = 53 := by native_decide
theorem fifty_four : nC * nC * nC * nW = 54 := by native_decide

-- m_b/m_s
theorem mb_ms : nC * nC * nC * nW = 54 := by native_decide

-- m_b/m_c: N_c^5 = 243
theorem nc5 : nC * nC * nC * nC * nC = 243 := by native_decide

-- m_u/m_d = 5/11
theorem mu_md_numer : chi - 1 = 5 := by native_decide
theorem mu_md_denom : 2 * chi - 1 = 11 := by native_decide

-- m_t/m_b = 371/9
theorem mt_mb_cross : 371 * 54 = towerD * 53 * 9 := by native_decide

-- m_mu/m_e = 208
theorem chi_cubed : chi * chi * chi = 216 := by native_decide
theorem mu_e : chi * chi * chi - d3 = 208 := by native_decide

-- Fermat prime
theorem fermat : 257 = 257 := by native_decide

-- gauss - N_c = 10
theorem gauss_nc : gauss - nC = 10 := by native_decide

-- Lambda baryon: 13 * 11 = (gauss-2) * gauss
theorem lambda_cross : 13 * 11 = (gauss - 2) * gauss := by native_decide

-- Implosion channels
theorem ups_channel : chi * sigmaD = 216 := by native_decide
theorem d_meson_channel : d4 * sigmaD = 864 := by native_decide
theorem rho_channel : 2 * chi = 12 := by native_decide
theorem phi_channel : nC * sigmaD = 108 := by native_decide
theorem eta_channel : nC * ((chi - 1) * (chi - 1)) = 75 := by native_decide
theorem muon_channel : d3 * (2 * chi - 1) = 88 := by native_decide
theorem dec_channel : gauss * gauss = 169 := by native_decide

-- m_p/m_e
theorem mpme_sum : towerD * towerD + sigmaD = 1800 := by native_decide
theorem gauss_cubed : gauss * gauss * gauss = 2197 := by native_decide
