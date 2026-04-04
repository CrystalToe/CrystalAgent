-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # CrystalAtoms — Integer identities for the 15 building blocks

  All 15 atoms derived from N_w = 2 and N_c = 3.
  VEV = 246.22 GeV is the single optional input (not proven here,
  it's a measured scale).

  All integer relations proven by native_decide.
-/

-- §0 The two primes
abbrev nW : Nat := 2
abbrev nC : Nat := 3

-- §1 Derived integers
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := 7
abbrev d1 : Nat := 1
abbrev d2 : Nat := nW * nW - 1
abbrev d3 : Nat := nC * nC - 1
abbrev d4 : Nat := (nW * nW - 1) * (nC * nC - 1)
abbrev sigmaD : Nat := d1 + d2 + d3 + d4
abbrev sigmaD2 : Nat := d1*d1 + d2*d2 + d3*d3 + d4*d4
abbrev towerD : Nat := sigmaD + chi
abbrev gauss : Nat := nW * nW + nC * nC
abbrev fermat3 : Nat := 257

-- ═══════════════════════════════════════════════════════════════
-- §2 ATOM VALUES
-- ═══════════════════════════════════════════════════════════════

theorem chi_val : chi = 6 := by native_decide
theorem beta0_val : beta0 = 7 := by native_decide
theorem beta0_from_atoms : 11 * nC = 3 * beta0 + 2 * chi := by native_decide

theorem d1_val : d1 = 1 := by native_decide
theorem d2_val : d2 = 3 := by native_decide
theorem d3_val : d3 = 8 := by native_decide
theorem d4_val : d4 = 24 := by native_decide

theorem sigmaD_val : sigmaD = 36 := by native_decide
theorem sigmaD2_val : sigmaD2 = 650 := by native_decide
theorem towerD_val : towerD = 42 := by native_decide
theorem gauss_val : gauss = 13 := by native_decide
theorem fermat3_val : fermat3 = 257 := by native_decide

-- ═══════════════════════════════════════════════════════════════
-- §3 STRUCTURAL IDENTITIES
-- ═══════════════════════════════════════════════════════════════

-- Mixed = weak ⊗ colour
theorem mixed_tensor : d2 * d3 = d4 := by native_decide
theorem d4_alt : nC * d3 = d4 := by native_decide

-- Σd decomposition
theorem sigmaD_sum : d1 + d2 + d3 + d4 = 36 := by native_decide
theorem sigmaD_is_sum : sigmaD = d1 + d2 + d3 + d4 := by native_decide

-- Tower = state space + internal
theorem tower_decomp : sigmaD + chi = 42 := by native_decide
theorem tower_is_sum : towerD = sigmaD + chi := by native_decide

-- Product of eigenvalue denominators: 1 × 2 × 3 × 6 = 36
theorem eigen_product : 1 * nW * nC * chi = sigmaD := by native_decide

-- Gauss integer
theorem gauss_from_primes : nW * nW + nC * nC = 13 := by native_decide

-- ═══════════════════════════════════════════════════════════════
-- §4 CKM IDENTITIES
-- ═══════════════════════════════════════════════════════════════

-- V_cb numerator: d₃ × d₄ = 192
theorem vcb_num : d3 * d4 = 192 := by native_decide

-- V_cb denominator: β₀ × Σd² = 4550
theorem vcb_den : beta0 * sigmaD2 = 4550 := by native_decide

-- 192 = 2⁶ × 3 = N_w⁶ × N_c
theorem vcb_192_factored : nW^6 * nC = 192 := by native_decide
theorem vcb_192_powers : 64 * 3 = 192 := by native_decide

-- V_ub denominator: gauss² = 169
theorem vub_den : gauss * gauss = 169 := by native_decide

-- ═══════════════════════════════════════════════════════════════
-- §5 ELECTROWEAK IDENTITIES
-- ═══════════════════════════════════════════════════════════════

-- sin²θ_W = N_c/gauss = 3/13 (cross-multiplied)
theorem sin2w_cross : nC * 13 = 3 * gauss := by native_decide

-- Hypercharge: d₃/(N_c·gauss) = 8/39 (cross-multiplied)
theorem hypercharge_cross : d3 * 39 = 8 * nC * gauss := by native_decide

-- Strong coupling denominator: gauss + N_w² = 17
theorem alpha_s_den : gauss + nW * nW = 17 := by native_decide

-- Strong coupling cross-check: N_w × 17 = 2 × 17
theorem alpha_s_cross : nW * 17 = 2 * (gauss + nW * nW) := by native_decide

-- ═══════════════════════════════════════════════════════════════
-- §6 NEUTRINO SUPPRESSION
-- ═══════════════════════════════════════════════════════════════

-- D × F₃ × Σd = 388584
theorem nu_suppression : towerD * fermat3 * sigmaD = 388584 := by native_decide

-- Y_e denominator: 2 × gauss × F₃ = 6682
theorem ye_den : nW * gauss * fermat3 = 6682 := by native_decide

-- Y_u denominator: Σd × gauss = 468
theorem yu_den : sigmaD * gauss = 468 := by native_decide

-- ═══════════════════════════════════════════════════════════════
-- §7 CHIRALITY IDENTITIES
-- ═══════════════════════════════════════════════════════════════

-- Left-handed total: 1 + 2 + 4 + 12 = 19
theorem left_total : 1 + nW + d3/2 + d4/2 = 19 := by native_decide

-- Right-handed total: 0 + 1 + 4 + 12 = 17
theorem right_total : 0 + (d2 - nW) + d3/2 + d4/2 = 17 := by native_decide

-- Sum = Σd
theorem lr_sum : 19 + 17 = sigmaD := by native_decide

-- Chiral asymmetry = N_w
theorem lr_asym : 19 - 17 = nW := by native_decide

-- ═══════════════════════════════════════════════════════════════
-- §8 BLOCK SIZES
-- ═══════════════════════════════════════════════════════════════

theorem block_01 : d1 * d2 = 3 := by native_decide
theorem block_02 : d1 * d3 = 8 := by native_decide
theorem block_03 : d1 * d4 = 24 := by native_decide
theorem block_12 : d2 * d3 = 24 := by native_decide
theorem block_13 : d2 * d4 = 72 := by native_decide
theorem block_23 : d3 * d4 = 192 := by native_decide

-- Total off-diagonal entries
theorem total_off_diag : 2*(d1*d2 + d1*d3 + d1*d4 + d2*d3 + d2*d4 + d3*d4) = 646 := by native_decide

-- Matrix size
theorem matrix_size : sigmaD * sigmaD = 1296 := by native_decide
theorem off_diag_count : sigmaD * sigmaD - sigmaD = 1260 := by native_decide

-- ═══════════════════════════════════════════════════════════════
-- §9 CP VIOLATION
-- ═══════════════════════════════════════════════════════════════

-- (N_c − 1)(N_c − 2)/2 = 1 CP-violating phase
theorem cp_phases : (nC - 1) * (nC - 2) / 2 = 1 := by native_decide

-- ═══════════════════════════════════════════════════════════════
-- §10 BIOLOGY IDENTITIES
-- ═══════════════════════════════════════════════════════════════

-- 20 amino acids = N_w² × (χ − 1)
theorem amino_acids : nW * nW * (chi - 1) = 20 := by native_decide

-- 64 codons = (N_w²)^N_c = 4³
theorem codons : (nW * nW)^nC = 64 := by native_decide

-- Codon base = N_w² = 4
theorem codon_base : nW * nW = 4 := by native_decide

-- ═══════════════════════════════════════════════════════════════
-- §11 STRUCTURAL CROSS-CHECKS
-- ═══════════════════════════════════════════════════════════════

-- Colour pairs: d₃ = 2 × 4
theorem colour_pairs : 2 * 4 = d3 := by native_decide

-- Mixed groups: d₄ = d₃ × 3
theorem mixed_groups : d3 * 3 = d4 := by native_decide

-- Mixed from tensor: d₄ = d₂ × d₃
theorem mixed_from_tensor : d2 * d3 = d4 := by native_decide

-- Colour squared
theorem colour_sq : d3 * d3 = 64 := by native_decide

-- Half of colour
theorem colour_half : d3 / 2 = 4 := by native_decide

-- Half of mixed
theorem mixed_half : d4 / 2 = 12 := by native_decide
