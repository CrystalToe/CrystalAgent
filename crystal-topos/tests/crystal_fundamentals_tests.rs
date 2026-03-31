// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later

// crystal_fundamentals_tests.rs
// 14 new observables: 181 → 195. Zero free parameters.
// Every integer identity and PWI bound proved.

#[cfg(test)]
mod tests {
    use std::f64::consts::PI;

    // ── Algebra Atoms ──
    const N_W: u64 = 2;
    const N_C: u64 = 3;
    const CHI: u64 = N_W * N_C;                        // 6
    const BETA0: u64 = (11 * N_C - 2 * CHI) / 3;      // 7
    const SIGMA_D: u64 = 1 + 3 + 8 + 24;               // 36
    const SIGMA_D2: u64 = 1 + 9 + 64 + 576;             // 650
    const GAUSS: u64 = N_C * N_C + N_W * N_W;           // 13
    const TOWER_D: u64 = SIGMA_D + CHI;                 // 42

    const V_MEV: f64 = 246220.0;
    const HBAR_C: f64 = 197.327;
    const PWI_WALL: f64 = 4.5;

    fn kappa() -> f64 { (3.0_f64).ln() / (2.0_f64).ln() }
    fn alpha() -> f64 { 1.0 / (43.0 * PI + (7.0_f64).ln()) }
    fn lambda_h() -> f64 { V_MEV / 257.0 }
    fn m_proton() -> f64 { V_MEV / 256.0 * 53.0 / 54.0 }
    fn m_pi() -> f64 { m_proton() / BETA0 as f64 }

    fn pwi(crystal: f64, pdg: f64) -> f64 {
        (crystal - pdg).abs() / pdg.abs() * 100.0
    }

    // ══════════════════════════════════════════════════
    // §1  INTEGER IDENTITY TESTS
    // ══════════════════════════════════════════════════

    // Phase 1
    #[test] fn neff_denom()    { assert_eq!(TOWER_D * N_C, 126); }
    #[test] fn ob_om_den()     { assert_eq!(GAUSS + CHI, 19); }
    #[test] fn sw0_corr_den()  { assert_eq!(TOWER_D * CHI, 252); }
    #[test] fn yp_corr_den()   { assert_eq!(CHI * TOWER_D, 252); }
    #[test] fn moment_num()    { assert_eq!(N_C * (SIGMA_D - 1), 105); }
    #[test] fn moment_den()    { assert_eq!(N_W * SIGMA_D, 72); }

    // Phase 2
    #[test] fn mcms_base()     { assert_eq!(N_W * N_W * N_C, 12); }
    #[test] fn mcms_base_alt() { assert_eq!(GAUSS - 1, 12); }
    #[test] fn mcms_base_alt2(){ assert_eq!(SIGMA_D / N_C, 12); }
    #[test] fn mcms_corr_num() { assert_eq!(TOWER_D + BETA0, 49); }
    #[test] fn mcms_corr_den() { assert_eq!(TOWER_D + BETA0 + 1, 50); }
    #[test] fn mcms_den_alt()  { assert_eq!(SIGMA_D2 / GAUSS, 50); }
    #[test] fn mcms_product()  { assert_eq!(12 * 49, 588); }
    #[test] fn mbtau_corr()    { assert_eq!(CHI * BETA0, TOWER_D); }
    #[test] fn yt_base_den()   { assert_eq!(GAUSS - N_C, 10); }
    #[test] fn rpi_num()       { assert_eq!(N_C * N_C, 9); }
    #[test] fn rpi_den()       { assert_eq!(GAUSS + BETA0, 20); }
    #[test] fn dalpha_den()    { assert_eq!(SIGMA_D, 36); }

    // Phase 3
    #[test] fn sigma_43()      { assert_eq!(TOWER_D + 1, 43); }
    #[test] fn sigma_same_43() { assert_eq!(TOWER_D + 1, SIGMA_D + CHI + 1); }
    #[test] fn dm32_nu3_num()  { assert_eq!(2 * CHI - 2, 10); }
    #[test] fn dm32_nu3_den()  { assert_eq!(2 * CHI - 1, 11); }
    #[test] fn split_chi4()    { assert_eq!(CHI.pow(4), 1296); }
    #[test] fn split_chi4m1()  { assert_eq!(CHI.pow(4) - 1, 1295); }
    #[test] fn grav_den()      { assert_eq!(BETA0 * (CHI - 1), 35); }
    #[test] fn grav_mp_num()   { assert_eq!(TOWER_D + GAUSS - N_W, 53); }
    #[test] fn grav_mp_den()   { assert_eq!(TOWER_D + GAUSS - N_W + 1, 54); }
    #[test] fn fermat_257()    { assert_eq!(2_u64.pow(2_u32.pow(N_C as u32)) + 1, 257); }

    // Cross-checks
    #[test] fn partition_19()  { assert_eq!(GAUSS + CHI, 19); }
    #[test] fn partition_20()  { assert_eq!(GAUSS + BETA0, 20); }
    #[test] fn partition_50()  { assert_eq!(TOWER_D + BETA0 + 1, SIGMA_D2 / GAUSS); }

    // ══════════════════════════════════════════════════
    // §2  OBSERVABLE PWI BOUND TESTS
    // ══════════════════════════════════════════════════

