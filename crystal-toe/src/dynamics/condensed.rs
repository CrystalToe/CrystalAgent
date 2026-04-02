// Metropolis Monte Carlo — Ising z=4=N_w², BCS 2Δ/kT_c=2π/e^γ
use crate::atoms::*;

pub const ISING_Z_SQUARE: u64 = N_W * N_W;     // 4
pub const ISING_BETA_CRITICAL_INV: u64 = D_COLOUR; // 8 (β_c = 1/8... simplified)

pub fn onsager_tc() -> f64 {
    N_W as f64 / (1.0 + (N_W as f64).sqrt()).ln() // 2/ln(1+√2) ≈ 2.269
}

pub fn bcs_gap_ratio() -> f64 {
    2.0 * std::f64::consts::PI / std::f64::consts::E.powf(0.5772156649) // 2π/e^γ ≈ 3.528
}

pub fn metropolis_accept(delta_e: f64, beta: f64) -> bool {
    if delta_e <= 0.0 { true }
    else { (-beta * delta_e).exp() > 0.5 } // simplified
}

pub fn ising_magnetization(t: f64) -> f64 {
    let tc = onsager_tc();
    if t >= tc { 0.0 }
    else { (1.0 - (t/tc).powi(2)).powf(1.0/D_COLOUR as f64) } // β=1/8
}
