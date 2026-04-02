// S-matrix + running couplings — spacetime 4=N_w², gluons 8=d₃, β₀=7
use crate::atoms::*;

pub const SPACETIME_DIM: u64 = N_W * N_W;           // 4
pub const LORENTZ_GEN: u64 = CHI;                    // 6
pub const DIRAC_GAMMAS: u64 = N_W * N_W;             // 4
pub const PHOTON_POL: u64 = N_C - 1;                 // 2
pub const GLUON_COLOURS: u64 = D3;                   // 8
pub const QCD_BETA0: u64 = BETA0;                    // 7
pub const ONE_LOOP_FACTOR: u64 = N_W * N_W * N_W * N_W; // 16
pub const THOMSON_NUM: u64 = D_COLOUR;               // 8
pub const THOMSON_DEN: u64 = N_C;                    // 3
pub const PROPAGATOR_EXP: u64 = N_C - 1;             // 2

pub fn sigma_ee_mumu(sqrt_s: f64) -> f64 {
    let alpha = 1.0 / ((TOWER_D as f64 + 1.0) * std::f64::consts::PI + (BETA0 as f64).ln());
    let hbarc2 = 0.389379e6; // nb·GeV²
    (N_W * N_W) as f64 * std::f64::consts::PI * alpha * alpha
        / (N_C as f64 * sqrt_s * sqrt_s) * hbarc2
}

pub fn thomson_cs() -> f64 {
    let alpha = 1.0 / ((TOWER_D as f64 + 1.0) * std::f64::consts::PI + (BETA0 as f64).ln());
    let me = 0.51099895e-3; // GeV
    let hbarc = 197.3269804e-3; // GeV·fm
    let re = alpha * hbarc / me;
    D_COLOUR as f64 / N_C as f64 * std::f64::consts::PI * re * re * 0.01
}

pub fn alpha_qcd(lambda: f64, q: f64) -> f64 {
    2.0 * std::f64::consts::PI / (BETA0 as f64 * (q / lambda).ln())
}
