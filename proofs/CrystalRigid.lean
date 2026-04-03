-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
/-! # CrystalRigid — Rigid Body integer identities from (2,3) -/
abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
-- Structure
theorem rot_axes : nC = 3 := by native_decide
theorem quat_comp : nW * nW = 4 := by native_decide
theorem inertia_tensor : chi = 6 := by native_decide
theorem rigid_dof : nC + nC = chi := by native_decide
theorem rot_matrix : nC * nC = 9 := by native_decide
theorem euler_angles : nC = 3 := by native_decide
-- Moments of inertia (as cross-multiply checks)
-- I_sphere: 2/5 = N_w/(chi-1) → 2*(chi-1) = 5*N_w
theorem i_sphere : 2 * (chi - 1) = 5 * nW := by native_decide
-- I_rod: 1/12 = 1/(2chi) → 2*chi = 12
theorem i_rod : 2 * chi = 12 := by native_decide
-- I_disk: 1/2 = 1/N_w → N_w = 2
theorem i_disk : nW = 2 := by native_decide
-- I_shell: 2/3 = N_w/N_c → 2*N_c = 3*N_w
theorem i_shell : 2 * nC = 3 * nW := by native_decide
-- Cross-checks
theorem lorentz_from_spacetime : nW * nW * (nW * nW - 1) / 2 = chi := by native_decide
theorem quat_is_spacetime : nW * nW = 4 := by native_decide
theorem inertia_is_lorentz : chi = 6 := by native_decide
theorem d2q9_from_rot : nC * nC = 9 := by native_decide
-- Engine wiring
abbrev sigmaD : Nat := 1 + 3 + 8 + 24
theorem engine_rot_sector : nC = 3 := by native_decide
theorem engine_quat : nW * nW = 4 := by native_decide
theorem engine_rigid_dof : chi = 6 := by native_decide
theorem engine_full : sigmaD = 36 := by native_decide
-- Engine wired.
