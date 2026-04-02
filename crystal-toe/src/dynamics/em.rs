// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// dynamics/em.rs — Electromagnetic Field Evolution from (2,3)
//
// Yee FDTD = monad S = W∘U on EM sector.
// χ = 6 components (E₃ + B₃). Maxwell = N_c + 1 = 4 equations.
// Larmor 2/3 = (N_c−1)/N_c. Rayleigh λ⁻⁴ = λ^(−N_w²).
// Planck λ⁻⁵ = λ^(−(χ−1)). Stefan T⁴ = T^(N_w²).

use crate::atoms::*;

pub const EM_COMPONENTS: u64 = CHI;             // 6
pub const E_COMPONENTS: u64 = N_C;              // 3
pub const B_COMPONENTS: u64 = N_C;              // 3
pub const MAXWELL_EQUATIONS: u64 = N_C + 1;     // 4
pub const TWO_FORM_DIM: u64 = (N_C + 1) * N_C / 2; // C(4,2) = 6 = χ
pub const POLARIZATION_STATES: u64 = N_C - 1;   // 2
pub const RAYLEIGH_WAVE_EXP: u64 = N_W * N_W;   // 4
pub const RAYLEIGH_SIZE_EXP: u64 = CHI;          // 6
pub const PLANCK_EXPONENT: u64 = CHI - 1;        // 5
pub const STEFAN_EXPONENT: u64 = N_W * N_W;      // 4
pub const STEFAN_DENOM: u64 = N_C * (CHI - 1);   // 15

#[inline] fn sq(x: f64) -> f64 { x * x }

// ═══════════════════════════════════════════════════════════════
// §1  1D YEE FDTD
// ═══════════════════════════════════════════════════════════════

/// 1D EM field: E_y on integer grid, B_z on half-integer grid.
#[derive(Clone, Debug)]
pub struct EMState1D {
    pub ey: Vec<f64>,
    pub bz: Vec<f64>,
    pub time: f64,
}

/// One Yee tick. B update = W (kick), E update = U (drift).
pub fn em_tick_1d(courant: f64, st: &EMState1D) -> EMState1D {
    let n = st.ey.len();
    // W: dB/dt = −dE/dx
    let bz: Vec<f64> = st.bz.iter().enumerate().map(|(i, &b)| {
        b - courant * (st.ey[i + 1] - st.ey[i])
    }).collect();
    // U: dE/dt = dB/dx (PEC boundaries)
    let mut ey = vec![0.0; n];
    for i in 1..n - 1 {
        ey[i] = st.ey[i] - courant * (bz[i] - bz[i - 1]);
    }
    EMState1D { ey, bz, time: st.time + courant }
}

/// Gaussian pulse initial condition.
pub fn gaussian_pulse(n_grid: usize, center: f64, width: f64, amp: f64) -> EMState1D {
    let dx = 1.0 / n_grid as f64;
    let ey: Vec<f64> = (0..n_grid).map(|i| {
        amp * (-sq((i as f64 * dx - center) / width)).exp()
    }).collect();
    let bz = vec![0.0; n_grid - 1];
    EMState1D { ey, bz, time: 0.0 }
}

/// Evolve for n steps. Returns snapshots at given interval.
pub fn evolve_em(courant: f64, n_steps: usize, snap_every: usize, st0: &EMState1D) -> Vec<EMState1D> {
    let mut snaps = Vec::new();
    let mut st = st0.clone();
    snaps.push(st.clone());
    for i in 0..n_steps {
        st = em_tick_1d(courant, &st);
        if (i + 1) % snap_every == 0 {
            snaps.push(st.clone());
        }
    }
    snaps
}

/// Total EM energy: (E² + B²) / 2.
pub fn em_energy_1d(st: &EMState1D) -> f64 {
    let e_en: f64 = st.ey.iter().map(|&e| sq(e)).sum::<f64>() / 2.0;
    let b_en: f64 = st.bz.iter().map(|&b| sq(b)).sum::<f64>() / 2.0;
    e_en + b_en
}

// ═══════════════════════════════════════════════════════════════
// §2  RADIATION FORMULAS
// ═══════════════════════════════════════════════════════════════

/// Larmor power: P = (N_c−1)/N_c × q² × a² = (2/3)q²a².
pub fn larmor_power(q: f64, accel: f64) -> f64 {
    (N_C - 1) as f64 / N_C as f64 * sq(q) * sq(accel)
}

/// Coulomb force: F = q₁q₂/r² (1/r^(N_c−1)).
pub fn coulomb_force(q1: f64, q2: f64, r: f64) -> f64 {
    q1 * q2 / sq(r)
}

