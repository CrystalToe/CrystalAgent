// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// dynamics/classical.rs — From Monad to Orbits (FULL PORT)
//
// Symplectic leapfrog integrator = classical limit of monad S = W∘U∘W.
// Full Kepler orbits, conservation proofs, Hohmann transfers, slingshots.
// Every integer from (N_w, N_c) = (2, 3).

use crate::atoms::*;

// ═══════════════════════════════════════════════════════════════
// §0  CRYSTAL CONSTANTS
// ═══════════════════════════════════════════════════════════════

pub const SPATIAL_DIM: u64 = N_C;               // 3
pub const PHASE_SPACE_DIM: u64 = CHI;           // 6 = 2×3
pub const FORCE_EXPONENT: u64 = N_C - 1;        // 2 (inverse-square)

#[inline]
fn sq(x: f64) -> f64 { x * x }

// ═══════════════════════════════════════════════════════════════
// §1  VECTOR3 — position/velocity in R^N_c
// ═══════════════════════════════════════════════════════════════

#[derive(Clone, Copy, Debug, Default, PartialEq)]
pub struct Vec3 {
    pub x: f64,
    pub y: f64,
    pub z: f64,
}

impl Vec3 {
    pub fn new(x: f64, y: f64, z: f64) -> Self { Vec3 { x, y, z } }
    pub fn zero() -> Self { Vec3 { x: 0.0, y: 0.0, z: 0.0 } }
    pub fn norm2(&self) -> f64 { sq(self.x) + sq(self.y) + sq(self.z) }
    pub fn norm(&self) -> f64 { self.norm2().sqrt() }
    pub fn scale(&self, s: f64) -> Vec3 { Vec3 { x: self.x * s, y: self.y * s, z: self.z * s } }
    pub fn add(&self, o: &Vec3) -> Vec3 { Vec3 { x: self.x + o.x, y: self.y + o.y, z: self.z + o.z } }
    pub fn sub(&self, o: &Vec3) -> Vec3 { Vec3 { x: self.x - o.x, y: self.y - o.y, z: self.z - o.z } }
    pub fn dot(&self, o: &Vec3) -> f64 { self.x * o.x + self.y * o.y + self.z * o.z }

    /// Cross product in N_c = 3 dimensions.
    pub fn cross(&self, o: &Vec3) -> Vec3 {
        Vec3 {
            x: self.y * o.z - self.z * o.y,
            y: self.z * o.x - self.x * o.z,
            z: self.x * o.y - self.y * o.x,
        }
    }
}

impl std::ops::Add for Vec3 {
    type Output = Vec3;
    fn add(self, rhs: Vec3) -> Vec3 { Vec3::add(&self, &rhs) }
}

impl std::ops::Sub for Vec3 {
    type Output = Vec3;
    fn sub(self, rhs: Vec3) -> Vec3 { Vec3::sub(&self, &rhs) }
}

impl std::ops::Mul<f64> for Vec3 {
    type Output = Vec3;
    fn mul(self, rhs: f64) -> Vec3 { self.scale(rhs) }
}

// ═══════════════════════════════════════════════════════════════
// §2  PHASE STATE — (position, velocity) in R^N_c × R^N_c
// ═══════════════════════════════════════════════════════════════

#[derive(Clone, Debug)]
pub struct PhaseState {
    pub pos: Vec3,
    pub vel: Vec3,
}

impl PhaseState {
    pub fn new(pos: Vec3, vel: Vec3) -> Self { PhaseState { pos, vel } }
}

// ═══════════════════════════════════════════════════════════════
// §3  EMERGENT NEWTON
// ═══════════════════════════════════════════════════════════════

/// Gravitational acceleration in N_c = 3 dimensions.
/// a = -GM × r_hat / |r|² (inverse-square: exponent N_c - 1 = 2).
pub fn newton_accel(gm: f64, pos: &Vec3) -> Vec3 {
    let r2 = pos.norm2();
    let r = r2.sqrt();
    let r3 = r * r2;
    pos.scale(-gm / r3)
}

