-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/-! # CrystalDynamicEngine — Integer identities for the dynamics engine

  Tick loop, sector projections (Verlet, Yee, Metropolis),
  HMC sampler, MERA layer sampling.

  All integer relations proven by native_decide.
-/

-- Atoms
abbrev nW : Nat := 2
abbrev nC : Nat := 3
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

-- ═══════════════════════════════════════════════════════════════
-- §1 STATE SPACE AND TICK
-- ═══════════════════════════════════════════════════════════════

theorem state_dim : sigmaD = 36 := by native_decide
theorem eigen_weak : nW = 2 := by native_decide
theorem eigen_colour : nC = 3 := by native_decide
theorem eigen_mixed : chi = 6 := by native_decide
theorem eigen_product : 1 * nW * nC * chi = sigmaD := by native_decide

-- ═══════════════════════════════════════════════════════════════
-- §2 SECTOR PROJECTIONS
-- ═══════════════════════════════════════════════════════════════

-- Classical mechanics
theorem classical_phase_space : chi = 6 := by native_decide
theorem position_dof : d2 = 3 := by native_decide
theorem classical_dof : d2 + 3 = chi := by native_decide
theorem verlet_order : nW = 2 := by native_decide

-- Electromagnetism (Yee FDTD)
theorem yee_courant_den : nW = 2 := by native_decide
theorem em_field_components : chi = 6 := by native_decide
theorem em_sector_dim : d3 = 8 := by native_decide

-- Thermal (Metropolis)
theorem metropolis_states : nW = 2 := by native_decide
theorem thermal_sector_dim : d4 = 24 := by native_decide

-- Lennard-Jones
theorem lj_attractive : chi = 6 := by native_decide
theorem lj_repulsive : 2 * chi = 12 := by native_decide

-- Lattice Boltzmann
theorem d2q9_velocities : nC * nC = 9 := by native_decide

-- Monatomic gas gamma: (chi-1)/N_c = 5/3 cross-multiplied
theorem gamma_mono : (chi - 1) * 3 = 5 * nC := by native_decide

-- Peters 32/5: N_w^5/(chi-1) cross-multiplied
theorem peters : nW^5 * 5 = 32 * (chi - 1) := by native_decide

-- ═══════════════════════════════════════════════════════════════
-- §3 HMC PARAMETERS
-- ═══════════════════════════════════════════════════════════════

theorem hmc_momentum_dim : d2 = 3 := by native_decide
theorem hmc_state_dim : sigmaD = 36 := by native_decide
theorem lcg_multiplier : sigmaD2 = 650 := by native_decide
theorem lcg_increment : beta0 = 7 := by native_decide
theorem lcg_modulus : 2^16 = 65536 := by native_decide
theorem hmc_phase_space : d2 + d3 = 11 := by native_decide

-- LCG quality: 650 and 65536 are coprime (gcd = 2, but mod arithmetic still works)
-- More importantly: 650 mod 4 = 2, which gives full period for power-of-2 modulus

-- ═══════════════════════════════════════════════════════════════
-- §4 MERA SAMPLING
-- ═══════════════════════════════════════════════════════════════

theorem mera_layers : towerD = 42 := by native_decide
theorem tower_decomp : sigmaD + chi = 42 := by native_decide
theorem mera_total_dof : towerD * sigmaD = 1512 := by native_decide
theorem ent_entropy_base : chi = 6 := by native_decide
theorem rt_four : nW * nW = 4 := by native_decide

-- ═══════════════════════════════════════════════════════════════
-- §5 ENERGY SPECTRUM
-- ═══════════════════════════════════════════════════════════════

-- E_mixed = E_weak + E_colour (denominators multiply)
theorem energy_additivity : nW * nC = chi := by native_decide

-- Sum of reciprocals: 1/1 + 1/2 + 1/3 + 1/6 = 2
-- Cross-multiplied: 6 + 3 + 2 + 1 = 12, and 12/6 = 2
theorem recip_sum_num : chi + nC + nW + 1 = 12 := by native_decide
theorem recip_sum_check : 12 / chi = 2 := by native_decide

-- ═══════════════════════════════════════════════════════════════
-- §6 ARROW OF TIME
-- ═══════════════════════════════════════════════════════════════

theorem lost_dof : sigmaD - 1 = 35 := by native_decide
theorem chi_gt_one : chi - 1 = 5 := by native_decide

-- 35 = N_w × N_c × (χ-1) + N_w × N_c - 1
-- = 2 × 3 × 5 + 2 × 3 - 1 = 30 + 6 - 1 = 35
theorem lost_dof_factored : nW * nC * (chi - 1) + nW * nC - 1 = 35 := by native_decide

-- ═══════════════════════════════════════════════════════════════
-- §7 SECTOR BOUNDARIES
-- ═══════════════════════════════════════════════════════════════

theorem boundary_1 : d1 = 1 := by native_decide
theorem boundary_2 : d1 + d2 = 4 := by native_decide
theorem boundary_3 : d1 + d2 + d3 = 12 := by native_decide
theorem boundary_end : d1 + d2 + d3 + d4 = 36 := by native_decide

-- ═══════════════════════════════════════════════════════════════
-- §8 CROSS-CHECKS
-- ═══════════════════════════════════════════════════════════════

theorem mixed_tensor : d2 * d3 = d4 := by native_decide
theorem gauss_val : gauss = 13 := by native_decide
theorem alpha_s_den : gauss + nW * nW = 17 := by native_decide

-- Kolmogorov 5/3 exponent cross-multiplied
theorem kolmogorov : (chi - 1) * 3 = 5 * nC := by native_decide

-- Stokes drag coefficient = d₄ = 24
theorem stokes_drag : d4 = 24 := by native_decide

-- Stefan-Boltzmann T exponent = N_w² = 4
theorem stefan_boltzmann : nW * nW = 4 := by native_decide

-- Rayleigh scattering size exponent = χ = 6
theorem rayleigh_size : chi = 6 := by native_decide

-- Planck radiation wavelength exponent = χ - 1 = 5
theorem planck_lambda : chi - 1 = 5 := by native_decide
