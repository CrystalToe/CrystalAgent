// Fixed-point + LOD wrappers — LJ cutoff=N_cσ, BH θ=1/N_w
use crate::atoms::*;

pub const LJ_CUTOFF: u64 = N_C;                      // 3
pub const BH_THETA_DEN: u64 = N_W;                   // 2 (θ=1/2)
pub const OCTREE_CHILDREN: u64 = D_COLOUR;            // 8
pub const EULER_ORDER: u64 = 1;                       // d₁
pub const VERLET_ORDER: u64 = N_W;                    // 2
pub const FIXED_BITS: u64 = N_W * N_W * N_W * N_W;  // 16
pub const HASH_CELLS: u64 = N_C;                      // 3
pub const LOD_LEVELS: u64 = N_C;                      // 3
pub const MF_TC: u64 = N_W * N_W;                    // 4
pub const NEWTON_ITER: u64 = N_W;                     // 2
pub const FAST_ALPHA_INV: u64 = 137;                  // floor(43π+ln7)

pub fn wca_cutoff() -> f64 { (N_W as f64).powf(1.0 / CHI as f64) } // 2^(1/6)
pub fn bh_theta() -> f64 { 1.0 / N_W as f64 }
pub fn fixed_resolution() -> f64 { 1.0 / (1u64 << FIXED_BITS) as f64 }