// ═══════════════════════════════════════════════════════════════
// §4  SYMPLECTIC INTEGRATOR (Leapfrog / Störmer-Verlet)
//
// Leapfrog = classical limit of monad S = W∘U∘W:
//   W = half-kick (velocity update)
//   U = full drift (position update)
//   W = half-kick
// Symplectic → preserves phase space volume → energy conserved.
// ═══════════════════════════════════════════════════════════════

/// One tick of the classical monad (Leapfrog).
pub fn classical_tick<F>(dt: f64, accel: &F, ps: &PhaseState) -> PhaseState
where
    F: Fn(&Vec3) -> Vec3,
{
    // W: half-kick
    let a0 = accel(&ps.pos);
    let v_half = ps.vel + a0 * (dt / 2.0);
    // U: full drift
    let x1 = ps.pos + v_half * dt;
    // W: half-kick with new acceleration
    let a1 = accel(&x1);
    let v1 = v_half + a1 * (dt / 2.0);
    PhaseState { pos: x1, vel: v1 }
}

/// Evolve for n ticks, returning full trajectory.
pub fn evolve<F>(dt: f64, accel: &F, n: usize, ps0: &PhaseState) -> Vec<PhaseState>
where
    F: Fn(&Vec3) -> Vec3,
{
    let mut traj = Vec::with_capacity(n + 1);
    let mut ps = ps0.clone();
    traj.push(ps.clone());
    for _ in 0..n {
        ps = classical_tick(dt, accel, &ps);
        traj.push(ps.clone());
    }
    traj
}

/// Evolve returning only final state (memory efficient for long runs).
pub fn evolve_final<F>(dt: f64, accel: &F, n: usize, ps0: &PhaseState) -> PhaseState
where
    F: Fn(&Vec3) -> Vec3,
{
    let mut ps = ps0.clone();
    for _ in 0..n {
        ps = classical_tick(dt, accel, &ps);
    }
    ps
}

// ═══════════════════════════════════════════════════════════════
// §5  KEPLER ORBIT
// ═══════════════════════════════════════════════════════════════

/// Evolve a Kepler orbit (central body at origin).
pub fn kepler_orbit(gm: f64, ps0: &PhaseState, dt: f64, n: usize) -> Vec<PhaseState> {
    evolve(dt, &|pos: &Vec3| newton_accel(gm, pos), n, ps0)
}

/// Analytic Kepler period: T = 2π √(a³/GM)
pub fn kepler_period(a: f64, gm: f64) -> f64 {
    2.0 * std::f64::consts::PI * (a.powi(N_C as i32) / gm).sqrt()
}

// ═══════════════════════════════════════════════════════════════
// §6  CONSERVED QUANTITIES (Noether charges)
// ═══════════════════════════════════════════════════════════════

/// Orbital energy: E = ½v² − GM/r
pub fn orbital_energy(gm: f64, ps: &PhaseState) -> f64 {
    0.5 * ps.vel.norm2() - gm / ps.pos.norm()
}

/// Angular momentum vector: L = r × v (cross product in N_c = 3).
pub fn angular_momentum_vec(ps: &PhaseState) -> Vec3 {
    ps.pos.cross(&ps.vel)
}

/// Angular momentum magnitude: |L|.
pub fn angular_momentum_mag(ps: &PhaseState) -> f64 {
    angular_momentum_vec(ps).norm()
}

/// Eccentricity vector (Laplace-Runge-Lenz): e = (v × L)/GM − r_hat.
pub fn eccentricity_vector(gm: f64, ps: &PhaseState) -> Vec3 {
    let l = angular_momentum_vec(ps);
    let r = ps.pos.norm();
    let r_hat = ps.pos.scale(1.0 / r);
    let vxl = ps.vel.cross(&l);
    vxl.scale(1.0 / gm) - r_hat
}

/// Scalar eccentricity.
pub fn eccentricity(gm: f64, ps: &PhaseState) -> f64 {
    eccentricity_vector(gm, ps).norm()
}

/// Check energy conservation over a trajectory.
/// Returns maximum relative deviation.
pub fn energy_deviation(gm: f64, traj: &[PhaseState]) -> f64 {
    if traj.is_empty() { return 0.0; }
    let e0 = orbital_energy(gm, &traj[0]);
    traj.iter()
        .map(|ps| (orbital_energy(gm, ps) - e0).abs() / e0.abs())
        .fold(0.0_f64, f64::max)
}

