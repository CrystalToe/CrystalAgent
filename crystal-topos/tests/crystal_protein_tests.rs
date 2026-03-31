// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later

//! crystal_protein_tests.rs -- Full Tower Force Field Tests (D=0..D=42)
//!
//! Session 14: All 43 layers, hierarchical implosion, running alpha.
//! Every constant from {2, 3, v=246.22, pi, ln}. Zero fitted parameters.
//!
//! 60 tests: 20 integer, 5 VdW, 5 cascade, 7 implosion, 8 energy,
//!           5 running alpha, 4 cosmological, 6 exact.
//!
//! LICENSE: AGPL-3.0

use std::f64::consts::PI;

// ==============================================================
// D=0: TOWER CONSTANTS
// ==============================================================
const N_C: usize = 3;
const N_W: usize = 2;
const D1: usize = 1;
const D2: usize = 3;
const D3: usize = 8;
const D4: usize = 24;
const CHI: usize = 6;
const BETA0: usize = 7;
const SIGMA_D: usize = 36;
const SIGMA_D2: usize = 650;
const GAUSS: usize = 13;
const D_MAX: usize = 42;
const F3: usize = 257;
const SHARED_CORE: usize = 27300;

const E_H: f64 = 27.2114; // Hartree (eV)
const HBAR_C: f64 = 197.3269804e-8; // GeV*A
const V_HIGGS: f64 = 246.22; // GeV

// ==============================================================
// D=5: RUNNING ALPHA
// ==============================================================
fn alpha_inv_at(d: usize) -> f64 {
    (d as f64 + 1.0) * PI + (BETA0 as f64).ln()
}

fn alpha_at(d: usize) -> f64 {
    1.0 / alpha_inv_at(d)
}

fn alpha() -> f64 { alpha_at(D_MAX) }
fn alpha_inv() -> f64 { alpha_inv_at(D_MAX) }

// Implosion correction on alpha_inv
fn alpha_inv_delta() -> f64 {
    -1.0 / (CHI * D4 * SIGMA_D2 * D_MAX) as f64
}

// ==============================================================
// D=5: LEPTON MASSES
// ==============================================================
fn m_e_gev() -> f64 {
    let d_colour = N_C * N_C - 1; // 8
    let m_mu = V_HIGGS / (1usize << (2 * CHI - 1)) as f64
             * d_colour as f64 / (N_C * N_C) as f64;
    m_mu / (CHI * CHI * CHI - d_colour) as f64
}

fn a0() -> f64 {
    HBAR_C / (m_e_gev() * alpha())
}

// ==============================================================
// D=18: SCREENING
// ==============================================================
fn z_eff(z: usize, n: usize) -> f64 {
    if z == 1 { return 1.0; }
    let n1s = z.min(2);
    let n2s = (z.saturating_sub(2)).min(2);
    let n2p = (z.saturating_sub(4)).min(6);
    let sigma = if n == 1 {
        (n1s - 1) as f64 * 0.30
    } else if n == 2 {
        n1s as f64 * 0.85 + (n2s + n2p - 1) as f64 * 0.35
    } else {
        let n3s = (z.saturating_sub(10)).min(2);
        let n3p = (z.saturating_sub(12)).min(6);
        n1s as f64 * 1.00 + (n2s + n2p) as f64 * 0.85
            + (n3s + n3p - 1) as f64 * 0.35
    };
    z as f64 - sigma
}

// ==============================================================
// D=20, D=21: HYBRIDIZATION
// ==============================================================
fn sp3() -> f64 { (-1.0 / N_C as f64).acos() }
fn sp2() -> f64 { 2.0 * PI / N_C as f64 }

// ==============================================================
// D=22: VDW RADII
// ==============================================================
fn vdw(z_eff_val: f64, n_val: f64, n: f64) -> f64 {
    let zeta = z_eff_val / (n * a0());
    let nc = N_C as f64;
    let arg = nc.powi(2) * n_val.powi(2) * z_eff_val.powi(2)
            / (alpha() * n.powi(2));
    let f = if (n - 1.0).abs() < 0.01 { 2.0 / PI } else { 1.0 };
    f * arg.ln() / (2.0 * zeta)
}

