// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later

// THE AXIOM: A_F = C + M2(C) + M3(C) — Starting point, not conclusion
// crystal_proton_radius_tests.rs — Proton charge radius tests
// Session 6: Observable #181
// License: AGPL-3.0

#[cfg(test)]
mod proton_radius_tests {
    // Axiom: A_F = C + M2(C) + M3(C)
    const N_W: u64 = 2;
    const N_C: u64 = 3;
    const CHI: u64 = N_W * N_C;        // 6
    const BETA0: u64 = (11 * N_C - 2 * CHI) / 3;  // 7
    const D1: u64 = 1;
    const D2: u64 = 3;
    const D3: u64 = 8;
    const D4: u64 = 24;
    const SIGMA_D: u64 = D1 + D2 + D3 + D4;  // 36
    const SIGMA_D2: u64 = D1*D1 + D2*D2 + D3*D3 + D4*D4;  // 650
    const GAUSS: u64 = N_C * N_C + N_W * N_W;  // 13
    const TOWER_D: u64 = SIGMA_D + CHI;  // 42

    // Group theory
    const fn c_f() -> f64 { (N_C * N_C - 1) as f64 / (2 * N_C) as f64 }  // 4/3
    const T_F: f64 = 0.5;
    const fn kappa() -> f64 { 1.5849625007211563 }  // ln3/ln2

    // Physical constants
    const HBAR_C_FM: f64 = 197.3269804;   // MeV*fm
    const M_P_MEV: f64 = 938.272088;      // MeV
    const COMPTON_P_FM: f64 = HBAR_C_FM / M_P_MEV;

    // PDG targets
    const R_P_MUONIC: f64 = 0.84087;     // fm
    const R_P_MUONIC_UNC: f64 = 0.00039; // fm
    const R_P_CODATA: f64 = 0.8414;      // fm
    const R_P_CODATA_UNC: f64 = 0.0019;  // fm

    // ── Core identity: 2*d3*sigma_d = d4^2 ──

    #[test]
    fn dual_route_identity() {
        assert_eq!(2 * D3 * SIGMA_D, D4 * D4);
    }

    #[test]
    fn d4_squared_is_576() {
        assert_eq!(D4 * D4, 576);
    }

    #[test]
    fn two_d3_sigma_d_is_576() {
        assert_eq!(2 * D3 * SIGMA_D, 576);
    }

    // ── Base formula ──

    #[test]
    fn cf_nc_is_four() {
        let cf_nc = c_f() * N_C as f64;
        assert!((cf_nc - 4.0).abs() < 1e-12);
    }

    #[test]
    fn nc_sq_minus_one_is_eight() {
        assert_eq!(N_C * N_C - 1, 8);
    }

    // ── Proton radius: base ──

    #[test]
    fn proton_radius_base_inside_codata() {
        let r_p = c_f() * N_C as f64 * COMPTON_P_FM;
        let delta = (r_p - R_P_CODATA).abs() / R_P_CODATA_UNC;
        assert!(delta < 1.0, "base r_p outside CODATA: delta/unc = {}", delta);
    }

    // ── Proton radius: corrected ──

    #[test]
    fn proton_radius_corrected_inside_muonic() {
        let correction = T_F / (D3 as f64 * SIGMA_D as f64);
        let r_p = (c_f() * N_C as f64 - correction) * COMPTON_P_FM;
        let delta = (r_p - R_P_MUONIC).abs() / R_P_MUONIC_UNC;
        assert!(delta < 1.0, "corrected r_p outside muonic: delta/unc = {}", delta);
    }

    #[test]
    fn proton_radius_corrected_inside_codata() {
        let correction = T_F / (D3 as f64 * SIGMA_D as f64);
        let r_p = (c_f() * N_C as f64 - correction) * COMPTON_P_FM;
        let delta = (r_p - R_P_CODATA).abs() / R_P_CODATA_UNC;
        assert!(delta < 1.0, "corrected r_p outside CODATA: delta/unc = {}", delta);
    }

    #[test]
    fn proton_radius_muonic_deep_inside() {
        let correction = 1.0 / (D4 as f64 * D4 as f64);
        let r_p = (c_f() * N_C as f64 - correction) * COMPTON_P_FM;
        let delta = (r_p - R_P_MUONIC).abs() / R_P_MUONIC_UNC;
        assert!(delta < 0.01, "not deep inside muonic: delta/unc = {}", delta);
    }

    // ── Dual route ──

    #[test]
    fn dual_route_corrections_match() {
        let corr_a = T_F / (D3 as f64 * SIGMA_D as f64);
        let corr_b = 1.0 / (D4 as f64 * D4 as f64);
        assert!((corr_a - corr_b).abs() < 1e-15,
            "dual routes disagree: {} vs {}", corr_a, corr_b);
    }

    // ── Three-body bounds ──

    #[test]
    fn r_max_above_measurement() {
        let r_max = c_f() * N_C as f64 * COMPTON_P_FM;
        assert!(r_max > R_P_MUONIC, "r_max {} <= r_p {}", r_max, R_P_MUONIC);
    }

