// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// dynamics/gr.rs — General Relativistic Orbits from (2,3)
//
// Schwarzschild geodesic integration via symplectic leapfrog.
// Every integer: r_s=2(N_c-1), precession=6(χ), bending=4(N_w²),
// ISCO=6(χ)=3(N_c)×r_s, spacetime=4(N_c+1), 16πG=N_w⁴.

use crate::atoms::*;

// ═══════════════════════════════════════════════════════════════
// §0  CRYSTAL CONSTANTS
// ═══════════════════════════════════════════════════════════════

pub const SCHWARZ_FACTOR: u64 = N_C - 1;        // 2 in r_s = 2GM
pub const ISCO_FACTOR: u64 = CHI;               // 6 in r_ISCO = 6GM
pub const PRECESSION_FACTOR: u64 = CHI;         // 6 in δφ = 6πGM/...
pub const BENDING_FACTOR: u64 = N_W * N_W;      // 4 in δθ = 4GM/b
pub const PHOTON_SPHERE: u64 = N_C;             // 3 in r_ph = 3GM
pub const SPACETIME_DIM: u64 = N_C + 1;         // 4
pub const COEFF_16PI_G: u64 = N_W * N_W * N_W * N_W; // 16

#[inline]
fn sq(x: f64) -> f64 { x * x }

// ═══════════════════════════════════════════════════════════════
// §1  SCHWARZSCHILD METRIC
// ═══════════════════════════════════════════════════════════════

/// Schwarzschild radius: r_s = 2GM where 2 = N_c − 1.
pub fn schwarzschild_r(gm: f64) -> f64 {
    SCHWARZ_FACTOR as f64 * gm
}

/// Metric g_tt = -(1 - r_s/r)
pub fn g_tt(rs: f64, r: f64) -> f64 {
    -(1.0 - rs / r)
}

/// Metric g_rr = (1 - r_s/r)^(-1)
pub fn g_rr(rs: f64, r: f64) -> f64 {
    1.0 / (1.0 - rs / r)
}

/// Schwarzschild metric component: 1 - r_s/r
pub fn schwarzschild_metric(r: f64, rs: f64) -> f64 {
    1.0 - rs / r
}

// ═══════════════════════════════════════════════════════════════
// §2  EFFECTIVE POTENTIALS
// ═══════════════════════════════════════════════════════════════

/// Effective potential for massive particle.
pub fn v_eff_massive(rs: f64, ang_l: f64, r: f64) -> f64 {
    let l2 = ang_l * ang_l;
    0.5 * (1.0 - rs / r) * (1.0 + l2 / (r * r))
}

/// Effective potential for photon (null geodesic).
pub fn v_eff_photon(rs: f64, ang_l: f64, r: f64) -> f64 {
    let l2 = ang_l * ang_l;
    0.5 * (1.0 - rs / r) * l2 / (r * r)
}

/// Radial force for massive particle: -dV_eff/dr
/// F = -GM/r² + L²/r³ − N_c·GM·L²/r⁴
pub fn radial_force(rs: f64, ang_l: f64, r: f64) -> f64 {
    let gm = rs / 2.0;
    let l2 = ang_l * ang_l;
    let r2 = r * r;
    let r3 = r2 * r;
    let r4 = r3 * r;
    -gm / r2 + l2 / r3 - N_C as f64 * gm * l2 / r4
}

/// Radial force for photon.
pub fn radial_force_photon(rs: f64, ang_l: f64, r: f64) -> f64 {
    let gm = rs / 2.0;
    let l2 = ang_l * ang_l;
    let r3 = r * r * r;
    let r4 = r3 * r;
    l2 / r3 - N_C as f64 * gm * l2 / r4
}

// ═══════════════════════════════════════════════════════════════
// §3  GR PHASE STATE AND SYMPLECTIC INTEGRATOR
// ═══════════════════════════════════════════════════════════════

/// GR orbital state in equatorial Schwarzschild.
#[derive(Clone, Debug)]
pub struct GRState {
    pub r: f64,      // radial coordinate
    pub vr: f64,     // dr/dtau
    pub phi: f64,    // azimuthal angle
    pub t: f64,      // coordinate time
    pub tau: f64,    // proper time
}