/// Check angular momentum conservation over a trajectory.
/// Returns maximum relative deviation.
pub fn angular_momentum_deviation(traj: &[PhaseState]) -> f64 {
    if traj.is_empty() { return 0.0; }
    let l0 = angular_momentum_mag(&traj[0]);
    traj.iter()
        .map(|ps| (angular_momentum_mag(ps) - l0).abs() / l0.abs())
        .fold(0.0_f64, f64::max)
}

// ═══════════════════════════════════════════════════════════════
// §7  SATELLITE LEO
// ═══════════════════════════════════════════════════════════════

/// Circular orbit at radius r. Returns (state, v_circular, period).
pub fn satellite_circular(gm: f64, r: f64) -> (PhaseState, f64, f64) {
    let vc = (gm / r).sqrt();
    let t = kepler_period(r, gm);
    let ps = PhaseState {
        pos: Vec3::new(r, 0.0, 0.0),
        vel: Vec3::new(0.0, vc, 0.0),
    };
    (ps, vc, t)
}

/// Elliptical orbit with given semi-major axis and eccentricity.
/// Starts at periapsis.
pub fn orbit_elliptical(gm: f64, a: f64, ecc: f64) -> PhaseState {
    let r_peri = a * (1.0 - ecc);
    let v_peri = ((gm / a) * (1.0 + ecc) / (1.0 - ecc)).sqrt();
    PhaseState {
        pos: Vec3::new(r_peri, 0.0, 0.0),
        vel: Vec3::new(0.0, v_peri, 0.0),
    }
}

/// Find y-axis zero crossings in a trajectory (for period measurement).
pub fn find_zero_crossings(dt: f64, traj: &[PhaseState]) -> Vec<f64> {
    let mut crossings = Vec::new();
    for i in 11..traj.len() {
        let y1 = traj[i - 1].pos.y;
        let y2 = traj[i].pos.y;
        if y1 <= 0.0 && y2 > 0.0 {
            let frac = (-y1) / (y2 - y1);
            crossings.push((i as f64 + frac) * dt);
        }
    }
    crossings
}

// ═══════════════════════════════════════════════════════════════
// §8  N-BODY ACCELERATION
// ═══════════════════════════════════════════════════════════════

/// N-body gravitational acceleration on a test body from multiple sources.
pub fn accel_nbody(bodies: &[(f64, Vec3)], pos: &Vec3) -> Vec3 {
    let mut acc = Vec3::zero();
    for &(gm, ref b_pos) in bodies {
        let dr = *pos - *b_pos;
        let r2 = dr.norm2();
        let r = r2.sqrt();
        let r3 = r * r2;
        if r2 > 1e-20 {
            acc = acc + dr.scale(-gm / r3);
        }
    }
    acc
}

/// Slingshot gravity assist around a moon.
pub fn slingshot(
    gm_primary: f64, gm_secondary: f64, secondary_pos: Vec3,
    sc0: &PhaseState, dt: f64, n: usize,
) -> Vec<PhaseState> {
    let bodies = vec![
        (gm_primary, Vec3::zero()),
        (gm_secondary, secondary_pos),
    ];
    evolve(dt, &|pos: &Vec3| accel_nbody(&bodies, pos), n, sc0)
}

// ═══════════════════════════════════════════════════════════════
// §9  HOHMANN TRANSFER
// ═══════════════════════════════════════════════════════════════

/// Vis-viva equation: v = √(GM(2/r − 1/a))
pub fn vis_viva(gm: f64, r: f64, a: f64) -> f64 {
    (gm * (2.0 / r - 1.0 / a)).sqrt()
}

/// Hohmann transfer orbit between two circular orbits.
/// Returns (delta_v1, delta_v2, transfer_time).
pub fn hohmann_transfer(gm: f64, r1: f64, r2: f64) -> (f64, f64, f64) {
    let a_t = (r1 + r2) / 2.0;
    let dv1 = vis_viva(gm, r1, a_t) - vis_viva(gm, r1, r1);
    let dv2 = vis_viva(gm, r2, r2) - vis_viva(gm, r2, a_t);
    let t_t = std::f64::consts::PI * (a_t.powi(3) / gm).sqrt();
    (dv1, dv2, t_t)
}

