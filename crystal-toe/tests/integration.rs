// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// tests/integration.rs — End-to-end physics regression tests
//
// These test PHYSICS, not just integers. If a formula changes,
// these catch it. Run: cargo test --test integration

use crystal_toe::*;
use crystal_toe::{gauge, qcd, cosmo, mixing, alpha_proton, gravity, protein};
use crystal_toe::monad::{AlgebraState, Monad};
use crystal_toe::tower;
use crystal_toe::hierarchy;

// ═══════════════════════════════════════════════════════════════════
// PDG COMPARISON (Crystal default vs known values)
// ═══════════════════════════════════════════════════════════════════

fn pdg_check(name: &str, crystal: f64, pdg: f64, tolerance_pct: f64) {
    let pwi = (crystal - pdg).abs() / pdg * 100.0;
    assert!(pwi < tolerance_pct,
        "{name}: crystal={crystal:.6}, pdg={pdg:.6}, PWI={pwi:.3}% (limit {tolerance_pct}%)");
}

#[test]
fn pdg_alpha_inv() {
    pdg_check("α⁻¹", Toe::new().alpha_inv(), 137.036, 0.01);
}

#[test]
fn pdg_sin2_theta_w() {
    pdg_check("sin²θ_W", Toe::new().sin2_theta_w(), 0.23122, 0.5);
}

#[test]
fn pdg_proton_mass() {
    let pdg = Toe::new().to_pdg();
    pdg_check("m_p (GeV)", pdg.proton_mass(), 0.93827, 1.0);
}

#[test]
fn pdg_z_mass() {
    let pdg = Toe::new().to_pdg();
    pdg_check("M_Z (GeV)", pdg.z_mass(), 91.1876, 1.5);
}

#[test]
fn pdg_top_mass() {
    let pdg = Toe::new().to_pdg();
    pdg_check("m_t (GeV)", qcd::top_mass(&pdg), 173.0, 1.0);
}

#[test]
fn pdg_mp_me_ratio() {
    pdg_check("m_p/m_e", qcd::mp_me_ratio(), 1836.153, 0.05);
}

#[test]
fn pdg_mu_e_ratio() {
    pdg_check("m_μ/m_e", gauge::mu_e_ratio(), 206.768, 1.0);
}

#[test]
fn pdg_omega_lambda() {
    pdg_check("Ω_Λ", cosmo::omega_lambda(), 0.685, 1.0);
}

#[test]
fn pdg_spectral_index() {
    pdg_check("n_s", cosmo::spectral_index(), 0.965, 1.5);
}

#[test]
fn pdg_proton_radius() {
    pdg_check("r_p (fm)", alpha_proton::proton_radius(), 0.8409, 0.5);
}

// ═══════════════════════════════════════════════════════════════════
// CONVERSION FACTOR CONSISTENCY
// ═══════════════════════════════════════════════════════════════════

#[test]
fn conversion_round_trip() {
    let crystal = Toe::new();
    let pdg = crystal.to_pdg();
    let factor = crystal_toe::vev::conversion_factor();

    // Every VEV-dependent quantity scales by factor
    let ratio_mp = pdg.proton_mass() / crystal.proton_mass();
    let ratio_me = pdg.electron_mass() / crystal.electron_mass();
    let ratio_mz = pdg.z_mass() / crystal.z_mass();

    assert!((ratio_mp - factor).abs() < 1e-12, "proton mass ratio");
    assert!((ratio_me - factor).abs() < 1e-12, "electron mass ratio");
    assert!((ratio_mz - factor).abs() < 1e-12, "Z mass ratio");
}

#[test]
fn dimensionless_invariant() {
    let a = Toe::new();
    let b = Toe::with_vev(300.0);

    assert_eq!(a.alpha_inv(), b.alpha_inv());
    assert_eq!(a.sin2_theta_w(), b.sin2_theta_w());
    assert_eq!(a.kappa(), b.kappa());
    assert_eq!(a.c_f(), b.c_f());
    assert!((a.mp_me_ratio() - b.mp_me_ratio()).abs() < 1e-10);
}

