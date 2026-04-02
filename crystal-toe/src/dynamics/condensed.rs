// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// dynamics/condensed.rs — Ising/BCS from (2,3)
//
// z_square = N_w² = 4. z_cubic = χ = 6. Ising states = N_w = 2.
// Onsager T_c = N_w/ln(1+√N_w). β_crit = 1/N_w³ = 1/8.
// BCS: 2Δ/(kT_c) = N_w·π/e^γ ≈ 3.528.

use crate::atoms::*;

// ═══════════════════════════════════════════════════════════════
// §1  CONDENSED MATTER CONSTANTS
// ═══════════════════════════════════════════════════════════════

pub const ISING_Z_SQUARE: u64 = N_W * N_W;       // 4
pub const ISING_Z_CUBIC: u64 = CHI;               // 6
pub const ISING_STATES: u64 = N_W;                // 2
pub const GROUND_E_PER_SITE: i64 = -(N_W as i64); // -2

/// Onsager T_c = N_w/ln(1+√N_w) ≈ 2.269.
pub fn onsager_tc() -> f64 {
    N_W as f64 / (1.0 + (N_W as f64).sqrt()).ln()
}

/// Critical exponent β = 1/N_w³ = 1/8.
pub fn critical_beta() -> f64 { 1.0 / (N_W * N_W * N_W) as f64 }

/// BCS gap ratio: 2Δ/(kT_c) = N_w·π/e^γ ≈ 3.528.
pub fn bcs_ratio() -> f64 {
    let gamma: f64 = 0.5772156649015329; // Euler-Mascheroni
    N_W as f64 * std::f64::consts::PI / gamma.exp()
}

/// BCS gap: Δ = N_w·ℏω_D·exp(−1/(N(0)V)).
pub fn bcs_gap(nv: f64) -> f64 {
    N_W as f64 * (-1.0 / nv).exp()
}

/// Ising magnetization (mean-field approx below T_c).
pub fn ising_magnetization(t: f64) -> f64 {
    let tc = onsager_tc();
    if t >= tc { 0.0 }
    else { (1.0 - (t / tc).powi(2)).powf(critical_beta()) }
}

// ═══════════════════════════════════════════════════════════════
// §2  LCG PSEUDO-RANDOM NUMBER GENERATOR
// ═══════════════════════════════════════════════════════════════

fn lcg_next(seed: u64) -> u64 {
    (1103515245_u64.wrapping_mul(seed).wrapping_add(12345)) % 2147483648
}

fn lcg_double(seed: u64) -> (f64, u64) {
    let s = lcg_next(seed);
    (s as f64 / 2147483648.0, s)
}

// ═══════════════════════════════════════════════════════════════
// §3  2D ISING MODEL (Metropolis Monte Carlo)
// ═══════════════════════════════════════════════════════════════

/// 2D Ising lattice: n×n with periodic BC. Spins ∈ {+1, −1}.
#[derive(Clone)]
pub struct Lattice {
    pub n: usize,
    pub spins: Vec<i32>,
}

impl Lattice {
    /// All spins = s.
    pub fn new(n: usize, s: i32) -> Self {
        Lattice { n, spins: vec![s; n * n] }
    }

    fn idx(&self, i: usize, j: usize) -> usize { i * self.n + j }

    fn get(&self, i: usize, j: usize) -> i32 {
        self.spins[self.idx(i % self.n, j % self.n)]
    }

    /// Magnetization per site.
    pub fn magnetization(&self) -> f64 {
        let total: i32 = self.spins.iter().sum();
        total as f64 / (self.n * self.n) as f64
    }

    /// Total energy: E = −J Σ_{⟨ij⟩} s_i·s_j.
    pub fn energy(&self) -> i64 {
        let n = self.n;
        let mut e: i64 = 0;
        for i in 0..n {
            for j in 0..n {
                let s = self.get(i, j) as i64;
                let sr = self.get((i + 1) % n, j) as i64;
                let sd = self.get(i, (j + 1) % n) as i64;
                e -= s * sr + s * sd;
            }
        }
        e
    }
}

