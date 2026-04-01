// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later

// crystal_hierarchy_tests.rs
// Hierarchical implosion — dual route identities + corrected observables
//
// THE AXIOM: A_F = C + M2(C) + M3(C)
// All atoms from N_w=2, N_c=3. Zero free parameters.
// Session 8: 5 outlier corrections, all rational, all dual-routed.

#[cfg(test)]
mod tests {

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
    const SHARED_CORE: u64 = SIGMA_D2 * TOWER_D;        // 27300

    const PWI_THRESHOLD: f64 = 0.5; // percent — all corrected must be TIGHT

    fn pwi(computed: f64, target: f64) -> f64 {
        (computed - target).abs() / target * 100.0
    }

    // Lambda from VEV (same as CrystalQCD.getLambda)
    fn lambda_h() -> f64 {
        let m_pl: f64 = 1.220890e19;
        let v = m_pl * 35.0 / (43.0 * 36.0 * (2.0_f64).powi(50));
        v / 256.0 * 1e3  // MeV
    }

    // ══════════════════════════════════════════════════
    // §1  HIERARCHY LEVEL IDENTITIES
    // ══════════════════════════════════════════════════

    #[test]
    fn test_shared_core() {
        assert_eq!(SHARED_CORE, 27300);
    }

    #[test]
    fn test_level_a0() {
        assert_eq!(SIGMA_D, 36);
    }

    #[test]
    fn test_level_a4() {
        assert_eq!(SIGMA_D2, 650);
    }

    #[test]
    fn test_level_ratio_numerator() {
        // a4/a0 = 650/36 = 325/18
        assert_eq!(SIGMA_D2 * 18, SIGMA_D * 325);
    }

    // ══════════════════════════════════════════════════
    // §2  DUAL ROUTE IDENTITIES (exact integer arithmetic)
    // ══════════════════════════════════════════════════

    // m_Υ: N_c³/(χ·Σd) = N_c²/(N_w·Σd) = 1/8
    // Cross-multiply: N_c³ · N_w · Σd = N_c² · χ · Σd

    #[test]
    fn test_upsilon_dual_route() {
        let lhs = N_C.pow(3) * N_W * SIGMA_D;
        let rhs = N_C.pow(2) * CHI * SIGMA_D;
        assert_eq!(lhs, rhs);
    }

    #[test]
    fn test_upsilon_corr_value() {
        // N_c³ × 8 = χ · Σd → correction = 1/8
        assert_eq!(N_C.pow(3) * 8, CHI * SIGMA_D);
    }

    #[test]
    fn test_upsilon_corr_is_eighth() {
        // 27/216 = 1/8
        assert_eq!(N_C.pow(3) * 8, CHI * SIGMA_D);
        assert_eq!(CHI * SIGMA_D, 216);
        assert_eq!(N_C.pow(3), 27);
    }

    // m_D: D/(d₄·Σd) = 7/144
    // Cross-multiply: D · 144 = 7 · d₄ · Σd

    #[test]
    fn test_dmeson_dual_route() {
        assert_eq!(TOWER_D * 144, 7 * D4 * SIGMA_D);
    }

    #[test]
    fn test_dmeson_split() {
        // D = Σd + χ (the split identity)
        assert_eq!(TOWER_D, SIGMA_D + CHI);
    }

    #[test]
    fn test_dmeson_dual_route_b() {
        // 1/d₄ + χ/(d₄·Σd) = (Σd + χ)/(d₄·Σd) = D/(d₄·Σd)
        let route_a_num = TOWER_D;
        let route_a_den = D4 * SIGMA_D;
        let route_b_num = SIGMA_D + CHI;
        let route_b_den = D4 * SIGMA_D;
        assert_eq!(route_a_num * route_b_den, route_b_num * route_a_den);
    }

    // m_ρ: T_F/χ = N_c/Σd = 1/12
    // Cross-multiply: Σd = 2·χ·N_c

    #[test]
    fn test_rho_dual_route() {
        assert_eq!(SIGMA_D, 2 * CHI * N_C);
    }

    #[test]
    fn test_rho_corr_value() {
        // 1/(2·χ) = 1/12 and N_c/Σd = 3/36 = 1/12
        assert_eq!(2 * CHI, 12);
        assert_eq!(N_C * 12, SIGMA_D);
    }

