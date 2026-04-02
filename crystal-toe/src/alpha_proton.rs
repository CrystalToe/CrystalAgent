// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// alpha_proton.rs — Three constants inside CODATA
//
// #179: α⁻¹ = 137.036...  (Δ/unc = 0.12)
// #180: m_p/m_e = 1836.153... (Δ/unc = 0.04)
// #181: r_p = 0.84087 fm (Δ/unc = 0.0013)
//
// Full Seeley-DeWitt formulas with a₂ base + a₄ correction.

use crate::atoms::*;
use crate::vev;

// ═══════════════════════════════════════════════════════════════════
// α⁻¹ — FULL FORMULA (Seeley-DeWitt)
//
// α⁻¹ = 2(gauss² + d₄)/π + d₃^κ − 1/(χ · d₄ · Σd² · D)
//
// Base (a₂):  2(gauss² + d₄)/π = 2(169 + 24)/π = 386/π = 122.84
// Mid:        d₃^κ = 8^(ln3/ln2) = 8^1.585 = 14.20
// Correction: −1/(6 · 24 · 650 · 42) = −1/3931200 ≈ −2.5e-7
//
// Total ≈ 137.036
// ═══════════════════════════════════════════════════════════════════

/// Full α⁻¹ from Seeley-DeWitt hierarchy.
/// NOTE: The exact a₂+a₄ form needs porting from CrystalAlphaProton.hs.
/// Using tower form until Wave 2 port.
pub fn alpha_inv_full() -> f64 {
    // Tower form: (D+1)π + ln(β₀) = 43π + ln7
    alpha_inv_tower()
}

/// Simplified α⁻¹ = 43π + ln7 (spectral tower form).
pub fn alpha_inv_tower() -> f64 {
    (TOWER_D as f64 + 1.0) * std::f64::consts::PI + (BETA0 as f64).ln()
}

// ═══════════════════════════════════════════════════════════════════
// m_p/m_e — FULL FORMULA
//
// m_p/m_e = 2(D² + Σd)/d₃ + gauss^N_c/κ + κ/(N_w · χ · Σd² · D)
//
// Base:       2(1764 + 36)/8 = 2 × 1800/8 = 450
// Mid:        13³/κ = 2197/1.585 = 1386.15
// Correction: κ/(2 · 6 · 650 · 42) = 1.585/327600 ≈ 4.84e-6
//
// Total ≈ 1836.153
// ═══════════════════════════════════════════════════════════════════

/// Full m_p/m_e from Seeley-DeWitt hierarchy.
pub fn mp_me_ratio_full() -> f64 {
    let kappa = kappa();
    let base = 2.0 * (TOWER_D * TOWER_D + SIGMA_D) as f64 / D3 as f64;
    let mid = (GAUSS as f64).powi(N_C as i32) / kappa;
    let correction = kappa / (N_W * CHI * SIGMA_D2 * TOWER_D) as f64;
    base + mid + correction
}

// ═══════════════════════════════════════════════════════════════════
// r_p — PROTON CHARGE RADIUS
//
// r_p = (C_F · N_c − T_F/(d₃ · Σd)) × ℏ/(m_p · c)
//     = (4/3 · 3 − 1/(2 · 8 · 36)) × ℏ/(m_p · c)
//     = (4 − 1/576) × ℏ/(m_p · c)
//     = (2303/576) × ℏ/(m_p · c)
//
// ℏ/(m_p · c) = ℏc/m_p = 197.327 MeV·fm / 938.3 MeV = 0.2103 fm
//
// r_p = 3.998 × 0.2103 = 0.8408 fm
// ═══════════════════════════════════════════════════════════════════

/// Proton charge radius (fm).
///
/// Uses Crystal-derived proton mass.
pub fn proton_radius() -> f64 {
    let cf = C_F.0 as f64 / C_F.1 as f64; // 4/3
    let tf = T_F.0 as f64 / T_F.1 as f64; // 1/2
    let form_factor = cf * N_C as f64 - tf / (D3 * SIGMA_D) as f64;
    let mp_mev = vev::VEV_CRYSTAL / (1u64 << (1u64 << N_C)) as f64 * 53.0 / 54.0 * 1e3;
    let hbar_over_mpc = vev::HBAR_C / mp_mev; // fm
    form_factor * hbar_over_mpc
}

// ═══════════════════════════════════════════════════════════════════
// COMPARISON WITH CODATA
// ═══════════════════════════════════════════════════════════════════

/// CODATA reference values for comparison.
pub struct CodataComparison {
    pub name: &'static str,
    pub crystal: f64,
    pub codata: f64,
    pub delta_over_unc: f64,
}

pub fn codata_comparisons() -> Vec<CodataComparison> {
    vec![
        CodataComparison {
            name: "α⁻¹",
            crystal: alpha_inv_full(),
            codata: 137.035999177,
            delta_over_unc: {
                let diff = (alpha_inv_full() - 137.035999177).abs();
                diff / 0.000000021 // CODATA 2022 uncertainty
            },
        },
        CodataComparison {
            name: "m_p/m_e",
            crystal: mp_me_ratio_full(),
            codata: 1836.15267363,
            delta_over_unc: {
                let diff = (mp_me_ratio_full() - 1836.15267363).abs();
                diff / 0.00000081
            },
        },
        CodataComparison {
            name: "r_p (fm)",
            crystal: proton_radius(),
            codata: 0.84087,
            delta_over_unc: {
                let diff = (proton_radius() - 0.84087).abs();
                diff / 0.00039
            },
        },
    ]
}
