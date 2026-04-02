// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// dynamics/md.rs — Molecular Dynamics from (2,3)
//
// sp3 = acos(−1/N_c) = 109.47°. Water = acos(−1/N_w²) = 104.48°.
// Helix = 18/5 = N_c²N_w/(χ−1). Flory ν = N_w/(χ−1) = 2/5.
// H-bonds: A-T = N_w = 2, G-C = N_c = 3. DNA bases = N_w² = 4.

use crate::atoms::*;

#[inline] fn sq(x: f64) -> f64 { x * x }

// ═══════════════════════════════════════════════════════════════
// §1  MOLECULAR GEOMETRY CONSTANTS
// ═══════════════════════════════════════════════════════════════

/// sp3 tetrahedral angle: acos(−1/N_c) = 109.47°.
pub fn tetrahedral_angle() -> f64 { (-1.0 / N_C as f64).acos() }

/// Water bond angle: acos(−1/N_w²) = 104.48°.
pub fn water_angle() -> f64 { (-1.0 / (N_W * N_W) as f64).acos() }

/// Alpha helix: 18/5 = N_c²·N_w/(χ−1) = 3.6 residues/turn.
pub fn helix_per_turn() -> f64 { (N_C * N_C * N_W) as f64 / (CHI - 1) as f64 }

/// Flory exponent: ν = N_w/(χ−1) = 2/5.
pub fn flory_nu() -> f64 { N_W as f64 / (CHI - 1) as f64 }

pub const AMINO_ACIDS: u64 = N_W * N_W * (CHI - 1);  // 20
pub const DNA_BASES: u64 = N_W * N_W;                  // 4
pub const CODONS: u64 = 64;                             // (N_w²)^N_c = 4³
pub const HBOND_AT: u64 = N_W;                          // 2
pub const HBOND_GC: u64 = N_C;                          // 3
pub const BP_PER_TURN: u64 = N_W * (CHI - 1);          // 10
pub const LJ_POT_COEFF: u64 = N_W * N_W;               // 4
pub const LJ_FORCE_COEFF: u64 = D4;                     // 24 = d_mixed
pub const COULOMB_EXP: u64 = N_C - 1;                   // 2

// ═══════════════════════════════════════════════════════════════
// §2  LJ POTENTIAL & FORCE (reduced units)
// ═══════════════════════════════════════════════════════════════

/// V(r) = 4[(1/r)¹² − (1/r)⁶] = N_w²[(1/r)^(2χ) − (1/r)^χ].
pub fn lj_potential(r: f64) -> f64 {
    let r2 = r * r; let r4 = r2 * r2; let r6 = r4 * r2;
    let r12 = r6 * r6;
    LJ_POT_COEFF as f64 * (1.0 / r12 - 1.0 / r6)
}

/// dV/dr = −2·d_mixed/r¹³ + d_mixed/r⁷.
pub fn lj_dvdr(r: f64) -> f64 {
    let r2 = r * r; let r4 = r2 * r2; let r6 = r4 * r2;
    let r7 = r6 * r; let r12 = r6 * r6; let r13 = r12 * r;
    let dm = LJ_FORCE_COEFF as f64;
    -2.0 * dm / r13 + dm / r7
}

/// LJ force magnitude (with sigma, eps).
pub fn lj_force(r: f64, sigma: f64, eps: f64) -> f64 {
    let sr = sigma / r;
    let sr3 = sr * sr * sr; let sr6 = sr3 * sr3; let sr12 = sr6 * sr6;
    LJ_FORCE_COEFF as f64 * eps / r * (2.0 * sr12 - sr6)
}

// ═══════════════════════════════════════════════════════════════
// §3  2-PARTICLE VELOCITY VERLET
// ═══════════════════════════════════════════════════════════════

#[derive(Clone, Debug)]
pub struct MD2 {
    pub x1: f64, pub v1: f64,
    pub x2: f64, pub v2: f64,
}

impl MD2 {
    pub fn new(x1: f64, v1: f64, x2: f64, v2: f64) -> Self { MD2 { x1, v1, x2, v2 } }

    fn accel(&self) -> (f64, f64) {
        let r = self.x2 - self.x1;
        let f = lj_dvdr(r);
        (f, -f)
    }

    pub fn energy(&self) -> f64 {
        let r = self.x2 - self.x1;
        0.5 * (sq(self.v1) + sq(self.v2)) + lj_potential(r)
    }
}

/// One Velocity Verlet step.
pub fn md2_step(dt: f64, st: &MD2) -> MD2 {
    let (a1, a2) = st.accel();
    let x1 = st.x1 + st.v1 * dt + 0.5 * a1 * dt * dt;
    let x2 = st.x2 + st.v2 * dt + 0.5 * a2 * dt * dt;
    let st2 = MD2::new(x1, 0.0, x2, 0.0);
    let (a1p, a2p) = st2.accel();
    let v1 = st.v1 + 0.5 * (a1 + a1p) * dt;
    let v2 = st.v2 + 0.5 * (a2 + a2p) * dt;
    MD2 { x1, v1, x2, v2 }
}

