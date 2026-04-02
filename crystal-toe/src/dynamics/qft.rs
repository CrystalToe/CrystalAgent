// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// dynamics/qft.rs — Quantum Field Dynamics from (2,3)
//
// Spacetime = N_w² = 4. Lorentz = χ = 6. Dirac = N_w² = 4.
// Gluons = d₃ = 8. β₀ = 7. Thomson 8/3 = d_colour/N_c.
// Running couplings, cross-sections, phase space.

use crate::atoms::*;

#[inline] fn sq(x: f64) -> f64 { x * x }
const PI: f64 = std::f64::consts::PI;

// ═══════════════════════════════════════════════════════════════
// §1  QFT CONSTANTS
// ═══════════════════════════════════════════════════════════════

pub const SPACETIME_DIM: u64 = N_W * N_W;                    // 4
pub const LORENTZ_GEN: u64 = CHI;                             // 6 = d(d-1)/2
pub const DIRAC_GAMMAS: u64 = N_W * N_W;                     // 4
pub const SPINOR_COMP: u64 = N_W;                             // 2
pub const PHOTON_POL: u64 = N_C - 1;                          // 2
pub const GLUON_COLOURS: u64 = D3;                             // 8 = N_c²−1
pub const QCD_BETA0: u64 = BETA0;                              // 7
pub const ONE_LOOP_FACTOR: u64 = N_W * N_W * N_W * N_W;      // 16
pub const PROPAGATOR_EXP: u64 = N_C - 1;                      // 2
pub const PAIR_FACTOR: u64 = N_W;                              // 2

// ═══════════════════════════════════════════════════════════════
// §2  FINE STRUCTURE CONSTANT
// ═══════════════════════════════════════════════════════════════

/// α⁻¹ = (D+1)π + ln(β₀) = 43π + ln7.
pub fn alpha_inv() -> f64 {
    (TOWER_D + 1) as f64 * PI + (BETA0 as f64).ln()
}

pub fn alpha_em() -> f64 { 1.0 / alpha_inv() }

// ═══════════════════════════════════════════════════════════════
// §3  CROSS-SECTIONS
// ═══════════════════════════════════════════════════════════════

const HBARC2: f64 = 0.389379e6; // nb·GeV²

/// e⁺e⁻ → μ⁺μ⁻: σ = N_w²πα²/(N_c·s) × ℏ²c².
pub fn sigma_ee_mumu(sqrt_s: f64) -> f64 {
    let s = sq(sqrt_s);
    (N_W * N_W) as f64 * PI * sq(alpha_em()) / (N_C as f64 * s) * HBARC2
}

/// Thomson: σ_T = (d_colour/N_c)π r_e².
pub fn thomson_cs() -> f64 {
    let me: f64 = 0.51099895e-3;
    let hbarc: f64 = 197.3269804e-3;
    let re = alpha_em() * hbarc / me;
    D_COLOUR as f64 / N_C as f64 * PI * sq(re) * 0.01 // fm²→barn
}

/// Pair threshold: E = N_w·m = 2m.
pub fn pair_threshold(m: f64) -> f64 { N_W as f64 * m }

/// 2-body phase space: Φ₂ = 1/(d_colour·π) = 1/(8π).
pub fn phase_space_2() -> f64 { 1.0 / (D_COLOUR as f64 * PI) }

/// n-body phase space dimension: N_c·n − (N_c+1).
pub fn phase_space_dim(n: u64) -> u64 { N_C * n - (N_C + 1) }

// ═══════════════════════════════════════════════════════════════
// §4  RUNNING COUPLINGS
// ═══════════════════════════════════════════════════════════════

/// QED running α(Q), reference scale μ.
pub fn alpha_qed(mu: f64, q: f64) -> f64 {
    let a0 = alpha_em();
    let ln_r = (sq(q) / sq(mu)).ln();
    a0 / (1.0 - a0 / (N_C as f64 * PI) * ln_r)
}

/// QCD running α_s(Q) given Λ_QCD.
pub fn alpha_qcd(lambda_qcd: f64, q: f64) -> f64 {
    2.0 * PI / (BETA0 as f64 * (q / lambda_qcd).ln())
}

/// QCD α_s at M_Z (standard reference).
pub fn alpha_s_mz() -> f64 {
    alpha_qcd(0.217, 91.2) // Λ_QCD ≈ 217 MeV, Q = M_Z
}