/// Bi-elliptic transfer (three burns). Returns (dv1, dv2, dv3, time).
pub fn bielliptic_transfer(gm: f64, r1: f64, r2: f64, r_intermediate: f64) -> (f64, f64, f64, f64) {
    let a1 = (r1 + r_intermediate) / 2.0;
    let a2 = (r_intermediate + r2) / 2.0;
    let dv1 = vis_viva(gm, r1, a1) - vis_viva(gm, r1, r1);
    let dv2 = vis_viva(gm, r_intermediate, a2) - vis_viva(gm, r_intermediate, a1);
    let dv3 = vis_viva(gm, r2, r2) - vis_viva(gm, r2, a2);
    let t1 = std::f64::consts::PI * (a1.powi(3) / gm).sqrt();
    let t2 = std::f64::consts::PI * (a2.powi(3) / gm).sqrt();
    (dv1, dv2, dv3, t1 + t2)
}

/// Escape velocity at radius r: v_esc = √(2GM/r)
pub fn escape_velocity(gm: f64, r: f64) -> f64 {
    (2.0 * gm / r).sqrt()
}

// ═══════════════════════════════════════════════════════════════
// §10  COORDINATE EXTRACTORS (for plotting)
// ═══════════════════════════════════════════════════════════════

/// Extract x coordinates from trajectory.
pub fn traj_x(traj: &[PhaseState]) -> Vec<f64> {
    traj.iter().map(|ps| ps.pos.x).collect()
}

/// Extract y coordinates from trajectory.
pub fn traj_y(traj: &[PhaseState]) -> Vec<f64> {
    traj.iter().map(|ps| ps.pos.y).collect()
}

/// Extract z coordinates from trajectory.
pub fn traj_z(traj: &[PhaseState]) -> Vec<f64> {
    traj.iter().map(|ps| ps.pos.z).collect()
}

/// Extract radii from trajectory.
pub fn traj_r(traj: &[PhaseState]) -> Vec<f64> {
    traj.iter().map(|ps| ps.pos.norm()).collect()
}

/// Extract speeds from trajectory.
pub fn traj_speed(traj: &[PhaseState]) -> Vec<f64> {
    traj.iter().map(|ps| ps.vel.norm()).collect()
}

/// Extract energies from trajectory.
pub fn traj_energy(gm: f64, traj: &[PhaseState]) -> Vec<f64> {
    traj.iter().map(|ps| orbital_energy(gm, ps)).collect()
}

/// Extract angular momentum magnitudes from trajectory.
pub fn traj_angular_momentum(traj: &[PhaseState]) -> Vec<f64> {
    traj.iter().map(|ps| angular_momentum_mag(ps)).collect()
}

/// Time array: [0, dt, 2*dt, ..., n*dt]
pub fn traj_time(dt: f64, n: usize) -> Vec<f64> {
    (0..=n).map(|i| i as f64 * dt).collect()
}

// ═══════════════════════════════════════════════════════════════
// §11  INTEGER IDENTITY PROOFS
// ═══════════════════════════════════════════════════════════════

pub const PROVE_FORCE_EXPONENT: u64 = N_C - 1;                  // 2
pub const PROVE_SPATIAL_DIM: u64 = N_C;                          // 3
pub const PROVE_PHASE_DECOMP: (u64, u64) = (GAUSS - N_C, D3);  // (10, 8)
pub const PROVE_KEPLER_EXP: u64 = N_C;                          // 3
pub const PROVE_KEPLER_4PI2: u64 = N_W * N_W;                   // 4
pub const PROVE_ANG_MOM_COMPONENTS: u64 = N_C * (N_C - 1) / 2; // 3
pub const PROVE_LAGRANGE_POINTS: u64 = CHI - 1;                 // 5
pub const PROVE_QUADRUPOLE: (u64, u64) = (N_W * N_W * N_W * N_W * N_W, CHI - 1); // (32, 5)

// ═══════════════════════════════════════════════════════════════
// TESTS
// ═══════════════════════════════════════════════════════════════

#[cfg(test)]
mod tests {
    use super::*;

