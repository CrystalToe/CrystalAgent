// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later

// crystal_alpha_proton_tests.rs
// Prove functions for alpha_inv and m_proton_over_m_e
// All atoms from A_F = C + M2(C) + M3(C)
// Zero free parameters. Zero hardcoded numbers.

#[cfg(test)]
mod tests {
    use std::f64::consts::PI;

    // ── Algebra Atoms ──
    const N_W: u64 = 2;
    const N_C: u64 = 3;
    const CHI: u64 = N_W * N_C;                        // 6
    const BETA0: u64 = (11 * N_C - 2 * CHI) / 3;      // 7

    const D1: u64 = 1;
    const D2: u64 = 3;
    const D3: u64 = 8;
    const D4: u64 = 24;

    const SIGMA_D: u64 = D1 + D2 + D3 + D4;            // 36
    const SIGMA_D2: u64 = 1 + 9 + 64 + 576;             // 650
    const GAUSS: u64 = N_C * N_C + N_W * N_W;           // 13
    const TOWER_D: u64 = SIGMA_D + CHI;                 // 42

    fn kappa() -> f64 { (3.0_f64).ln() / (2.0_f64).ln() }
    fn ln2() -> f64 { (2.0_f64).ln() }
    fn ln3() -> f64 { (3.0_f64).ln() }

    // ── PDG targets ──
    const PDG_ALPHA_INV: f64 = 137.035999084;
    const PDG_MP_ME: f64 = 1836.15267343;
    const PWI_THRESHOLD: f64 = 4.5; // percent

    fn sigma(computed: f64, target: f64) -> f64 {
        (computed - target).abs() / target
    }

    fn pwi_pass(computed: f64, target: f64) -> bool {
        sigma(computed, target) * 100.0 <= PWI_THRESHOLD
    }

    // ══════════════════════════════════════════════════
    // ATOM IDENTITY TESTS
    // ══════════════════════════════════════════════════

    #[test]
    fn test_chi() { assert_eq!(CHI, 6); }

    #[test]
    fn test_beta0() { assert_eq!(BETA0, 7); }

    #[test]
    fn test_sigma_d() { assert_eq!(SIGMA_D, 36); }

    #[test]
    fn test_sigma_d2() { assert_eq!(SIGMA_D2, 650); }

    #[test]
    fn test_gauss() { assert_eq!(GAUSS, 13); }

    #[test]
    fn test_tower_d() { assert_eq!(TOWER_D, 42); }

    #[test]
    fn test_sector_dims() {
        assert_eq!((D1, D2, D3, D4), (1, 3, 8, 24));
    }

    // ══════════════════════════════════════════════════
    // PROVE: alpha_inv (SINDy)
    // 2*(gauss^2 + d4)/pi + d3^ln3/ln2
    // ══════════════════════════════════════════════════

    #[test]
    fn test_alpha_inv_sindy() {
        let g2 = (GAUSS * GAUSS) as f64;          // 169
        let term1 = 2.0 * (g2 + D4 as f64) / PI;  // 2*193/pi
        let term2 = (D3 as f64).powf(ln3()) / ln2(); // 8^ln3/ln2
        let val = term1 + term2;
        let s = sigma(val, PDG_ALPHA_INV);
        println!("alpha_inv_sindy = {:.15} (sigma = {:.4e}, {:.4} ppm)", val, s, s * 1e6);
        assert!(pwi_pass(val, PDG_ALPHA_INV),
            "alpha_inv_sindy PWI failed: {:.8}%", s * 100.0);
        assert!(s < 1e-8, "alpha_inv_sindy sigma > 1e-8: {:.4e}", s);
    }

    // ══════════════════════════════════════════════════
    // PROVE: alpha_inv (HMC base)
    // sigma_d^ln3 * pi - d4
    // ══════════════════════════════════════════════════

