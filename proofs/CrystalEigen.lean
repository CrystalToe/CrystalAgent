-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # CrystalEigen — Component 4: Eigenvalue identities.
  All integer relations proven by native_decide. -/

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev sigmaD : Nat := 36

-- Eigenvalue denominators
theorem denom_singlet : 1 = 1 := by native_decide
theorem denom_weak : nW = 2 := by native_decide
theorem denom_colour : nC = 3 := by native_decide
theorem denom_mixed : chi = 6 := by native_decide

-- Product of denominators = Sigma_d
theorem denom_product : 1 * nW * nC * chi = sigmaD := by native_decide

-- Sum of reciprocals (cross-multiplied)
theorem recip_sum : chi + nC + nW + 1 = 12 := by native_decide
theorem recip_check : 12 / chi = 2 := by native_decide

-- Mixed = weak x colour
theorem mixed_product : nW * nC = chi := by native_decide

-- W o U factorisation
theorem factor_singlet : 1 * 1 = 1 := by native_decide
theorem factor_mixed : chi = nW * nC := by native_decide

-- Energy ordering
theorem order_1_2 : 1 + 1 = nW := by native_decide
theorem order_2_3 : nW + 1 = nC := by native_decide
theorem order_3_6 : nC + nC = chi := by native_decide
theorem chi_gt_one : chi - 1 = 5 := by native_decide
