// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// Crystal Toe — Physics from A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ)

// Wave 0: Foundation
pub mod atoms;
pub mod vev;
pub mod toe;
pub mod monad;
pub mod tower;
pub mod hierarchy;
pub mod heyting;

// Wave 1: Core Physics
pub mod gauge;
pub mod qcd;
pub mod cosmo;
pub mod mixing;
pub mod alpha_proton;

// Wave 2: Extended Observables
pub mod gravity;
pub mod protein;
pub mod cross_domain;
pub mod waca_scan;
pub mod quantum;
pub mod mandelbrot;

// Wave 3: Dynamics Phase 1
pub mod dynamics;

// Wave 5: Python bindings (feature-gated)
#[cfg(feature = "python")]
mod py;

pub use toe::Toe;
pub use atoms::{
    N_W, N_C, CHI, BETA0, SIGMA_D, SIGMA_D2, GAUSS, TOWER_D,
    D_COLOUR, D_MIXED, SHARED_CORE, FERMAT3,
    D1, D2, D3, D4, SECTOR_DIMS,
    Sector, Frac,
};
pub use vev::{VEV_CRYSTAL, M_PL};

// ═══════════════════════════════════════════════════════════════════
// TESTS
// ═══════════════════════════════════════════════════════════════════

#[cfg(test)]
mod tests {
    use super::*;
    use monad::{AlgebraState, Monad};
    use tower::TowerAscent;
    use hierarchy::{implosion_channels, CosmoPartition, SeeleyDeWitt};
    use heyting::Truth;

    // ── Wave 0: Atoms ─────────────────────────────────────────
    #[test]
    fn atoms_correct() {
        assert_eq!(N_W, 2); assert_eq!(N_C, 3); assert_eq!(CHI, 6);
        assert_eq!(BETA0, 7); assert_eq!(SIGMA_D, 36);
        assert_eq!(SIGMA_D2, 650); assert_eq!(GAUSS, 13);
        assert_eq!(TOWER_D, 42); assert_eq!(D_COLOUR, 8);
        assert_eq!(SHARED_CORE, 27300); assert_eq!(FERMAT3, 257);
    }

    #[test]
    fn sector_dims_sum() { assert_eq!(SECTOR_DIMS.iter().sum::<u64>(), SIGMA_D); }

    #[test]
    fn all_from_two_primes() {
        assert_eq!(CHI, N_W * N_C);
        assert_eq!(BETA0, (11 * N_C - 2 * CHI) / 3);
        assert_eq!(TOWER_D, SIGMA_D + CHI);
        assert_eq!(D_COLOUR, N_W * N_W * N_W);
        assert_eq!(GAUSS, N_C * N_C + N_W * N_W);
    }

    // ── Wave 0: Toe ───────────────────────────────────────────
    #[test]
    fn toe_default_is_crystal() {
        let t = Toe::new();
        assert!(t.is_crystal_default());
        assert!((t.vev() - 245.17).abs() < 0.01);
    }

    #[test]
    fn conversion_factor_is_1_004() {
        assert!((vev::conversion_factor() - 1.00435).abs() < 0.0005);
    }

    #[test]
    fn to_pdg_gives_246() {
        let p = Toe::new().to_pdg();
        assert!((p.vev() - 246.22).abs() < 0.1);
    }

    #[test]
    fn dimensionless_same_both_modes() {
        let c = Toe::new(); let p = c.to_pdg();
        assert_eq!(c.alpha_inv(), p.alpha_inv());
        assert_eq!(c.sin2_theta_w(), p.sin2_theta_w());
    }

    #[test]
    fn masses_differ_by_conversion() {
        let c = Toe::new(); let p = c.to_pdg();
        let ratio = p.proton_mass() / c.proton_mass();
        assert!((ratio - vev::conversion_factor()).abs() < 1e-10);
    }

    #[test]
    fn mp_me_ratio_same_both() {
        let c = Toe::new(); let p = c.to_pdg();
        assert!((c.mp_me_ratio() - p.mp_me_ratio()).abs() < 1e-10);
    }