    // m_φ: N_w/(N_c·Σd) = (d₄−d₃)/(d₄·Σd) = 1/54
    // Cross-multiply: N_w · d₄ · Σd = (d₄−d₃) · N_c · Σd

    #[test]
    fn test_phi_dual_route() {
        assert_eq!(N_W * D4 * SIGMA_D, (D4 - D3) * N_C * SIGMA_D);
    }

    #[test]
    fn test_phi_d4_minus_d3() {
        assert_eq!(D4 - D3, N_W * D3);  // 16 = 2 × 8
    }

    #[test]
    fn test_phi_d3_nc_eq_d4() {
        assert_eq!(D3 * N_C, D4);  // 8 × 3 = 24
    }

    #[test]
    fn test_phi_corr_value() {
        // N_w/(N_c·Σd) = 2/108 = 1/54
        assert_eq!(N_W * 54, N_C * SIGMA_D);
    }

    // Ω_DM: 1/(gauss·(gauss−N_c)) = 1/(N_w·(χ−1)·gauss) = 1/130

    #[test]
    fn test_omega_dm_dual_route() {
        assert_eq!(GAUSS * (GAUSS - N_C), N_W * (CHI - 1) * GAUSS);
    }

    #[test]
    fn test_omega_dm_identity() {
        // gauss − N_c = N_w·(χ−1) = 10
        assert_eq!(GAUSS - N_C, N_W * (CHI - 1));
        assert_eq!(GAUSS - N_C, 10);
    }

    #[test]
    fn test_omega_dm_corr_value() {
        assert_eq!(GAUSS * (GAUSS - N_C), 130);
    }

    // r_p (session 6): T_F/(d₃·Σd) = 1/d₄² = 1/576
    // Cross-multiply: 2·d₃·Σd = d₄²

    #[test]
    fn test_rp_dual_route() {
        assert_eq!(2 * D3 * SIGMA_D, D4.pow(2));
    }

    #[test]
    fn test_rp_corr_value() {
        assert_eq!(D4.pow(2), 576);
    }

    // ══════════════════════════════════════════════════
    // §3  SUPPORTING IDENTITIES
    // ══════════════════════════════════════════════════

    #[test]
    fn test_chi_is_nw_nc() {
        assert_eq!(CHI, N_W * N_C);
    }

    #[test]
    fn test_all_corrections_negative() {
        // All 5 outliers: crystal > target → correction is negative
        // This test documents the sign convention
        let lam = lambda_h();
        assert!(lam * 10.0 > 9460.3);         // m_Υ base > target
        assert!(lam * 2.0 > 1869.7);          // m_D base > target
        assert!(134.977 * 35.0/6.0 > 775.3);  // m_ρ base > target
        assert!(lam * 13.0/12.0 > 1019.5);    // m_φ base > target
    }

    #[test]
    fn test_all_corrections_perturbative() {
        // All correction fractions are << 1
        let corrs: Vec<f64> = vec![
            1.0/8.0,     // m_Υ
            7.0/144.0,   // m_D
            1.0/12.0,    // m_ρ (relative to multiplier 35/6 ≈ 5.83)
            1.0/54.0,    // m_φ
            1.0/130.0,   // Ω_DM
        ];
        for c in &corrs {
            assert!(*c < 0.2, "correction {} not perturbative", c);
        }
    }

    // ══════════════════════════════════════════════════
    // §4  CORRECTED OBSERVABLE VALUES
    // ══════════════════════════════════════════════════

    #[test]
    fn test_upsilon_corrected() {
        let lam = lambda_h();
        let val = lam * (10.0 - 1.0/8.0);  // Λ × 79/8
        let p = pwi(val, 9460.3);
        println!("m_Υ corrected = {:.2} MeV, PWI = {:.4}%", val, p);
        assert!(p < PWI_THRESHOLD, "m_Υ PWI {:.4}% > {}", p, PWI_THRESHOLD);
    }

    #[test]
    fn test_dmeson_corrected() {
        let lam = lambda_h();
        let val = lam * (2.0 - 7.0/144.0);  // Λ × 281/144
        let p = pwi(val, 1869.7);
        println!("m_D corrected = {:.2} MeV, PWI = {:.4}%", val, p);
        assert!(p < PWI_THRESHOLD, "m_D PWI {:.4}% > {}", p, PWI_THRESHOLD);
    }