/// One leapfrog tick of the GR geodesic (massive particle).
pub fn gr_tick(dtau: f64, rs: f64, ang_l: f64, energy: f64, gs: &GRState) -> GRState {
    let fr0 = radial_force(rs, ang_l, gs.r);
    let vr_h = gs.vr + (dtau / 2.0) * fr0;
    let r1 = gs.r + dtau * vr_h;
    let fr1 = radial_force(rs, ang_l, r1);
    let vr1 = vr_h + (dtau / 2.0) * fr1;
    let phi1 = gs.phi + dtau * ang_l / (gs.r * gs.r);
    let denom = 1.0 - rs / gs.r;
    let t1 = gs.t + if denom.abs() > 1e-15 { dtau * energy / denom } else { 0.0 };
    GRState { r: r1, vr: vr1, phi: phi1, t: t1, tau: gs.tau + dtau }
}

/// One leapfrog tick for photon geodesic.
pub fn gr_tick_photon(dtau: f64, rs: f64, ang_l: f64, gs: &GRState) -> GRState {
    let fr0 = radial_force_photon(rs, ang_l, gs.r);
    let vr_h = gs.vr + (dtau / 2.0) * fr0;
    let r1 = gs.r + dtau * vr_h;
    let fr1 = radial_force_photon(rs, ang_l, r1);
    let vr1 = vr_h + (dtau / 2.0) * fr1;
    let phi1 = gs.phi + dtau * ang_l / (gs.r * gs.r);
    GRState { r: r1, vr: vr1, phi: phi1, t: gs.t, tau: gs.tau + dtau }
}

/// Evolve GR orbit for n proper-time steps.
pub fn evolve_gr(dtau: f64, rs: f64, ang_l: f64, energy: f64, n: usize, gs0: &GRState) -> Vec<GRState> {
    let mut traj = Vec::with_capacity(n + 1);
    let mut gs = gs0.clone();
    traj.push(gs.clone());
    for _ in 0..n {
        gs = gr_tick(dtau, rs, ang_l, energy, &gs);
        traj.push(gs.clone());
    }
    traj
}

/// Evolve photon geodesic.
pub fn evolve_photon(dtau: f64, rs: f64, ang_l: f64, n: usize, gs0: &GRState) -> Vec<GRState> {
    let mut traj = Vec::with_capacity(n + 1);
    let mut gs = gs0.clone();
    traj.push(gs.clone());
    for _ in 0..n {
        gs = gr_tick_photon(dtau, rs, ang_l, &gs);
        traj.push(gs.clone());
    }
    traj
}

// ═══════════════════════════════════════════════════════════════
// §4  PERIHELION PRECESSION
// ═══════════════════════════════════════════════════════════════

/// Analytic precession: δφ = χ·π·GM/(a(1−e²)) per orbit.
/// The χ = 6 = N_w × N_c.
pub fn precession_analytic(rs: f64, a: f64, e: f64) -> f64 {
    CHI as f64 * std::f64::consts::PI * (rs / 2.0) / (a * (1.0 - e * e))
}

/// Numerical precession by integrating and measuring perihelion advance.
pub fn precession_numerical(gm: f64, a: f64, e: f64, dtau: f64, n_orbits: usize) -> f64 {
    let rs = schwarzschild_r(gm);
    let r_peri = a * (1.0 - e);
    let ang_l = (gm * a * (1.0 - e * e)).sqrt();
    let e_sq = sq(1.0 - rs / r_peri) * (1.0 + sq(ang_l) / sq(r_peri));
    let energy = e_sq.sqrt();
    let gs0 = GRState { r: r_peri, vr: 0.0, phi: 0.0, t: 0.0, tau: 0.0 };
    let t_orbit = 2.0 * std::f64::consts::PI * (a * a * a / gm).sqrt();
    let n_steps = (n_orbits as f64 * t_orbit / dtau) as usize + 1000;
    let traj = evolve_gr(dtau, rs, ang_l, energy, n_steps, &gs0);
    let peris = find_perihelions(&traj);
    if peris.len() < 2 { return 0.0; }
    let total_phi = peris.last().unwrap().phi - peris[0].phi;
    let n_peri = peris.len() - 1;
    (total_phi - n_peri as f64 * 2.0 * std::f64::consts::PI) / n_peri as f64
}

