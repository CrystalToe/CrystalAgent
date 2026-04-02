// Störmer-Verlet leapfrog — force 2=N_c−1, dim 3=N_c, phase 6=χ
use crate::atoms::*;

pub const SPATIAL_DIM: u64 = N_C;               // 3
pub const PHASE_SPACE_DIM: u64 = CHI;           // 6 = 2×3
pub const FORCE_EXPONENT: u64 = N_C - 1;        // 2 (inverse-square)
pub const KEPLER_THIRD: (u64,u64) = (N_C, N_W); // 3/2

pub fn verlet_step(x: f64, v: f64, a: f64, dt: f64) -> (f64, f64) {
    let x1 = x + v * dt + 0.5 * a * dt * dt;
    (x1, v + a * dt) // velocity updated after new force eval in practice
}

pub fn gravitational_accel(m: f64, r: f64) -> f64 {
    -m / (r * r) // inverse-square: exponent N_c-1 = 2
}

pub fn kepler_period(a: f64, m: f64) -> f64 {
    2.0 * std::f64::consts::PI * (a.powi(N_C as i32) / m).sqrt()
}

pub fn angular_momentum(r: f64, v_perp: f64) -> f64 {
    r * v_perp // L = r × v⊥, conserved in central force
}