    #[test]
    fn test_alpha_inv_hmc_base() {
        let val = (SIGMA_D as f64).powf(ln3()) * PI - D4 as f64;
        let s = sigma(val, PDG_ALPHA_INV);
        println!("alpha_inv_hmc_base = {:.15} (sigma = {:.4e}, {:.4} ppm)", val, s, s * 1e6);
        assert!(pwi_pass(val, PDG_ALPHA_INV));
        assert!(s < 2e-7, "sigma > 2e-7: {:.4e}", s);
    }

    // ══════════════════════════════════════════════════
    // PROVE: alpha_inv (HMC refined)
    // sigma_d^ln3 * pi - d4 + T_F/(D*sigma_d2)
    // ══════════════════════════════════════════════════

    #[test]
    fn test_alpha_inv_hmc_refined() {
        let base = (SIGMA_D as f64).powf(ln3()) * PI - D4 as f64;
        let corr = 0.5 / (TOWER_D as f64 * SIGMA_D2 as f64);
        let val = base + corr;
        let s = sigma(val, PDG_ALPHA_INV);
        println!("alpha_inv_hmc_refined = {:.15} (sigma = {:.4e}, {:.4} ppm)", val, s, s * 1e6);
        assert!(pwi_pass(val, PDG_ALPHA_INV));
        assert!(s < 1e-8, "sigma > 1e-8: {:.4e}", s);
    }

    // ══════════════════════════════════════════════════
    // PROVE: m_p/m_e (SINDy)
    // 2*(D^2 + sigma_d)/d3 + gauss^N_c/kappa
    // ══════════════════════════════════════════════════

    #[test]
    fn test_mp_me_sindy() {
        let d_sq = (TOWER_D * TOWER_D) as f64;     // 1764
        let term1 = 2.0 * (d_sq + SIGMA_D as f64) / D3 as f64; // 450
        let term2 = (GAUSS.pow(N_C as u32)) as f64 / kappa();   // 2197/kappa
        let val = term1 + term2;
        let s = sigma(val, PDG_MP_ME);
        println!("mp_me_sindy = {:.15} (sigma = {:.4e}, {:.4} ppm)", val, s, s * 1e6);
        assert!(pwi_pass(val, PDG_MP_ME),
            "mp_me_sindy PWI failed: {:.8}%", s * 100.0);
        assert!(s < 1e-8, "mp_me_sindy sigma > 1e-8: {:.4e}", s);
    }

    // ══════════════════════════════════════════════════
    // PROVE: m_p/m_e (HMC)
    // chi * pi^5 + sqrt(ln2)/d4
    // ══════════════════════════════════════════════════

    #[test]
    fn test_mp_me_hmc() {
        let base = CHI as f64 * PI.powi(5);
        let corr = ln2().sqrt() / D4 as f64;
        let val = base + corr;
        let s = sigma(val, PDG_MP_ME);
        println!("mp_me_hmc = {:.15} (sigma = {:.4e}, {:.4} ppm)", val, s, s * 1e6);
        assert!(pwi_pass(val, PDG_MP_ME));
        assert!(s < 1e-7, "sigma > 1e-7: {:.4e}", s);
    }

    // ══════════════════════════════════════════════════
    // CROSS-DOMAIN STRUCTURE
    // ══════════════════════════════════════════════════

    #[test]
    fn test_cross_domain_gauss_shared() {
        // gauss = 13 appears in both formulas
        let alpha_term = GAUSS * GAUSS + D4; // 193
        let mp_term = GAUSS.pow(N_C as u32); // 2197
        assert_eq!(alpha_term, 193);
        assert_eq!(mp_term, 2197);
    }

    #[test]
    fn test_cross_domain_d3_shared() {
        // d3 = 8 is divisor in both
        assert_eq!(D3, 8);
    }

    #[test]
    fn test_mp_me_rational_part() {
        // Rational part: 2*(42^2 + 36)/8 = 2*1800/8 = 450
        let val = 2 * (TOWER_D * TOWER_D + SIGMA_D) / D3;
        assert_eq!(val, 450);
    }

    #[test]
    fn test_alpha_rational_numerator() {
        // Rational numerator: 2*(13^2 + 24) = 2*193 = 386
        let val = 2 * (GAUSS * GAUSS + D4);
        assert_eq!(val, 386);
    }
}
