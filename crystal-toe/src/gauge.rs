// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// gauge.rs — Gauge couplings, boson masses, lepton spectrum
//
// All from A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ). Every formula uses Toe.

use crate::atoms::*;
use crate::toe::Toe;

// ═══════════════════════════════════════════════════════════════════
// COUPLING CONSTANTS (dimensionless — VEV-independent)
// ═══════════════════════════════════════════════════════════════════

/// α⁻¹ = (D+1)π + ln(β₀) = 43π + ln7 ≈ 137.034.
pub fn alpha_inv() -> f64 {
    (TOWER_D as f64 + 1.0) * std::f64::consts::PI + (BETA0 as f64).ln()
}

/// sin²θ_W = N_c/gauss + β₀/(d₄·Σd²) ≈ 0.23122.
pub fn sin2_theta_w() -> f64 {
    N_C as f64 / GAUSS as f64 + BETA0 as f64 / (D4 * SIGMA_D2) as f64
}

/// cos²θ_W = 1 − sin²θ_W.
pub fn cos2_theta_w() -> f64 {
    1.0 - sin2_theta_w()
}

/// Weinberg angle sin²θ_W in alternative forms.
pub fn sin_theta_w() -> f64 {
    sin2_theta_w().sqrt()
}

/// Strong coupling at M_Z: one-loop running.
/// α_s(M_Z) = 12π/((11N_c − 2N_f) · ln(M_Z²/Λ_QCD²))
/// At M_Z with N_f=5: 11N_c − 2·5 = 23.
/// Λ_QCD from Crystal: m_p × N_c/gauss.
/// NOTE: Exact formula needs CrystalQCD.hs port. This is leading order.
pub fn alpha_s_mz() -> f64 {
    let mz = 91.2; // GeV (= v × 3/8 at PDG)
    let lambda = 0.938 * N_C as f64 / GAUSS as f64; // Λ_QCD ~ 0.216 GeV
    let nf = 5.0; // active flavors at M_Z
    let b0 = 11.0 * N_C as f64 - 2.0 * nf; // 23
    12.0 * std::f64::consts::PI / (b0 * (mz * mz / (lambda * lambda)).ln())
}

/// Electromagnetic coupling α = 1/α⁻¹.
pub fn alpha_em() -> f64 {
    1.0 / alpha_inv()
}

/// SU(2) coupling: g₂² = 4πα/sin²θ_W.
pub fn g2_squared() -> f64 {
    4.0 * std::f64::consts::PI * alpha_em() / sin2_theta_w()
}

/// U(1) coupling: g₁² = 4πα/cos²θ_W.
pub fn g1_squared() -> f64 {
    4.0 * std::f64::consts::PI * alpha_em() / cos2_theta_w()
}

// ═══════════════════════════════════════════════════════════════════
// BOSON MASSES (VEV-dependent)
// ═══════════════════════════════════════════════════════════════════

/// W boson mass: M_W = v · g₂/2 = v · √(πα/sin²θ_W).
pub fn w_mass(toe: &Toe) -> f64 {
    toe.vev() * (std::f64::consts::PI * alpha_em() / sin2_theta_w()).sqrt()
}

/// Z boson mass: M_Z = M_W / cos(θ_W) = v · N_c/(N_c²−1).
/// Crystal form: M_Z = v · N_c / d₃ = v × 3/8.
pub fn z_mass(toe: &Toe) -> f64 {
    toe.vev() * N_C as f64 / D3 as f64
}

/// Higgs mass: m_H ≈ v / N_w (leading order).
pub fn higgs_mass(toe: &Toe) -> f64 {
    toe.vev() / N_W as f64
}

// ═══════════════════════════════════════════════════════════════════
// LEPTON MASSES (VEV-dependent)
// ═══════════════════════════════════════════════════════════════════

/// Electron mass: m_e = Λ_h / (N_c² · N_w⁴ · gauss).
pub fn electron_mass(toe: &Toe) -> f64 {
    let lambda_h = toe.vev() / FERMAT3 as f64;
    lambda_h / (N_C * N_C * N_W * N_W * N_W * N_W * GAUSS) as f64
}

/// Muon mass: m_μ = m_e × N_w⁴ × gauss = Λ_h / N_c².
pub fn muon_mass(toe: &Toe) -> f64 {
    electron_mass(toe) * (N_W * N_W * N_W * N_W * GAUSS) as f64
}

/// m_μ/m_e ratio = N_w⁴ × gauss = 16 × 13 = 208.
pub fn mu_e_ratio() -> f64 {
    (N_W * N_W * N_W * N_W * GAUSS) as f64 // 208
}

/// Tau mass: m_τ = m_μ × gauss × N_c/β₀ (approximate).
pub fn tau_mass(toe: &Toe) -> f64 {
    muon_mass(toe) * GAUSS as f64 * N_C as f64 / BETA0 as f64
}

/// Tau/muon ratio = gauss × N_c/β₀ = 13 × 3/7.
pub fn tau_mu_ratio() -> f64 {
    GAUSS as f64 * N_C as f64 / BETA0 as f64
}

// ═══════════════════════════════════════════════════════════════════
// FERMI CONSTANT
// ═══════════════════════════════════════════════════════════════════

/// Fermi constant: G_F = 1/(√2 · v²).
pub fn fermi_constant(toe: &Toe) -> f64 {
    1.0 / (std::f64::consts::SQRT_2 * toe.vev() * toe.vev())
}
