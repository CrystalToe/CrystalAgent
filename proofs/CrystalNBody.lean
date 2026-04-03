-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
/- CrystalNBody.lean — N-body integer identities from (2,3). -/
def N_w : Nat := 2
def N_c : Nat := 3
def chi : Nat := N_w * N_c
theorem oct_children : N_w ^ N_c = 8 := by native_decide
theorem oct_is_dcolour : N_w ^ N_c = N_c ^ 2 - 1 := by native_decide
theorem force_exp : N_c - 1 = 2 := by native_decide
theorem spatial_dim : N_c = 3 := by native_decide
theorem phase_per_body : 2 * N_c = chi := by native_decide
theorem chi_val : chi = 6 := by native_decide