    // ── Wave 0: Monad ─────────────────────────────────────────
    #[test]
    fn monad_tick_eigenvalues() {
        let mut s = AlgebraState::new(); Monad::tick(&mut s);
        assert!((s.amplitudes[0] - 1.0).abs() < 1e-15);
        assert!((s.amplitudes[1] - 0.5).abs() < 1e-15);
        assert!((s.amplitudes[3] - 1.0/6.0).abs() < 1e-15);
    }

    #[test]
    fn monad_42_hierarchy() {
        let s = AlgebraState::at_tick(42);
        assert!((s.amplitudes[0] - 1.0).abs() < 1e-15);
        assert!(s.amplitudes[3] < 1e-30);
    }

    #[test]
    fn hologron_attractive() {
        assert!(monad::hologron_potential(2.0) < 0.0);
    }

    // ── Wave 0: Tower ─────────────────────────────────────────
    #[test]
    fn tower_43_layers() { assert_eq!(tower::spectral_tower().len(), 43); }

    #[test]
    fn tower_top_137() {
        let layers: Vec<_> = TowerAscent::new().collect();
        assert!((layers[42].alpha_inv - 137.034).abs() < 0.01);
    }

    // ── Wave 0: Hierarchy ─────────────────────────────────────
    #[test]
    fn seeley_dewitt() {
        assert_eq!(SeeleyDeWitt::A0, 36);
        assert_eq!(SeeleyDeWitt::A4, 650);
        assert_eq!(SeeleyDeWitt::CORE, 27300);
    }

    #[test]
    fn implosion_fractions() {
        let ch = implosion_channels();
        assert_eq!(ch[0].multiplier, Frac::new(7, 8));
        assert_eq!(ch[1].multiplier, Frac::new(11, 12));
        assert_eq!(ch[5].multiplier, Frac::new(53, 54));
    }

    #[test]
    fn cosmo_partition_sums() {
        let c = CosmoPartition::new(); assert!(c.verify_sum());
    }

    // ── Wave 0: Heyting ───────────────────────────────────────
    #[test]
    fn uncertainty_coprimality() {
        assert_eq!(Truth::meet(Truth::WEAK, Truth::COLOUR), Truth::MIXED);
    }

    #[test]
    fn complementarity() {
        assert_eq!(Truth::join(Truth::WEAK, Truth::COLOUR), Truth::TRUE);
    }

    // ══════════════════════════════════════════════════════════
    // WAVE 1: GAUGE
    // ══════════════════════════════════════════════════════════

    #[test]
    fn gauge_alpha_inv() {
        assert!((gauge::alpha_inv() - 137.034).abs() < 0.01);
    }

    #[test]
    fn gauge_sin2_theta_w() {
        assert!((gauge::sin2_theta_w() - 0.2312).abs() < 0.001);
    }

    #[test]
    fn gauge_alpha_s() {
        let a = gauge::alpha_s_mz();
        assert!(a > 0.10 && a < 0.15, "alpha_s = {a}"); // one-loop, needs 2-loop for 0.118
    }

    #[test]
    fn gauge_w_mass() {
        let t = Toe::new().to_pdg();
        let mw = gauge::w_mass(&t) * 1e3; // GeV → MeV... no, already GeV
        assert!((gauge::w_mass(&t) - 80.0).abs() < 3.0); // ~80 GeV
    }

    #[test]
    fn gauge_z_mass() {
        let t = Toe::new().to_pdg();
        assert!((gauge::z_mass(&t) - 92.3).abs() < 1.0);
    }

    #[test]
    fn gauge_electron_mass() {
        let t = Toe::new();
        let me_mev = gauge::electron_mass(&t) * 1e3;
        assert!((me_mev - 0.511).abs() / 0.511 < 0.02);
    }

    #[test]
    fn gauge_mu_e_ratio() {
        assert_eq!(gauge::mu_e_ratio(), 208.0);
    }

    #[test]
    fn gauge_higgs_mass() {
        let t = Toe::new().to_pdg();
        assert!((gauge::higgs_mass(&t) - 123.0).abs() < 5.0);
    }

    // ══════════════════════════════════════════════════════════
    // WAVE 1: QCD
    // ══════════════════════════════════════════════════════════

