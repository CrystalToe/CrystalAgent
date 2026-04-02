// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// dynamics/optics.rs — Ray/Wave Optics from (2,3)
//
// n_water = C_F = (N_c²−1)/(2N_c) = 4/3.
// n_glass = N_c/N_w = 3/2. n_diamond = gauss/(χ−1) = 13/5.
// Rayleigh λ⁻⁴ = λ^(−N_w²), d⁶ = d^χ. Planck λ⁻⁵ = λ^(−(χ−1)).

use crate::atoms::*;

#[inline] fn sq(x: f64) -> f64 { x * x }

// ═══════════════════════════════════════════════════════════════
// §1  REFRACTIVE INDICES FROM (2,3)
// ═══════════════════════════════════════════════════════════════

/// n_water = C_F = (N_c²−1)/(2N_c) = 8/6 = 4/3.
pub fn n_water() -> f64 { (N_C * N_C - 1) as f64 / (2 * N_C) as f64 }

/// n_glass = N_c/N_w = 3/2.
pub fn n_glass() -> f64 { N_C as f64 / N_W as f64 }

/// n_diamond = (N_w² + N_c²)/(χ−1) = 13/5 = 2.6.
pub fn n_diamond() -> f64 { (N_W * N_W + N_C * N_C) as f64 / (CHI - 1) as f64 }

pub const RAYLEIGH_LAMBDA_EXP: u64 = N_W * N_W; // 4
pub const RAYLEIGH_SIZE_EXP: u64 = CHI;          // 6
pub const PLANCK_LAMBDA_EXP: u64 = CHI - 1;      // 5

// ═══════════════════════════════════════════════════════════════
// §2  SNELL'S LAW
// ═══════════════════════════════════════════════════════════════

/// Snell refraction: n₁sinθ₁ = n₂sinθ₂. Returns None for TIR.
pub fn snell(n1: f64, n2: f64, theta_i: f64) -> Option<f64> {
    let sin_t = n1 / n2 * theta_i.sin();
    if sin_t.abs() > 1.0 { None } else { Some(sin_t.asin()) }
}

/// Critical angle for total internal reflection (requires n1 > n2).
pub fn critical_angle(n1: f64, n2: f64) -> Option<f64> {
    if n1 > n2 { Some((n2 / n1).asin()) } else { None }
}

/// Brewster's angle: tan(θ_B) = n₂/n₁.
pub fn brewster_angle(n1: f64, n2: f64) -> f64 {
    (n2 / n1).atan()
}

// ═══════════════════════════════════════════════════════════════
// §3  FRESNEL EQUATIONS
// ═══════════════════════════════════════════════════════════════

/// Fresnel reflectance, s-polarisation.
pub fn fresnel_rs(n1: f64, n2: f64, theta_i: f64) -> f64 {
    match snell(n1, n2, theta_i) {
        None => 1.0,
        Some(theta_t) => {
            let ci = theta_i.cos(); let ct = theta_t.cos();
            sq((n1 * ci - n2 * ct) / (n1 * ci + n2 * ct))
        }
    }
}

/// Fresnel reflectance, p-polarisation.
pub fn fresnel_rp(n1: f64, n2: f64, theta_i: f64) -> f64 {
    match snell(n1, n2, theta_i) {
        None => 1.0,
        Some(theta_t) => {
            let ci = theta_i.cos(); let ct = theta_t.cos();
            sq((n2 * ci - n1 * ct) / (n2 * ci + n1 * ct))
        }
    }
}

/// Unpolarised reflectance: (Rs + Rp)/2.
pub fn fresnel_r(n1: f64, n2: f64, theta_i: f64) -> f64 {
    0.5 * (fresnel_rs(n1, n2, theta_i) + fresnel_rp(n1, n2, theta_i))
}

/// Normal-incidence reflectance: R = ((n₁−n₂)/(n₁+n₂))².
pub fn normal_reflectance(n1: f64, n2: f64) -> f64 {
    sq((n1 - n2) / (n1 + n2))
}

// ═══════════════════════════════════════════════════════════════
// §4  RAYLEIGH SCATTERING
// ═══════════════════════════════════════════════════════════════

/// Rayleigh intensity: I ∝ (λ₀/λ)^(N_w²).
pub fn rayleigh_intensity(lambda0: f64, lambda: f64) -> f64 {
    (lambda0 / lambda).powi((N_W * N_W) as i32)
}

/// Sky blue ratio: (700/450)^4 ≈ 5.86.
pub fn sky_blue_ratio() -> f64 {
    rayleigh_intensity(700.0, 450.0)
}

// ═══════════════════════════════════════════════════════════════
// §5  PLANCK & WIEN
// ═══════════════════════════════════════════════════════════════

const H_PLANCK: f64 = 6.62607015e-34;
const C_LIGHT: f64 = 2.99792458e8;
const K_BOLTZ: f64 = 1.380649e-23;

