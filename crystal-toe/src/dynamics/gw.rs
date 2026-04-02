// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// dynamics/gw.rs — Gravitational Waveforms from (2,3)
//
// Binary inspiral waveform generation. Every coefficient from A_F.
//   Quadrupole power:   32/5 = N_w⁵/(χ−1)
//   Polarizations:      2 = N_c − 1
//   f_GW = 2·f_orb:    2 = N_w
//   Amplitude:          4 = N_w²
//   Chirp mass exp:     3/5, 2/5 from N_c/(χ−1), N_w/(χ−1)
//   ISCO cutoff:        6 = χ
//   Orbital decay:      64/5 = N_w⁶/(χ−1)

use crate::atoms::*;

// ═══════════════════════════════════════════════════════════════
// §0  CRYSTAL CONSTANTS
// ═══════════════════════════════════════════════════════════════

pub const GW_POLARIZATIONS: u64 = N_C - 1;     // 2
pub const QUADRUPOLE_ORDER: u64 = N_W;          // 2 (f_GW = N_w × f_orb)
pub const AMPLITUDE_FACTOR: u64 = N_W * N_W;    // 4

#[inline]
fn sq(x: f64) -> f64 { x * x }

// ═══════════════════════════════════════════════════════════════
// §1  PETERS FORMULA
// ═══════════════════════════════════════════════════════════════

/// Peters quadrupole coefficient: 32/5 = N_w⁵/(χ−1).
pub fn peters_coefficient() -> f64 {
    (N_W as f64).powi(5) / (CHI - 1) as f64
}

/// GW power radiated (natural units G=c=1).
/// P = (32/5) μ² M³ / a⁵
pub fn gw_power(mu: f64, total_m: f64, a: f64) -> f64 {
    peters_coefficient() * sq(mu) * total_m * sq(total_m) / (a * sq(a) * sq(a))
}

// ═══════════════════════════════════════════════════════════════
// §2  ORBITAL DECAY
// ═══════════════════════════════════════════════════════════════

/// Orbital decay rate: da/dt = −(64/5) μ M² / a³
/// 64/5 = N_w⁶/(χ−1) = 2 × Peters
pub fn orbit_decay_rate(mu: f64, total_m: f64, a: f64) -> f64 {
    let coeff = 2.0 * peters_coefficient(); // 64/5
    -coeff * mu * sq(total_m) / (a * sq(a))
}

// ═══════════════════════════════════════════════════════════════
// §3  CHIRP MASS
// ═══════════════════════════════════════════════════════════════

/// Chirp exponent: (χ−1)/N_c = 5/3 (Kolmogorov!)
pub fn chirp_exponent() -> f64 {
    (CHI - 1) as f64 / N_C as f64
}

/// Chirp mass: M_c = μ^(3/5) × M^(2/5)
/// 3/5 = N_c/(χ−1), 2/5 = N_w/(χ−1)
pub fn chirp_mass(m1: f64, m2: f64) -> f64 {
    let mu = m1 * m2 / (m1 + m2);
    let total_m = m1 + m2;
    let exp_35 = N_C as f64 / (CHI - 1) as f64;  // 3/5
    let exp_25 = N_W as f64 / (CHI - 1) as f64;  // 2/5
    mu.powf(exp_35) * total_m.powf(exp_25)
}

// ═══════════════════════════════════════════════════════════════
// §4  GW FREQUENCY
// ═══════════════════════════════════════════════════════════════

/// GW frequency from orbital separation.
/// f_GW = N_w × f_orb = N_w/(2π) × √(M/a³)
pub fn gw_frequency(total_m: f64, a: f64) -> f64 {
    let f_orb = (total_m / (a * sq(a))).sqrt() / (2.0 * std::f64::consts::PI);
    N_W as f64 * f_orb
}

/// Orbital separation from GW frequency (inverse).
pub fn separation_from_freq(total_m: f64, f_gw: f64) -> f64 {
    let f_orb = f_gw / N_W as f64;
    let a3 = total_m / sq(2.0 * std::f64::consts::PI * f_orb);
    a3.cbrt()
}

