// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// dynamics/cfd.rs — Lattice Boltzmann Fluid Dynamics from (2,3)
//
// D2Q9 = N_c². Collision = W (BGK), Streaming = U. Monad S = W∘U.
// Kolmogorov −5/3 = −(χ−1)/N_c. Stokes 24 = d_mixed.

use crate::atoms::*;

pub const D2Q9_VELOCITIES: u64 = N_C * N_C;     // 9
pub const STOKES_DRAG: u64 = D4;                 // 24 = d_mixed
pub const KOLMOGOROV_EXP: (u64, u64) = (CHI - 1, N_C); // 5/3

#[inline] fn sq(x: f64) -> f64 { x * x }

// ═══════════════════════════════════════════════════════════════
// §1  D2Q9 LATTICE
// ═══════════════════════════════════════════════════════════════

const NQ: usize = 9;
const EX: [i32; 9] = [0, 1, 0, -1, 0, 1, -1, -1, 1];
const EY: [i32; 9] = [0, 0, 1, 0, -1, 1, 1, -1, -1];
const OPP: [usize; 9] = [0, 3, 4, 1, 2, 7, 8, 5, 6];

/// Weights: w0=4/9=N_w²/N_c², wC=1/9=1/N_c², wD=1/36=1/Σ_d.
fn weight(q: usize) -> f64 {
    match q {
        0 => (N_W * N_W) as f64 / (N_C * N_C) as f64,      // 4/9
        1..=4 => 1.0 / (N_C * N_C) as f64,                   // 1/9
        _ => 1.0 / SIGMA_D as f64,                            // 1/36
    }
}

/// Speed of sound squared: c_s² = 1/N_c = 1/3.
pub const CS2: f64 = 1.0 / N_C as f64;

// ═══════════════════════════════════════════════════════════════
// §2  LBM STATE
// ═══════════════════════════════════════════════════════════════

/// 2D LBM state. f[q][i*ny + j].
#[derive(Clone)]
pub struct LBMState {
    pub nx: usize,
    pub ny: usize,
    pub f: Vec<Vec<f64>>,  // f[q][i*ny+j]
}

impl LBMState {
    fn idx(&self, i: usize, j: usize) -> usize { i * self.ny + j }

    pub fn density(&self, i: usize, j: usize) -> f64 {
        let idx = self.idx(i, j);
        (0..NQ).map(|q| self.f[q][idx]).sum()
    }

    pub fn velocity_x(&self, i: usize, j: usize) -> f64 {
        let idx = self.idx(i, j);
        let rho = self.density(i, j);
        if rho < 1e-20 { return 0.0; }
        (0..NQ).map(|q| self.f[q][idx] * EX[q] as f64).sum::<f64>() / rho
    }

    pub fn velocity_y(&self, i: usize, j: usize) -> f64 {
        let idx = self.idx(i, j);
        let rho = self.density(i, j);
        if rho < 1e-20 { return 0.0; }
        (0..NQ).map(|q| self.f[q][idx] * EY[q] as f64).sum::<f64>() / rho
    }
}

/// Equilibrium distribution.
fn feq(rho: f64, ux: f64, uy: f64, q: usize) -> f64 {
    let eu = EX[q] as f64 * ux + EY[q] as f64 * uy;
    let u2 = ux * ux + uy * uy;
    weight(q) * rho * (1.0 + eu / CS2 + sq(eu) / (2.0 * sq(CS2)) - u2 / (2.0 * CS2))
}

/// Initialize uniform density, zero velocity.
pub fn lbm_init(nx: usize, ny: usize, rho0: f64) -> LBMState {
    let n = nx * ny;
    let f: Vec<Vec<f64>> = (0..NQ).map(|q| vec![feq(rho0, 0.0, 0.0, q); n]).collect();
    LBMState { nx, ny, f }
}

// ═══════════════════════════════════════════════════════════════
// §3  COLLISION & STREAMING
// ═══════════════════════════════════════════════════════════════