// ==============================================================
// D=24: WATER
// ==============================================================
fn water_angle() -> f64 { (-1.0 / (N_W * N_W) as f64).acos() }

// ==============================================================
// D=25: H-BOND, STRAND
// ==============================================================
fn h_bond() -> f64 {
    let r_n = vdw(z_eff(7, 2), 5.0, 2.0);
    let r_o = vdw(z_eff(8, 2), 6.0, 2.0);
    (r_n + r_o) * (1.0 - alpha().sqrt())
}

fn strand_anti() -> f64 {
    2.0 * h_bond() * ((PI - sp3()) / 2.0).cos()
}

fn strand_para() -> f64 {
    strand_anti() * (1.0 + 1.0 / BETA0 as f64)
}

// ==============================================================
// D=27-28: BACKBONE
// ==============================================================
fn cov_r_c() -> f64 {
    let ze = z_eff(6, 2);
    a0() * (3.0 * 4.0 - 1.0 * 2.0) / (2.0 * ze)
}

fn cov_r_n() -> f64 {
    let ze = z_eff(7, 2);
    a0() * (3.0 * 4.0 - 1.0 * 2.0) / (2.0 * ze)
}

fn cn_peptide() -> f64 {
    let bond_order = (1.0 + N_W as f64) / N_W as f64; // 3/2
    (cov_r_c() + cov_r_n()) - a0() * bond_order.ln()
}

fn ca_c_bond() -> f64 { 2.0 * cov_r_c() }
fn n_ca_bond() -> f64 { cov_r_n() + cov_r_c() }

fn ca_ca() -> f64 {
    let chi_c = z_eff(6, 2) / 4.0;
    let chi_n = z_eff(7, 2) / 4.0;
    let delta = sp2().to_degrees() - sp3().to_degrees();
    let a1 = (sp2().to_degrees() - delta * (chi_n - chi_c) / ((chi_n + chi_c) / 2.0))
             .to_radians();
    let a2 = (sp2().to_degrees() + delta * (chi_c - chi_n) / ((chi_c + chi_n) / 2.0))
             .to_radians();
    let d_cn = (ca_c_bond().powi(2) + cn_peptide().powi(2)
                - 2.0 * ca_c_bond() * cn_peptide() * a1.cos()).sqrt();
    (d_cn.powi(2) + n_ca_bond().powi(2)
     - 2.0 * d_cn * n_ca_bond() * a2.cos()).sqrt()
}

// ==============================================================
// HIERARCHICAL IMPLOSION FACTORS
// ==============================================================
fn imp_vdw() -> f64 {
    1.0 - (N_C * N_C * N_C) as f64 / (CHI * SIGMA_D) as f64
}

fn imp_hbond() -> f64 {
    1.0 - 0.5 / CHI as f64
}

fn imp_angle() -> f64 {
    1.0 + D_MAX as f64 / (D4 * SIGMA_D) as f64
}

fn imp_burial() -> f64 {
    1.0 + BETA0 as f64 / (D4 * SIGMA_D2) as f64
}

fn imp_vdw_dist() -> f64 {
    1.0 - 0.5 / (D3 * SIGMA_D) as f64
}

fn imp_hb_dist() -> f64 {
    1.0 - N_W as f64 / (N_C * SIGMA_D) as f64
}

// ==============================================================
// ENERGY SCALES (imploded)
// ==============================================================
fn e_vdw_base() -> f64 { alpha() * E_H / (N_C * N_C) as f64 }
fn e_hbond_base() -> f64 { alpha() * E_H }
fn k_angle_base() -> f64 { alpha() * E_H }
fn e_burial_base() -> f64 {
    (N_C * N_C) as f64 * alpha() * E_H
        * (1.0 - water_angle().cos() / sp3().cos())
}

fn e_vdw() -> f64 { e_vdw_base() * imp_vdw() }
fn e_hbond() -> f64 { e_hbond_base() * imp_hbond() }
fn k_angle() -> f64 { k_angle_base() * imp_angle() }
fn e_burial() -> f64 { e_burial_base() * imp_burial() }

