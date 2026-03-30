// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later

//! Tests for the DerivedAt<D> layer provenance system.
//! Verifies the spectral tower cascade D=0 → D=42.

use crystal_topos::base::*;
use std::f64::consts::PI;

const TOL: f64 = 0.05; // 5% tolerance

fn assert_within(name: &str, got: f64, expected: f64, tol: f64) {
    let err = (got - expected).abs() / expected.abs().max(1e-15);
    assert!(
        err < tol,
        "{}: got {:.6}, expected {:.6}, error {:.2}% > {:.0}%",
        name, got, expected, err * 100.0, tol * 100.0
    );
}

// ═══════════════════════════════════════════════════════════════
// D=0: Algebra layer
// ═══════════════════════════════════════════════════════════════

#[test]
fn layer0_algebra() {
    assert_eq!(LAYER0_CHI.val(), 6.0);
    assert_eq!(LAYER0_BETA0.val(), 7.0);
    assert_eq!(LAYER0_SIGMA_D.val(), 36.0);
    assert_eq!(LAYER0_SIGMA_D2.val(), 650.0);
    assert_eq!(LAYER0_D_MAX.val(), 42.0);
    assert_eq!(LAYER0_V_HIGGS.val(), 246.22);
}

#[test]
fn layer0_type_safety() {
    // Verify the layer index is correct at the type level
    assert_eq!(LAYER0_CHI.layer(), 0);
    assert_eq!(LAYER0_BETA0.layer(), 0);
}

// ═══════════════════════════════════════════════════════════════
// D=5: Frozen alpha
// ═══════════════════════════════════════════════════════════════

#[test]
fn layer5_alpha_value() {
    let ainv = layer5_alpha_inv();
    // alpha_inv = 43*pi + ln(7)
    let expected = 43.0 * PI + 7.0_f64.ln();
    assert_within("alpha_inv", ainv.val(), expected, 1e-6);
    assert_within("alpha_inv vs CODATA", ainv.val(), 137.035999, 0.001);
    assert_eq!(ainv.layer(), 5);
}

#[test]
fn layer5_alpha_reciprocal() {
    let a = layer5_alpha();
    let ainv = layer5_alpha_inv();
    assert_within("alpha * alpha_inv", a.val() * ainv.val(), 1.0, 1e-10);
}

// ═══════════════════════════════════════════════════════════════
// D=10: QCD
// ═══════════════════════════════════════════════════════════════

#[test]
fn layer10_proton() {
    let mp = layer10_proton_mass();
    assert_within("m_p", mp.val(), 0.938272, TOL);
    assert_eq!(mp.layer(), 10);
}

// ═══════════════════════════════════════════════════════════════
// D=18: Bohr radius
// ═══════════════════════════════════════════════════════════════

#[test]
fn layer18_bohr_radius() {
    assert_within("a_0", LAYER18_BOHR.val(), 0.529177, 1e-6);
    assert_eq!(LAYER18_BOHR.layer(), 18);
}

// ═══════════════════════════════════════════════════════════════
// D=20: Hybridization
// ═══════════════════════════════════════════════════════════════

#[test]
fn layer20_sp3_exact() {
    let sp3 = layer20_sp3();
    assert_within("sp3", sp3.val(), 109.4712, 0.001);
    assert_eq!(sp3.layer(), 20);
}

// ═══════════════════════════════════════════════════════════════
// D=25: Strand spacings — the key test
// ═══════════════════════════════════════════════════════════════

#[test]
fn layer25_strand_anti_spacing() {
    let s = layer25_strand_anti();
    assert_within("strand_anti", s.val(), 4.700, TOL);
    assert_eq!(s.layer(), 25);
}

#[test]
fn layer25_strand_par_spacing() {
    let s = layer25_strand_par();
    assert_within("strand_par", s.val(), 5.200, TOL);
    assert_eq!(s.layer(), 25);
}

#[test]
fn layer25_strand_ratio() {
    // Parallel/anti ratio should be (beta_0 + 1) / beta_0 = 8/7
    let anti = layer25_strand_anti().val();
    let par = layer25_strand_par().val();
    let ratio = par / anti;
    assert_within("strand_par/anti ratio", ratio, 8.0 / 7.0, 0.001);
}

// ═══════════════════════════════════════════════════════════════
// D=28: CA-CA virtual bond
// ═══════════════════════════════════════════════════════════════

#[test]
fn layer28_ca_ca_distance() {
    let d = layer28_ca_ca();
    assert_within("CA-CA", d.val(), 3.800, TOL);
    assert_eq!(d.layer(), 28);
}

// ═══════════════════════════════════════════════════════════════
// D=32: Helix geometry
// ═══════════════════════════════════════════════════════════════

#[test]
fn layer32_helix_exact() {
    let h = layer32_helix_per_turn();
    // 18/5 = 3.600 exactly
    assert_within("helix_per_turn", h.val(), 3.600, 1e-10);
    assert_eq!(h.layer(), 32);
}

#[test]
fn layer32_helix_rise_exact() {
    let r = layer32_helix_rise();
    // N_c / N_w = 3/2 = 1.5
    assert_within("helix_rise", r.val(), 1.500, 1e-10);
}

#[test]
fn layer32_pitch() {
    let per_turn = layer32_helix_per_turn().val();
    let rise = layer32_helix_rise().val();
    assert_within("helix_pitch", per_turn * rise, 5.400, 1e-10);
}

// ═══════════════════════════════════════════════════════════════
// D=33: Flory exponent
// ═══════════════════════════════════════════════════════════════

#[test]
fn layer33_flory() {
    let nu = layer33_flory_nu();
    assert_within("flory_nu", nu.val(), 0.400, 1e-10);
    assert_eq!(nu.layer(), 33);
}

// ═══════════════════════════════════════════════════════════════
// D=42: Fold energy
// ═══════════════════════════════════════════════════════════════

#[test]
fn layer42_energy_scale() {
    let e = layer42_fold_energy();
    let expected = 246.22 / 2.0_f64.powi(42);
    assert_within("E_fold", e.val(), expected, 1e-10);
    assert_eq!(e.layer(), 42);
}

// ═══════════════════════════════════════════════════════════════
// Cascade integrity: verify derivation chain consistency
// ═══════════════════════════════════════════════════════════════

#[test]
fn cascade_integer_structure() {
    // All integer relationships from A_F
    assert_eq!(CHI, 6);
    assert_eq!(BETA0, 7);
    assert_eq!(D_TOTAL, 42);
    assert_eq!(SIGMA_D, 36);
    assert_eq!(SIGMA_D2, 650);
    assert_eq!(GAUSS, 13);
    assert_eq!(FERMAT3, 257);
    assert_eq!(D_TOTAL + 1, 43);       // alpha integer part
    assert_eq!(BETA0 + 1, 8);          // strand ratio numerator
    assert_eq!(NC * CHI, 18);          // helix numerator
    assert_eq!(CHI - 1, 5);            // helix denominator
    assert_eq!(NW + NC, 5);            // Flory denominator
}

#[test]
fn derive_to_transitions() {
    // Test that derive_to correctly produces values at new layers
    let chi_0: DerivedAt<0> = LAYER0_CHI;
    let chi_as_5: DerivedAt<5> = chi_0.derive_to(|x| x);
    assert_eq!(chi_as_5.val(), 6.0);
    assert_eq!(chi_as_5.layer(), 5);
}