/// Find perihelion passages (vr crosses zero going positive).
pub fn find_perihelions(traj: &[GRState]) -> Vec<GRState> {
    let mut peris = Vec::new();
    for i in 1..traj.len() {
        if traj[i - 1].vr <= 0.0 && traj[i].vr > 0.0 {
            peris.push(traj[i].clone());
        }
    }
    peris
}

// ═══════════════════════════════════════════════════════════════
// §5  LIGHT BENDING
// ═══════════════════════════════════════════════════════════════

/// Analytic light bending: δθ = N_w²·GM/b = 2r_s/b.
pub fn light_bending_analytic(rs: f64, b: f64) -> f64 {
    BENDING_FACTOR as f64 * (rs / 2.0) / b
}

/// Numerical light bending by photon geodesic integration.
pub fn light_bending_numerical(gm: f64, b: f64, dtau: f64, n_steps: usize) -> f64 {
    let rs = schwarzschild_r(gm);
    let r_start = 1000.0 * rs;
    let ang_l = b;
    let vr0 = -(1.0 - sq(b) * (1.0 - rs / r_start) / sq(r_start)).sqrt();
    let gs0 = GRState { r: r_start, vr: vr0, phi: 0.0, t: 0.0, tau: 0.0 };
    let traj = evolve_photon(dtau, rs, ang_l, n_steps, &gs0);
    traj.last().unwrap().phi - std::f64::consts::PI
}

// ═══════════════════════════════════════════════════════════════
// §6  ISCO
// ═══════════════════════════════════════════════════════════════

/// ISCO radius: r_ISCO = N_c · r_s = χ · GM.
pub fn isco_radius(gm: f64) -> f64 {
    N_C as f64 * schwarzschild_r(gm)
}

/// ISCO angular momentum: L = r_s · √N_c.
pub fn isco_angular_momentum(gm: f64) -> f64 {
    schwarzschild_r(gm) * (N_C as f64).sqrt()
}

/// ISCO energy: E = √(d_colour/N_c²) = √(8/9).
pub fn isco_energy() -> f64 {
    ((N_C * N_C - 1) as f64 / (N_C * N_C) as f64).sqrt()
}

// ═══════════════════════════════════════════════════════════════
// §7  SHAPIRO DELAY
// ═══════════════════════════════════════════════════════════════

/// Shapiro delay: Δt = r_s · ln(N_w² · r₁·r₂/b²).
pub fn shapiro_delay(gm: f64, r1: f64, r2: f64, b: f64) -> f64 {
    let rs = schwarzschild_r(gm);
    rs * (BENDING_FACTOR as f64 * r1 * r2 / (b * b)).ln()
}

// ═══════════════════════════════════════════════════════════════
// §8  GRAVITATIONAL REDSHIFT
// ═══════════════════════════════════════════════════════════════

/// Gravitational redshift: z = 1/√(1 − r_s/r) − 1.
pub fn gravitational_redshift(rs: f64, r: f64) -> f64 {
    1.0 / (1.0 - rs / r).sqrt() - 1.0
}

/// Frequency ratio: f_recv/f_emit = √(g_tt_emit / g_tt_recv).
pub fn frequency_ratio(rs: f64, r_emit: f64, r_recv: f64) -> f64 {
    ((1.0 - rs / r_emit) / (1.0 - rs / r_recv)).sqrt()
}

// ═══════════════════════════════════════════════════════════════
// §9  TRAJECTORY EXTRACTORS
// ═══════════════════════════════════════════════════════════════

pub fn traj_r(traj: &[GRState]) -> Vec<f64> { traj.iter().map(|g| g.r).collect() }
pub fn traj_phi(traj: &[GRState]) -> Vec<f64> { traj.iter().map(|g| g.phi).collect() }
pub fn traj_vr(traj: &[GRState]) -> Vec<f64> { traj.iter().map(|g| g.vr).collect() }
pub fn traj_tau(traj: &[GRState]) -> Vec<f64> { traj.iter().map(|g| g.tau).collect() }

