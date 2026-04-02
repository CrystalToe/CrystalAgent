// Lane-Emden + stellar scaling — polytrope 3/2=N_c/N_w, Hawking 8=N_w³
use crate::atoms::*;

pub const POLYTROPE_NR: (u64, u64) = (N_C, N_W);    // 3/2
pub const POLYTROPE_REL: u64 = N_C;                   // 3
pub const SCHWARZ: u64 = N_W;                         // 2
pub const HAWKING: u64 = D_COLOUR;                    // 8
pub const SB_DENOM: u64 = N_C * (CHI - 1);           // 15
pub const EDDINGTON: u64 = N_W * N_W;                 // 4
pub const MS_LUM_EXP: (u64, u64) = (BETA0, N_W);     // 7/2
pub const MS_LIFE_EXP: (u64, u64) = (CHI - 1, N_W);  // 5/2
pub const VIRIAL: u64 = N_W;                          // 2
pub const GRAV_PE: (u64, u64) = (N_C, CHI - 1);      // 3/5

pub fn lane_emden(n: f64) -> (f64, f64) {
    let dxi: f64 = 0.0005;
    let eps: f64 = 0.001;
    let mut xi: f64 = eps;
    let mut th: f64 = 1.0 - eps*eps/6.0;
    let mut dth: f64 = -eps/3.0;
    while th > 0.0 && xi < 20.0 {
        let f1 = -th.powf(n) - 2.0*dth/xi;
        let xi2: f64 = xi+0.5*dxi;
        let th2: f64 = th+0.5*dxi*dth;
        let dth2: f64 = dth+0.5*dxi*f1;
        let f2 = -(if th2>0.0{th2.powf(n)}else{0.0}) - 2.0*dth2/xi2;
        th += dxi*dth2; dth += dxi*f2; xi += dxi;
    }
    (xi, -xi*xi*dth)
}
