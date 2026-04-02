// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// dynamics/plasma.rs — MHD / Plasma Physics from (2,3)
//
// MHD states = d_colour = N_w³ = 8. Wave types = N_c = 3.
// Propagating modes = χ = 6. Non-propagating = N_w = 2.
// Alfvén FDTD = staggered leapfrog (same as EM Yee).

use crate::atoms::*;

#[inline] fn sq(x: f64) -> f64 { x * x }

pub const MHD_STATES: u64 = D_COLOUR;           // 8 = N_w³
pub const WAVE_TYPES: u64 = N_C;                // 3 (slow, Alfvén, fast)
pub const PROPAGATING_MODES: u64 = CHI;         // 6 = 2 × N_c
pub const NON_PROPAGATING: u64 = N_W;           // 2 (entropy + div-B)
pub const IDEAL_MHD_EQUATIONS: u64 = D_COLOUR;  // 8
pub const MAG_PRESSURE_FACTOR: u64 = N_W;       // 2 in B²/(2μ₀)
pub const PLASMA_BETA_FACTOR: u64 = N_W;        // 2 in 2μ₀p/B²

// ═══════════════════════════════════════════════════════════════
// §1  PLASMA FORMULAS
// ═══════════════════════════════════════════════════════════════

/// Alfvén speed: v_A = B/√(μ₀ρ). Normalised: v_A = B/√ρ.
pub fn alfven_speed(b: f64, rho: f64) -> f64 { b / rho.sqrt() }

/// Magnetic pressure: p_mag = B²/(N_w·μ₀) = B²/2.
pub fn mag_pressure(b: f64) -> f64 { sq(b) / N_W as f64 }

/// Plasma beta: β = N_w·μ₀·p/B² = 2p/B².
pub fn plasma_beta(p: f64, b: f64) -> f64 { N_W as f64 * p / sq(b) }

/// Total pressure: p_gas + B²/(2μ₀).
pub fn total_pressure(p_gas: f64, b: f64) -> f64 { p_gas + mag_pressure(b) }

/// Cyclotron frequency: ω_c = qB/m.
pub fn cyclotron_frequency(q: f64, b: f64, m: f64) -> f64 { q * b / m }

/// Debye length: λ_D = √(kT/(nq²)).
pub fn debye_length(kt: f64, n: f64, q: f64) -> f64 { (kt / (n * q * q)).sqrt() }

/// Plasma frequency: ω_p = √(ne²/(ε₀m)). Normalised: ω_p = √(n/m).
pub fn plasma_frequency(n: f64, m: f64) -> f64 { (n / m).sqrt() }

/// Larmor radius: r_L = mv⊥/(qB).
pub fn larmor_radius(m: f64, v_perp: f64, q: f64, b: f64) -> f64 { m * v_perp / (q * b) }

// ═══════════════════════════════════════════════════════════════
// §2  ALFVÉN WAVE FDTD (1D)
//
// dv_y/dt = dB_y/dx,  dB_y/dt = dv_y/dx  (normalised)
// Staggered: v_y on integer grid, B_y on half-integer.
// Same W∘U structure as Yee EM.
// ═══════════════════════════════════════════════════════════════

#[derive(Clone)]
pub struct MHDState {
    pub vy: Vec<f64>,
    pub by: Vec<f64>,
}

/// Sinusoidal initial condition.
pub fn mhd_init(n: usize) -> MHDState {
    let vy: Vec<f64> = (0..n).map(|i| {
        (2.0 * std::f64::consts::PI * i as f64 / n as f64).sin()
    }).collect();
    let by = vec![0.0; n];
    MHDState { vy, by }
}

/// Gaussian pulse initial condition.
pub fn mhd_pulse(n: usize, center: f64, width: f64) -> MHDState {
    let vy: Vec<f64> = (0..n).map(|i| {
        let x = i as f64 / n as f64;
        (-sq((x - center) / width)).exp()
    }).collect();
    let by = vec![0.0; n];
    MHDState { vy, by }
}

/// One FDTD step.
pub fn mhd_step(n: usize, cfl: f64, st: &MHDState) -> MHDState {
    // Update v_y: v_y += cfl * (B_y[i] - B_y[i-1])
    let vy: Vec<f64> = (0..n).map(|i| {
        let b_i = st.by[i];
        let b_im = st.by[(i + n - 1) % n];
        st.vy[i] + cfl * (b_i - b_im)
    }).collect();
    // Update B_y: B_y += cfl * (v_y[i+1] - v_y[i])
    let by: Vec<f64> = (0..n).map(|i| {
        let v_ip = vy[(i + 1) % n];
        let v_i = vy[i];
        st.by[i] + cfl * (v_ip - v_i)
    }).collect();
    MHDState { vy, by }
}

/// Wave energy: E = 0.5·Σ(v_y² + B_y²).
pub fn mhd_energy(st: &MHDState) -> f64 {
    0.5 * (st.vy.iter().map(|v| sq(*v)).sum::<f64>() + st.by.iter().map(|b| sq(*b)).sum::<f64>())
}

/// Evolve n_steps. Returns snapshots at interval.
pub fn mhd_evolve(n_grid: usize, cfl: f64, n_steps: usize, snap_every: usize, st0: &MHDState) -> Vec<MHDState> {
    let mut snaps = vec![st0.clone()];
    let mut st = st0.clone();
    for i in 0..n_steps {
        st = mhd_step(n_grid, cfl, &st);
        if (i + 1) % snap_every == 0 { snaps.push(st.clone()); }
    }
    snaps
}

// ═══════════════════════════════════════════════════════════════
// §3  INTEGER PROOFS
// ═══════════════════════════════════════════════════════════════

pub const PROVE_MHD_STATES: u64 = D_COLOUR;   // 8
pub const PROVE_WAVE_TYPES: u64 = N_C;         // 3
pub const PROVE_PROP_MODES: u64 = CHI;         // 6
pub const PROVE_NON_PROP: u64 = N_W;           // 2
pub const PROVE_TOTAL: u64 = CHI + N_W;        // 8

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn mhd_states_8() { assert_eq!(MHD_STATES, 8); }
    #[test] fn wave_types_3() { assert_eq!(WAVE_TYPES, 3); }
    #[test] fn prop_modes_6() { assert_eq!(PROPAGATING_MODES, 6); }
    #[test] fn non_prop_2() { assert_eq!(NON_PROPAGATING, 2); }
    #[test] fn total_8() { assert_eq!(PROVE_TOTAL, 8); }

    #[test] fn alfven_energy_conserved() {
        let n = 100;
        let st0 = mhd_init(n);
        let e0 = mhd_energy(&st0);
        let mut st = st0;
        for _ in 0..500 { st = mhd_step(n, 0.5, &st); }
        let ef = mhd_energy(&st);
        assert!((ef - e0).abs() / e0 < 0.01, "MHD energy dev: {}", (ef-e0)/e0);
    }

    #[test] fn plasma_beta_unity() {
        // β = 1 when 2p = B²
        let b = 1.0;
        let p = sq(b) / (N_W as f64); // p = B²/2
        assert!((plasma_beta(p, b) - 1.0).abs() < 1e-10);
    }

    #[test] fn pressure_balance() {
        let p = 1.0; let b = 2.0;
        let pt = total_pressure(p, b);
        assert!((pt - (p + sq(b) / 2.0)).abs() < 1e-10);
    }
}