/// Planck spectral radiance B(λ,T). λ in metres, T in kelvin.
pub fn planck_radiance(lambda: f64, t: f64) -> f64 {
    let lam5 = lambda.powi(PLANCK_LAMBDA_EXP as i32); // λ^(χ−1) = λ⁵
    let num = 2.0 * H_PLANCK * C_LIGHT * C_LIGHT / lam5;
    let x = H_PLANCK * C_LIGHT / (lambda * K_BOLTZ * t);
    if x > 500.0 { return 0.0; }
    num / (x.exp() - 1.0)
}

/// Wien displacement: λ_max = b/T.
pub fn wien_displacement(t: f64) -> f64 {
    2.8977719e-3 / t
}

// ═══════════════════════════════════════════════════════════════
// §6  THIN LENS & DIFFRACTION
// ═══════════════════════════════════════════════════════════════

/// Thin lens equation: 1/f = (n−1)(1/R₁ − 1/R₂).
pub fn thin_lens_focal(n: f64, r1: f64, r2: f64) -> f64 {
    1.0 / ((n - 1.0) * (1.0 / r1 - 1.0 / r2))
}

/// Single-slit diffraction minimum: sinθ = mλ/a.
pub fn diffraction_min(m: i32, lambda: f64, slit_width: f64) -> f64 {
    (m as f64 * lambda / slit_width).asin()
}

/// Airy disk radius: θ = 1.22 λ/D.
pub fn airy_radius(lambda: f64, aperture: f64) -> f64 {
    1.22 * lambda / aperture
}

// ═══════════════════════════════════════════════════════════════
// §7  FRESNEL CURVE GENERATORS
// ═══════════════════════════════════════════════════════════════

/// Generate Fresnel reflectance curve. Returns (angles_deg, rs, rp, r_avg).
pub fn fresnel_curve(n1: f64, n2: f64, n_points: usize) -> (Vec<f64>, Vec<f64>, Vec<f64>, Vec<f64>) {
    let pi2 = std::f64::consts::FRAC_PI_2;
    let da = pi2 / n_points as f64;
    let mut angles = Vec::new();
    let mut rs_v = Vec::new();
    let mut rp_v = Vec::new();
    let mut r_v = Vec::new();
    for i in 0..n_points {
        let theta = i as f64 * da;
        angles.push(theta.to_degrees());
        rs_v.push(fresnel_rs(n1, n2, theta));
        rp_v.push(fresnel_rp(n1, n2, theta));
        r_v.push(fresnel_r(n1, n2, theta));
    }
    (angles, rs_v, rp_v, r_v)
}

/// Generate Planck curves for several temperatures. Returns (lambdas_nm, [spectra]).
pub fn planck_curves(temps: &[f64], n_points: usize) -> (Vec<f64>, Vec<Vec<f64>>) {
    let lam: Vec<f64> = (1..=n_points).map(|i| (i as f64 / n_points as f64) * 3000e-9).collect();
    let lam_nm: Vec<f64> = lam.iter().map(|&l| l * 1e9).collect();
    let spectra: Vec<Vec<f64>> = temps.iter().map(|&t| {
        lam.iter().map(|&l| planck_radiance(l, t)).collect()
    }).collect();
    (lam_nm, spectra)
}

// ═══════════════════════════════════════════════════════════════
// TESTS
// ═══════════════════════════════════════════════════════════════

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn n_water_4_3() { assert!((n_water() - 4.0/3.0).abs() < 1e-10); }
    #[test] fn n_glass_3_2() { assert!((n_glass() - 1.5).abs() < 1e-10); }
    #[test] fn n_diamond_13_5() { assert!((n_diamond() - 13.0/5.0).abs() < 1e-10); }

    #[test] fn snell_normal() {
        let t = snell(1.0, n_water(), 0.0).unwrap();
        assert!(t.abs() < 1e-10);
    }
    #[test] fn tir_water_air() {
        let tc = critical_angle(n_water(), 1.0).unwrap();
        assert!(tc > 0.0);
        assert!(snell(n_water(), 1.0, tc + 0.01).is_none());
    }
    #[test] fn brewster_glass() {
        let tb = brewster_angle(1.0, n_glass());
        // At Brewster angle, Rp = 0
        assert!(fresnel_rp(1.0, n_glass(), tb) < 1e-10);
    }
    #[test] fn normal_reflectance_glass() {
        let r = normal_reflectance(1.0, n_glass());
        assert!((r - 0.04).abs() < 0.005); // ~4%
    }
    #[test] fn rayleigh_4_3() {
        assert!((rayleigh_intensity(1.0, 0.5) - 16.0).abs() < 1e-10); // (1/0.5)^4 = 16
    }
    #[test] fn sky_blue() {
        assert!(sky_blue_ratio() > 5.0); // blue scattered much more
    }
    #[test] fn wien_5778k() {
        let lmax = wien_displacement(5778.0);
        assert!((lmax * 1e9 - 502.0).abs() < 5.0); // ~502 nm
    }
    #[test] fn planck_positive() {
        assert!(planck_radiance(500e-9, 5778.0) > 0.0);
    }
}
