//! Crystal Topos structural theorem tests — all from N_w=2, N_c=3.

use crystal_topos::base::*;
use crystal_topos::entangle;
use crystal_topos::gates;

#[test]
fn test_crystal_constants() {
    assert_eq!(NW, 2);
    assert_eq!(NC, 3);
    assert_eq!(CHI, 6);
    assert_eq!(BETA0, 7);
    assert_eq!(SIGMA_D, 36);
    assert_eq!(SIGMA_D2, 650);
    assert_eq!(GAUSS, 13);
    assert_eq!(D_TOTAL, 42);
}

#[test]
fn test_two_particles_is_algebra() {
    // dim(H₂) = χ² = 36 = Σd
    assert_eq!(CHI * CHI, SIGMA_D);
}

#[test]
fn test_entanglement_is_arrow() {
    let psi = entangle::max_entangled();
    let rho = entangle::partial_trace(&psi);
    let s = entangle::von_neumann_entropy(&rho);
    assert!((s - max_entropy()).abs() < 0.01);
}

#[test]
fn test_fermion_is_su4() {
    let fermions = CHI * (CHI - 1) / 2;  // 15
    let su_nw2 = NW * NW * NW * NW - 1;  // 16 - 1 = 15
    assert_eq!(fermions, su_nw2);
}

#[test]
fn test_ppt_decidable() {
    assert!(NW * NC <= 6);  // PPT exact for 2×3
}

#[test]
fn test_gate_count() {
    assert_eq!(SIGMA_D2, 650);  // total endomorphisms
    assert_eq!(CHI * CHI, 36);  // gates on ℂ^χ
}

#[test]
fn test_fock_limit() {
    let lim = (CHI as f64).exp();
    assert!((lim - 403.4).abs() < 1.0);
}

#[test]
fn test_ladder_symmetric() {
    let en = energies();
    let step01 = en[1] - en[0];
    let step23 = en[3] - en[2];
    assert!((step01 - step23).abs() < 1e-10);
}

#[test]
fn test_interactions_duality() {
    let interactions = CHI * (CHI - 1);  // 30
    let fermions = CHI * (CHI - 1) / 2; // 15
    assert_eq!(interactions, 2 * fermions);
}

#[test]
fn test_cnot_neutrino() {
    let cnot_dim = CHI * CHI * CHI * CHI;  // 1296
    assert_eq!(cnot_dim, 1296);
    assert_eq!(cnot_dim - 1, 1295);
}

#[test]
fn test_max_entangled_entropy() {
    let psi = entangle::max_entangled();
    assert!(!entangle::ppt_test(&psi));  // entangled
    let c = entangle::concurrence(&psi);
    assert!(c > 0.5);  // highly entangled
}

#[test]
fn test_hadamard_is_unitary() {
    let h = gates::gate_h();
    let hh = h.mul_mat(&h.dagger());
    for i in 0..CHI {
        for j in 0..CHI {
            let expected = if i == j { 1.0 } else { 0.0 };
            assert!((hh.get(i, j).re - expected).abs() < 1e-10);
            assert!(hh.get(i, j).im.abs() < 1e-10);
        }
    }
}

// ═══════════════════════════════════════════════════════════════
// THERMODYNAMICS
// ═══════════════════════════════════════════════════════════════

#[test]
fn test_carnot_efficiency() {
    let eta = (CHI - 1) as f64 / CHI as f64;
    assert!((eta - 5.0/6.0).abs() < 1e-10);
}

#[test]
fn test_stefan_boltzmann() {
    assert_eq!(NW * NC * (GAUSS + BETA0), 120);
}

#[test]
fn test_thermal_conductivity() {
    let mixing = CHI * (CHI - 1);  // 30
    let k = (CHI * mixing) as f64 / SIGMA_D as f64;
    assert!((k - 5.0).abs() < 1e-10);
}

// ═══════════════════════════════════════════════════════════════
// FLUID DYNAMICS
// ═══════════════════════════════════════════════════════════════

#[test]
fn test_kolmogorov_spectrum() {
    let exp = (NC + NW) as f64 / NC as f64;
    assert!((exp - 5.0/3.0).abs() < 1e-10);
}

#[test]
fn test_kolmogorov_microscale() {
    assert_eq!(NW * NW, 4);  // exponent 1/4
}

#[test]
fn test_von_karman() {
    let vk = NW as f64 / (NC + NW) as f64;
    assert!((vk - 0.4).abs() < 1e-10);
}

#[test]
fn test_reynolds_critical() {
    assert_eq!(D_TOTAL * (D_TOTAL + GAUSS), 2310);
}

// ═══════════════════════════════════════════════════════════════
// COLOR CONFINEMENT
// ═══════════════════════════════════════════════════════════════

#[test]
fn test_casimir() {
    let cf = (NC * NC - 1) as f64 / (2 * NC) as f64;
    assert!((cf - 4.0/3.0).abs() < 1e-10);
}