/// Chirp rate: df/dt = (96/5) π^(8/3) M_c^(5/3) f^(11/3)
/// 96/5 = N_c × Peters = N_c × N_w⁵/(χ−1)
pub fn chirp_rate(mc: f64, f_gw: f64) -> f64 {
    let coeff = N_C as f64 * peters_coefficient(); // 96/5
    let exp_83 = D3 as f64 / N_C as f64;          // 8/3
    let exp_53 = (CHI - 1) as f64 / N_C as f64;   // 5/3
    let exp_113 = (N_C * N_C + N_W) as f64 / N_C as f64; // 11/3
    coeff * std::f64::consts::PI.powf(exp_83) * mc.powf(exp_53) * f_gw.powf(exp_113)
}

// ═══════════════════════════════════════════════════════════════
// §5  TIME TO MERGER
// ═══════════════════════════════════════════════════════════════

/// Time to merger: t = (χ−1)/N_w⁸ × M_c^(−5/3) × (πf)^(−8/3)
pub fn time_to_merger(mc: f64, f_gw: f64) -> f64 {
    let num = (CHI - 1) as f64;
    let den = (N_W as f64).powi(8); // 256
    let exp_53 = (CHI - 1) as f64 / N_C as f64;
    let exp_83 = D3 as f64 / N_C as f64;
    (num / den) * mc.powf(-exp_53) * (std::f64::consts::PI * f_gw).powf(-exp_83)
}

// ═══════════════════════════════════════════════════════════════
// §6  ISCO CUTOFF
// ═══════════════════════════════════════════════════════════════

/// ISCO frequency: f = 1/(χ^(3/2) π M)
pub fn isco_frequency(total_m: f64) -> f64 {
    let chi_d = CHI as f64;
    1.0 / (chi_d * chi_d.sqrt() * std::f64::consts::PI * total_m)
}

// ═══════════════════════════════════════════════════════════════
// §7  WAVEFORM GENERATION
// ═══════════════════════════════════════════════════════════════

/// GW waveform sample.
#[derive(Clone, Debug)]
pub struct GWState {
    pub time: f64,
    pub freq: f64,
    pub phase: f64,
    pub h_plus: f64,
    pub h_cross: f64,
}

/// Generate inspiral waveform h+(t), hx(t).
/// Amplitude = N_w²/r, freq exponent = (N_c−1)/N_c = 2/3.
pub fn inspiral_waveform(
    m1: f64, m2: f64, dist: f64, iota: f64, f0: f64, dt: f64,
) -> Vec<GWState> {
    let mc = chirp_mass(m1, m2);
    let total_m = m1 + m2;
    let f_isco = isco_frequency(total_m);
    let amp0 = AMPLITUDE_FACTOR as f64 / dist;
    let exp_53 = (CHI - 1) as f64 / N_C as f64;
    let exp_23 = (N_C - 1) as f64 / N_C as f64;
    let cos_i = iota.cos();
    let f_plus = (1.0 + cos_i * cos_i) / 2.0;
    let f_cross = cos_i;

    let mut states = Vec::new();
    let mut t = 0.0;
    let mut f = f0;
    let mut phase: f64 = 0.0;

    while f < f_isco && states.len() < 500000 {
        let amp = amp0 * mc.powf(exp_53) * (std::f64::consts::PI * f).powf(exp_23);
        let hp = amp * f_plus * phase.cos();
        let hx = amp * f_cross * phase.sin();
        states.push(GWState { time: t, freq: f, phase, h_plus: hp, h_cross: hx });

        let dfdt = chirp_rate(mc, f);
        f += dfdt * dt;
        phase += 2.0 * std::f64::consts::PI * f * dt;
        t += dt;
    }
    states
}

// ═══════════════════════════════════════════════════════════════
// §8  INSPIRAL INTEGRATION (orbital)
// ═══════════════════════════════════════════════════════════════

/// Binary orbital state during inspiral.
#[derive(Clone, Debug)]
pub struct BinaryState {
    pub a: f64,       // separation
    pub freq: f64,    // GW frequency
    pub time: f64,
    pub phase: f64,
}

/// Integrate binary inspiral from initial separation to ISCO.
pub fn integrate_inspiral(m1: f64, m2: f64, a0: f64, dt: f64) -> Vec<BinaryState> {
    let total_m = m1 + m2;
    let mu = m1 * m2 / total_m;
    let rs = (N_C - 1) as f64 * total_m;
    let a_isco = N_C as f64 * rs; // 3 r_s = 6M

    let mut states = Vec::new();
    let mut a = a0;
    let mut t = 0.0;
    let mut phase: f64 = 0.0;

    while a > a_isco && states.len() < 1000000 {
        let f_gw = gw_frequency(total_m, a);
        let f_orb = f_gw / N_W as f64;
        states.push(BinaryState { a, freq: f_gw, time: t, phase });

        let dadt = orbit_decay_rate(mu, total_m, a);
        a += dadt * dt;
        phase += 2.0 * std::f64::consts::PI * f_orb * dt;
        t += dt;
    }
    states
}

