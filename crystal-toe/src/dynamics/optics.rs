// Snell + Fresnel — n_water=4/3=C_F, n_glass=3/2=N_c/N_w
use crate::atoms::*;

pub fn n_water() -> f64 { (N_C*N_C - 1) as f64 / (2*N_C) as f64 } // C_F = 4/3
pub fn n_glass() -> f64 { N_C as f64 / N_W as f64 }                 // 3/2
pub fn n_diamond() -> f64 { (N_W * N_W + N_C * N_C) as f64 / (CHI - 1) as f64 } // 13/5=2.6

pub const RAYLEIGH_LAMBDA_EXP: u64 = N_W * N_W; // 4 in λ⁻⁴
pub const RAYLEIGH_SIZE_EXP: u64 = CHI;          // 6 in d⁶
pub const PLANCK_LAMBDA_EXP: u64 = CHI - 1;     // 5 in λ⁻⁵

pub fn snell(n1: f64, theta1: f64, n2: f64) -> f64 {
    (n1 * theta1.sin() / n2).asin()
}

pub fn brewster_angle(n1: f64, n2: f64) -> f64 {
    (n2 / n1).atan()
}

pub fn critical_angle(n1: f64, n2: f64) -> Option<f64> {
    if n1 > n2 { Some((n2/n1).asin()) } else { None }
}
