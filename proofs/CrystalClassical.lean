-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-
  CrystalClassical.lean — Integer identities in classical orbital mechanics.
  All from (N_w, N_c) = (2, 3). Machine-checked by Lean 4.
-/

-- §0 A_F atoms
def N_w : Nat := 2
def N_c : Nat := 3
def chi : Nat := N_w * N_c                           -- 6
def beta0 : Nat := (11 * N_c - 2 * chi) / 3         -- 7
def sigma_d : Nat := 1 + 3 + 8 + 24                  -- 36
def sigma_d2 : Nat := 1 + 9 + 64 + 576               -- 650
def gauss : Nat := N_c ^ 2 + N_w ^ 2                 -- 13
def tower_d : Nat := sigma_d + chi                    -- 42

-- §1 Force and spatial dimensions
theorem force_exponent : N_c - 1 = 2 := by native_decide
theorem spatial_dim : N_c = 3 := by native_decide
theorem bertrand_closed_orbits : N_c - 1 = 2 := by native_decide

-- §2 Kepler's laws
theorem kepler_exponent : N_c = 3 := by native_decide  -- T² ∝ r³
theorem kepler_coeff : N_w ^ 2 = 4 := by native_decide  -- 4 in 4π²
theorem spacetime_dim : N_c + 1 = 4 := by native_decide

-- §3 Angular momentum
theorem ang_mom_components : N_c * (N_c - 1) / 2 = 3 := by native_decide

-- §4 Three-body phase space decomposition
theorem phase_solvable : gauss - N_c = 10 := by native_decide
theorem phase_chaotic : N_c ^ 2 - 1 = 8 := by native_decide
theorem phase_total : (gauss - N_c) + (N_c ^ 2 - 1) = 18 := by native_decide

-- §5 Lagrange points
theorem lagrange_points : chi - 1 = 5 := by native_decide

-- §6 Gravitational wave radiation
theorem gw_polarizations : N_c - 1 = 2 := by native_decide
theorem einstein_coeff : N_w ^ 4 = 16 := by native_decide  -- 16πG
theorem schwarzschild_2 : N_c - 1 = 2 := by native_decide  -- r_s = 2GM

-- §7 Ryu-Takayanagi
theorem rt_4 : N_w ^ 2 = 4 := by native_decide  -- S = A/(4G)

-- §8 Quadrupole radiation coefficient
-- 32/5 = N_w⁵ / (χ − 1)
theorem quadrupole_num : N_w ^ 5 = 32 := by native_decide
theorem quadrupole_den : chi - 1 = 5 := by native_decide

-- §9 Crystal invariants
theorem chi_val : chi = 6 := by native_decide
theorem beta0_val : beta0 = 7 := by native_decide
theorem sigma_d_val : sigma_d = 36 := by native_decide
theorem sigma_d2_val : sigma_d2 = 650 := by native_decide
theorem gauss_val : gauss = 13 := by native_decide
theorem tower_val : tower_d = 42 := by native_decide

-- §10 Sector dimensions
theorem d_colour : N_c ^ 2 - 1 = 8 := by native_decide
theorem d_weak : N_c = 3 := by native_decide
theorem d_mixed : N_w ^ 3 * N_c = 24 := by native_decide
theorem d_total_check : 1 + 3 + 8 + 24 = sigma_d := by native_decide
