// Monte Carlo phase space — beta 192=d_mixed·d_colour, sin²θ_W=3/13
use crate::atoms::*;

pub const BETA_FACTOR: u64 = D_MIXED * D_COLOUR; // 192
pub const SIN2_THETA_W_APPROX: (u64,u64) = (N_C, GAUSS); // 3/13
pub const PHASE_SPACE_DIM_3BODY: u64 = N_C * 3 - (N_C + 1); // 5

pub fn fermi_golden_rule(matrix_element_sq: f64, density_of_states: f64) -> f64 {
    2.0 * std::f64::consts::PI * matrix_element_sq * density_of_states
    // 2π = N_w·π, the N_w from Fermi's rule
}

pub fn beta_decay_rate(gf: f64, energy: f64) -> f64 {
    let factor = BETA_FACTOR as f64; // 192
    gf * gf * energy.powi(5) / (factor * std::f64::consts::PI.powi(3))
}

pub fn phase_space_volume_2body(s: f64) -> f64 {
    1.0 / (D_COLOUR as f64 * std::f64::consts::PI) * s.sqrt() // 1/(8π)√s
}