/// Convert polar (r, phi) to Cartesian (x, y).
pub fn traj_xy(traj: &[GRState]) -> (Vec<f64>, Vec<f64>) {
    let xs: Vec<f64> = traj.iter().map(|g| g.r * g.phi.cos()).collect();
    let ys: Vec<f64> = traj.iter().map(|g| g.r * g.phi.sin()).collect();
    (xs, ys)
}

/// Effective potential along trajectory.
pub fn traj_veff(rs: f64, ang_l: f64, traj: &[GRState]) -> Vec<f64> {
    traj.iter().map(|g| v_eff_massive(rs, ang_l, g.r)).collect()
}

// ═══════════════════════════════════════════════════════════════
// §10  INTEGER PROOFS
// ═══════════════════════════════════════════════════════════════

pub const PROVE_SCHWARZSCHILD: u64 = N_C - 1;           // 2
pub const PROVE_PRECESSION: u64 = CHI;                   // 6
pub const PROVE_BENDING: u64 = N_W * N_W;                // 4
pub const PROVE_ISCO_6: u64 = CHI;                       // 6
pub const PROVE_ISCO_3: u64 = N_C;                       // 3
pub const PROVE_ISCO_ENERGY: (u64, u64) = (N_C*N_C - 1, N_C*N_C); // (8, 9)
pub const PROVE_SHAPIRO: (u64, u64) = (N_C - 1, N_W*N_W); // (2, 4)
pub const PROVE_SPACETIME: u64 = N_C + 1;                // 4
pub const PROVE_16PI_G: u64 = N_W*N_W*N_W*N_W;           // 16

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn integer_identities() {
        assert_eq!(PROVE_SCHWARZSCHILD, 2);
        assert_eq!(PROVE_PRECESSION, 6);
        assert_eq!(PROVE_BENDING, 4);
        assert_eq!(PROVE_ISCO_6, 6);
        assert_eq!(PROVE_ISCO_3, 3);
        assert_eq!(PROVE_ISCO_ENERGY, (8, 9));
        assert_eq!(PROVE_SHAPIRO, (2, 4));
        assert_eq!(PROVE_SPACETIME, 4);
        assert_eq!(PROVE_16PI_G, 16);
    }

    #[test] fn isco_is_3rs() {
        let gm = 1.0;
        let rs = schwarzschild_r(gm);
        let r_isco = isco_radius(gm);
        assert!((r_isco / rs - 3.0).abs() < 1e-10);
    }

    #[test] fn isco_energy_sqrt89() {
        let e = isco_energy();
        assert!((e - (8.0_f64 / 9.0).sqrt()).abs() < 1e-10);
    }

    #[test] fn mercury_precession() {
        let rs_sun = 2.953;
        let a_merc = 5.791e7;
        let e_merc = 0.2056;
        let prec = precession_analytic(rs_sun, a_merc, e_merc);
        let orbits_per_century = 365.25 * 100.0 / 87.969;
        let arcsec = prec * (180.0 / std::f64::consts::PI) * 3600.0 * orbits_per_century;
        assert!((arcsec - 42.98).abs() < 1.0, "Mercury: {} arcsec/century", arcsec);
    }

    #[test] fn sun_light_bending() {
        let rs_sun = 2.953;
        let r_sun = 6.957e5;
        let bend = light_bending_analytic(rs_sun, r_sun);
        let arcsec = bend * (180.0 / std::f64::consts::PI) * 3600.0;
        assert!((arcsec - 1.75).abs() < 0.02, "Light bending: {} arcsec", arcsec);
    }

    #[test] fn redshift_at_isco() {
        let gm = 1.0;
        let rs = schwarzschild_r(gm);
        let r_isco = isco_radius(gm);
        let z = gravitational_redshift(rs, r_isco);
        assert!(z > 0.0 && z < 1.0);
    }
}
