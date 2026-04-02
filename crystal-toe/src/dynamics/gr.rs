// Schwarzschild geodesic — precession 6=χ, bending 4=N_w², ISCO 6=χ
use crate::atoms::*;

pub const SCHWARZ_FACTOR: u64 = N_W;            // 2 in r_s = 2GM/c²
pub const ISCO_FACTOR: u64 = CHI;               // 6 in r_isco = 6GM/c²
pub const PRECESSION_FACTOR: u64 = CHI;         // 6 in δφ = 6πGM/(ac²(1-e²))
pub const BENDING_FACTOR: u64 = N_W * N_W;      // 4 in δθ = 4GM/(bc²)
pub const PHOTON_SPHERE: u64 = N_C;             // 3 in r_ph = 3GM/c²

pub fn schwarzschild_metric(r: f64, rs: f64) -> f64 {
    1.0 - rs / r // g_tt = 1 - r_s/r
}

pub fn perihelion_precession(gm: f64, a: f64, e: f64) -> f64 {
    CHI as f64 * std::f64::consts::PI * gm / (a * (1.0 - e * e))
}

pub fn light_deflection(gm: f64, b: f64) -> f64 {
    (N_W * N_W) as f64 * gm / b // 4GM/(bc²)
}

pub fn gravitational_redshift(rs: f64, r: f64) -> f64 {
    (1.0 - rs / r).sqrt()
}
