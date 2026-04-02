// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// dynamics/decay.rs — Particle Decay from (2,3)
//
// β constant 192 = d_mixed × d_colour. Weinberg 3/13 = N_c/gauss.
// PMNS θ₂₃ = 6/11 = χ/(2χ−1). θ₁₂ = 3/π² = N_c/π².
// Fermi golden rule, muon decay, neutron lifetime, neutrino oscillations.

use crate::atoms::*;

#[inline] fn sq(x: f64) -> f64 { x * x }
const PI: f64 = std::f64::consts::PI;

// ═══════════════════════════════════════════════════════════════
// §1  DECAY CONSTANTS
// ═══════════════════════════════════════════════════════════════

pub const BETA_FACTOR: u64 = D4 * D_COLOUR;     // 192 = d_mixed × d_colour
pub const D_COLOUR_VAL: u64 = D_COLOUR;          // 8 = N_w³

/// sin²θ_W = N_c/gauss = 3/13.
pub fn sin2_theta_w() -> f64 { N_C as f64 / GAUSS as f64 }

/// sin²θ₁₂ = N_c/π² = 3/π².
pub fn sin2_theta_12() -> f64 { N_C as f64 / (PI * PI) }

/// sin²θ₂₃ = χ/(2χ−1) = 6/11.
pub fn sin2_theta_23() -> f64 { CHI as f64 / (2 * CHI - 1) as f64 }

/// sin²(2θ₂₃) = 120/121 = 4·(6/11)·(5/11).
pub fn sin2_2theta_23() -> f64 {
    let s = sin2_theta_23();
    4.0 * s * (1.0 - s)
}

/// Phase space dimension: 3N − 4 = N_c·N − (N_c+1).
pub fn phase_space_dim(n_final: u64) -> u64 { N_C * n_final - (N_C + 1) }

// ═══════════════════════════════════════════════════════════════
// §2  FERMI GOLDEN RULE & BETA DECAY RATE
// ═══════════════════════════════════════════════════════════════

/// Fermi golden rule: Γ = 2π|M|²ρ. 2 = N_w.
pub fn fermi_golden_rule(matrix_element_sq: f64, density_of_states: f64) -> f64 {
    N_W as f64 * PI * matrix_element_sq * density_of_states
}

/// Beta decay rate: Γ = G_F²E⁵/(192π³).
pub fn beta_decay_rate(gf: f64, energy: f64) -> f64 {
    gf * gf * energy.powi(5) / (BETA_FACTOR as f64 * PI.powi(3))
}

/// Phase space volume (2-body): 1/(8π)√s.
pub fn phase_space_2body(s: f64) -> f64 {
    s.sqrt() / (D_COLOUR as f64 * PI)
}

// ═══════════════════════════════════════════════════════════════
// §3  G_F FROM MUON DECAY (via 192)
// ═══════════════════════════════════════════════════════════════

const HBAR: f64 = 6.582119569e-25; // GeV·s
const M_MU: f64 = 0.1056583755;    // GeV
const TAU_MU: f64 = 2.1969811e-6;  // s

/// G_F extracted from muon lifetime: G_F² = 192π³/(τ_μ·m_μ⁵).
pub fn g_fermi_sq() -> f64 {
    let tau_nat = TAU_MU / HBAR;
    let mm5 = M_MU.powi(5);
    BETA_FACTOR as f64 * PI.powi(3) / (tau_nat * mm5)
}

pub fn g_fermi() -> f64 { g_fermi_sq().sqrt() }

// ═══════════════════════════════════════════════════════════════
// §4  NEUTRON BETA DECAY
// ═══════════════════════════════════════════════════════════════

const M_E: f64 = 0.00051099895;     // GeV
const M_N: f64 = 0.93956542052;     // GeV
const M_P: f64 = 0.93827208816;     // GeV
const V_UD: f64 = 0.97373;
const G_AXIAL: f64 = 1.2764;
const ALPHA_EM: f64 = 1.0 / 137.035999084;
const DELTA_R: f64 = 0.02467;

fn q_value() -> f64 { M_N - M_P }
fn e0() -> f64 { q_value() / M_E }

/// Fermi function (Coulomb correction, Z=1).
fn fermi_func(e: f64) -> f64 {
    let p = (sq(e) - 1.0).max(0.0).sqrt();
    if p < 1e-15 { return 1.0; }
    let eta = ALPHA_EM * e / p;
    let x = 2.0 * PI * eta;
    x / (1.0 - (-x).exp())
}

/// Beta spectrum integrand.
fn beta_integrand(e: f64) -> f64 {
    let p = (sq(e) - 1.0).max(0.0).sqrt();
    fermi_func(e) * p * e * sq(e0() - e)
}

/// Simpson integration.
fn simpson(n: usize, a: f64, b: f64, f: impl Fn(f64) -> f64) -> f64 {
    let n = if n % 2 == 1 { n + 1 } else { n };
    let h = (b - a) / n as f64;
    let mut sum = f(a) + f(b);
    for i in 1..n {
        let x = a + i as f64 * h;
        sum += if i % 2 == 0 { 2.0 } else { 4.0 } * f(x);
    }
    sum * h / 3.0
}

