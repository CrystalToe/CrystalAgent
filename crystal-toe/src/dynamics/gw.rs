// Inspiral waveform — Peters 32/5=N_w⁵/(χ−1), chirp 5/3=(χ−1)/N_c
use crate::atoms::*;

pub fn peters_coefficient() -> f64 {
    (N_W as f64).powi(5) / (CHI - 1) as f64 // 32/5
}
pub fn chirp_exponent() -> f64 {
    (CHI - 1) as f64 / N_C as f64 // 5/3
}
pub const GW_POLARIZATIONS: u64 = N_C - 1; // 2
pub const QUADRUPOLE_ORDER: u64 = N_W;      // 2

pub fn chirp_mass(m1: f64, m2: f64) -> f64 {
    let mt = m1 + m2;
    (m1 * m2).powf(chirp_exponent() / (chirp_exponent() + 1.0)) / mt.powf(1.0/5.0)
}

pub fn gw_frequency(m_chirp: f64, t_to_merge: f64) -> f64 {
    let c = peters_coefficient();
    (5.0 / (256.0 * t_to_merge)).powf(3.0/8.0) / (std::f64::consts::PI * m_chirp)
}

pub fn orbital_decay_rate(m1: f64, m2: f64, a: f64) -> f64 {
    -64.0/5.0 * m1 * m2 * (m1+m2) / (a*a*a) // Peters formula structure
}