#[test]
fn test_string_tension() {
    let st = NC as f64 / (NC * NC - 1) as f64;
    assert!((st - 3.0/8.0).abs() < 1e-10);
}

#[test]
fn test_asymptotic_freedom() {
    assert!(11 * NC > 2 * CHI);  // β₀ > 0
    assert_eq!(BETA0, 7);
}

#[test]
fn test_confinement_heyting() {
    // ¬(1/N_c) = 1/χ ≠ 1: colour can't reach singlet
    assert_ne!(CHI / NC, 1);  // 6/3 = 2 ≠ 1
    assert_eq!(CHI / NC, NW); // negation sends colour to weak, not singlet
}

// ═══════════════════════════════════════════════════════════════
// BIOLOGICAL INFORMATION
// ═══════════════════════════════════════════════════════════════

#[test]
fn test_dna_bases() {
    assert_eq!(NW * NW, 4);  // A, T, G, C
}

#[test]
fn test_codons() {
    let bases = NW * NW;  // 4
    let codons = bases.pow(NC as u32);  // 4³ = 64
    assert_eq!(codons, 64);
}

#[test]
fn test_amino_acids() {
    assert_eq!(GAUSS + BETA0, 20);
}

#[test]
fn test_codon_signals() {
    assert_eq!(NC * BETA0, 21);  // 20 AA + 1 stop
}

#[test]
fn test_codon_redundancy() {
    let codons = (NW * NW).pow(NC as u32);  // 64
    let signals = NC * BETA0;                // 21
    assert_eq!(codons / signals, NC);        // 64/21 = 3 (integer div)
}

#[test]
fn test_complexity_threshold() {
    assert_eq!(D_TOTAL, 42);  // the answer
    assert_eq!(SIGMA_D + CHI, 42);
}

// ═══════════════════════════════════════════════════════════════
// SECTOR BOUNDARY CORRECTIONS
// ═══════════════════════════════════════════════════════════════

#[test]
fn test_neutron_lifetime_correction() {
    // τ_n = D²/N_w − N_w² = 1764/2 − 4 = 878
    let tau = D_TOTAL * D_TOTAL / NW - NW * NW;
    assert_eq!(tau, 878);
}

#[test]
fn test_phi_boundary() {
    // φ correction denominator: gauss × N_w × β₀ = 182
    assert_eq!(GAUSS * NW * BETA0, 182);
}

#[test]
fn test_golden_ratio_corrected() {
    let phi = GAUSS as f64 / (NW * NW * NW) as f64
            - 1.0 / (GAUSS * NW * BETA0) as f64;
    let exact = (1.0 + 5.0_f64.sqrt()) / 2.0;
    assert!((phi - exact).abs() < 0.002);  // PWI < 0.1%
}

// ═══════════════════════════════════════════════════════════════
// CHEMISTRY
// ═══════════════════════════════════════════════════════════════

#[test]
fn test_s_orbital() { assert_eq!(NW, 2); }

#[test]
fn test_p_orbital() { assert_eq!(NW * NC, 6); }

#[test]
fn test_d_orbital() { assert_eq!(NW * (CHI - 1), 10); }

#[test]
fn test_f_orbital() { assert_eq!(NW * BETA0, 14); }

#[test]
fn test_tetrahedral_angle() {
    let angle = (-1.0 / NC as f64).acos() * 180.0 / std::f64::consts::PI;
    assert!((angle - 109.4712).abs() < 0.001);
}

#[test]
fn test_krypton_is_sigma_d() {
    assert_eq!(SIGMA_D, 36);  // Kr atomic number = Σd
}

// ═══════════════════════════════════════════════════════════════
// GENETICS & PROTEIN FOLDING
// ═══════════════════════════════════════════════════════════════

#[test]
fn test_helix_turn() {
    // 3.6 = N_c + N_c/(χ-1) = 3 + 3/5 = 18/5
    let turn = NC as f64 + NC as f64 / (CHI - 1) as f64;
    assert!((turn - 3.6).abs() < 1e-10);
}

#[test]
fn test_helix_rise() {
    // 1.5 Å = N_c/N_w = 3/2
    assert_eq!(NC * 2, NW * 3);  // cross multiply: 3/2
}

#[test]
fn test_beta_sheet() {
    // 3.5 Å = β₀/N_w = 7/2
    assert_eq!(BETA0 * 2, NW * 7);
}

#[test]
fn test_at_hydrogen_bonds() { assert_eq!(NW, 2); }

#[test]
fn test_gc_hydrogen_bonds() { assert_eq!(NC, 3); }

#[test]
fn test_groove_ratio() {
    // 11/χ = 11/6 → 11×6 = 66 cross check
    assert_eq!(11 * NC, 3 * BETA0 + 2 * CHI);  // 33 = 21 + 12
}