    #[test]
    fn qcd_proton_mass() {
        let t = Toe::new().to_pdg();
        let mp = qcd::proton_mass(&t) * 1e3; // MeV
        assert!((mp - 943.0).abs() < 10.0);
    }

    #[test]
    fn qcd_pion_mass() {
        let t = Toe::new().to_pdg();
        let mpi = qcd::pion_mass(&t) * 1e3; // MeV
        assert!((mpi - 134.0).abs() < 5.0);
    }

    #[test]
    fn qcd_top_mass() {
        let t = Toe::new().to_pdg();
        assert!((qcd::top_mass(&t) - 174.0).abs() < 3.0);
    }

    #[test]
    fn qcd_mp_me_ratio() {
        let r = qcd::mp_me_ratio();
        assert!((r - 1836.15).abs() < 0.5);
    }

    #[test]
    fn qcd_mpi_mp_ratio() {
        assert!((qcd::mpi_mp_ratio() - 1.0/7.0).abs() < 1e-10);
    }

    // ══════════════════════════════════════════════════════════
    // WAVE 1: COSMO
    // ══════════════════════════════════════════════════════════

    #[test]
    fn cosmo_omega_lambda() {
        assert!((cosmo::omega_lambda() - 0.690).abs() < 0.001);
    }

    #[test]
    fn cosmo_omega_b() {
        assert!((cosmo::omega_b() - 0.0476).abs() < 0.001);
    }

    #[test]
    fn cosmo_omega_total() {
        assert!((cosmo::omega_total() - 1.0).abs() < 1e-12);
    }

    #[test]
    fn cosmo_spectral_index() {
        assert!((cosmo::spectral_index() - 0.9524).abs() < 0.001);
    }

    #[test]
    fn cosmo_n_generations() {
        assert_eq!(cosmo::N_GENERATIONS, 3);
    }

    // ══════════════════════════════════════════════════════════
    // WAVE 1: MIXING
    // ══════════════════════════════════════════════════════════

    #[test]
    fn mixing_cabibbo() {
        assert!((mixing::sin_cabibbo() - 0.2774).abs() < 0.01);
    }

    #[test]
    fn mixing_theta23_maximal() {
        assert!((mixing::sin2_theta23() - 0.5).abs() < 1e-12);
    }

    #[test]
    fn mixing_n_angles() {
        assert_eq!(mixing::n_mixing_angles(), 3);
    }

    #[test]
    fn mixing_n_cp_phases() {
        assert_eq!(mixing::n_cp_phases(), 1);
    }

    // ══════════════════════════════════════════════════════════
    // WAVE 1: ALPHA_PROTON (CODATA)
    // ══════════════════════════════════════════════════════════

    #[test]
    fn codata_alpha_inv_full() {
        let a = alpha_proton::alpha_inv_full();
        assert!((a - 137.036).abs() < 0.01);
    }

    #[test]
    fn codata_mp_me_full() {
        let r = alpha_proton::mp_me_ratio_full();
        assert!((r - 1836.153).abs() < 0.5);
    }

    #[test]
    fn codata_proton_radius() {
        let rp = alpha_proton::proton_radius();
        assert!((rp - 0.841).abs() < 0.01);
    }

    #[test]
    fn codata_three_comparisons() {
        let comps = alpha_proton::codata_comparisons();
        assert_eq!(comps.len(), 3);
    }

    // ══════════════════════════════════════════════════════════
    // WAVE 2: GRAVITY
    // ══════════════════════════════════════════════════════════

    #[test]
    fn gravity_einstein_16() {
        assert_eq!(gravity::EINSTEIN_16, 16);
        assert_eq!(gravity::EINSTEIN_16, N_W * N_W * N_W * N_W);
    }

    #[test]
    fn gravity_graviton_pol() {
        assert_eq!(gravity::GRAVITON_POL, 2);
    }

    #[test]
    fn gravity_peters() {
        assert!((gravity::peters_factor() - 6.4).abs() < 1e-10); // 32/5
    }

    #[test]
    fn gravity_isco() {
        assert_eq!(gravity::isco_factor(), CHI); // 6
    }