    // Phase 1
    #[test]
    fn test_neff() {
        let crystal = N_C as f64 + kappa() / TOWER_D as f64;
        assert!(pwi(crystal, 3.044) < 0.5, "N_eff PWI = {:.3}%", pwi(crystal, 3.044));
    }

    #[test]
    fn test_ob_om() {
        let crystal = N_C as f64 / (GAUSS + CHI) as f64;
        assert!(pwi(crystal, 0.157) < 1.0, "Ob/Om PWI = {:.3}%", pwi(crystal, 0.157));
    }

    #[test]
    fn test_sw0() {
        let crystal = N_C as f64 / GAUSS as f64
                    + N_W as f64 / (TOWER_D * CHI) as f64;
        assert!(pwi(crystal, 0.23857) < 0.5, "sw0 PWI = {:.3}%", pwi(crystal, 0.23857));
    }

    #[test]
    fn test_yp() {
        let crystal = 0.25 - 1.0 / (CHI * TOWER_D) as f64;
        assert!(pwi(crystal, 0.2449) < 0.5, "Y_p PWI = {:.3}%", pwi(crystal, 0.2449));
    }

    #[test]
    fn test_moment_ratio() {
        let crystal = -(N_C as f64 / N_W as f64)
                     * (1.0 - 1.0 / SIGMA_D as f64);
        assert!(pwi(crystal, -1.45990) < 0.5, "mu PWI = {:.3}%", pwi(crystal, -1.45990));
    }

    // Phase 2
    #[test]
    fn test_mc_ms() {
        let crystal = (N_W * N_W * N_C) as f64
                    * (TOWER_D + BETA0) as f64
                    / (TOWER_D + BETA0 + 1) as f64;
        assert!(pwi(crystal, 11.76) < 0.01, "m_c/m_s PWI = {:.4}%", pwi(crystal, 11.76));
    }

    #[test]
    fn test_mb_mtau() {
        let crystal = BETA0 as f64 / N_C as f64
                    + 1.0 / (CHI * BETA0) as f64;
        assert!(pwi(crystal, 2.3525) < 0.5, "m_b/m_tau PWI = {:.3}%", pwi(crystal, 2.3525));
    }

    #[test]
    fn test_top_yukawa() {
        let crystal = BETA0 as f64 / (GAUSS - N_C) as f64
                    + 1.0 / SIGMA_D2 as f64;
        assert!(pwi(crystal, 0.70165) < 0.5, "y_t PWI = {:.3}%", pwi(crystal, 0.70165));
    }

    #[test]
    fn test_pion_radius_sq() {
        let coeff = (N_C * N_C) as f64 / (GAUSS + BETA0) as f64;
        let r_pi = coeff * HBAR_C / m_pi();
        let crystal = r_pi * r_pi;
        assert!(pwi(crystal, 0.434) < 0.5, "r2_pi PWI = {:.3}%", pwi(crystal, 0.434));
    }

    #[test]
    fn test_delta_alpha_had() {
        let crystal = 1.0 / SIGMA_D as f64;
        assert!(pwi(crystal, 0.02766) < 0.5, "Dalpha PWI = {:.3}%", pwi(crystal, 0.02766));
    }

    // Phase 3
    #[test]
    fn test_sigma_pin() {
        let crystal = m_pi() * m_pi() * N_C as f64 / m_proton()
                    * (TOWER_D + 1) as f64 / TOWER_D as f64;
        assert!(pwi(crystal, 59.0) < 0.5, "sigma_piN PWI = {:.3}%", pwi(crystal, 59.0));
    }

    #[test]
    fn test_dm21_direct() {
        let v_ev: f64 = 246.22e9;
        let pow42: f64 = 2.0_f64.powi(TOWER_D as i32);
        let m_nu2 = N_W as f64 * v_ev / (pow42 * GAUSS as f64);
        let crystal = m_nu2 * m_nu2;
        assert!(pwi(crystal, 7.42e-5) < 0.5, "Dm21 PWI = {:.3}%", pwi(crystal, 7.42e-5));
    }

    #[test]
    fn test_dm32() {
        let v_ev: f64 = 246.22e9;
        let pow42: f64 = 2.0_f64.powi(TOWER_D as i32);
        let m_nu3 = v_ev / pow42 * 10.0 / 11.0;
        let m_nu2 = N_W as f64 * v_ev / (pow42 * GAUSS as f64);
        let crystal = m_nu3 * m_nu3 - m_nu2 * m_nu2;
        assert!(pwi(crystal, 2.515e-3) < 0.5, "Dm32 PWI = {:.3}%", pwi(crystal, 2.515e-3));
    }

    #[test]
    fn test_grav_coupling() {
        let mpl_over_v = (TOWER_D as f64).exp()
                       / (BETA0 as f64 * (CHI - 1) as f64);
        let mp_over_v = 53.0 / (54.0 * 2.0_f64.powi(2_i32.pow(N_C as u32)));
        let mp_over_mpl = mp_over_v / mpl_over_v;
        let crystal = mp_over_mpl * mp_over_mpl;
        assert!(pwi(crystal, 5.905e-39) < 1.0, "G_N PWI = {:.3}%", pwi(crystal, 5.905e-39));
    }
}