/// One LBM tick: collision (W) + streaming (U).
pub fn lbm_tick(tau: f64, force_x: f64, st: &LBMState) -> LBMState {
    let nx = st.nx; let ny = st.ny; let n = nx * ny;
    let omega = 1.0 / tau;

    // Collision
    let mut f_post = vec![vec![0.0; n]; NQ];
    for i in 0..nx {
        for j in 0..ny {
            let idx = i * ny + j;
            let rho = st.density(i, j);
            let ux0 = st.velocity_x(i, j);
            let ux = ux0 + 0.5 * force_x / rho;
            let uy = st.velocity_y(i, j);
            for q in 0..NQ {
                let f_eq = feq(rho, ux, uy, q);
                let eu = EX[q] as f64 * ux + EY[q] as f64 * uy;
                let s_q = (1.0 - 0.5 * omega) * weight(q)
                    * ((EX[q] as f64 - ux) / CS2 + eu * EX[q] as f64 / (CS2 * CS2)) * force_x;
                f_post[q][idx] = st.f[q][idx] - omega * (st.f[q][idx] - f_eq) + s_q;
            }
        }
    }

    // Streaming (pull, periodic x, bounce-back y walls)
    let mut f_new = vec![vec![0.0; n]; NQ];
    for q in 0..NQ {
        for i in 0..nx {
            for j in 0..ny {
                let si = {
                    let raw = (i as i32) - EX[q] + (nx as i32);
                    (raw % (nx as i32)) as usize
                };
                let sj: i32 = (j as i32) - EY[q];
                let idx = i * ny + j;
                if sj < 0 || sj >= ny as i32 {
                    f_new[q][idx] = f_post[OPP[q]][idx]; // bounce-back
                } else {
                    f_new[q][idx] = f_post[q][si * ny + sj as usize];
                }
            }
        }
    }
    LBMState { nx, ny, f: f_new }
}

/// Evolve n steps. Returns final state.
pub fn lbm_evolve(tau: f64, force_x: f64, n_steps: usize, st: &LBMState) -> LBMState {
    let mut current = st.clone();
    for _ in 0..n_steps { current = lbm_tick(tau, force_x, &current); }
    current
}

/// Total mass (conservation check).
pub fn total_mass(st: &LBMState) -> f64 {
    (0..st.nx).flat_map(|i| (0..st.ny).map(move |j| (i, j)))
        .map(|(i, j)| st.density(i, j)).sum()
}

// ═══════════════════════════════════════════════════════════════
// §4  POISEUILLE ANALYTICAL
// ═══════════════════════════════════════════════════════════════

/// Analytical Poiseuille velocity: u(y) = F/(2ν)·y·(H−y).
pub fn poiseuille_profile(force_x: f64, tau: f64, ny: usize, j: usize) -> f64 {
    let nu = CS2 * (tau - 0.5);
    let h = ny as f64;
    let y = j as f64 + 0.5;
    force_x / (2.0 * nu) * y * (h - y)
}

// ═══════════════════════════════════════════════════════════════
// §5  CFD FORMULAS
// ═══════════════════════════════════════════════════════════════

pub fn stokes_drag_force(mu: f64, r: f64, v: f64) -> f64 {
    CHI as f64 * std::f64::consts::PI * mu * r * v // 6πμrv
}

pub fn reynolds_number(rho: f64, v: f64, l: f64, mu: f64) -> f64 { rho * v * l / mu }

/// Kolmogorov energy spectrum: E(k) ∝ ε^(2/3) k^(−5/3).
pub fn kolmogorov_spectrum(k: f64, eps: f64) -> f64 {
    let exp = (CHI - 1) as f64 / N_C as f64; // 5/3
    eps.powf(2.0 / 3.0) * k.powf(-exp)
}

