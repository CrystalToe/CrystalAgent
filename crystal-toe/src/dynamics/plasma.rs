// Alfvén FDTD (EM+CFD capstone) — MHD modes 8=N_w³, wave types 3=N_c
use crate::atoms::*;

pub const MHD_STATES: u64 = D_COLOUR;           // 8 = N_w³ (ρ,ρv₃,B₃,E)
pub const WAVE_TYPES: u64 = N_C;                // 3 (Alfvén, fast, slow)
pub const PROPAGATING_MODES: u64 = CHI;         // 6
pub const IDEAL_MHD_EQUATIONS: u64 = D_COLOUR;  // 8

pub fn alfven_speed(b: f64, rho: f64) -> f64 {
    b / rho.sqrt() // v_A = B/√(μ₀ρ)
}

pub fn plasma_beta(p: f64, b: f64) -> f64 {
    N_W as f64 * p / (b * b) // β = 2p/B², 2=N_w
}

pub fn cyclotron_frequency(q: f64, b: f64, m: f64) -> f64 {
    q * b / m // ω_c = qB/m
}

pub fn debye_length(kt: f64, n: f64, q: f64) -> f64 {
    (kt / (n * q * q)).sqrt() // λ_D = √(kT/(nq²))
}
