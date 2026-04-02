// Barnes-Hut + leapfrog — octree 8=d_colour=N_w³
use crate::atoms::*;

pub const OCTREE_CHILDREN: u64 = D_COLOUR;     // 8 = N_w³
pub const BH_THETA: f64 = 0.5;                  // 1/N_w = opening angle
pub const SOFTENING_EXP: u64 = N_C - 1;        // 2 (gravitational)

pub fn should_open_node(node_size: f64, distance: f64) -> bool {
    node_size / distance > 1.0 / N_W as f64
}

pub fn softened_force(m1: f64, m2: f64, r: f64, eps: f64) -> f64 {
    -m1 * m2 / ((r*r + eps*eps).powf((N_C as f64) / 2.0)) * r
}