// ═══════════════════════════════════════════════════════════════════
// CROSS-MODULE RATIO CONSISTENCY
// ═══════════════════════════════════════════════════════════════════

#[test]
fn ratio_2_5_everywhere() {
    let flory = crystal_toe::dynamics::bio::flory_nu();
    let i_sphere = crystal_toe::dynamics::rigid::i_sphere_factor();
    assert!((flory - i_sphere).abs() < 1e-15, "Flory = I_sphere = 2/5");
    assert!((flory - 0.4).abs() < 1e-15);
}

#[test]
fn ratio_4_is_n_w_squared() {
    assert_eq!(crystal_toe::dynamics::qft::SPACETIME_DIM, N_W * N_W);
    assert_eq!(crystal_toe::dynamics::rigid::QUAT_COMPONENTS, N_W * N_W);
    assert_eq!(crystal_toe::dynamics::qinfo::BELL_STATES, N_W * N_W);
    assert_eq!(crystal_toe::dynamics::bio::DNA_BASES, N_W * N_W);
    assert_eq!(crystal_toe::dynamics::condensed::ISING_Z_SQUARE, N_W * N_W);
    assert_eq!(crystal_toe::dynamics::astro::EDDINGTON, N_W * N_W);
}

#[test]
fn ratio_8_is_d_colour() {
    assert_eq!(crystal_toe::dynamics::qft::GLUON_COLOURS, D_COLOUR);
    assert_eq!(crystal_toe::dynamics::plasma::MHD_STATES, D_COLOUR);
    assert_eq!(crystal_toe::dynamics::arcade::OCTREE_CHILDREN, D_COLOUR);
    assert_eq!(crystal_toe::dynamics::nbody::OCTREE_CHILDREN, D_COLOUR);
    assert_eq!(crystal_toe::dynamics::astro::HAWKING, D_COLOUR);
}

#[test]
fn ratio_7_is_beta0() {
    assert_eq!(crystal_toe::dynamics::qft::QCD_BETA0, BETA0);
    assert_eq!(crystal_toe::dynamics::chem::NEUTRAL_PH, BETA0);
    assert_eq!(crystal_toe::dynamics::qinfo::STEANE_N, BETA0);
    assert_eq!(crystal_toe::dynamics::nuclear::IRON_PEAK_A, D_COLOUR * BETA0);
}

#[test]
fn magic_numbers_from_two_primes() {
    let m = crystal_toe::dynamics::nuclear::magic_numbers();
    assert_eq!(m[0], N_W);
    assert_eq!(m[1], N_W * N_W * N_W);
    assert_eq!(m[2], N_W * N_W * (CHI - 1));
    assert_eq!(m[3], N_W * N_W * BETA0);
    assert_eq!(m[4], N_W * (CHI - 1) * (CHI - 1));
    assert_eq!(m[5], N_W * (TOWER_D - 1));
    assert_eq!(m[6], N_W * BETA0 * N_C * N_C);
}

// ═══════════════════════════════════════════════════════════════════
// MONAD PHYSICS
// ═══════════════════════════════════════════════════════════════════

#[test]
fn hierarchy_from_monad() {
    let s = AlgebraState::at_tick(TOWER_D);
    // Singlet survives
    assert!((s.amplitudes[0] - 1.0).abs() < 1e-15);
    // Mixed suppressed by (1/6)^42
    assert!(s.amplitudes[3] < 1e-30);
    // Hierarchy ratio
    let ratio = s.amplitudes[0] / s.amplitudes[3];
    assert!(ratio > 1e30, "hierarchy > 10^30");
}

#[test]
fn tower_alpha_monotone() {
    let t = tower::spectral_tower();
    for i in 1..t.len() {
        assert!(t[i].alpha_inv > t[i-1].alpha_inv,
            "α⁻¹ must increase with depth");
    }
}

