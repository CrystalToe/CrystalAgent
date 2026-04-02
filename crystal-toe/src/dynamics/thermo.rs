// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// dynamics/thermo.rs — Thermodynamic Dynamics from (2,3)
//
// LJ 6-12 = χ / 2χ. Velocity Verlet = W∘U∘W.
// γ_mono = 5/3 = (χ−1)/N_c. γ_di = 7/5 = β₀/(χ−1).
// Force prefactor 24 = d_mixed. Stokes drag 24 = d_mixed.

use crate::atoms::*;

pub const LJ_ATTRACT: u64 = CHI;                // 6
pub const LJ_REPEL: u64 = 2 * CHI;              // 12
pub const LJ_FORCE_PREFACTOR: u64 = D4;         // 24 = d_mixed
pub const DOF_MONO: u64 = N_C;                  // 3
pub const DOF_DI: u64 = CHI - 1;                // 5
pub const STOKES_DRAG: u64 = D4;                // 24

#[inline] fn sq(x: f64) -> f64 { x * x }

// ═══════════════════════════════════════════════════════════════
// §1  LENNARD-JONES POTENTIAL
// ═══════════════════════════════════════════════════════════════

/// V(r) = 4ε[(σ/r)¹² − (σ/r)⁶]. 12 = 2χ, 6 = χ.
pub fn lj_potential(eps: f64, sigma: f64, r: f64) -> f64 {
    let sr = sigma / r;
    let sr3 = sr * sr * sr;
    let sr6 = sr3 * sr3;       // (σ/r)^χ
    let sr12 = sr6 * sr6;      // (σ/r)^(2χ)
    4.0 * eps * (sr12 - sr6)
}

/// F = 24ε/r [2(σ/r)¹² − (σ/r)⁶]. 24 = d_mixed.
pub fn lj_force_mag(eps: f64, sigma: f64, r: f64) -> f64 {
    let sr = sigma / r;
    let sr3 = sr * sr * sr;
    let sr6 = sr3 * sr3;
    let sr12 = sr6 * sr6;
    D4 as f64 * eps / r * (2.0 * sr12 - sr6)
}

// ═══════════════════════════════════════════════════════════════
// §2  PARTICLE TYPE
// ═══════════════════════════════════════════════════════════════

#[derive(Clone, Debug)]
pub struct Particle {
    pub x: f64, pub y: f64, pub z: f64,
    pub vx: f64, pub vy: f64, pub vz: f64,
    pub m: f64,
}

impl Particle {
    pub fn new(x: f64, y: f64, z: f64, vx: f64, vy: f64, vz: f64, m: f64) -> Self {
        Particle { x, y, z, vx, vy, vz, m }
    }
}

/// LJ acceleration on particle i from all others.
fn lj_accel(eps: f64, sigma: f64, cutoff: f64, parts: &[Particle], idx: usize) -> (f64, f64, f64) {
    let pi = &parts[idx];
    let mut ax = 0.0; let mut ay = 0.0; let mut az = 0.0;
    for (j, pj) in parts.iter().enumerate() {
        if j == idx { continue; }
        let dx = pi.x - pj.x; let dy = pi.y - pj.y; let dz = pi.z - pj.z;
        let r2 = dx*dx + dy*dy + dz*dz;
        let r = r2.sqrt();
        if r > cutoff || r < 1e-10 { continue; }
        let fmag = lj_force_mag(eps, sigma, r) / (pi.m * r);
        ax -= fmag * dx; ay -= fmag * dy; az -= fmag * dz;
    }
    (ax, ay, az)
}

// ═══════════════════════════════════════════════════════════════
// §3  VELOCITY VERLET (W∘U∘W)
// ═══════════════════════════════════════════════════════════════

/// One Verlet tick for all particles.
pub fn thermo_tick(dt: f64, eps: f64, sigma: f64, cutoff: f64, parts: &[Particle]) -> Vec<Particle> {
    let n = parts.len();
    let accels: Vec<_> = (0..n).map(|i| lj_accel(eps, sigma, cutoff, parts, i)).collect();
    // W: half-kick
    let parts1: Vec<Particle> = parts.iter().zip(accels.iter()).map(|(p, &(ax,ay,az))| {
        Particle { vx: p.vx+(dt/2.0)*ax, vy: p.vy+(dt/2.0)*ay, vz: p.vz+(dt/2.0)*az, ..*p }
    }).collect();
    // U: full drift
    let parts2: Vec<Particle> = parts1.iter().map(|p| {
        Particle { x: p.x+dt*p.vx, y: p.y+dt*p.vy, z: p.z+dt*p.vz, ..*p }
    }).collect();
    // W: half-kick at new positions
    let accels2: Vec<_> = (0..n).map(|i| lj_accel(eps, sigma, cutoff, &parts2, i)).collect();
    parts2.iter().zip(accels2.iter()).map(|(p, &(ax,ay,az))| {
        Particle { vx: p.vx+(dt/2.0)*ax, vy: p.vy+(dt/2.0)*ay, vz: p.vz+(dt/2.0)*az, ..*p }
    }).collect()
}

/// Evolve n steps. Returns snapshots at interval.
pub fn evolve_thermo(dt: f64, eps: f64, sigma: f64, cutoff: f64, n_steps: usize, snap_every: usize, parts: &[Particle]) -> Vec<Vec<Particle>> {
    let mut snaps = vec![parts.to_vec()];
    let mut current = parts.to_vec();
    for i in 0..n_steps {
        current = thermo_tick(dt, eps, sigma, cutoff, &current);
        if (i + 1) % snap_every == 0 { snaps.push(current.clone()); }
    }
    snaps
}

// ═══════════════════════════════════════════════════════════════
// §4  THERMODYNAMIC QUANTITIES
// ═══════════════════════════════════════════════════════════════

