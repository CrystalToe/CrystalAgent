// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// qcd.rs — Proton, quarks, hadron spectrum from A_F

use crate::atoms::*;
use crate::toe::Toe;

// ═══════════════════════════════════════════════════════════════════
// QCD SCALES (VEV-dependent)
// ═══════════════════════════════════════════════════════════════════

/// Proton mass: m_p = v / 2^(2^N_c) × 53/54.
pub fn proton_mass(toe: &Toe) -> f64 {
    toe.vev() / (1u64 << (1u64 << N_C)) as f64 * 53.0 / 54.0
}

/// Neutron mass: m_n = m_p × (1 + α/(N_c · gauss)).
pub fn neutron_mass(toe: &Toe) -> f64 {
    let mp = proton_mass(toe);
    let alpha = 1.0 / crate::gauge::alpha_inv();
    mp * (1.0 + alpha / (N_C * GAUSS) as f64)
}

/// Neutron–proton mass difference (MeV).
pub fn mn_mp_diff(toe: &Toe) -> f64 {
    (neutron_mass(toe) - proton_mass(toe)) * 1e3
}

/// QCD scale: Λ_QCD = m_p × N_c/gauss.
pub fn lambda_qcd(toe: &Toe) -> f64 {
    proton_mass(toe) * N_C as f64 / GAUSS as f64
}

/// Pion mass: m_π = m_p / β₀.
pub fn pion_mass(toe: &Toe) -> f64 {
    proton_mass(toe) / BETA0 as f64
}

/// Pion decay constant: f_π = Λ_QCD × N_c/β₀.
pub fn f_pi(toe: &Toe) -> f64 {
    lambda_qcd(toe) * N_C as f64 / BETA0 as f64
}

/// Kaon mass: m_K = m_π × √(gauss/β₀).
pub fn kaon_mass(toe: &Toe) -> f64 {
    pion_mass(toe) * (GAUSS as f64 / BETA0 as f64).sqrt()
}

/// Rho mass: m_ρ = m_p × d₃/(d₃ + N_c) = m_p × 8/11.
pub fn rho_mass(toe: &Toe) -> f64 {
    proton_mass(toe) * D3 as f64 / (D3 + N_C) as f64
}

/// Omega mass: m_ω ≈ m_ρ (degenerate in Crystal).
pub fn omega_mass(toe: &Toe) -> f64 {
    rho_mass(toe)
}

/// Delta mass: m_Δ = m_p × (1 + N_c/D).
pub fn delta_mass(toe: &Toe) -> f64 {
    proton_mass(toe) * (1.0 + N_C as f64 / TOWER_D as f64)
}

// ═══════════════════════════════════════════════════════════════════
// QUARK MASSES (current, VEV-dependent)
// ═══════════════════════════════════════════════════════════════════

/// Higgs condensation scale.
fn lambda_h(toe: &Toe) -> f64 {
    toe.vev() / FERMAT3 as f64
}

/// Up quark: m_u = Λ_h / (N_c · gauss · d₃).
pub fn up_mass(toe: &Toe) -> f64 {
    lambda_h(toe) / (N_C * GAUSS * D3) as f64
}

/// Down quark: m_d = m_u × N_c.
pub fn down_mass(toe: &Toe) -> f64 {
    up_mass(toe) * N_C as f64
}

/// Strange quark: m_s = m_d × gauss.
pub fn strange_mass(toe: &Toe) -> f64 {
    down_mass(toe) * GAUSS as f64
}

/// Charm quark: m_c = m_s × N_c.
pub fn charm_mass(toe: &Toe) -> f64 {
    strange_mass(toe) * N_C as f64
}

/// Bottom quark: m_b = m_c × N_c.
pub fn bottom_mass(toe: &Toe) -> f64 {
    charm_mass(toe) * N_C as f64
}

/// Top quark: m_t = v / √2 (conformal fixed point y_t=1).
pub fn top_mass(toe: &Toe) -> f64 {
    toe.vev() / std::f64::consts::SQRT_2
}

// ═══════════════════════════════════════════════════════════════════
// DIMENSIONLESS RATIOS (VEV-independent)
// ═══════════════════════════════════════════════════════════════════

/// m_p/m_e = proton-to-electron mass ratio.
/// Full formula: 2(D²+Σd)/d₃ + gauss^N_c/κ + κ/(N_w·χ·Σd²·D).
pub fn mp_me_ratio() -> f64 {
    let kappa = crate::atoms::kappa();
    let base = 2.0 * (TOWER_D * TOWER_D + SIGMA_D) as f64 / D3 as f64;
    let mid = (GAUSS as f64).powf(N_C as f64) / kappa;
    let correction = kappa / (N_W * CHI * SIGMA_D2 * TOWER_D) as f64;
    base + mid + correction
}

/// m_π/m_p = 1/β₀.
pub fn mpi_mp_ratio() -> f64 {
    1.0 / BETA0 as f64
}

/// Λ_QCD/m_p = N_c/gauss.
pub fn lambda_qcd_mp_ratio() -> f64 {
    N_C as f64 / GAUSS as f64
}