    #[test]
    fn test_rho_corrected() {
        let mpi = 134.977;
        let val = mpi * (35.0/6.0 - 1.0/12.0);  // m_π × 23/4
        let p = pwi(val, 775.3);
        println!("m_ρ corrected = {:.2} MeV, PWI = {:.4}%", val, p);
        assert!(p < PWI_THRESHOLD, "m_ρ PWI {:.4}% > {}", p, PWI_THRESHOLD);
    }

    #[test]
    fn test_phi_corrected() {
        let lam = lambda_h();
        let val = lam * (13.0/12.0 - 1.0/54.0);  // Λ × 115/108
        let p = pwi(val, 1019.5);
        println!("m_φ corrected = {:.2} MeV, PWI = {:.4}%", val, p);
        assert!(p < PWI_THRESHOLD, "m_φ PWI {:.4}% > {}", p, PWI_THRESHOLD);
    }

    #[test]
    fn test_omega_dm_corrected() {
        let omega_m = CHI as f64 / (GAUSS + CHI) as f64;       // 6/19
        let omega_b = N_C as f64 / (N_C * (GAUSS + BETA0) + D1) as f64;  // 3/61
        let corr = 1.0 / (GAUSS * (GAUSS - N_C)) as f64;       // 1/130
        let val = omega_m - omega_b - corr;
        let p = pwi(val, 0.2589);
        println!("Ω_DM corrected = {:.6}, PWI = {:.4}%", val, p);
        assert!(p < PWI_THRESHOLD, "Ω_DM PWI {:.4}% > {}", p, PWI_THRESHOLD);
    }

    // ══════════════════════════════════════════════════
    // §5  CORRECTED MULTIPLIER EXACT RATIONALS
    // ══════════════════════════════════════════════════

    #[test]
    fn test_upsilon_multiplier() {
        // 10 − 1/8 = 79/8
        assert_eq!(10 * 8 - 1, 79);
    }

    #[test]
    fn test_dmeson_multiplier() {
        // 2 − 7/144 = 281/144
        assert_eq!(2 * 144 - 7, 281);
    }

    #[test]
    fn test_rho_multiplier() {
        // 35/6 − 1/12 = 70/12 − 1/12 = 69/12 = 23/4
        assert_eq!(35 * 2 - 1, 69);
        assert_eq!(69 * 4, 23 * 12);
    }

    #[test]
    fn test_phi_multiplier() {
        // 13/12 − 1/54 = (13·54 − 12)/(12·54) = (702 − 12)/648 = 690/648 = 115/108
        assert_eq!(13 * 54 - 12, 690);
        assert_eq!(690 * 108, 115 * 648);
    }

    // ══════════════════════════════════════════════════
    // §6  ALL CORRECTIONS SHARE A_F ATOMS ONLY
    // ══════════════════════════════════════════════════

    #[test]
    fn test_all_denoms_factor_from_af() {
        // Every correction denominator factors into products of
        // N_w, N_c, d_i, Σd, χ, D, gauss, β₀
        assert_eq!(CHI * SIGMA_D, 216);     // m_Υ denom
        assert_eq!(D4 * SIGMA_D, 864);      // m_D denom
        assert_eq!(2 * CHI, 12);            // m_ρ denom
        assert_eq!(N_C * SIGMA_D, 108);     // m_φ denom
        assert_eq!(GAUSS * (GAUSS - N_C), 130);  // Ω_DM denom
    }

    // ══════════════════════════════════════════════════
    // §7  sin²θ₁₃ CORRECTION
    // ══════════════════════════════════════════════════

    const D_W: u64 = N_W * N_W - 1;  // 3

    #[test]
    fn test_sin13_dual_route() {
        let route_a = (TOWER_D + D_W) * N_W.pow(2) * (CHI - 1).pow(2);
        let route_b = SIGMA_D * (CHI - 1).pow(3);
        assert_eq!(route_a, route_b);
    }

    #[test]
    fn test_sin13_corr_value() {
        assert_eq!((TOWER_D + D_W) * N_W.pow(2) * (CHI - 1).pow(2), 4500);
    }

    #[test]
    fn test_sin13_identity() {
        // (D+d_w)·N_w² = Σd·(χ−1)
        assert_eq!((TOWER_D + D_W) * N_W.pow(2), SIGMA_D * (CHI - 1));
    }