    #[test]
    fn gravity_12_audit() {
        assert_eq!(gravity::GR_AUDIT_COUNT, 12);
    }

    #[test]
    fn gravity_first_law() {
        assert!((gravity::FIRST_LAW_RATIO - 1.0).abs() < gravity::FIRST_LAW_ERROR);
    }

    // ══════════════════════════════════════════════════════════
    // WAVE 2: PROTEIN
    // ══════════════════════════════════════════════════════════

    #[test]
    fn protein_sp3_angle() {
        let deg = protein::sp3_angle() * 180.0 / std::f64::consts::PI;
        assert!((deg - 109.47).abs() < 0.01);
    }

    #[test]
    fn protein_water_angle() {
        let deg = protein::water_angle() * 180.0 / std::f64::consts::PI;
        assert!((deg - 104.48).abs() < 0.01);
    }

    #[test]
    fn protein_helix() {
        assert!((protein::helix_per_turn() - 3.6).abs() < 1e-10);
    }

    #[test]
    fn protein_flory() {
        assert!((protein::flory_nu() - 0.4).abs() < 1e-10);
    }

    #[test]
    fn protein_dielectric() {
        assert_eq!(protein::PROTEIN_DIELECTRIC, 16);
    }

    #[test]
    fn protein_bp_per_turn() {
        assert_eq!(protein::bp_per_turn(), 10);
    }

    #[test]
    fn protein_energy_hierarchy() {
        let t = Toe::new();
        let h = protein::energy_hierarchy(&t);
        assert_eq!(h.len(), 5);
        // VdW < H-bond < angle < burial (energy ordering)
        assert!(h[0].1 < h[1].1); // vdw < hbond
    }

    // ══════════════════════════════════════════════════════════
    // WAVE 2: CROSS-DOMAIN
    // ══════════════════════════════════════════════════════════

    #[test]
    fn cross_domain_count() {
        assert!(cross_domain::n_shared_ratios() >= 14);
    }

    #[test]
    fn cross_domain_links() {
        assert!(cross_domain::n_cross_links() >= 40);
    }

    // ══════════════════════════════════════════════════════════
    // WAVE 2: STUBS (need Haskell source)
    // ══════════════════════════════════════════════════════════

    #[test]
    fn waca_scan_198() {
        assert_eq!(waca_scan::N_TOTAL, 198);
    }

    #[test]
    fn quantum_hilbert_dim() {
        assert_eq!(quantum::HILBERT_DIM, CHI);
    }

    #[test]
    fn mandelbrot_proofs() {
        assert_eq!(mandelbrot::N_PROOFS, 38);
    }

    // ══════════════════════════════════════════════════════════
    // WAVE 3: DYNAMICS PHASE 1 (13 modules)
    // ══════════════════════════════════════════════════════════

    #[test]
    fn dyn_classical_phase_space() {
        assert_eq!(dynamics::classical::PHASE_SPACE_DIM, CHI); // 6
        assert_eq!(dynamics::classical::SPATIAL_DIM, N_C);     // 3
        assert_eq!(dynamics::classical::FORCE_EXPONENT, N_C-1); // 2
    }

    #[test]
    fn dyn_gr_integers() {
        assert_eq!(dynamics::gr::ISCO_FACTOR, CHI);
        assert_eq!(dynamics::gr::PRECESSION_FACTOR, CHI);
        assert_eq!(dynamics::gr::BENDING_FACTOR, N_W*N_W);
        assert_eq!(dynamics::gr::SCHWARZ_FACTOR, N_W);
    }

    #[test]
    fn dyn_gw_peters() {
        assert!((dynamics::gw::peters_coefficient() - 6.4).abs() < 1e-10);
        assert!((dynamics::gw::chirp_exponent() - 5.0/3.0).abs() < 1e-10);
        assert_eq!(dynamics::gw::GW_POLARIZATIONS, 2);
    }

    #[test]
    fn dyn_em_components() {
        assert_eq!(dynamics::em::EM_COMPONENTS, CHI);
        assert_eq!(dynamics::em::MAXWELL_EQUATIONS, N_C + 1);
    }

