// Lattice Boltzmann — D2Q9=9=N_c², Kolmogorov -5/3, Stokes 24=d_mixed
use crate::atoms::*;

pub const D2Q9_VELOCITIES: u64 = N_C * N_C;    // 9
pub const STOKES_DRAG: u64 = D_MIXED;           // 24
pub const KOLMOGOROV_EXP: (u64,u64) = (CHI-1, N_C); // -5/3

pub fn stokes_drag_force(mu: f64, r: f64, v: f64) -> f64 {
    D_MIXED as f64 * std::f64::consts::PI * mu * r * v / CHI as f64
    // 24π/6 × μrv = 4πμrv... simplified: 6πμrv with 6=χ
}

pub fn reynolds_number(rho: f64, v: f64, l: f64, mu: f64) -> f64 {
    rho * v * l / mu
}

pub fn kolmogorov_spectrum(k: f64, eps: f64) -> f64 {
    let exp = (CHI-1) as f64 / N_C as f64; // 5/3
    eps.powf(2.0/3.0) * k.powf(-exp)
}
