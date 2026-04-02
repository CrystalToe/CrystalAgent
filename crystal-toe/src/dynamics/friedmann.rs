// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// dynamics/friedmann.rs — Cosmological Expansion from (2,3)
//
// Ω_Λ = gauss/(gauss+χ) = 13/19. Ω_m = χ/(gauss+χ) = 6/19.
// H²(a) = H₀²[Ω_r/a⁴ + Ω_m/a³ + Ω_Λ]. Matter 1/a^N_c, radiation 1/a^(N_c+1).

use crate::atoms::*;

// ═══════════════════════════════════════════════════════════════
// §1  DENSITY PARAMETERS
// ═══════════════════════════════════════════════════════════════

/// Ω_Λ = gauss/(gauss+χ) = 13/19.
pub fn omega_lambda() -> f64 { GAUSS as f64 / (GAUSS + CHI) as f64 }

/// Ω_m = χ/(gauss+χ) = 6/19.
pub fn omega_matter() -> f64 { CHI as f64 / (GAUSS + CHI) as f64 }

/// Ω_b = Ω_m × β₀/(β₀+12π).
pub fn omega_baryon() -> f64 {
    omega_matter() * BETA0 as f64 / (BETA0 as f64 + 12.0 * std::f64::consts::PI)
}

/// Ω_DM = Ω_m − Ω_b.
pub fn omega_dm() -> f64 { omega_matter() - omega_baryon() }

/// Ω_radiation ≈ 9e-5.
pub fn omega_rad() -> f64 { 9.0e-5 }

/// DM/baryon = 12π/β₀ = N_w²·N_c·π/β₀.
pub fn dm_baryon_ratio() -> f64 {
    (N_W * N_W * N_C) as f64 * std::f64::consts::PI / BETA0 as f64
}

/// w_DE = −1 (Landauer erasure).
pub const W_DE: i64 = -1;

// ═══════════════════════════════════════════════════════════════
// §2  HUBBLE PARAMETER
// ═══════════════════════════════════════════════════════════════

/// H(a)/H₀ = √[Ω_r/a⁴ + Ω_m/a³ + Ω_Λ].
pub fn hubble_norm(a: f64) -> f64 {
    let a2 = a * a; let a3 = a2 * a; let a4 = a3 * a;
    (omega_rad() / a4 + omega_matter() / a3 + omega_lambda()).sqrt()
}

/// da/dt = a·H(a).
pub fn dadt(a: f64) -> f64 { a * hubble_norm(a) }

/// Deceleration parameter: q = Ω_m/(2a³H²) − Ω_Λ/H².
pub fn deceleration_param(a: f64) -> f64 {
    let h2 = hubble_norm(a).powi(2);
    let a3 = a * a * a;
    omega_matter() / (2.0 * a3 * h2) - omega_lambda() / h2
}

/// Hubble parameter H₀ = 100·D/(Σ_d+β₀).
pub fn h0_crystal() -> f64 {
    100.0 * TOWER_D as f64 / (SIGMA_D + BETA0) as f64
}

// ═══════════════════════════════════════════════════════════════
// §3  FRIEDMANN INTEGRATION (RK2)
// ═══════════════════════════════════════════════════════════════

#[derive(Clone, Debug)]
pub struct CosmoState {
    pub a: f64,
    pub time: f64,  // in units of 1/H₀
    pub z: f64,     // redshift = 1/a − 1
}

/// Integrate Friedmann from a_init to a_final. RK2 midpoint.
pub fn integrate_friedmann(a_init: f64, a_final: f64, dt: f64, max_steps: usize) -> Vec<CosmoState> {
    let mut traj = Vec::new();
    let mut a = a_init;
    let mut t = 0.0;
    traj.push(CosmoState { a, time: t, z: 1.0/a - 1.0 });
    for _ in 0..max_steps {
        if a >= a_final { break; }
        let k1 = dadt(a);
        let a_mid = a + 0.5 * dt * k1;
        let k2 = dadt(a_mid);
        a += dt * k2;
        t += dt;
        traj.push(CosmoState { a, time: t, z: 1.0/a - 1.0 });
    }
    traj
}

/// Find redshift where acceleration begins (q crosses zero).
pub fn acceleration_onset(a_init: f64, dt: f64, max_steps: usize) -> f64 {
    let mut a = a_init;
    let mut q_prev = 1.0;
    for _ in 0..max_steps {
        if a >= 1.0 { break; }
        let q = deceleration_param(a);
        if q_prev > 0.0 && q <= 0.0 { return 1.0/a - 1.0; }
        q_prev = q;
        let k1 = dadt(a);
        let a_mid = a + 0.5 * dt * k1;
        a += dt * dadt(a_mid);
    }
    0.0
}

// ═══════════════════════════════════════════════════════════════
// §4  DISTANCES
// ═══════════════════════════════════════════════════════════════

/// Comoving distance to redshift z (in units of c/H₀).
pub fn comoving_distance(z_target: f64, n_steps: usize) -> f64 {
    let a_target = 1.0 / (1.0 + z_target);
    let da = (1.0 - a_target) / n_steps as f64;
    let mut a = a_target;
    let mut dc = 0.0;
    for _ in 0..n_steps {
        let h = hubble_norm(a);
        dc += da / (a * a * h);
        a += da;
    }
    dc
}

