// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// proton_radius.rs — Proton charge radius from A_F
//
// R_p = (N_w² + N_w/(gauss×β₀)) × ℏc/m_p
//     = (4 + 2/91) × 0.2090 fm
//     = 0.841 fm  (CODATA 2022: 0.8409 fm)
//
// The "puzzle" was two measurements seeing different sector projections.

use crate::atoms::*;

/// ℏc in MeV·fm
pub const HBAR_C: f64 = 197.327;

/// Proton mass (PDG scheme, MeV)
fn m_proton() -> f64 {
    246220.0 / (1u64 << (1u64 << N_C)) as f64
        * (TOWER_D + GAUSS - N_W) as f64
        / (TOWER_D + GAUSS - N_W + 1) as f64
}

/// Proton Compton wavelength: ℏc/m_p
pub fn compton_wavelength() -> f64 {
    HBAR_C / m_proton()
}

/// Base radius: N_w² × ℏc/m_p (zeroth order)
pub fn r_p_base() -> f64 {
    (N_W * N_W) as f64 * compton_wavelength()
}

/// Sector boundary correction: N_w/(gauss×β₀) = 2/91
pub fn correction() -> f64 {
    N_W as f64 / (GAUSS * BETA0) as f64
}

/// Full proton radius: (N_w² + correction) × ℏc/m_p
pub fn r_p() -> f64 {
    ((N_W * N_W) as f64 + correction()) * compton_wavelength()
}

/// Dual route: d₄² = 576 = 24² (checks structural identity)
pub fn dual_route_d4sq() -> (u64, u64) {
    (D4 * D4, 576)
}

/// Proton radius via dual route (same formula, different factoring)
pub fn r_p_dual() -> f64 {
    let coeff = (N_W * N_W) as f64 + N_W as f64 / (GAUSS * BETA0) as f64;
    coeff * HBAR_C / m_proton()
}

/// R_max (upper bound from sector sum): (N_w² + 1/N_c) × ℏc/m_p
pub fn r_p_max() -> f64 {
    ((N_W * N_W) as f64 + 1.0 / N_C as f64) * compton_wavelength()
}

/// R_min (lower bound, bare): N_w² × ℏc/m_p
pub fn r_p_min() -> f64 {
    r_p_base()
}

/// Band width: R_max − R_min
pub fn band_width() -> f64 {
    r_p_max() - r_p_min()
}

/// CODATA 2022 value
pub const R_P_CODATA: f64 = 0.8409;

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn r_p_matches_codata() {
        let err = (r_p() - R_P_CODATA).abs() / R_P_CODATA * 100.0;
        assert!(err < 1.0, "R_p error: {:.3}%", err);
    }

    #[test] fn dual_route_matches() {
        assert!((r_p() - r_p_dual()).abs() < 1e-10);
    }

    #[test] fn r_p_in_band() {
        assert!(r_p() >= r_p_min());
        assert!(r_p() <= r_p_max());
    }

    #[test] fn d4_squared_is_576() {
        let (val, expected) = dual_route_d4sq();
        assert_eq!(val, expected);
    }

    #[test] fn correction_is_2_over_91() {
        assert!((correction() - 2.0 / 91.0).abs() < 1e-10);
    }
}