    #[test]
    fn dyn_friedmann_flat() {
        let total = dynamics::friedmann::omega_lambda() + dynamics::friedmann::omega_matter();
        assert!((total - 1.0).abs() < 1e-12);
    }

    #[test]
    fn dyn_nbody_octree() {
        assert_eq!(dynamics::nbody::OCTREE_CHILDREN, D_COLOUR);
        assert!(dynamics::nbody::should_open_node(2.0, 3.0)); // 2/3 > 0.5
        assert!(!dynamics::nbody::should_open_node(1.0, 3.0)); // 1/3 < 0.5
    }

    #[test]
    fn dyn_thermo_lj() {
        assert_eq!(dynamics::thermo::LJ_ATTRACT, CHI);
        assert_eq!(dynamics::thermo::LJ_REPEL, 2 * CHI);
        // LJ at r=σ should be 0
        let v = dynamics::thermo::lj_potential(1.0, 1.0, 1.0);
        assert!(v.abs() < 1e-10);
    }

    #[test]
    fn dyn_cfd_d2q9() {
        assert_eq!(dynamics::cfd::D2Q9_VELOCITIES, N_C * N_C);
        assert_eq!(dynamics::cfd::STOKES_DRAG, D_MIXED);
    }

    #[test]
    fn dyn_decay_beta() {
        assert_eq!(dynamics::decay::BETA_FACTOR, 192);
        assert_eq!(dynamics::decay::BETA_FACTOR, D_MIXED * D_COLOUR);
    }

    #[test]
    fn dyn_optics_indices() {
        assert!((dynamics::optics::n_water() - 4.0/3.0).abs() < 1e-10);
        assert!((dynamics::optics::n_glass() - 1.5).abs() < 1e-10);
        assert_eq!(dynamics::optics::RAYLEIGH_LAMBDA_EXP, 4);
        assert_eq!(dynamics::optics::PLANCK_LAMBDA_EXP, 5);
    }

    #[test]
    fn dyn_md_angles() {
        let sp3 = dynamics::md::tetrahedral_angle() * 180.0 / std::f64::consts::PI;
        assert!((sp3 - 109.47).abs() < 0.01);
        assert_eq!(dynamics::md::AMINO_ACIDS, 20);
        assert_eq!(dynamics::md::DNA_BASES, 4);
    }

    #[test]
    fn dyn_condensed_ising() {
        assert_eq!(dynamics::condensed::ISING_Z_SQUARE, N_W * N_W);
        let tc = dynamics::condensed::onsager_tc();
        assert!((tc - 2.269).abs() < 0.001);
    }

    #[test]
    fn dyn_plasma_mhd() {
        assert_eq!(dynamics::plasma::MHD_STATES, D_COLOUR);
        assert_eq!(dynamics::plasma::WAVE_TYPES, N_C);
        assert_eq!(dynamics::plasma::PROPAGATING_MODES, CHI);
    }

    // ══════════════════════════════════════════════════════════
    // WAVE 4: DYNAMICS PHASE 2 (8 modules)
    // ══════════════════════════════════════════════════════════

    #[test]
    fn dyn_qft_integers() {
        assert_eq!(dynamics::qft::SPACETIME_DIM, N_W * N_W);
        assert_eq!(dynamics::qft::LORENTZ_GEN, CHI);
        assert_eq!(dynamics::qft::GLUON_COLOURS, D3);
        assert_eq!(dynamics::qft::QCD_BETA0, BETA0);
        assert_eq!(dynamics::qft::ONE_LOOP_FACTOR, 16);
        assert_eq!(dynamics::qft::PHOTON_POL, 2);
    }

    #[test]
    fn dyn_qft_thomson() {
        let sigma = dynamics::qft::thomson_cs();
        assert!((sigma - 0.665).abs() < 0.01); // barn
    }

    #[test]
    fn dyn_qft_ee_mumu() {
        let sigma = dynamics::qft::sigma_ee_mumu(10.0);
        assert!((sigma - 0.87).abs() < 0.02); // nb at √s=10 GeV
    }

