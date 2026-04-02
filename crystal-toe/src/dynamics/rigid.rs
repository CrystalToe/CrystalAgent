// Quaternion Euler equations — quaternion 4=N_w², I_sphere=2/5=Flory, inertia 6=χ
use crate::atoms::*;

pub const QUAT_COMPONENTS: u64 = N_W * N_W;         // 4
pub const INERTIA_INDEP: u64 = CHI;                  // 6
pub const RIGID_DOF: u64 = CHI;                      // 6
pub const ROT_MATRIX: u64 = N_C * N_C;              // 9
pub const EULER_ANGLES: u64 = N_C;                   // 3

pub fn i_sphere(m: f64, r: f64) -> f64 {
    N_W as f64 / (CHI - 1) as f64 * m * r * r // 2/5 MR²
}
pub fn i_rod(m: f64, l: f64) -> f64 {
    m * l * l / (2 * CHI) as f64 // 1/12 ML²
}
pub fn i_disk(m: f64, r: f64) -> f64 {
    m * r * r / N_W as f64 // 1/2 MR²
}
pub fn i_shell(m: f64, r: f64) -> f64 {
    N_W as f64 / N_C as f64 * m * r * r // 2/3 MR²
}
pub fn i_sphere_factor() -> f64 { N_W as f64 / (CHI - 1) as f64 } // 2/5 = Flory!
