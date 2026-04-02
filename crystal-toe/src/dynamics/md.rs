// Velocity Verlet LJ+Coulomb — bond 109.47°=arccos(-1/N_c), helix=18/5
use crate::atoms::*;

pub fn tetrahedral_angle() -> f64 { (-1.0 / N_C as f64).acos() } // 109.47°
pub fn water_angle() -> f64 { (-1.0 / (N_W*N_W) as f64).acos() } // 104.48°
pub fn helix_per_turn() -> f64 { (N_C*N_C*N_W) as f64 / (CHI-1) as f64 } // 18/5
pub fn flory_nu() -> f64 { N_W as f64 / (CHI-1) as f64 } // 2/5

pub const AMINO_ACIDS: u64 = N_W * N_W * (CHI - 1); // 20
pub const DNA_BASES: u64 = N_W * N_W;                // 4
pub const CODONS: u64 = 64; // (N_w²)^N_c

pub fn lj_force(r: f64, sigma: f64, eps: f64) -> f64 {
    let sr = sigma / r;
    let sr6 = sr.powi(CHI as i32);
    let sr12 = sr6 * sr6;
    24.0 * eps / r * (2.0 * sr12 - sr6) // 24 = d_mixed
}

pub fn coulomb_energy(q1: f64, q2: f64, r: f64, eps_r: f64) -> f64 {
    q1 * q2 / (eps_r * r)
}
