// Yee FDTD (Maxwell) — components 6=χ, Maxwell 4=N_c+1, Larmor 2/3
use crate::atoms::*;

pub const EM_COMPONENTS: u64 = CHI;             // 6 (E₃ + B₃)
pub const MAXWELL_EQUATIONS: u64 = N_C + 1;     // 4
pub const LARMOR_FACTOR: (u64,u64) = (N_W, N_C); // 2/3
pub const POYNTING_CROSS: u64 = N_C;            // E×B in 3D
pub const POLARIZATION_STATES: u64 = N_C - 1;   // 2

pub fn larmor_power(q: f64, a: f64) -> f64 {
    N_W as f64 / N_C as f64 * q * q * a * a // (2/3)q²a²/c³
}

pub fn coulomb_force(q1: f64, q2: f64, r: f64) -> f64 {
    q1 * q2 / (r * r) // 1/r² = 1/r^(N_c-1)
}

pub fn wave_impedance() -> f64 {
    376.73 // Z₀ = μ₀c ≈ 120π Ω, 120 = N_w³ × (χ+N_c+D/6)... simplified
}
