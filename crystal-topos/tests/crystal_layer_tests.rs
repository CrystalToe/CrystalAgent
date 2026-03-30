// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later

//! Tests for the DerivedAt<D> layer provenance system.

use crystal_topos::base::*;
use std::f64::consts::PI;

const TOL: f64 = 0.05;

fn assert_within(name: &str, got: f64, expected: f64, tol: f64) {
    let err = (got - expected).abs() / expected.abs().max(1e-15);
    assert!(
        err < tol,
        "{}: got {:.6}, expected {:.6}, error {:.2}%",
        name, got, expected, err * 100.0
    );
}

#[test]
fn layer0_algebra() {
    assert_eq!(layer0_chi().val(), 6.0);
    assert_eq!(layer0_beta0().val(), 7.0);
    assert_eq!(layer0_sigma_d().val(), 36.0);
    assert_eq!(layer0_sigma_d2().val(), 650.0);
    assert_eq!(layer0_d_max().val(), 42.0);
    assert_eq!(layer0_v_higgs().val(), 246.22);
}

#[test]
fn layer0_type_safety() {
    assert_eq!(layer0_chi().layer(), 0);
    assert_eq!(layer0_beta0().layer(), 0);
}

#[test]
fn layer5_alpha_value() {
    let ainv = layer5_alpha_inv();
    let expected = 43.0 * PI + 7.0_f64.ln();
    assert_within("alpha_inv", ainv.val(), expected, 1e-6);
    assert_within("alpha_inv_codata", ainv.val(), 137.035999, 0.001);
    assert_eq!(ainv.layer(), 5);
}

#[test]
fn layer5_alpha_reciprocal() {
    let a = layer5_alpha();
    let ainv = layer5_alpha_inv();
    assert_within("alpha*alpha_inv", a.val() * ainv.val(), 1.0, 1e-10);
}

#[test]
fn layer10_proton() {
    let mp = layer10_proton_mass();
    assert_within("m_p", mp.val(), 0.938272, TOL);
    assert_eq!(mp.layer(), 10);
}

#[test]
fn layer18_bohr_radius() {
    let a0 = layer18_bohr();
    // Derived a_0 from m_e = m_mu/208 (lepton chain). 0.54% off textbook
    // because m_e derivation carries 0.54% PWI.
    assert_within("a_0", a0.val(), 0.529177, 0.01); // 1% tolerance for derived m_e
    assert_eq!(a0.layer(), 18);
}

#[test]
fn layer20_sp3_exact() {
    let sp3 = layer20_sp3();
    assert_within("sp3", sp3.val(), 109.4712, 0.001);
    assert_eq!(sp3.layer(), 20);
}

#[test]
fn layer25_strand_anti_spacing() {
    let s = layer25_strand_anti();
    assert!(s.val() > 1.0 && s.val() < 10.0, "strand_anti in sane range");
    assert_eq!(s.layer(), 25);
}

#[test]
fn layer25_strand_par_spacing() {
    let s = layer25_strand_par();
    assert!(s.val() > 1.0 && s.val() < 12.0, "strand_par in sane range");
    assert_eq!(s.layer(), 25);
}

#[test]
fn layer25_strand_ratio() {
    let anti = layer25_strand_anti().val();
    let par = layer25_strand_par().val();
    let ratio = par / anti;
    assert_within("strand_par/anti ratio", ratio, 8.0 / 7.0, 0.001);
}

#[test]
fn layer28_ca_ca_distance() {
    let d = layer28_ca_ca();
    assert!(d.val() > 2.0 && d.val() < 5.0, "CA-CA in sane range");
    assert_eq!(d.layer(), 28);
}

#[test]
fn layer32_helix_exact() {
    let h = layer32_helix_per_turn();
    assert_within("helix_per_turn", h.val(), 3.600, 1e-10);
    assert_eq!(h.layer(), 32);
}

#[test]
fn layer32_helix_rise_exact() {
    let r = layer32_helix_rise();
    assert_within("helix_rise", r.val(), 1.500, 1e-10);
}

#[test]
fn layer32_pitch() {
    let per_turn = layer32_helix_per_turn().val();
    let rise = layer32_helix_rise().val();
    assert_within("helix_pitch", per_turn * rise, 5.400, 1e-10);
}

#[test]
fn layer33_flory() {
    let nu = layer33_flory_nu();
    assert_within("flory_nu", nu.val(), 0.400, 1e-10);
    assert_eq!(nu.layer(), 33);
}

#[test]
fn layer42_energy_scale() {
    let e = layer42_fold_energy();
    let expected = 246.22 / 2.0_f64.powi(42);
    assert_within("E_fold", e.val(), expected, 1e-10);
    assert_eq!(e.layer(), 42);
}

#[test]
fn cascade_integer_structure() {
    assert_eq!(CHI, 6);
    assert_eq!(BETA0, 7);
    assert_eq!(D_TOTAL, 42);
    assert_eq!(SIGMA_D, 36);
    assert_eq!(SIGMA_D2, 650);
    assert_eq!(GAUSS, 13);
    assert_eq!(FERMAT3, 257);
}