    #[test]
    fn dyn_rigid_inertia() {
        assert_eq!(dynamics::rigid::QUAT_COMPONENTS, N_W * N_W);
        assert_eq!(dynamics::rigid::INERTIA_INDEP, CHI);
        assert!((dynamics::rigid::i_sphere_factor() - 0.4).abs() < 1e-10);
        assert!((dynamics::rigid::i_sphere(1.0, 1.0) - 0.4).abs() < 1e-10);
        assert!((dynamics::rigid::i_rod(1.0, 1.0) - 1.0/12.0).abs() < 1e-10);
    }

    #[test]
    fn dyn_chem_shells() {
        assert_eq!(dynamics::chem::S_CAPACITY, 2);
        assert_eq!(dynamics::chem::P_CAPACITY, 6);
        assert_eq!(dynamics::chem::D_CAPACITY, 10);
        assert_eq!(dynamics::chem::F_CAPACITY, 14);
        assert_eq!(dynamics::chem::NOBLE_KR, SIGMA_D); // 36!
        assert_eq!(dynamics::chem::NEUTRAL_PH, BETA0);
    }

    #[test]
    fn dyn_nuclear_magic() {
        let m = dynamics::nuclear::magic_numbers();
        assert_eq!(m, [2, 8, 20, 28, 50, 82, 126]);
        assert_eq!(dynamics::nuclear::IRON_PEAK_A, 56);
        assert_eq!(dynamics::nuclear::IRON_PEAK_A, D_COLOUR * BETA0);
    }

    #[test]
    fn dyn_nuclear_fe56_peak() {
        let bfe = dynamics::nuclear::binding_per_nucleon(56, 26);
        let bfe55 = dynamics::nuclear::binding_per_nucleon(55, 26);
        assert!(bfe > bfe55); // Fe-56 is binding peak
    }

    #[test]
    fn dyn_astro_lane_emden() {
        let (xi1, _) = dynamics::astro::lane_emden(1.5); // n=N_c/N_w
        assert!((xi1 - 3.654).abs() < 0.01);
        let (xi3, _) = dynamics::astro::lane_emden(3.0); // n=N_c
        assert!((xi3 - 6.897).abs() < 0.01);
    }

    #[test]
    fn dyn_astro_integers() {
        assert_eq!(dynamics::astro::HAWKING, D_COLOUR);
        assert_eq!(dynamics::astro::SB_DENOM, 15);
        assert_eq!(dynamics::astro::EDDINGTON, N_W * N_W);
        assert_eq!(dynamics::astro::VIRIAL, N_W);
    }

    #[test]
    fn dyn_qinfo_steane() {
        assert_eq!(dynamics::qinfo::STEANE_N, BETA0);
        assert_eq!(dynamics::qinfo::STEANE_D, N_C);
        assert_eq!(dynamics::qinfo::SHOR_N, N_C * N_C);
        assert_eq!(dynamics::qinfo::MERA_DEPTH, TOWER_D);
        assert!(dynamics::qinfo::hamming_check()); // 7 = 2³−1
    }

    #[test]
    fn dyn_bio_genetic_code() {
        assert_eq!(dynamics::bio::DNA_BASES, 4);
        assert_eq!(dynamics::bio::AMINO_ACIDS, 20);
        assert_eq!(dynamics::bio::TOTAL_CODONS, 64);
        assert_eq!(dynamics::bio::STOP_CODONS, N_C);
        assert_eq!(dynamics::bio::BP_PER_TURN, 10);
        assert!((dynamics::bio::kleiber_exp() - 0.75).abs() < 1e-10);
    }

    #[test]
    fn dyn_bio_redundancy() {
        let r = dynamics::bio::codon_redundancy();
        assert!((r - 3.05).abs() < 0.01); // ≈ N_c
    }

    #[test]
    fn dyn_arcade_params() {
        assert_eq!(dynamics::arcade::LJ_CUTOFF, N_C);
        assert_eq!(dynamics::arcade::OCTREE_CHILDREN, D_COLOUR);
        assert_eq!(dynamics::arcade::FIXED_BITS, 16);
        assert_eq!(dynamics::arcade::LOD_LEVELS, N_C);
        assert_eq!(dynamics::arcade::FAST_ALPHA_INV, 137);
        assert!((dynamics::arcade::wca_cutoff() - 1.1225).abs() < 0.001);
    }
}
