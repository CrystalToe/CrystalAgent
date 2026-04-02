// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// dynamics/astro.rs — Astrophysical Extremes from (2,3)
//
// Lane-Emden stellar structure + Chandrasekhar, Schwarzschild, Hawking.
//
//   Polytrope (NR degen):  3/2 = N_c/N_w          (white dwarf)
//   Polytrope (relativ):   3   = N_c               (massive star)
//   Schwarzschild:         2   = N_w               (r_s = 2GM/c²)
//   Hawking T:             8   = d_colour = N_w³   (T = ℏc³/(8πGMk))
//   Stefan-Boltzmann:      15  = N_c(χ−1)          (σ ~ 2π⁵/(15h³c²))
//   Eddington:             4   = N_w²              (L_Ed = 4πGMc/κ)
//   MS luminosity:         7/2 = β₀/N_w            (L ~ M^3.5)
//   MS lifetime:           5/2 = (χ−1)/N_w         (t ~ M^(-5/2))
//   Virial factor:         2   = N_w               (2K + U = 0)
//   Grav PE factor:        3/5 = N_c/(χ−1)         (U = −3GM²/(5R))
//   Chandrasekhar μ_e:     2   = N_w               (e⁻ per nucleon, C/O)
//   Jeans T exponent:      3/2 = N_c/N_w
//   Jeans ρ exponent:      1/2 = 1/N_w
//
// Observable count: 13.

use crate::atoms::*;

#[inline] fn sq(x: f64) -> f64 { x * x }

// ═══════════════════════════════════════════════════════════════
// §1  ASTROPHYSICAL CONSTANTS FROM (2,3)
// ═══════════════════════════════════════════════════════════════

/// Polytropic index, non-relativistic degenerate: N_c/N_w = 3/2.
pub const POLYTROPE_NR: (u64, u64) = (N_C, N_W);     // 3/2

/// Polytropic index, ultra-relativistic: N_c = 3.
pub const POLYTROPE_REL: u64 = N_C;                    // 3

/// Schwarzschild factor: r_s = 2GM/c² → 2 = N_w.
pub const SCHWARZ: u64 = N_W;                          // 2

/// Hawking temperature factor: T = ℏc³/(8πGMk) → 8 = d_colour = N_w³.
pub const HAWKING: u64 = D_COLOUR;                     // 8

/// Stefan-Boltzmann denominator: σ ~ 2π⁵/(15 h³ c²) → 15 = N_c(χ−1).
pub const SB_DENOM: u64 = N_C * (CHI - 1);            // 15

/// Eddington luminosity factor: L_Ed = 4πGMc/κ → 4 = N_w².
pub const EDDINGTON: u64 = N_W * N_W;                  // 4

/// Main sequence luminosity exponent: L ~ M^(7/2) = M^(β₀/N_w).
pub const MS_LUM_EXP: (u64, u64) = (BETA0, N_W);      // 7/2

/// Main sequence lifetime exponent: t ~ M^(−5/2) = M^(−(χ−1)/N_w).
pub const MS_LIFE_EXP: (u64, u64) = (CHI - 1, N_W);   // 5/2

/// Virial theorem: 2K + U = 0 → factor 2 = N_w.
pub const VIRIAL: u64 = N_W;                           // 2

/// Gravitational PE: U = −3GM²/(5R) → 3/5 = N_c/(χ−1).
pub const GRAV_PE: (u64, u64) = (N_C, CHI - 1);       // 3/5

/// Chandrasekhar e⁻ fraction: μ_e = N_w for C/O composition.
pub const CHANDRA_MU_E: u64 = N_W;                     // 2

/// Jeans mass: M_J ~ T^(3/2) ρ^(−1/2).
pub const JEANS_T_EXP:   (u64, u64) = (N_C, N_W);     // 3/2
pub const JEANS_RHO_EXP: (u64, u64) = (1, N_W);       // 1/2