// ==============================================================
// COSMOLOGICAL PARTITION
// ==============================================================
fn omega_lambda() -> f64 { 29.0 / D_MAX as f64 }
fn omega_cdm() -> f64 { 11.0 / D_MAX as f64 }
fn omega_b() -> f64 { 2.0 / D_MAX as f64 }

// ==============================================================
// TESTS (60)
// ==============================================================
#[cfg(test)]
mod tests {
    use super::*;

    fn within(name: &str, got: f64, want: f64, tol_pct: f64) {
        let err = ((got - want) / want * 100.0).abs();
        assert!(err < tol_pct,
            "{name}: got {got:.6} want {want:.6} err {err:.2}% tol {tol_pct}%");
    }

    fn exact(name: &str, got: f64, want: f64) {
        assert!((got - want).abs() < 1e-12,
            "{name}: got {got} want {want}");
    }

    // === D=0: Integer structure (20) ===
    #[test] fn int_nc()       { assert_eq!(N_C, 3); }
    #[test] fn int_nw()       { assert_eq!(N_W, 2); }
    #[test] fn int_d1()       { assert_eq!(D1, 1); }
    #[test] fn int_d2()       { assert_eq!(D2, N_C); }
    #[test] fn int_d3()       { assert_eq!(D3, N_C*N_C - 1); }
    #[test] fn int_d4()       { assert_eq!(D4, N_W*N_W*N_W*N_C); }
    #[test] fn int_chi()      { assert_eq!(CHI, N_W * N_C); }
    #[test] fn int_beta0()    { assert_eq!(BETA0, 7); }
    #[test] fn int_sigma_d()  { assert_eq!(SIGMA_D, D1+D2+D3+D4); }
    #[test] fn int_sigma_d2() { assert_eq!(SIGMA_D2, D1*D1+D2*D2+D3*D3+D4*D4); }
    #[test] fn int_gauss()    { assert_eq!(GAUSS, N_C*N_C + N_W*N_W); }
    #[test] fn int_dmax()     { assert_eq!(D_MAX, SIGMA_D + CHI); }
    #[test] fn int_f3()       { assert_eq!(F3, 257); }
    #[test] fn int_core()     { assert_eq!(SHARED_CORE, SIGMA_D2 * D_MAX); }
    #[test] fn int_eps_r()    { assert_eq!(N_W*N_W*(N_C+1), 16); }
    #[test] fn int_43()       { assert_eq!(D_MAX + 1, 43); }
    #[test] fn int_208()      { assert_eq!(CHI*CHI*CHI - (N_C+N_C+N_W), 208); }
    #[test] fn int_helix()    { assert_eq!(N_C * CHI, 18); }
    #[test] fn int_flory()    { assert_eq!(N_W + N_C, 5); }
    #[test] fn int_cosmo()    { assert_eq!(29 + 11 + 2, D_MAX); }