/// Rayleigh scattering cross-section ∝ d^χ / λ^(N_w²).
pub fn rayleigh_sigma(diam: f64, wavelength: f64) -> f64 {
    diam.powi(CHI as i32) / wavelength.powi((N_W * N_W) as i32)
}

/// Sky blue ratio: σ_blue/σ_red = (λ_red/λ_blue)^(N_w²).
pub fn sky_blue_ratio(lambda_blue: f64, lambda_red: f64) -> f64 {
    (lambda_red / lambda_blue).powi((N_W * N_W) as i32)
}

/// Planck spectral radiance ∝ λ^(−(χ−1)) at peak.
pub fn planck_radiance(wavelength: f64, temp: f64) -> f64 {
    let exp = PLANCK_EXPONENT as f64; // 5
    let x = 1.0 / (wavelength * temp); // hc/(λkT) proxy
    wavelength.powf(-exp) / (x.exp() - 1.0)
}

/// Stefan-Boltzmann: P ∝ T^(N_w²) = T⁴.
pub fn stefan_boltzmann_power(temp: f64) -> f64 {
    temp.powi(STEFAN_EXPONENT as i32)
}

/// Wave impedance Z₀ ≈ 120π Ω. 120 = N_w × N_c × (gauss + β₀).
pub fn wave_impedance() -> f64 {
    (N_W * N_C * (GAUSS + BETA0)) as f64 * std::f64::consts::PI
}

// ═══════════════════════════════════════════════════════════════
// §3  EXTRACTORS
// ═══════════════════════════════════════════════════════════════

pub fn snap_ey(snaps: &[EMState1D]) -> Vec<Vec<f64>> {
    snaps.iter().map(|s| s.ey.clone()).collect()
}
pub fn snap_bz(snaps: &[EMState1D]) -> Vec<Vec<f64>> {
    snaps.iter().map(|s| s.bz.clone()).collect()
}
pub fn snap_energy(snaps: &[EMState1D]) -> Vec<f64> {
    snaps.iter().map(em_energy_1d).collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn em_components_6() { assert_eq!(EM_COMPONENTS, 6); }
    #[test] fn two_form_chi() { assert_eq!(TWO_FORM_DIM, CHI); }
    #[test] fn maxwell_4() { assert_eq!(MAXWELL_EQUATIONS, 4); }
    #[test] fn polarizations_2() { assert_eq!(POLARIZATION_STATES, 2); }
    #[test] fn planck_5() { assert_eq!(PLANCK_EXPONENT, 5); }
    #[test] fn stefan_4() { assert_eq!(STEFAN_EXPONENT, 4); }
    #[test] fn stefan_denom_15() { assert_eq!(STEFAN_DENOM, 15); }
    #[test] fn rayleigh_wave_4() { assert_eq!(RAYLEIGH_WAVE_EXP, 4); }
    #[test] fn rayleigh_size_6() { assert_eq!(RAYLEIGH_SIZE_EXP, 6); }

    #[test] fn larmor_2_3() {
        assert!((larmor_power(1.0, 1.0) - 2.0/3.0).abs() < 1e-12);
    }
    #[test] fn larmor_scales() {
        let p = larmor_power(2.0, 3.0);
        assert!((p - 2.0/3.0 * 4.0 * 9.0).abs() < 1e-10);
    }
    #[test] fn rayleigh_inverse_fourth() {
        let s1 = rayleigh_sigma(1e-6, 500e-9);
        let s2 = rayleigh_sigma(1e-6, 1000e-9);
        assert!((s1/s2 - 16.0).abs() < 1e-6); // 2^4 = 16
    }
    #[test] fn yee_energy_conserved() {
        let st0 = gaussian_pulse(200, 0.3, 0.05, 1.0);
        let e0 = em_energy_1d(&st0);
        let mut st = st0;
        for _ in 0..200 { st = em_tick_1d(0.5, &st); }
        let ef = em_energy_1d(&st);
        assert!((ef - e0).abs() / e0 < 0.01);
    }
    #[test] fn yee_pulse_propagates() {
        let st0 = gaussian_pulse(200, 0.3, 0.05, 1.0);
        let ey0 = st0.ey.clone();
        let mut st = st0;
        for _ in 0..200 { st = em_tick_1d(0.5, &st); }
        let diff: f64 = ey0.iter().zip(st.ey.iter()).map(|(a,b)| (a-b).abs()).sum();
        assert!(diff > 0.1);
    }
    #[test] fn impedance_120pi() {
        assert!((wave_impedance() - 120.0 * std::f64::consts::PI).abs() < 1e-10);
    }
}