// ═══════════════════════════════════════════════════════════════
// §2  LANE-EMDEN SOLVER
//
// (1/ξ²) d/dξ (ξ² dθ/dξ) + θⁿ = 0
// → θ'' = −θⁿ − 2θ'/ξ
// BC: θ(0) = 1, θ'(0) = 0
// Near origin: θ ≈ 1 − ξ²/6, θ' ≈ −ξ/3
// ═══════════════════════════════════════════════════════════════

/// Solve Lane-Emden for polytropic index n.
/// Returns (ξ₁, −ξ₁²θ'(ξ₁)) where ξ₁ is the stellar surface.
pub fn lane_emden(n: f64) -> (f64, f64) {
    let dxi = 0.0005_f64;
    let eps = 0.001_f64;
    let mut xi = eps;
    let mut th = 1.0 - sq(eps) / 6.0;
    let mut dth = -eps / 3.0;
    while th > 0.0 && xi < 20.0 {
        // RK2 mid-step
        let th_n = if th > 0.0 { th.powf(n) } else { 0.0 };
        let f1 = -th_n - 2.0 * dth / xi;
        let xi2 = xi + 0.5 * dxi;
        let th2 = th + 0.5 * dxi * dth;
        let dth2 = dth + 0.5 * dxi * f1;
        let th_n2 = if th2 > 0.0 { th2.powf(n) } else { 0.0 };
        let f2 = -th_n2 - 2.0 * dth2 / xi2;
        th += dxi * dth2;
        dth += dxi * f2;
        xi += dxi;
    }
    (xi, -sq(xi) * dth)
}

/// Lane-Emden profile: returns Vec<(ξ, θ)> for plotting.
pub fn lane_emden_profile(n: f64) -> Vec<(f64, f64)> {
    let dxi = 0.001_f64;
    let eps = 0.001_f64;
    let mut xi = eps;
    let mut th = 1.0 - sq(eps) / 6.0;
    let mut dth = -eps / 3.0;
    let mut pts = vec![(0.0, 1.0), (xi, th)];
    while th > 0.0 && xi < 20.0 {
        let th_n = if th > 0.0 { th.powf(n) } else { 0.0 };
        let f1 = -th_n - 2.0 * dth / xi;
        let xi2 = xi + 0.5 * dxi;
        let th2 = th + 0.5 * dxi * dth;
        let dth2 = dth + 0.5 * dxi * f1;
        let th_n2 = if th2 > 0.0 { th2.powf(n) } else { 0.0 };
        let f2 = -th_n2 - 2.0 * dth2 / xi2;
        th += dxi * dth2;
        dth += dxi * f2;
        xi += dxi;
        if th > 0.0 {
            pts.push((xi, th));
        }
    }
    pts
}

// ═══════════════════════════════════════════════════════════════
// §3  STELLAR STRUCTURE RESULTS
// ═══════════════════════════════════════════════════════════════

/// Lane-Emden for n = N_c/N_w = 3/2 (white dwarf).
pub fn lane_emden_nr() -> (f64, f64) {
    lane_emden(N_C as f64 / N_W as f64)
}

/// Lane-Emden for n = N_c = 3 (Chandrasekhar relativistic).
pub fn lane_emden_rel() -> (f64, f64) {
    lane_emden(N_C as f64)
}

/// Reference values for validation.
pub const XI1_NR_REF: f64 = 3.654;   // n=3/2
pub const XI1_REL_REF: f64 = 6.897;  // n=3
pub const MASS_REL_REF: f64 = 2.018; // -ξ²θ'(ξ₁) for n=3

// ═══════════════════════════════════════════════════════════════
// §4  STELLAR SCALING LAWS
// ═══════════════════════════════════════════════════════════════

/// Main sequence luminosity: L/L_☉ ≈ (M/M_☉)^(β₀/N_w).
pub fn ms_luminosity(m_ratio: f64) -> f64 {
    m_ratio.powf(BETA0 as f64 / N_W as f64)  // M^3.5
}

/// Main sequence lifetime: t/t_☉ ≈ (M/M_☉)^(−(χ−1)/N_w).
pub fn ms_lifetime(m_ratio: f64) -> f64 {
    m_ratio.powf(-((CHI - 1) as f64) / N_W as f64)  // M^(-2.5)
}