/// Luminosity distance: d_L = (1+z)·d_C.
pub fn luminosity_distance(z: f64, n_steps: usize) -> f64 {
    (1.0 + z) * comoving_distance(z, n_steps)
}

// ═══════════════════════════════════════════════════════════════
// §5  CMB PARAMETERS
// ═══════════════════════════════════════════════════════════════

/// 100θ* = 100/(N_w(D+χ)) = 100/96.
pub fn cmb_100_theta() -> f64 { 100.0 / (N_W * (TOWER_D + CHI)) as f64 }

/// T_CMB = (gauss+χ)/β₀ = 19/7 K.
pub fn cmb_temperature() -> f64 { (GAUSS + CHI) as f64 / BETA0 as f64 }

/// n_s = 1 − κ/D.
pub fn spectral_index() -> f64 { 1.0 - kappa() / TOWER_D as f64 }

/// ln(10¹⁰ A_s) = ln(N_c·β₀) = ln(21).
pub fn scalar_amplitude() -> f64 { (N_C * BETA0) as f64 }
pub fn ln_scalar_amplitude() -> f64 { ((N_C * BETA0) as f64).ln() }

/// Age = gauss + χ/β₀ = 97/7 Gyr.
pub fn age_analytic() -> f64 { GAUSS as f64 + CHI as f64 / BETA0 as f64 }

/// N_eff ≈ N_c + 0.044 = 3.044.
pub fn n_effective() -> f64 { N_C as f64 + 0.044 }

// ═══════════════════════════════════════════════════════════════
// §6  EXTRACTORS
// ═══════════════════════════════════════════════════════════════

pub fn traj_a(traj: &[CosmoState]) -> Vec<f64> { traj.iter().map(|s| s.a).collect() }
pub fn traj_time(traj: &[CosmoState]) -> Vec<f64> { traj.iter().map(|s| s.time).collect() }
pub fn traj_z(traj: &[CosmoState]) -> Vec<f64> { traj.iter().map(|s| s.z).collect() }

// ═══════════════════════════════════════════════════════════════
// §7  INTEGER PROOFS
// ═══════════════════════════════════════════════════════════════

pub const PROVE_OMEGA_L: (u64, u64) = (GAUSS, GAUSS + CHI);         // 13/19
pub const PROVE_OMEGA_M: (u64, u64) = (CHI, GAUSS + CHI);           // 6/19
pub const PROVE_100THETA: (u64, u64) = (100, N_W * (TOWER_D + CHI)); // 100/96
pub const PROVE_TCMB: (u64, u64) = (GAUSS + CHI, BETA0);           // 19/7
pub const PROVE_AGE: (u64, u64) = (GAUSS * BETA0 + CHI, BETA0);     // 97/7
pub const PROVE_AMPLITUDE: u64 = N_C * BETA0;                        // 21
pub const PROVE_MATTER_EXP: u64 = N_C;                               // 3
pub const PROVE_RAD_EXP: u64 = N_C + 1;                              // 4

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn omega_sum_flat() {
        assert!((omega_lambda() + omega_matter() + omega_rad() - 1.0).abs() < 0.001);
    }
    #[test] fn omega_l_13_19() {
        assert!((omega_lambda() - 13.0/19.0).abs() < 1e-10);
    }
    #[test] fn omega_m_6_19() {
        assert!((omega_matter() - 6.0/19.0).abs() < 1e-10);
    }
    #[test] fn dm_baryon_ratio_12pi_7() {
        assert!((dm_baryon_ratio() - 12.0*std::f64::consts::PI/7.0).abs() < 1e-10);
    }
    #[test] fn cmb_temp_19_7() {
        assert!((cmb_temperature() - 19.0/7.0).abs() < 1e-10);
    }
    #[test] fn spectral_ns() {
        assert!((spectral_index() - 0.9649).abs() < 0.005);
    }
    #[test] fn age_97_7() {
        assert!((age_analytic() - 97.0/7.0).abs() < 1e-10);
    }
    #[test] fn friedmann_expands() {
        let traj = integrate_friedmann(0.01, 1.0, 1e-4, 500000);
        assert!(traj.last().unwrap().a > 0.99);
    }
    #[test] fn acceleration_at_z_06() {
        let z = acceleration_onset(0.001, 1e-4, 5000000);
        assert!(z > 0.4 && z < 1.0, "z_accel = {}", z);
    }
    #[test] fn integer_proofs() {
        assert_eq!(PROVE_OMEGA_L, (13, 19));
        assert_eq!(PROVE_OMEGA_M, (6, 19));
        assert_eq!(PROVE_100THETA, (100, 96));
        assert_eq!(PROVE_TCMB, (19, 7));
        assert_eq!(PROVE_AGE, (97, 7));
        assert_eq!(PROVE_AMPLITUDE, 21);
        assert_eq!(PROVE_MATTER_EXP, 3);
        assert_eq!(PROVE_RAD_EXP, 4);
    }
}