#[test]
fn entropy_decreases_with_ticks() {
    let s0 = AlgebraState::at_tick(0).entropy();
    let s10 = AlgebraState::at_tick(10).entropy();
    let s42 = AlgebraState::at_tick(42).entropy();
    assert!(s0 > s10, "entropy decreases");
    assert!(s10 > s42, "entropy still decreasing");
}

// ═══════════════════════════════════════════════════════════════════
// HIERARCHY IMPLOSION
// ═══════════════════════════════════════════════════════════════════

#[test]
fn implosion_corrections_are_small() {
    let channels = hierarchy::implosion_channels();
    for ch in &channels {
        let c = ch.correction.value().abs();
        assert!(c < 0.15, "{} correction {c} too large", ch.name);
    }
}

#[test]
fn cosmo_partition_exact() {
    let c = hierarchy::CosmoPartition::new();
    assert!(c.verify_sum());
    // Ω_Λ + Ω_cdm + Ω_b = 1 exactly (integer arithmetic)
    let sum = (TOWER_D - GAUSS) + (GAUSS - N_W) + N_W;
    assert_eq!(sum, TOWER_D);
}

// ═══════════════════════════════════════════════════════════════════
// PROTEIN FORCE FIELD
// ═══════════════════════════════════════════════════════════════════

#[test]
fn energy_ordering() {
    let toe = Toe::new();
    let vdw = protein::eps_vdw(&toe);
    let hbond = protein::e_hbond(&toe);
    let burial = protein::e_burial(&toe);
    // VdW < H-bond < burial
    assert!(vdw < hbond, "VdW < H-bond");
    assert!(hbond < burial, "H-bond < burial");
}

#[test]
fn molecular_angles_from_algebra() {
    let sp3 = protein::sp3_angle().to_degrees();
    let water = protein::water_angle().to_degrees();
    let sp2 = protein::sp2_angle().to_degrees();
    assert!((sp3 - 109.47).abs() < 0.01);
    assert!((water - 104.48).abs() < 0.01);
    assert!((sp2 - 120.0).abs() < 1e-10);
    assert!(water < sp3, "water angle < sp3 (lone pair compression)");
}

// ═══════════════════════════════════════════════════════════════════
// DYNAMICS PHYSICS
// ═══════════════════════════════════════════════════════════════════

#[test]
fn lane_emden_wd_and_chandrasekhar() {
    let (xi_wd, _) = crystal_toe::dynamics::astro::lane_emden(1.5);
    let (xi_ch, mass_ch) = crystal_toe::dynamics::astro::lane_emden(3.0);
    assert!((xi_wd - 3.654).abs() < 0.01, "WD surface");
    assert!((xi_ch - 6.897).abs() < 0.01, "Chandrasekhar surface");
    assert!((mass_ch - 2.018).abs() < 0.01, "Chandrasekhar mass param");
}

#[test]
fn thomson_cross_section() {
    let sigma = crystal_toe::dynamics::qft::thomson_cs();
    assert!((sigma - 0.6652).abs() < 0.01, "Thomson = 0.665 barn");
}

#[test]
fn onsager_tc() {
    let tc = crystal_toe::dynamics::condensed::onsager_tc();
    assert!((tc - 2.269).abs() < 0.001, "Onsager T_c");
}

#[test]
fn genetic_code_arithmetic() {
    use crystal_toe::dynamics::bio::*;
    assert_eq!(TOTAL_CODONS, (DNA_BASES as u64).pow(CODON_LEN as u32));
    assert_eq!(AMINO_ACIDS + STOP_CODONS + (TOTAL_CODONS - AMINO_ACIDS - STOP_CODONS),
               TOTAL_CODONS);
    // Redundancy ≈ N_c
    let r = codon_redundancy();
    assert!((r - N_C as f64).abs() < 0.1);
}

#[test]
fn iron_is_where_stars_die() {
    use crystal_toe::dynamics::nuclear::*;
    let bfe = binding_per_nucleon(56, 26);
    // Fe-56 has highest B/A of any nucleus near it
    for a in 50..62 {
        let b = binding_per_nucleon(a, a/2);
        assert!(bfe >= b - 0.1, "Fe-56 should be near peak at A={a}");
    }
}