    const GM_EARTH: f64 = 3.986004418e5;
    const R_EARTH: f64 = 6371.0;
    const R_LEO: f64 = R_EARTH + 400.0;

    #[test]
    fn integer_identities() {
        assert_eq!(PROVE_FORCE_EXPONENT, 2);
        assert_eq!(PROVE_SPATIAL_DIM, 3);
        assert_eq!(PROVE_PHASE_DECOMP, (10, 8));
        assert_eq!(PROVE_KEPLER_EXP, 3);
        assert_eq!(PROVE_KEPLER_4PI2, 4);
        assert_eq!(PROVE_ANG_MOM_COMPONENTS, 3);
        assert_eq!(PROVE_LAGRANGE_POINTS, 5);
        assert_eq!(PROVE_QUADRUPOLE, (32, 5));
    }

    #[test]
    fn circular_orbit_energy_conserved() {
        let (ps0, _, period) = satellite_circular(GM_EARTH, R_LEO);
        let dt = 1.0;
        let n = (period / dt) as usize + 100;
        let traj = kepler_orbit(GM_EARTH, &ps0, dt, n);
        let dev = energy_deviation(GM_EARTH, &traj);
        assert!(dev < 1e-6, "Energy deviation: {}", dev);
    }

    #[test]
    fn circular_orbit_angular_momentum_conserved() {
        let (ps0, _, period) = satellite_circular(GM_EARTH, R_LEO);
        let dt = 1.0;
        let n = (period / dt) as usize + 100;
        let traj = kepler_orbit(GM_EARTH, &ps0, dt, n);
        let dev = angular_momentum_deviation(&traj);
        assert!(dev < 1e-10, "L deviation: {}", dev);
    }

    #[test]
    fn kepler_period_matches() {
        let (ps0, _, t_analytic) = satellite_circular(GM_EARTH, R_LEO);
        let dt = 1.0;
        let n = (2.0 * t_analytic / dt) as usize;
        let traj = kepler_orbit(GM_EARTH, &ps0, dt, n);
        let crossings = find_zero_crossings(dt, &traj);
        assert!(!crossings.is_empty(), "No zero crossings found");
        let t_numerical = crossings[0];
        let rel_err = (t_numerical - t_analytic).abs() / t_analytic;
        assert!(rel_err < 0.001, "Period error: {:.4}%", rel_err * 100.0);
    }

    #[test]
    fn vis_viva_consistency() {
        let gm = 1.0;
        let r = 2.0;
        let a = 3.0;
        let v = vis_viva(gm, r, a);
        let e1 = 0.5 * v * v - gm / r;
        let e2 = -gm / (2.0 * a);
        assert!((e1 - e2).abs() < 1e-12);
    }

    #[test]
    fn hohmann_earth_mars() {
        let mu_sun = 1.327124e11;
        let r_earth = 1.496e8;
        let r_mars = 2.279e8;
        let (dv1, dv2, t) = hohmann_transfer(mu_sun, r_earth, r_mars);
        // dV total should be ~5-6 km/s
        let dv_total = dv1.abs() + dv2.abs();
        assert!(dv_total > 4.0 && dv_total < 8.0, "Hohmann dV: {}", dv_total);
        // Transfer time ~259 days
        let days = t / 86400.0;
        assert!(days > 200.0 && days < 300.0, "Transfer days: {}", days);
    }

    #[test]
    fn elliptical_orbit_conserves_energy() {
        let gm = 1.0;
        let ps0 = orbit_elliptical(gm, 5.0, 0.6);
        let period = kepler_period(5.0, gm);
        let dt = period / 1000.0;
        let n = 2000;
        let traj = kepler_orbit(gm, &ps0, dt, n);
        let dev = energy_deviation(gm, &traj);
        assert!(dev < 1e-3, "Elliptical energy dev: {}", dev);
    }

    #[test]
    fn escape_velocity_formula() {
        let gm = GM_EARTH;
        let r = R_LEO;
        let v_esc = escape_velocity(gm, r);
        let (_, v_circ, _) = satellite_circular(gm, r);
        // v_esc = √2 × v_circ
        let ratio = v_esc / v_circ;
        assert!((ratio - std::f64::consts::SQRT_2).abs() < 1e-10);
    }
}