/// Fermi integral (phase space with Coulomb correction).
pub fn fermi_integral() -> f64 {
    simpson(10000, 1.00001, e0() - 0.00001, beta_integrand)
}

/// Neutron lifetime (seconds).
pub fn neutron_lifetime() -> f64 {
    let me5 = M_E.powi(5);
    let lam2 = sq(G_AXIAL);
    let factor = g_fermi_sq() * sq(V_UD) * me5 * (1.0 + 3.0 * lam2)
        * fermi_integral() * (1.0 + DELTA_R);
    let tau_nat = 2.0 * PI.powi(3) / factor;
    tau_nat * HBAR
}

// ═══════════════════════════════════════════════════════════════
// §5  NEUTRINO OSCILLATIONS
// ═══════════════════════════════════════════════════════════════

/// P(νₐ→ν_b) = sin²(2θ)·sin²(1.267·Δm²·L/E).
pub fn oscill_prob(sin2_2th: f64, dm2: f64, l_over_e: f64) -> f64 {
    sin2_2th * sq((1.267 * dm2 * l_over_e).sin())
}

/// Atmospheric oscillation at L/E ≈ 500 km/GeV.
pub fn atmos_oscillation() -> f64 {
    oscill_prob(sin2_2theta_23(), 2.5e-3, 500.0)
}

// ═══════════════════════════════════════════════════════════════
// §6  BETA SPECTRUM
// ═══════════════════════════════════════════════════════════════

/// Beta spectrum at kinetic energy T (MeV).
pub fn beta_spectrum(t_mev: f64) -> f64 {
    let e = t_mev / (M_E * 1000.0) + 1.0;
    if e >= e0() || e <= 1.0 { 0.0 } else { beta_integrand(e) }
}

/// Endpoint kinetic energy (MeV).
pub fn beta_endpoint() -> f64 { (e0() - 1.0) * M_E * 1000.0 }

/// Generate beta spectrum curve. Returns (t_mev, spectrum).
pub fn beta_spectrum_curve(n_points: usize) -> (Vec<f64>, Vec<f64>) {
    let ep = beta_endpoint();
    let dt = ep / n_points as f64;
    let ts: Vec<f64> = (0..n_points).map(|i| (i as f64 + 0.5) * dt).collect();
    let spec: Vec<f64> = ts.iter().map(|&t| beta_spectrum(t)).collect();
    (ts, spec)
}

// ═══════════════════════════════════════════════════════════════
// §7  INTEGER PROOFS
// ═══════════════════════════════════════════════════════════════

pub const PROVE_BETA: u64 = D4 * D_COLOUR;           // 192
pub const PROVE_WEINBERG: (u64, u64) = (N_C, GAUSS); // 3/13
pub const PROVE_THETA23: (u64, u64) = (CHI, 2*CHI-1); // 6/11
pub const PROVE_PHASE2: u64 = N_C * 2 - (N_C + 1);   // 2
pub const PROVE_PHASE3: u64 = N_C * 3 - (N_C + 1);   // 5
pub const PROVE_PHASE4: u64 = N_C * 4 - (N_C + 1);   // 8

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn beta_192() { assert_eq!(PROVE_BETA, 192); }
    #[test] fn weinberg_3_13() {
        assert!((sin2_theta_w() - 3.0/13.0).abs() < 1e-10);
    }
    #[test] fn theta23_6_11() {
        assert!((sin2_theta_23() - 6.0/11.0).abs() < 1e-10);
    }
    #[test] fn sin2_2theta23_120_121() {
        assert!((sin2_2theta_23() - 120.0/121.0).abs() < 1e-10);
    }
    #[test] fn theta12_3_pi2() {
        assert!((sin2_theta_12() - 3.0/(PI*PI)).abs() < 1e-10);
    }
    #[test] fn phase_dims() {
        assert_eq!(phase_space_dim(2), 2);
        assert_eq!(phase_space_dim(3), 5);
        assert_eq!(phase_space_dim(4), 8);
    }
    #[test] fn g_fermi_value() {
        let gf = g_fermi();
        let gf_pdg = 1.1663788e-5;
        assert!((gf - gf_pdg).abs() / gf_pdg < 0.005, "G_F = {}", gf);
    }
    #[test] fn neutron_lifetime_reasonable() {
        let tau = neutron_lifetime();
        assert!(tau > 800.0 && tau < 1000.0, "tau_n = {} s", tau);
    }
    #[test] fn oscill_in_range() {
        let p = atmos_oscillation();
        assert!(p >= 0.0 && p <= 1.0);
    }
    #[test] fn beta_spectrum_shape() {
        let ep = beta_endpoint();
        let s_mid = beta_spectrum(ep * 0.4);
        let s_end = beta_spectrum(ep - 0.001);
        assert!(s_mid > s_end);
    }
}