    #[test]
    fn test_sin13_clean_form() {
        // (2χ−1)/(N_w²·(χ−1)³) = 11/500
        assert_eq!(2 * CHI - 1, 11);
        assert_eq!(N_W.pow(2) * (CHI - 1).pow(3), 500);
    }

    #[test]
    fn test_sin13_corrected() {
        let val = 11.0 / 500.0;
        let p = pwi(val, 0.0220);
        println!("sin²θ₁₃ corrected = {:.6}, PWI = {:.6}%", val, p);
        assert!(p < PWI_THRESHOLD, "sin²θ₁₃ PWI {:.4}% > {}", p, PWI_THRESHOLD);
    }

    #[test]
    fn test_sin13_multiplier() {
        // 1/45 − 1/4500 = (100−1)/4500 = 99/4500 = 11/500
        assert_eq!(100 - 1, 99);
        assert_eq!(99 * 500, 11 * 4500);
    }

    #[test]
    fn test_sin13_shares_2chi_minus_1() {
        // sin²θ₂₃ = χ/(2χ−1) = 6/11
        // sin²θ₁₃ = (2χ−1)/(N_w²(χ−1)³) = 11/500
        // The atom (2χ−1) = 11 appears in both
        assert_eq!(2 * CHI - 1, 11);
    }

    // ══════════════════════════════════════════════════
    // §4  SESSION 9 — Five LOOSE closures (a₄ corrections)
    //
    // All five overshoot → all corrections NEGATIVE.
    // Pattern: base × (1 − correction_fraction)
    // ══════════════════════════════════════════════════

    // ── m_ω (omega meson 782): bug fix, inherit corrected ρ ──

    #[test]
    fn test_omega_meson_inherits_rho() {
        // ω and ρ share base m_π × 35/6 and correction −T_F/χ = −1/12
        // Corrected multiplier: 35/6 − 1/12 = 69/12 = 23/4
        assert_eq!(35 * 12 - 6 * 1, 414); // 35/6 − 1/12 = (420−6)/72
        assert_eq!(414 / 18, 23);          // = 23/4 in lowest terms
        assert_eq!(72 / 18, 4);
    }

    #[test]
    fn test_omega_meson_corrected() {
        let m_pi = 136.02; // pion mass from pipeline
        let val = m_pi * 23.0 / 4.0;
        let p = pwi(val, 782.7);
        println!("m_ω corrected = {:.3} MeV, PWI = {:.4}%", val, p);
        assert!(p < PWI_THRESHOLD, "m_ω PWI {:.4}% > {}", p, PWI_THRESHOLD);
    }

    // ── m_η (eta meson 548): −1/(N_c(χ−1)²) = −1/75 ──

    #[test]
    fn test_eta_dual_route() {
        // Route A: N_c · (χ−1)² = 3 · 25 = 75
        let route_a = N_C * (CHI - 1).pow(2);
        // Route B: N_w · Σd + N_c = 72 + 3 = 75
        let route_b = N_W * SIGMA_D + N_C;
        assert_eq!(route_a, 75);
        assert_eq!(route_b, 75);
        assert_eq!(route_a, route_b);
    }

    #[test]
    fn test_eta_identity() {
        // Identity: N_c(χ−1)² = N_w·Σd + N_c
        // 3·25 = 75 = 2·36 + 3
        assert_eq!(N_C * (CHI - 1).pow(2), N_W * SIGMA_D + N_C);
    }

    #[test]
    fn test_eta_corrected() {
        let lam = lambda_h();
        let val = lam / (N_C as f64).sqrt() * 74.0 / 75.0;
        let p = pwi(val, 547.86);
        println!("m_η corrected = {:.3} MeV, PWI = {:.4}%", val, p);
        assert!(p < PWI_THRESHOLD, "m_η PWI {:.4}% > {}", p, PWI_THRESHOLD);
    }

    // ── M_Z (Z boson 91.19): −1/((D+1)(χ−1)) = −1/215 ──

    #[test]
    fn test_mz_correction_denominator() {
        // (D+1)(χ−1) = 43 × 5 = 215
        assert_eq!((TOWER_D + 1) * (CHI - 1), 215);
        assert_eq!(TOWER_D + 1, 43);
        assert_eq!(CHI - 1, 5);
    }