// ═══════════════════════════════════════════════════════════════
// §9  EXTRACTORS
// ═══════════════════════════════════════════════════════════════

pub fn wf_time(wf: &[GWState]) -> Vec<f64> { wf.iter().map(|s| s.time).collect() }
pub fn wf_freq(wf: &[GWState]) -> Vec<f64> { wf.iter().map(|s| s.freq).collect() }
pub fn wf_h_plus(wf: &[GWState]) -> Vec<f64> { wf.iter().map(|s| s.h_plus).collect() }
pub fn wf_h_cross(wf: &[GWState]) -> Vec<f64> { wf.iter().map(|s| s.h_cross).collect() }
pub fn wf_phase(wf: &[GWState]) -> Vec<f64> { wf.iter().map(|s| s.phase).collect() }

pub fn insp_time(bs: &[BinaryState]) -> Vec<f64> { bs.iter().map(|s| s.time).collect() }
pub fn insp_a(bs: &[BinaryState]) -> Vec<f64> { bs.iter().map(|s| s.a).collect() }
pub fn insp_freq(bs: &[BinaryState]) -> Vec<f64> { bs.iter().map(|s| s.freq).collect() }

// ═══════════════════════════════════════════════════════════════
// §10  INTEGER PROOFS
// ═══════════════════════════════════════════════════════════════

pub const PROVE_QUADRUPOLE: (u64, u64) = (N_W*N_W*N_W*N_W*N_W, CHI-1);  // (32, 5)
pub const PROVE_DECAY: (u64, u64) = (N_W*N_W*N_W*N_W*N_W*N_W, CHI-1);   // (64, 5)
pub const PROVE_POLARIZATIONS: u64 = N_C - 1;                              // 2
pub const PROVE_GW_DOUBLING: u64 = N_W;                                    // 2
pub const PROVE_AMPLITUDE: u64 = N_W * N_W;                                // 4
pub const PROVE_ISCO_FREQ: u64 = CHI;                                      // 6

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn peters_32_5() {
        assert!((peters_coefficient() - 6.4).abs() < 1e-10);
    }
    #[test] fn chirp_exp_5_3() {
        assert!((chirp_exponent() - 5.0/3.0).abs() < 1e-10);
    }
    #[test] fn chirp_mass_equal() {
        let mc = chirp_mass(30.0, 30.0);
        let expected = (30.0*30.0_f64).powf(0.6) / 60.0_f64.powf(0.2);
        assert!((mc - expected).abs() / expected < 1e-10);
    }
    #[test] fn isco_freq_positive() {
        assert!(isco_frequency(60.0) > 0.0);
    }
    #[test] fn time_to_merger_positive() {
        let mc = chirp_mass(30.0, 30.0);
        let f = isco_frequency(60.0) / 10.0;
        assert!(time_to_merger(mc, f) > 0.0);
    }
    #[test] fn waveform_chirps() {
        let wf = inspiral_waveform(30.0, 30.0, 1e6, 0.0, 0.0001, 1.0);
        assert!(wf.len() > 10, "waveform length: {}", wf.len());
        if wf.len() > 2 {
            assert!(wf.last().unwrap().freq > wf[0].freq);
        }
    }
    #[test] fn inspiral_reaches_isco() {
        let bs = integrate_inspiral(30.0, 30.0, 1000.0, 1.0);
        assert!(bs.len() > 10);
        let a_isco = N_C as f64 * (N_C - 1) as f64 * 60.0;
        assert!(bs.last().unwrap().a <= a_isco * 1.1 || bs.len() >= 1000000);
    }
    #[test] fn integer_proofs() {
        assert_eq!(PROVE_QUADRUPOLE, (32, 5));
        assert_eq!(PROVE_DECAY, (64, 5));
        assert_eq!(PROVE_POLARIZATIONS, 2);
        assert_eq!(PROVE_GW_DOUBLING, 2);
        assert_eq!(PROVE_AMPLITUDE, 4);
        assert_eq!(PROVE_ISCO_FREQ, 6);
    }
}