/// Blasius boundary layer: δ/x ∝ Re^(−1/N_w²) = Re^(−1/4).
pub fn blasius_exponent() -> f64 { 1.0 / (N_W * N_W) as f64 }

/// Von Karman constant: κ = N_w/(χ−1) = 2/5 = 0.4.
pub fn von_karman() -> f64 { N_W as f64 / (CHI - 1) as f64 }

// ═══════════════════════════════════════════════════════════════
// §6  EXTRACTORS
// ═══════════════════════════════════════════════════════════════

/// Extract velocity x-profile at column i.
pub fn velocity_profile_x(st: &LBMState, i: usize) -> Vec<f64> {
    (0..st.ny).map(|j| st.velocity_x(i, j)).collect()
}

/// Extract density field as flat array [i*ny + j].
pub fn density_field(st: &LBMState) -> Vec<f64> {
    (0..st.nx).flat_map(|i| (0..st.ny).map(move |j| st.density(i, j))).collect()
}

/// Extract velocity magnitude field.
pub fn speed_field(st: &LBMState) -> Vec<f64> {
    (0..st.nx).flat_map(|i| (0..st.ny).map(move |j| {
        let ux = st.velocity_x(i, j); let uy = st.velocity_y(i, j);
        (ux*ux + uy*uy).sqrt()
    })).collect()
}

// ═══════════════════════════════════════════════════════════════
// §7  INTEGER PROOFS
// ═══════════════════════════════════════════════════════════════

pub const PROVE_D2Q9: u64 = N_C * N_C;                       // 9
pub const PROVE_KOLMOGOROV: (u64, u64) = (CHI - 1, N_C);     // 5/3
pub const PROVE_STOKES: u64 = D4;                              // 24
pub const PROVE_BLASIUS: (u64, u64) = (1, N_W * N_W);         // 1/4
pub const PROVE_VON_KARMAN: (u64, u64) = (N_W, CHI - 1);     // 2/5
pub const PROVE_WEIGHT_REST: (u64, u64) = (N_W*N_W, N_C*N_C); // 4/9
pub const PROVE_WEIGHT_CARD: (u64, u64) = (1, N_C * N_C);     // 1/9
pub const PROVE_WEIGHT_DIAG: (u64, u64) = (1, SIGMA_D);       // 1/36
pub const PROVE_CS2: (u64, u64) = (1, N_C);                    // 1/3

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn d2q9_is_9() { assert_eq!(PROVE_D2Q9, 9); }
    #[test] fn kolmogorov_5_3() { assert_eq!(PROVE_KOLMOGOROV, (5, 3)); }
    #[test] fn stokes_24() { assert_eq!(PROVE_STOKES, 24); }
    #[test] fn blasius_1_4() { assert_eq!(PROVE_BLASIUS, (1, 4)); }
    #[test] fn von_karman_2_5() { assert_eq!(PROVE_VON_KARMAN, (2, 5)); }
    #[test] fn weights_sum_1() {
        let sum: f64 = (0..NQ).map(weight).sum();
        assert!((sum - 1.0).abs() < 1e-12);
    }
    #[test] fn mass_conserved() {
        let st = lbm_init(10, 8, 1.0);
        let m0 = total_mass(&st);
        let st2 = lbm_evolve(0.8, 1e-5, 50, &st);
        let m1 = total_mass(&st2);
        assert!((m1 - m0).abs() / m0 < 1e-10, "Mass dev: {}", (m1-m0)/m0);
    }
    #[test] fn poiseuille_parabolic() {
        let ny = 20; let tau = 0.8; let fx = 1e-6;
        let st = lbm_init(4, ny, 1.0);
        let st2 = lbm_evolve(tau, fx, 5000, &st);
        let profile = velocity_profile_x(&st2, 1);
        // Should be approximately parabolic
        let u_mid = profile[ny / 2];
        let u_edge = profile[1];
        assert!(u_mid > u_edge, "Not parabolic: mid={} edge={}", u_mid, u_edge);
    }
}