// ═══════════════════════════════════════════════════════════════
// §5  OPTICAL THEOREM
// ═══════════════════════════════════════════════════════════════

/// Im(M_forward) = N_w·s·σ (natural units).
pub fn optical_lhs(sqrt_s: f64) -> f64 {
    let s = sq(sqrt_s);
    N_W as f64 * s * sigma_ee_mumu(sqrt_s) / HBARC2
}

// ═══════════════════════════════════════════════════════════════
// §6  CURVE GENERATORS
// ═══════════════════════════════════════════════════════════════

/// σ(e⁺e⁻→μ⁺μ⁻) vs √s. Returns (sqrt_s, sigma_nb).
pub fn sigma_curve(s_min: f64, s_max: f64, n: usize) -> (Vec<f64>, Vec<f64>) {
    let ds = (s_max - s_min) / n as f64;
    let ss: Vec<f64> = (0..n).map(|i| s_min + (i as f64 + 0.5) * ds).collect();
    let sigmas: Vec<f64> = ss.iter().map(|&s| sigma_ee_mumu(s)).collect();
    (ss, sigmas)
}

/// α_s(Q) curve. Returns (Q, α_s).
pub fn alpha_s_curve(q_min: f64, q_max: f64, lambda: f64, n: usize) -> (Vec<f64>, Vec<f64>) {
    let dq = (q_max - q_min) / n as f64;
    let qs: Vec<f64> = (0..n).map(|i| q_min + (i as f64 + 0.5) * dq).collect();
    let alphas: Vec<f64> = qs.iter().map(|&q| alpha_qcd(lambda, q)).collect();
    (qs, alphas)
}

// ═══════════════════════════════════════════════════════════════
// §7  INTEGER PROOFS
// ═══════════════════════════════════════════════════════════════

pub const PROVE_SPACETIME: u64 = N_W * N_W;                        // 4
pub const PROVE_LORENTZ: u64 = N_W*N_W*(N_W*N_W-1)/2;             // 6
pub const PROVE_DIRAC: u64 = N_W * N_W;                             // 4
pub const PROVE_SPINOR: u64 = N_W;                                   // 2
pub const PROVE_PHOTON: u64 = N_C - 1;                               // 2
pub const PROVE_GLUONS: u64 = N_C * N_C - 1;                        // 8
pub const PROVE_BETA0: u64 = (11 * N_C - 2 * CHI) / 3;             // 7
pub const PROVE_ONE_LOOP: u64 = N_W * N_W * N_W * N_W;             // 16
pub const PROVE_THOMSON: (u64, u64) = (D_COLOUR, N_C);              // 8/3
pub const PROVE_PROPAGATOR: u64 = N_C - 1;                           // 2

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn spacetime_4() { assert_eq!(PROVE_SPACETIME, 4); }
    #[test] fn lorentz_6() { assert_eq!(PROVE_LORENTZ, 6); }
    #[test] fn lorentz_is_chi() { assert_eq!(LORENTZ_GEN, CHI); }
    #[test] fn dirac_4() { assert_eq!(PROVE_DIRAC, 4); }
    #[test] fn gluons_8() { assert_eq!(PROVE_GLUONS, 8); }
    #[test] fn gluons_is_d3() { assert_eq!(GLUON_COLOURS, D3); }
    #[test] fn beta0_7() { assert_eq!(PROVE_BETA0, 7); }
    #[test] fn one_loop_16() { assert_eq!(PROVE_ONE_LOOP, 16); }
    #[test] fn thomson_8_3() { assert_eq!(PROVE_THOMSON, (8, 3)); }

    #[test] fn alpha_inv_137() {
        let ai = alpha_inv();
        assert!((ai - 137.036).abs() < 0.1, "α⁻¹ = {}", ai);
    }
    #[test] fn sigma_ee_positive() {
        assert!(sigma_ee_mumu(10.0) > 0.0);
    }
    #[test] fn sigma_falls_with_s() {
        assert!(sigma_ee_mumu(10.0) > sigma_ee_mumu(100.0));
    }
    #[test] fn thomson_positive() {
        assert!(thomson_cs() > 0.0);
    }
    #[test] fn alpha_s_reasonable() {
        let a = alpha_s_mz();
        assert!(a > 0.1 && a < 0.2, "α_s(M_Z) = {}", a);
    }
    #[test] fn pair_threshold_2m() {
        assert!((pair_threshold(0.511e-3) - 2.0 * 0.511e-3).abs() < 1e-10);
    }
}