/// Evolve 2-particle system. Returns (separations, energies).
pub fn md2_evolve(dt: f64, n_steps: usize, st0: &MD2) -> (Vec<f64>, Vec<f64>) {
    let mut seps = Vec::with_capacity(n_steps + 1);
    let mut ens = Vec::with_capacity(n_steps + 1);
    let mut st = st0.clone();
    seps.push(st.x2 - st.x1);
    ens.push(st.energy());
    for _ in 0..n_steps {
        st = md2_step(dt, &st);
        seps.push(st.x2 - st.x1);
        ens.push(st.energy());
    }
    (seps, ens)
}

// ═══════════════════════════════════════════════════════════════
// §4  COULOMB
// ═══════════════════════════════════════════════════════════════

pub fn coulomb_potential(q1: f64, q2: f64, r: f64) -> f64 { q1 * q2 / r }
pub fn coulomb_force(q1: f64, q2: f64, r: f64) -> f64 { q1 * q2 / (r * r) }
pub fn coulomb_energy(q1: f64, q2: f64, r: f64, eps_r: f64) -> f64 { q1 * q2 / (eps_r * r) }

// ═══════════════════════════════════════════════════════════════
// §5  LJ POTENTIAL CURVE GENERATOR
// ═══════════════════════════════════════════════════════════════

/// Generate LJ potential + force curves. Returns (r, V, F).
pub fn lj_curves(r_min: f64, r_max: f64, n_points: usize) -> (Vec<f64>, Vec<f64>, Vec<f64>) {
    let dr = (r_max - r_min) / n_points as f64;
    let rs: Vec<f64> = (0..n_points).map(|i| r_min + (i as f64 + 0.5) * dr).collect();
    let vs: Vec<f64> = rs.iter().map(|&r| lj_potential(r)).collect();
    let fs: Vec<f64> = rs.iter().map(|&r| -lj_dvdr(r)).collect();
    (rs, vs, fs)
}

// ═══════════════════════════════════════════════════════════════
// §6  INTEGER PROOFS
// ═══════════════════════════════════════════════════════════════

pub const PROVE_LJ_ATT: u64 = CHI;                          // 6
pub const PROVE_LJ_REP: u64 = 2 * CHI;                      // 12
pub const PROVE_LJ_POT: u64 = N_W * N_W;                    // 4
pub const PROVE_LJ_FORCE: u64 = D4;                          // 24
pub const PROVE_TETRA_DEN: u64 = N_C;                        // 3
pub const PROVE_HBOND_AT: u64 = N_W;                         // 2
pub const PROVE_HBOND_GC: u64 = N_C;                         // 3
pub const PROVE_HELIX: (u64, u64) = (N_C * N_C * N_W, CHI - 1); // 18/5
pub const PROVE_FLORY: (u64, u64) = (N_W, CHI - 1);         // 2/5
pub const PROVE_COULOMB: u64 = N_C - 1;                      // 2
pub const PROVE_AMINO: u64 = N_W * N_W * (CHI - 1);         // 20
pub const PROVE_DNA: u64 = N_W * N_W;                        // 4
pub const PROVE_BP_TURN: u64 = N_W * (CHI - 1);             // 10

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn tetra_angle_109() {
        let deg = tetrahedral_angle().to_degrees();
        assert!((deg - 109.47).abs() < 0.01, "tetra = {}°", deg);
    }
    #[test] fn water_angle_104() {
        let deg = water_angle().to_degrees();
        assert!((deg - 104.48).abs() < 0.01, "water = {}°", deg);
    }
    #[test] fn helix_3_6() {
        assert!((helix_per_turn() - 3.6).abs() < 1e-10);
    }
    #[test] fn flory_2_5() {
        assert!((flory_nu() - 0.4).abs() < 1e-10);
    }
    #[test] fn amino_20() { assert_eq!(AMINO_ACIDS, 20); }
    #[test] fn dna_4() { assert_eq!(DNA_BASES, 4); }
    #[test] fn bp_turn_10() { assert_eq!(BP_PER_TURN, 10); }
    #[test] fn lj_min_at_minus_eps() {
        let r_min = 2.0_f64.powf(1.0 / 6.0);
        let v = lj_potential(r_min);
        assert!((v + 1.0).abs() < 1e-10);
    }
    #[test] fn lj_zero_at_sigma() {
        assert!(lj_potential(1.0).abs() < 1e-10);
    }
    #[test] fn md2_energy_conserved() {
        let st = MD2::new(0.0, 0.0, 1.5, 0.3);
        let e0 = st.energy();
        let (_, ens) = md2_evolve(0.001, 5000, &st);
        let max_dev = ens.iter().map(|e| (e - e0).abs() / e0.abs()).fold(0.0_f64, f64::max);
        assert!(max_dev < 0.01, "MD energy dev: {}", max_dev);
    }
    #[test] fn integer_proofs() {
        assert_eq!(PROVE_LJ_ATT, 6);
        assert_eq!(PROVE_LJ_REP, 12);
        assert_eq!(PROVE_LJ_POT, 4);
        assert_eq!(PROVE_LJ_FORCE, 24);
        assert_eq!(PROVE_AMINO, 20);
        assert_eq!(PROVE_DNA, 4);
    }
}
