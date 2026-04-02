// Velocity Verlet MD — LJ 6=χ/12=2χ, γ_mono=5/3, γ_di=7/5
use crate::atoms::*;

pub const LJ_ATTRACT: u64 = CHI;               // 6
pub const LJ_REPEL: u64 = 2 * CHI;             // 12
pub const GAMMA_MONO: (u64,u64) = (CHI-1, N_C); // 5/3
pub const GAMMA_DI: (u64,u64) = (BETA0, CHI-1); // 7/5

pub fn lj_potential(r: f64, sigma: f64, eps: f64) -> f64 {
    let sr = sigma / r;
    let sr6 = sr.powi(CHI as i32);      // (σ/r)^6
    let sr12 = sr.powi((2*CHI) as i32); // (σ/r)^12
    4.0 * eps * (sr12 - sr6)
}

pub fn ideal_gas_gamma(dof: u64) -> f64 {
    (dof as f64 + 2.0) / dof as f64 // (f+2)/f
}

pub fn maxwell_speed_rms(kt: f64, m: f64) -> f64 {
    (N_C as f64 * kt / m).sqrt() // √(3kT/m), 3=N_c
}

pub fn equipartition_energy(dof: u64, kt: f64) -> f64 {
    dof as f64 * kt / N_W as f64 // f·kT/2, 2=N_w
}