pub fn kinetic_energy(parts: &[Particle]) -> f64 {
    parts.iter().map(|p| 0.5 * p.m * (sq(p.vx)+sq(p.vy)+sq(p.vz))).sum()
}

/// T = 2KE / (N_dof). N_dof = N_c per particle.
pub fn temperature(parts: &[Particle]) -> f64 {
    let ndof = N_C as f64 * parts.len() as f64;
    2.0 * kinetic_energy(parts) / ndof
}

pub fn potential_energy(eps: f64, sigma: f64, cutoff: f64, parts: &[Particle]) -> f64 {
    let mut pe = 0.0;
    for i in 0..parts.len() {
        for j in (i+1)..parts.len() {
            let dx = parts[i].x-parts[j].x; let dy = parts[i].y-parts[j].y; let dz = parts[i].z-parts[j].z;
            let r = (dx*dx+dy*dy+dz*dz).sqrt();
            if r < cutoff && r > 1e-10 { pe += lj_potential(eps, sigma, r); }
        }
    }
    pe
}

pub fn total_energy(eps: f64, sigma: f64, cutoff: f64, parts: &[Particle]) -> f64 {
    kinetic_energy(parts) + potential_energy(eps, sigma, cutoff, parts)
}

// ═══════════════════════════════════════════════════════════════
// §5  CONSTANTS FROM (2,3)
// ═══════════════════════════════════════════════════════════════

pub fn gamma_monatomic() -> f64 { (CHI - 1) as f64 / N_C as f64 }       // 5/3
pub fn gamma_diatomic() -> f64 { BETA0 as f64 / (CHI - 1) as f64 }      // 7/5
pub fn carnot_efficiency() -> f64 { (CHI - 1) as f64 / CHI as f64 }      // 5/6
pub fn entropy_per_tick() -> f64 { (CHI as f64).ln() }                    // ln(6)
pub fn ideal_gas_gamma(dof: u64) -> f64 { (dof as f64 + 2.0) / dof as f64 }
pub fn maxwell_speed_rms(kt: f64, m: f64) -> f64 { (N_C as f64 * kt / m).sqrt() }
pub fn equipartition_energy(dof: u64, kt: f64) -> f64 { dof as f64 * kt / N_W as f64 }

// ═══════════════════════════════════════════════════════════════
// §6  INITIAL CONDITIONS
// ═══════════════════════════════════════════════════════════════

/// Create gas particles in a line with thermal velocities.
pub fn make_gas(n: usize, temp: f64, spacing: f64) -> Vec<Particle> {
    (1..=n).map(|i| {
        let fi = i as f64;
        let x = spacing * (fi - n as f64 / 2.0);
        Particle::new(x, 0.0, 0.0,
            temp * (fi * 3.14).sin(), temp * (fi * 2.71).cos(), temp * (fi * 1.41 + 1.0).sin(), 1.0)
    }).collect()
}

/// Create 2D grid of particles.
pub fn make_lattice_2d(nx: usize, ny: usize, spacing: f64, temp: f64) -> Vec<Particle> {
    let mut parts = Vec::new();
    for i in 0..nx {
        for j in 0..ny {
            let x = i as f64 * spacing; let y = j as f64 * spacing;
            let fi = (i * ny + j) as f64;
            let vx = temp * (fi * 2.13).sin(); let vy = temp * (fi * 3.71).cos();
            parts.push(Particle::new(x, y, 0.0, vx, vy, 0.0, 1.0));
        }
    }
    parts
}

// ═══════════════════════════════════════════════════════════════
// TESTS
// ═══════════════════════════════════════════════════════════════

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn lj_attract_6() { assert_eq!(LJ_ATTRACT, 6); }
    #[test] fn lj_repel_12() { assert_eq!(LJ_REPEL, 12); }
    #[test] fn lj_force_24() { assert_eq!(LJ_FORCE_PREFACTOR, 24); }
    #[test] fn dof_mono_3() { assert_eq!(DOF_MONO, 3); }
    #[test] fn dof_di_5() { assert_eq!(DOF_DI, 5); }

    #[test] fn gamma_mono_5_3() {
        assert!((gamma_monatomic() - 5.0/3.0).abs() < 1e-10);
    }
    #[test] fn gamma_di_7_5() {
        assert!((gamma_diatomic() - 7.0/5.0).abs() < 1e-10);
    }
    #[test] fn lj_minimum_at_minus_eps() {
        let r_min = 2.0_f64.powf(1.0/6.0);
        let v = lj_potential(1.0, 1.0, r_min);
        assert!((v + 1.0).abs() < 1e-10); // V(r_min) = -ε
    }
    #[test] fn lj_zero_at_sigma() {
        assert!(lj_potential(1.0, 1.0, 1.0).abs() < 1e-10);
    }
    #[test] fn md_energy_conserved() {
        let gas = make_gas(4, 0.05, 3.0);
        let e0 = total_energy(1.0, 1.0, 5.0, &gas);
        let mut current = gas;
        let mut max_dev = 0.0_f64;
        for _ in 0..200 {
            current = thermo_tick(0.002, 1.0, 1.0, 5.0, &current);
            let e = total_energy(1.0, 1.0, 5.0, &current);
            max_dev = max_dev.max((e - e0).abs() / (e0.abs() + 1e-20));
        }
        assert!(max_dev < 0.01, "Energy dev: {}", max_dev);
    }
    #[test] fn temperature_positive() {
        let gas = make_gas(10, 0.5, 2.0);
        assert!(temperature(&gas) > 0.0);
    }
    #[test] fn carnot_5_6() {
        assert!((carnot_efficiency() - 5.0/6.0).abs() < 1e-10);
    }
}