    #[test]
    fn r_min_below_measurement() {
        let geo_sum = 1.0 / (D4 as f64 * D4 as f64 - 1.0);
        let r_min = (c_f() * N_C as f64 - geo_sum) * COMPTON_P_FM;
        assert!(r_min < R_P_MUONIC, "r_min {} >= r_p {}", r_min, R_P_MUONIC);
    }

    #[test]
    fn af_floor_denom_is_575() {
        assert_eq!(D4 * D4 - 1, 575);
    }

    #[test]
    fn band_is_narrow() {
        let r_max = c_f() * N_C as f64 * COMPTON_P_FM;
        let r_min = (c_f() * N_C as f64 - 1.0 / (D4 as f64 * D4 as f64 - 1.0)) * COMPTON_P_FM;
        let band_frac = (r_max - r_min) / r_max;
        assert!(band_frac < 0.001, "band too wide: {}", band_frac);
    }

    #[test]
    fn measurement_inside_band() {
        let r_max = c_f() * N_C as f64 * COMPTON_P_FM;
        let r_min = (c_f() * N_C as f64 - 1.0 / (D4 as f64 * D4 as f64 - 1.0)) * COMPTON_P_FM;
        assert!(R_P_MUONIC >= r_min && R_P_MUONIC <= r_max,
            "muonic r_p {} outside band [{}, {}]", R_P_MUONIC, r_min, r_max);
    }

    // ── Suppression ──

    #[test]
    fn correction_is_suppressed() {
        let correction = 1.0 / (D4 as f64 * D4 as f64);
        let base = c_f() * N_C as f64;
        assert!(correction / base < 0.001, "correction not suppressed");
    }

    // ── Sign ──

    #[test]
    fn correction_is_negative() {
        let base = c_f() * N_C as f64 * COMPTON_P_FM;
        let corrected = (c_f() * N_C as f64 - 1.0 / (D4 as f64 * D4 as f64)) * COMPTON_P_FM;
        assert!(corrected < base, "correction not negative");
    }

    // ── Rational correction (gauge-sector split) ──

    #[test]
    fn correction_is_rational() {
        // 1/576 = 1/(24^2) — integer numerator and denominator
        assert_eq!(D4 * D4, 576);
        // Numerator is 1 (integer)
        let num: u64 = 1;
        let den: u64 = D4 * D4;
        assert_eq!(num, 1);
        assert_eq!(den, 576);
    }

    // ── N_c scaling ──

    #[test]
    fn nc3_tighter_than_nc2() {
        let d4_nc2: u64 = 2 * (2 * 2 - 1);  // 6
        let d4_nc3: u64 = 3 * (3 * 3 - 1);  // 24
        assert!(d4_nc3 * d4_nc3 > d4_nc2 * d4_nc2);
    }

    #[test]
    fn eps_nc2_value() {
        let d4_nc2: u64 = 2 * (2 * 2 - 1);
        assert_eq!(d4_nc2, 6);
        assert_eq!(d4_nc2 * d4_nc2, 36);
    }

    #[test]
    fn eps_nc3_value() {
        let d4_nc3: u64 = 3 * (3 * 3 - 1);
        assert_eq!(d4_nc3, 24);
        assert_eq!(d4_nc3 * d4_nc3, 576);
    }

    #[test]
    fn eps_nc4_value() {
        let d4_nc4: u64 = 4 * (4 * 4 - 1);
        assert_eq!(d4_nc4, 60);
        assert_eq!(d4_nc4 * d4_nc4, 3600);
    }

    // ── Cross-checks with Session 5 ──

    #[test]
    fn sigma_d2_value() {
        assert_eq!(SIGMA_D2, 650);
    }

    #[test]
    fn tower_d_value() {
        assert_eq!(TOWER_D, 42);
    }

    #[test]
    fn shared_core() {
        assert_eq!(SIGMA_D2 * TOWER_D, 27300);
    }

    #[test]
    fn alpha_channel() {
        assert_eq!(CHI * D4, 144);
    }

    // ── Trace identity ──

    #[test]
    fn trace_identity() {
        assert_eq!(2 * (D3 * SIGMA_D), D4 * D4);
    }

    #[test]
    fn d3_times_sigma_d() {
        assert_eq!(D3 * SIGMA_D, 288);
    }

    // ── Numerical precision ──

    #[test]
    fn resummed_also_inside() {
        let geo_sum = 1.0 / (D4 as f64 * D4 as f64 - 1.0);
        let r_p = (c_f() * N_C as f64 - geo_sum) * COMPTON_P_FM;
        let delta_mu = (r_p - R_P_MUONIC).abs() / R_P_MUONIC_UNC;
        let delta_co = (r_p - R_P_CODATA).abs() / R_P_CODATA_UNC;
        assert!(delta_mu < 1.0, "resummed outside muonic");
        assert!(delta_co < 1.0, "resummed outside CODATA");
    }

    #[test]
    fn band_denom_value() {
        assert_eq!((D4 * D4 - 1) * (D4 * D4), 331200);
    }

    // ── Summary: 30 tests ──
}