    #[test]
    fn test_mz_corrected_multiplier() {
        // v × (3/8 − 1/215) = v × (3×215 − 8)/(8×215) = v × 637/1720
        assert_eq!(3 * 215 - 8, 637);
        assert_eq!(8 * 215, 1720);
    }

    #[test]
    fn test_mz_corrected() {
        let v_gev = 246.22;
        let val = v_gev * 637.0 / 1720.0;
        let p = pwi(val, 91.1876);
        println!("M_Z corrected = {:.4} GeV, PWI = {:.4}%", val, p);
        assert!(p < PWI_THRESHOLD, "M_Z PWI {:.4}% > {}", p, PWI_THRESHOLD);
    }

    // ── Δm_dec (decuplet spacing 147): −N_w/gauss² = −2/169 ──

    #[test]
    fn test_decuplet_dual_route() {
        // Route A: N_w / gauss² = 2/169
        assert_eq!(GAUSS.pow(2), 169);
        // Route B: N_w / (N_c² + N_w²)² = 2/(9+4)² = 2/169
        assert_eq!((N_C.pow(2) + N_W.pow(2)).pow(2), 169);
    }

    #[test]
    fn test_decuplet_corrected() {
        // m_s from the pipeline chain ≈ 93.86 MeV (not Λ/10).
        // Use CrystalPdg uncorrected base: m_s × κ = 148.76 MeV.
        let base_uncorrected = 148.76;  // m_s × κ (CrystalPdg)
        let val = base_uncorrected * 167.0 / 169.0;
        let p = pwi(val, 147.0);
        println!("Δm_dec corrected = {:.3} MeV, PWI = {:.4}%", val, p);
        assert!(p < PWI_THRESHOLD, "Δm_dec PWI {:.4}% > {}", p, PWI_THRESHOLD);
    }

    // ── m_μ (muon 105.66): −1/(d₈(2χ−1)) = −1/88 ──

    #[test]
    fn test_muon_dual_route() {
        let d8 = N_C.pow(2) - 1;  // 8
        let two_chi_m1 = 2 * CHI - 1;  // 11
        // Route A: d₈ · (2χ−1) = 8 × 11 = 88
        let route_a = d8 * two_chi_m1;
        // Route B: N_w⁴(χ−1) + d₈ = 16×5 + 8 = 88
        let route_b = N_W.pow(4) * (CHI - 1) + d8;
        assert_eq!(route_a, 88);
        assert_eq!(route_b, 88);
        assert_eq!(route_a, route_b);
    }

    #[test]
    fn test_muon_identity() {
        // d₈(2χ−1) = N_w⁴(χ−1) + d₈
        // 8×11 = 16×5 + 8
        let d8 = N_C.pow(2) - 1;
        assert_eq!(d8 * (2 * CHI - 1), N_W.pow(4) * (CHI - 1) + d8);
    }

    #[test]
    fn test_muon_corrected() {
        let v_mev = 246.22e3;
        let val = v_mev / 2048.0 * 8.0 / 9.0 * 87.0 / 88.0;
        let p = pwi(val, 105.658);
        println!("m_μ corrected = {:.4} MeV, PWI = {:.4}%", val, p);
        assert!(p < PWI_THRESHOLD, "m_μ PWI {:.4}% > {}", p, PWI_THRESHOLD);
    }

    // ── Summary: all 5 LOOSE closures in one test ──

    #[test]
    fn test_all_five_loose_closed() {
        let lam = lambda_h();
        let m_pi = 136.02;
        let v_gev = 246.22;
        let v_mev = v_gev * 1e3;

        let omega = m_pi * 23.0 / 4.0;
        let eta   = lam / (N_C as f64).sqrt() * 74.0 / 75.0;
        let mz    = v_gev * 637.0 / 1720.0;
        let dm    = 148.76 * 167.0 / 169.0;  // m_s×κ(CrystalPdg) × 167/169
        let muon  = v_mev / 2048.0 * 8.0 / 9.0 * 87.0 / 88.0;

        assert!(pwi(omega, 782.7)   < 1.0, "m_ω still LOOSE");
        assert!(pwi(eta,   547.86)  < 1.0, "m_η still LOOSE");
        assert!(pwi(mz,    91.1876) < 1.0, "M_Z still LOOSE");
        assert!(pwi(dm,    147.0)   < 1.0, "Δm_dec still LOOSE");
        assert!(pwi(muon,  105.658) < 1.0, "m_μ still LOOSE");
    }
}
