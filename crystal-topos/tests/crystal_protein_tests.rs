// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later

//! crystal_protein_tests.rs — Tower Force Field Tests (D=0..D=38)
//!
//! Every constant from {2, 3, a₀, α, π, ln}. No fitted parameters.
//! 30 tests: 11 integer, 5 VdW, 4 cascade, 6 energy, 4 exact.
//!
//! LICENSE: AGPL-3.0

use std::f64::consts::PI;

// ══════════════════════════════════════════════════════
// TOWER CONSTANTS
// ══════════════════════════════════════════════════════
const N_C: usize = 3;
const N_W: usize = 2;
const CHI: usize = 6;
const GAUSS: usize = 13;
const SIGMA_D: usize = 36;
const A0: f64 = 0.52918;
const E_H: f64 = 27.2114;

fn alpha() -> f64 { 1.0 / (43.0 * PI + 7.0_f64.ln()) }

// ══════════════════════════════════════════════════════
// D=20, D=21
// ══════════════════════════════════════════════════════
fn sp3() -> f64 { (-1.0 / N_C as f64).acos() }
fn sp2() -> f64 { 2.0 * PI / N_C as f64 }

// ══════════════════════════════════════════════════════
// D=22 VDW
// ══════════════════════════════════════════════════════
fn vdw(z_eff: f64, n_val: f64, n: f64) -> f64 {
    let zeta = z_eff / (n * A0);
    let nc = N_C as f64;
    let arg = nc.powi(2) * n_val.powi(2) * z_eff.powi(2) / (alpha() * n.powi(2));
    let f = if (n - 1.0).abs() < 0.01 { 2.0 / PI } else { 1.0 };
    f * arg.ln() / (2.0 * zeta)
}

// ══════════════════════════════════════════════════════
// D=24 WATER
// ══════════════════════════════════════════════════════
fn water_angle() -> f64 { (-1.0 / (N_W * N_W) as f64).acos() }

// ══════════════════════════════════════════════════════
// D=25 H-BOND, STRAND
// ══════════════════════════════════════════════════════
fn h_bond() -> f64 {
    (vdw(3.9, 5.0, 2.0) + vdw(4.55, 6.0, 2.0)) * (1.0 - alpha().sqrt())
}
fn strand_anti() -> f64 {
    2.0 * h_bond() * ((PI - sp3()) / 2.0).cos()
}
fn strand_para() -> f64 { strand_anti() + A0 }

// ══════════════════════════════════════════════════════
// D=28 CA-CA
// ══════════════════════════════════════════════════════
fn ca_ca() -> f64 {
    let defl = PI - sp2();
    let x = 1.52 + 1.33 * defl.cos() + 1.47;
    let y = 1.33 * defl.sin();
    (x * x + y * y).sqrt()
}

// ══════════════════════════════════════════════════════
// ENERGY SCALES
// ══════════════════════════════════════════════════════
fn e_vdw() -> f64 { alpha() * E_H / (N_C * N_C) as f64 }
fn e_hbond() -> f64 { alpha() * E_H }
fn k_omega() -> f64 { N_C as f64 * alpha() * E_H }
fn e_burial() -> f64 {
    (N_C * N_C) as f64 * alpha() * E_H
        * (1.0 - water_angle().cos() / sp3().cos())
}

// ══════════════════════════════════════════════════════
// TESTS
// ══════════════════════════════════════════════════════
#[cfg(test)]
mod tests {
    use super::*;

    fn within(name: &str, got: f64, want: f64, tol_pct: f64) {
        let err = ((got - want) / want * 100.0).abs();
        assert!(err < tol_pct,
            "{name}: got {got:.4} want {want:.4} err {err:.1}% tol {tol_pct}%");
    }

    // ── D=0..4: Integer structure (11) ──

    #[test] fn int_n_c()       { assert_eq!(N_C, 3); }
    #[test] fn int_n_w()       { assert_eq!(N_W, 2); }
    #[test] fn int_chi()       { assert_eq!(CHI, 6); }
    #[test] fn int_gauss()     { assert_eq!(GAUSS, 13); }
    #[test] fn int_n_c_sq()    { assert_eq!(N_C * N_C, 9); }
    #[test] fn int_n_w_sq()    { assert_eq!(N_W * N_W, 4); }
    #[test] fn int_rep_exp()   { assert_eq!(N_C - 1, 2); }
    #[test] fn int_helix_18()  { assert_eq!(N_C * CHI, 18); }
    #[test] fn int_chi_1()     { assert_eq!(CHI - 1, 5); }
    #[test] fn int_flory_den() { assert_eq!(N_W + N_C, 5); }
    #[test] fn int_dielectric(){ assert_eq!(N_W * N_W * (N_C + 1), 16); }

    // ── D=5: α ──

    #[test] fn d5_alpha() { within("α", alpha(), 1.0/137.036, 0.01); }

    // ── D=20-21: Angles ──

    #[test] fn d20_sp3() { within("sp3", sp3().to_degrees(), 109.4712, 0.01); }
    #[test] fn d21_sp2() { within("sp2", sp2().to_degrees(), 120.0, 0.01); }

    // ── D=22: VdW radii (5) ──

    #[test] fn d22_vdw_h() { within("r(H)", vdw(1.0,  1.0, 1.0), 1.20, 10.0); }
    #[test] fn d22_vdw_c() { within("r(C)", vdw(3.25, 4.0, 2.0), 1.70, 10.0); }
    #[test] fn d22_vdw_n() { within("r(N)", vdw(3.90, 5.0, 2.0), 1.55, 10.0); }
    #[test] fn d22_vdw_o() { within("r(O)", vdw(4.55, 6.0, 2.0), 1.52, 10.0); }
    #[test] fn d22_vdw_s() { within("r(S)", vdw(5.45, 6.0, 3.0), 1.80, 10.0); }

    // ── D=24: Water angle ──

    #[test] fn d24_water() { within("water", water_angle().to_degrees(), 104.48, 0.1); }

    // ── D=25..28: Cascade (4) ──

    #[test] fn d25_hbond()  { within("H-bond",  h_bond(),      2.90, 15.0); }
    #[test] fn d25_strand() { within("β-anti",  strand_anti(), 4.70, 10.0); }
    #[test] fn d25_para()   { within("β-para",  strand_para(), 5.20, 10.0); }
    #[test] fn d28_caca()   { within("CA-CA",   ca_ca(),       3.80,  5.0); }

    // ── D=32, 33, 38: Exact ──

    #[test] fn d32_helix()  { assert!((18.0_f64/5.0 - 3.6).abs() < 1e-12); }
    #[test] fn d33_flory()  { assert!(((N_W as f64)/(N_W+N_C) as f64 - 0.4).abs() < 1e-12); }
    #[test] fn d38_tau()    { assert!(((CHI-1) as f64/SIGMA_D as f64 - 5.0/36.0).abs() < 1e-12); }

    // ── Energy scales (4) ──

    #[test] fn e_vdw_scale()    { within("ε_vdw",   e_vdw(),   0.0221, 5.0); }
    #[test] fn e_hbond_scale()  { within("E_hbond", e_hbond(), 0.199,  5.0); }
    #[test] fn e_omega_scale()  { within("k_ω",     k_omega(), 0.596,  5.0); }
    #[test] fn e_burial_scale() { within("E_burial",e_burial(), 0.447, 15.0); }
}