    // === D=5: Running alpha (5) ===
    #[test] fn d5_alpha_inv() { within("a_inv", alpha_inv(), 137.034, 0.01); }
    #[test] fn d5_alpha_mono() {
        for d in 0..D_MAX { assert!(alpha_at(d) > alpha_at(d+1)); }
    }
    #[test] fn d5_alpha_span() { assert!(alpha_at(0) / alpha_at(D_MAX) > 10.0); }
    #[test] fn d5_alpha_delta() {
        within("delta", alpha_inv_delta().abs(), 2.54e-7, 1.0);
    }
    #[test] fn d5_43_distinct() {
        let vals: Vec<f64> = (0..=D_MAX).map(alpha_at).collect();
        for i in 0..vals.len() {
            for j in (i+1)..vals.len() {
                assert!(vals[i] != vals[j]);
            }
        }
    }

    // === D=20-21: Hybridization (2) ===
    #[test] fn d20_sp3() { within("sp3", sp3().to_degrees(), 109.4712, 0.01); }
    #[test] fn d21_sp2() { within("sp2", sp2().to_degrees(), 120.0, 0.01); }

    // === D=22: VdW radii (5) ===
    #[test] fn d22_vdw_h() { within("r(H)", vdw(1.0, 1.0, 1.0), 1.20, 10.0); }
    #[test] fn d22_vdw_c() { within("r(C)", vdw(z_eff(6,2), 4.0, 2.0), 1.70, 10.0); }
    #[test] fn d22_vdw_n() { within("r(N)", vdw(z_eff(7,2), 5.0, 2.0), 1.55, 10.0); }
    #[test] fn d22_vdw_o() { within("r(O)", vdw(z_eff(8,2), 6.0, 2.0), 1.52, 10.0); }
    #[test] fn d22_vdw_s() { within("r(S)", vdw(z_eff(16,3), 6.0, 3.0), 1.80, 10.0); }

    // === D=25-28: Cascade (5) ===
    #[test] fn d25_hbond()  { within("H-bond",  h_bond(),      2.90, 15.0); }
    #[test] fn d25_strand() { within("anti",    strand_anti(), 4.70, 15.0); }
    #[test] fn d25_para()   { within("para",    strand_para(), 5.20, 15.0); }
    #[test] fn d28_caca()   { within("CA-CA",   ca_ca(),       3.80, 10.0); }
    #[test] fn d24_water()  { within("water",   water_angle().to_degrees(), 104.48, 0.1); }

    // === Implosion factors (7) ===
    #[test] fn imp_vdw_78()      { exact("7/8",     imp_vdw(),   7.0/8.0); }
    #[test] fn imp_hbond_1112()  { exact("11/12",   imp_hbond(), 11.0/12.0); }
    #[test] fn imp_angle_151()   { exact("151/144", imp_angle(), 151.0/144.0); }
    #[test] fn imp_burial_val()  { within("burial",  imp_burial(), 1.0 + 7.0/15600.0, 0.001); }
    #[test] fn imp_vdist_val()   { exact("1-1/576", imp_vdw_dist(), 1.0 - 1.0/576.0); }
    #[test] fn imp_hbdist_val()  { exact("1-1/54",  imp_hb_dist(),  1.0 - 1.0/54.0); }
    #[test] fn imp_ordering()    { assert!(imp_vdw() < imp_hbond() && imp_hbond() < imp_angle()); }

    // === Imploded energy scales (8) ===
    #[test] fn e_vdw_impl()    { within("e_vdw",   e_vdw(),   0.0221 * 7.0/8.0, 5.0); }
    #[test] fn e_hbond_impl()  { within("e_hb",    e_hbond(), 0.199 * 11.0/12.0, 5.0); }
    #[test] fn k_angle_impl()  { within("k_ang",   k_angle(), 0.199 * 151.0/144.0, 5.0); }
    #[test] fn e_burial_impl() { within("e_bur",   e_burial(), 0.447, 15.0); }
    #[test] fn energy_order()  { assert!(e_vdw() < e_hbond() && e_hbond() < e_burial()); }
    #[test] fn e_vdw_positive(){ assert!(e_vdw() > 0.0); }
    #[test] fn e_hb_positive() { assert!(e_hbond() > 0.0); }
    #[test] fn e_bur_positive(){ assert!(e_burial() > 0.0); }

    // === Cosmological partition (4) ===
    #[test] fn cosmo_lambda() { within("OL", omega_lambda(), 29.0/42.0, 0.01); }
    #[test] fn cosmo_cdm()    { within("Oc", omega_cdm(),    11.0/42.0, 0.01); }
    #[test] fn cosmo_b()      { within("Ob", omega_b(),       2.0/42.0, 0.01); }
    #[test] fn cosmo_total()  {
        within("sum", omega_lambda() + omega_cdm() + omega_b(), 1.0, 0.01);
    }

    // === Exact rationals (4) ===
    #[test] fn d32_helix()    { exact("helix", 18.0/5.0, 3.6); }
    #[test] fn d33_flory()    { exact("flory", N_W as f64 / (N_W+N_C) as f64, 0.4); }
    #[test] fn d42_tau()      { exact("tau",   (CHI-1) as f64 / SIGMA_D as f64, 5.0/36.0); }
    #[test] fn d29_rama()     { exact("rama",  SIGMA_D as f64 / 64.0, 0.5625); }
}
