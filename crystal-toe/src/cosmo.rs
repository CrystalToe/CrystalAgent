// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// cosmo.rs — Cosmological parameters from A_F

use crate::atoms::*;
use crate::toe::Toe;

// ═══════════════════════════════════════════════════════════════════
// DENSITY PARAMETERS (dimensionless — from tower partition)
// ═══════════════════════════════════════════════════════════════════

/// Dark energy: Ω_Λ = (D − gauss)/D = 29/42.
pub fn omega_lambda() -> f64 {
    (TOWER_D - GAUSS) as f64 / TOWER_D as f64
}

/// Cold dark matter: Ω_cdm = (gauss − N_w)/D = 11/42.
pub fn omega_cdm() -> f64 {
    (GAUSS - N_W) as f64 / TOWER_D as f64
}

/// Baryonic matter: Ω_b = N_w/D = 1/21.
pub fn omega_b() -> f64 {
    N_W as f64 / TOWER_D as f64
}

/// Total matter: Ω_m = Ω_cdm + Ω_b = gauss/D = 13/42.
pub fn omega_m() -> f64 {
    GAUSS as f64 / TOWER_D as f64
}

/// Verify Ω_Λ + Ω_m = 1 (flat universe).
pub fn omega_total() -> f64 {
    omega_lambda() + omega_m()
}

// ═══════════════════════════════════════════════════════════════════
// HUBBLE & AGE
// ═══════════════════════════════════════════════════════════════════

/// Hubble constant (km/s/Mpc): H₀ = 100 × D/(Σd + β₀) = 100 × 42/43.
pub fn h0() -> f64 {
    100.0 * TOWER_D as f64 / (SIGMA_D + BETA0) as f64
}

/// Reduced Hubble: h = H₀/100 = D/(Σd + β₀).
pub fn hubble_h() -> f64 {
    TOWER_D as f64 / (SIGMA_D + BETA0) as f64
}

/// Age of universe (Gyr): t₀ = gauss × β₀ + D/β₀ = 97.
/// t₀ = 97/H₀ in Hubble units.
pub fn age_hubble_units() -> f64 {
    (GAUSS * BETA0) as f64 + TOWER_D as f64 / BETA0 as f64
}

// ═══════════════════════════════════════════════════════════════════
// SPECTRAL INDEX
// ═══════════════════════════════════════════════════════════════════

/// Scalar spectral index: n_s = 1 − N_w/D = 1 − 2/42 = 20/21.
pub fn spectral_index() -> f64 {
    1.0 - N_W as f64 / TOWER_D as f64
}

/// Tensor-to-scalar ratio: r ≈ N_w²/D² (simplest form).
pub fn tensor_scalar_ratio() -> f64 {
    (N_W * N_W) as f64 / (TOWER_D * TOWER_D) as f64
}

// ═══════════════════════════════════════════════════════════════════
// NEUTRINO MASSES (VEV-dependent)
// ═══════════════════════════════════════════════════════════════════

/// Neutrino mass scale: m_ν ~ v / 2^D = v / 2⁴².
/// This is the seesaw suppression from the tower depth.
pub fn neutrino_mass_scale(toe: &Toe) -> f64 {
    toe.vev() / (1u64 << TOWER_D) as f64
}

/// Sum of neutrino masses (eV): Σm_ν ≈ N_c × m_ν_scale.
pub fn neutrino_mass_sum(toe: &Toe) -> f64 {
    N_C as f64 * neutrino_mass_scale(toe) * 1e9 // GeV → eV
}

// ═══════════════════════════════════════════════════════════════════
// NUMBER OF GENERATIONS
// ═══════════════════════════════════════════════════════════════════

/// Number of fermion generations = N_c = 3.
pub const N_GENERATIONS: u64 = N_C;

/// Number of light neutrinos = N_c = 3.
pub const N_NEUTRINOS: u64 = N_C;