/// Eddington luminosity (relative): L_Ed ∝ M.
pub fn eddington_luminosity(m_ratio: f64) -> f64 {
    m_ratio  // linear in mass
}

/// Schwarzschild radius (relative): r_s = N_w·GM/c².
pub fn schwarzschild_radius(m_ratio: f64) -> f64 {
    N_W as f64 * m_ratio
}

/// Hawking temperature (relative): T ∝ 1/(d_colour·π·M).
pub fn hawking_temperature(m_ratio: f64) -> f64 {
    1.0 / (HAWKING as f64 * std::f64::consts::PI * m_ratio)
}

/// Gravitational PE: U = −N_c/(χ−1) · GM²/R.
pub fn grav_pe(gm2_over_r: f64) -> f64 {
    -(N_C as f64 / (CHI - 1) as f64) * gm2_over_r
}

// ═══════════════════════════════════════════════════════════════
// §5  CROSS-MODULE CHECKS
// ═══════════════════════════════════════════════════════════════

/// MS exponent identity: α_L = 1 + α_t  (7/2 = 1 + 5/2).
pub fn ms_exponent_identity() -> bool {
    // β₀/N_w == 1 + (χ−1)/N_w  →  β₀ == N_w + χ − 1  →  7 == 2 + 5 ✓
    BETA0 == N_W + (CHI - 1)
}

/// Hawking × Eddington = 32 = N_w⁵ (Peters GW coefficient).
pub fn hawking_eddington_product() -> u64 {
    HAWKING * EDDINGTON  // 8 × 4 = 32
}

// ═══════════════════════════════════════════════════════════════
// §6  SELF-TEST
// ═══════════════════════════════════════════════════════════════

pub const OBSERVABLE_COUNT: u64 = 13;

pub fn self_test() -> (usize, usize, Vec<String>) {
    let mut msgs = Vec::new();
    let mut pass = 0usize;
    let mut total = 0usize;

    macro_rules! check {
        ($name:expr, $cond:expr) => {{
            total += 1;
            let ok = $cond;
            if ok { pass += 1; }
            msgs.push(format!("{}  {}", if ok { "PASS" } else { "FAIL" }, $name));
        }}
    }

    // §1 Integer identities
    check!("polytrope NR = 3/2 = N_c/N_w",         POLYTROPE_NR == (3, 2));
    check!("polytrope rel = 3 = N_c",               POLYTROPE_REL == 3);
    check!("Schwarzschild = 2 = N_w",               SCHWARZ == 2);
    check!("Hawking = 8 = d_colour = N_w³",         HAWKING == 8);
    check!("Stefan-Boltzmann 15 = N_c(χ−1)",        SB_DENOM == 15);
    check!("Eddington = 4 = N_w²",                  EDDINGTON == 4);
    check!("MS lum exp = 7/2 = β₀/N_w",            MS_LUM_EXP == (7, 2));
    check!("MS lifetime = 5/2 = (χ−1)/N_w",        MS_LIFE_EXP == (5, 2));
    check!("virial = 2 = N_w",                      VIRIAL == 2);
    check!("grav PE = 3/5 = N_c/(χ−1)",            GRAV_PE == (3, 5));
    check!("Chandrasekhar μ_e = 2 = N_w",           CHANDRA_MU_E == 2);
    check!("Jeans T = 3/2 = N_c/N_w",              JEANS_T_EXP == (3, 2));
    check!("Jeans ρ = 1/2 = 1/N_w",                JEANS_RHO_EXP == (1, 2));

    // §2 Lane-Emden n=3/2 (white dwarf)
    let (xi1_nr, _mass_nr) = lane_emden_nr();
    let nr_err = (xi1_nr - XI1_NR_REF).abs() / XI1_NR_REF;
    check!("Lane-Emden n=3/2 ξ₁ ≈ 3.654 (< 1%)", nr_err < 0.01);

    // §3 Lane-Emden n=3 (Chandrasekhar)
    let (xi1_rel, mass_rel) = lane_emden_rel();
    let rel_err = (xi1_rel - XI1_REL_REF).abs() / XI1_REL_REF;
    check!("Lane-Emden n=3 ξ₁ ≈ 6.897 (< 1%)",   rel_err < 0.01);
    let mass_err = (mass_rel - MASS_REL_REF).abs() / MASS_REL_REF;
    check!("Lane-Emden n=3 mass ≈ 2.018 (< 1%)",  mass_err < 0.01);

    // §4 Cross-checks
    check!("MS: α_L = 1 + α_t (7/2 = 1 + 5/2)",  ms_exponent_identity());
    check!("Hawking×Eddington = 32 = N_w⁵",        hawking_eddington_product() == 32);
    check!("SB 15 = N_c×(χ−1) = 3×5",             SB_DENOM == N_C * (CHI - 1));

    (pass, total, msgs)
}


