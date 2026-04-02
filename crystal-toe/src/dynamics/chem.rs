// Orbitals, Arrhenius — f-shell 14=N_w·β₀, Kr Z=36=Σd, pH=7=β₀
use crate::atoms::*;

pub const S_CAPACITY: u64 = N_W;                     // 2
pub const P_CAPACITY: u64 = CHI;                      // 6
pub const D_CAPACITY: u64 = N_W * (CHI - 1);         // 10
pub const F_CAPACITY: u64 = N_W * BETA0;              // 14
pub const NOBLE_HE: u64 = N_W;                        // 2
pub const NOBLE_NE: u64 = N_W * (CHI - 1);           // 10
pub const NOBLE_AR: u64 = N_W * N_C * N_C;           // 18
pub const NOBLE_KR: u64 = SIGMA_D;                    // 36!
pub const NEUTRAL_PH: u64 = BETA0;                    // 7

pub fn sp3_angle() -> f64 { (-1.0 / N_C as f64).acos() }
pub fn sp2_angle() -> f64 { 2.0 * std::f64::consts::PI / N_C as f64 }
pub fn water_angle() -> f64 { (-1.0 / (N_W * N_W) as f64).acos() }
pub fn shell_capacity(n: u64) -> u64 { N_W * n * n }

pub fn arrhenius(ea: f64, kt: f64) -> f64 { (-ea / kt).exp() }
