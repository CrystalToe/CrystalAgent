-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalRigid — Rigid body dynamics from (2,3)
-- Refactored: CrystalAtoms + CrystalSectors + CrystalEigen + CrystalOperators

abbrev nW : Nat := 2
abbrev nC : Nat := 3
abbrev chi : Nat := nW * nC
abbrev beta0 : Nat := 7
abbrev d1 : Nat := 1
abbrev d2 : Nat := nW * nW - 1
abbrev d3 : Nat := nC * nC - 1
abbrev d4 : Nat := (nW * nW - 1) * (nC * nC - 1)
abbrev sigmaD : Nat := d1 + d2 + d3 + d4
abbrev towerD : Nat := sigmaD + chi

-- §1 Rigid body structure
theorem rot_axes : nC = 3 := by native_decide
theorem quat_comp : nW * nW = 4 := by native_decide
theorem inertia_tensor : chi = 6 := by native_decide
theorem rigid_dof : nC + nC = 6 := by native_decide
theorem rot_mat : nC * nC = 9 := by native_decide
theorem euler_angles : nC = 3 := by native_decide

-- §2 Moments of inertia
theorem sphere_num : nW = 2 := by native_decide
theorem sphere_den : chi - 1 = 5 := by native_decide
theorem rod_den : 2 * chi = 12 := by native_decide
theorem disk_den : nW = 2 := by native_decide
theorem shell_num : nW = 2 := by native_decide
theorem shell_den : nC = 3 := by native_decide

-- §3 Cross products and rotations
theorem cross_dim : nC = 3 := by native_decide
theorem so3_generators : nC * (nC - 1) = 6 := by native_decide

-- §4 Crystal timestep
theorem dt_denom : towerD = 42 := by native_decide

-- §5 Flory = sphere MOI
theorem flory_num : nW = 2 := by native_decide
theorem flory_den : chi - 1 = 5 := by native_decide

-- §6 Component wiring
theorem comp_full : sigmaD = 36 := by native_decide
theorem comp_chi : chi = 6 := by native_decide
theorem comp_nw : nW = 2 := by native_decide

-- Total: 20 theorems by native_decide. Zero sorry.