#[cfg(test)]
mod tests {
    use super::*;

    // Integer identities
    #[test] fn polytrope_nr_3_2()  { assert_eq!(POLYTROPE_NR, (3, 2)); }
    #[test] fn polytrope_rel_3()   { assert_eq!(POLYTROPE_REL, 3); }
    #[test] fn schwarz_2()         { assert_eq!(SCHWARZ, 2); }
    #[test] fn hawking_8()         { assert_eq!(HAWKING, 8); }
    #[test] fn sb_15()             { assert_eq!(SB_DENOM, 15); }
    #[test] fn eddington_4()       { assert_eq!(EDDINGTON, 4); }
    #[test] fn ms_lum_7_2()        { assert_eq!(MS_LUM_EXP, (7, 2)); }
    #[test] fn ms_life_5_2()       { assert_eq!(MS_LIFE_EXP, (5, 2)); }
    #[test] fn virial_2()          { assert_eq!(VIRIAL, 2); }
    #[test] fn grav_pe_3_5()       { assert_eq!(GRAV_PE, (3, 5)); }
    #[test] fn chandra_2()         { assert_eq!(CHANDRA_MU_E, 2); }
    #[test] fn jeans_t_3_2()       { assert_eq!(JEANS_T_EXP, (3, 2)); }
    #[test] fn jeans_rho_1_2()     { assert_eq!(JEANS_RHO_EXP, (1, 2)); }

    // Lane-Emden
    #[test] fn le_nr_surface() {
        let (xi1, _) = lane_emden_nr();
        assert!((xi1 - XI1_NR_REF).abs() / XI1_NR_REF < 0.01);
    }
    #[test] fn le_rel_surface() {
        let (xi1, _) = lane_emden_rel();
        assert!((xi1 - XI1_REL_REF).abs() / XI1_REL_REF < 0.01);
    }
    #[test] fn le_rel_mass() {
        let (_, m) = lane_emden_rel();
        assert!((m - MASS_REL_REF).abs() / MASS_REL_REF < 0.01);
    }
    #[test] fn le_n1_exact() {
        // n=1: ξ₁ = π, exact solution θ = sin(ξ)/ξ
        let (xi1, _) = lane_emden(1.0);
        assert!((xi1 - std::f64::consts::PI).abs() < 0.01);
    }

    // Cross-checks
    #[test] fn ms_identity()     { assert!(ms_exponent_identity()); }
    #[test] fn hawking_edd_32()  { assert_eq!(hawking_eddington_product(), 32); }

    // Scaling laws
    #[test] fn ms_lum_solar()    { assert!((ms_luminosity(1.0) - 1.0).abs() < 1e-12); }
    #[test] fn ms_life_solar()   { assert!((ms_lifetime(1.0) - 1.0).abs() < 1e-12); }
    #[test] fn ms_lum_10x() {
        let l = ms_luminosity(10.0);
        // 10^3.5 ≈ 3162
        assert!((l - 3162.3).abs() / 3162.3 < 0.01);
    }

    // Profile
    #[test] fn profile_not_empty() {
        let pts = lane_emden_profile(1.5);
        assert!(pts.len() > 100);
        assert!((pts[0].1 - 1.0).abs() < 1e-10);
    }

    #[test] fn full_self_test() {
        let (pass, total, msgs) = self_test();
        for m in &msgs { if m.starts_with("FAIL") { panic!("{m}"); } }
        assert_eq!(pass, total);
    }
}