/// One Metropolis sweep.
pub fn ising_sweep(lat: &mut Lattice, inv_t: f64, seed: &mut u64) {
    let n = lat.n;
    for i in 0..n {
        for j in 0..n {
            let si = lat.get(i, j);
            let sn = lat.get((i + 1) % n, j) + lat.get((i + n - 1) % n, j)
                   + lat.get(i, (j + 1) % n) + lat.get(i, (j + n - 1) % n);
            let de = 2 * si * sn;
            let (r, s) = lcg_double(*seed);
            *seed = s;
            if de <= 0 || r < (-(de as f64) * inv_t).exp() {
                let idx = lat.idx(i, j);
                lat.spins[idx] = -si;
            }
        }
    }
}

/// Run n_sweeps Metropolis sweeps. Returns (magnetizations, energies) sampled every `sample_every`.
pub fn ising_run(lat: &mut Lattice, n_sweeps: usize, inv_t: f64, seed: &mut u64, sample_every: usize) -> (Vec<f64>, Vec<i64>) {
    let mut mags = Vec::new();
    let mut ens = Vec::new();
    for i in 0..n_sweeps {
        ising_sweep(lat, inv_t, seed);
        if (i + 1) % sample_every == 0 {
            mags.push(lat.magnetization());
            ens.push(lat.energy());
        }
    }
    (mags, ens)
}

// ═══════════════════════════════════════════════════════════════
// §4  INTEGER PROOFS
// ═══════════════════════════════════════════════════════════════

pub const PROVE_Z_SQUARE: u64 = N_W * N_W;        // 4
pub const PROVE_Z_CUBIC: u64 = CHI;                // 6
pub const PROVE_STATES: u64 = N_W;                 // 2
pub const PROVE_CRIT_BETA: (u64, u64) = (1, N_W * N_W * N_W); // 1/8
pub const PROVE_GROUND_E: i64 = -(N_W as i64);    // -2
pub const PROVE_BCS_PRE: u64 = N_W;                // 2

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn z_square_4() { assert_eq!(ISING_Z_SQUARE, 4); }
    #[test] fn z_cubic_6() { assert_eq!(ISING_Z_CUBIC, 6); }
    #[test] fn states_2() { assert_eq!(ISING_STATES, 2); }

    #[test] fn onsager_tc_correct() {
        let tc = onsager_tc();
        assert!((tc - 2.2691853142130216).abs() < 1e-10, "T_c = {}", tc);
    }

    #[test] fn bcs_ratio_3528() {
        let r = bcs_ratio();
        assert!((r - 3.5278).abs() < 0.001, "BCS = {}", r);
    }

    #[test] fn ground_energy_all_up() {
        let lat = Lattice::new(8, 1);
        let e = lat.energy();
        assert_eq!(e, -(N_W as i64) * 64); // -2 × 64 = -128
    }

    #[test] fn magnetization_all_up() {
        let lat = Lattice::new(8, 1);
        assert!((lat.magnetization() - 1.0).abs() < 1e-10);
    }

    #[test] fn low_t_ordered() {
        let mut lat = Lattice::new(8, 1);
        let mut seed = TOWER_D as u64;
        ising_run(&mut lat, 1000, 1.0 / 1.0, &mut seed, 100);
        assert!(lat.magnetization().abs() > 0.5);
    }

    #[test] fn high_t_disordered() {
        let mut lat = Lattice::new(8, 1);
        let mut seed = TOWER_D as u64;
        ising_run(&mut lat, 2000, 1.0 / 5.0, &mut seed, 100);
        assert!(lat.magnetization().abs() < 0.5);
    }

    #[test] fn crit_beta_1_8() {
        assert_eq!(PROVE_CRIT_BETA, (1, 8));
    }
}
