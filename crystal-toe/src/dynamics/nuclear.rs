// SEMF + shell model — all 7 magic numbers, Fe-56=d_colour·β₀
use crate::atoms::*;

pub fn magic_numbers() -> [u64; 7] {
    [
        N_W,                                     // 2
        D_COLOUR,                                // 8
        N_W * N_W * (CHI - 1),                  // 20
        N_W * N_W * BETA0,                       // 28
        N_W * (CHI - 1) * (CHI - 1),            // 50
        N_W * (TOWER_D - 1),                     // 82
        N_W * BETA0 * N_C * N_C,                // 126
    ]
}

pub const IRON_PEAK_A: u64 = D_COLOUR * BETA0;   // 56
pub const ISOSPIN_STATES: u64 = N_W;              // 2
pub const ALPHA_PARTICLE: u64 = N_W * N_W;        // 4
pub const SURFACE_EXP: (u64, u64) = (N_W, N_C);  // 2/3
pub const COULOMB_EXP: (u64, u64) = (1, N_C);    // 1/3
pub const PAIRING_EXP: (u64, u64) = (1, N_W);    // 1/2

pub fn binding_energy(a: u32, z: u32) -> f64 {
    let af = a as f64; let zf = z as f64;
    let bv = 15.8 * af;
    let bs = 18.3 * af.powf(N_W as f64 / N_C as f64);
    let bc = 0.714 * zf * (zf - 1.0) / af.powf(1.0 / N_C as f64);
    let ba = 23.2 * (af - N_W as f64 * zf).powi(2) / af;
    let bp = if a % 2 == 0 { if z % 2 == 0 { 12.0 } else { -12.0 } } else { 0.0 }
             / af.powf(1.0 / N_W as f64);
    bv - bs - bc - ba + bp
}

pub fn binding_per_nucleon(a: u32, z: u32) -> f64 { binding_energy(a, z) / a as f64 }
