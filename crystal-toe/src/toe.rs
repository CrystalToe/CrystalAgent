// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// toe.rs — The Toe struct
//
// One constructor. Default = Crystal derived (245.17 GeV).
// User can pass any VEV. Method to_pdg() converts using the
// 1.004 formula where every digit traces to (2,3).

use crate::atoms::*;
use crate::vev;

/// The Crystal Toe: physics from A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ).
///
/// ```
/// use crystal_toe::Toe;
///
/// let t = Toe::new();              // Crystal VEV (245.17)
/// let p = t.to_pdg();             // PDG VEV (246.22)
/// let custom = Toe::with_vev(250.0);  // any VEV
///
/// // Masses depend on VEV
/// assert!((t.proton_mass() - p.proton_mass()).abs() > 0.0);
///
/// // Dimensionless constants do NOT depend on VEV
/// assert_eq!(t.alpha_inv(), p.alpha_inv());
/// ```
#[derive(Debug, Clone, Copy)]
pub struct Toe {
    vev: f64,
}

impl Toe {
    // ═════════════════════════════════════════════════════════
    // CONSTRUCTORS
    // ═════════════════════════════════════════════════════════

    /// Default: Crystal-derived VEV = 245.17 GeV.
    pub fn new() -> Self {
        Toe { vev: vev::VEV_CRYSTAL }
    }

    /// Custom VEV (GeV).
    pub fn with_vev(vev: f64) -> Self {
        Toe { vev }
    }

    /// Convert to PDG scale using the Crystal conversion factor.
    ///
    /// factor = 1 + N_c/(16π²) · ln(√N_w · d₃/N_c²)
    ///        = 1 + 3/(16π²) · ln(√2 · 8/9)  ≈ 1.00435
    ///
    /// Meaningful when self is at Crystal default.
    /// Returns a NEW Toe at the PDG scale.
    pub fn to_pdg(&self) -> Self {
        Toe { vev: self.vev * vev::conversion_factor() }
    }

    /// The VEV this Toe is using (GeV).
    pub fn vev(&self) -> f64 {
        self.vev
    }

    /// Whether this Toe uses the Crystal default.
    pub fn is_crystal_default(&self) -> bool {
        (self.vev - vev::VEV_CRYSTAL).abs() < 0.01
    }

    // ═════════════════════════════════════════════════════════
    // VEV-DEPENDENT: masses and energy scales
    // ═════════════════════════════════════════════════════════

    /// Higgs condensation scale: Λ_h = v / F₃ = v/257.
    pub fn lambda_h(&self) -> f64 {
        self.vev / FERMAT3 as f64
    }

    /// Proton mass: m_p = v / 2^(2^N_c) × 53/54.
    pub fn proton_mass(&self) -> f64 {
        self.vev / (1u64 << (1u64 << N_C)) as f64 * 53.0 / 54.0
    }

    /// Pion mass: m_π = m_p / β₀.
    pub fn pion_mass(&self) -> f64 {
        self.proton_mass() / BETA0 as f64
    }

    /// Electron mass: m_e = Λ_h / (N_c² × N_w⁴ × gauss).
    pub fn electron_mass(&self) -> f64 {
        self.lambda_h() / (N_C * N_C * N_W * N_W * N_W * N_W * GAUSS) as f64
    }

    /// Muon mass: m_μ = m_e × N_w⁴ × gauss.
    pub fn muon_mass(&self) -> f64 {
        self.electron_mass() * (N_W * N_W * N_W * N_W * GAUSS) as f64
    }

    /// QCD scale: Λ_QCD = m_p × N_c / gauss.
    pub fn lambda_qcd(&self) -> f64 {
        self.proton_mass() * N_C as f64 / GAUSS as f64
    }

    /// Pion decay constant: f_π = Λ_QCD × N_c / β₀.
    pub fn f_pi(&self) -> f64 {
        self.lambda_qcd() * N_C as f64 / BETA0 as f64
    }

    /// Higgs mass: m_H = v × √(2 · Λ_h/v) type relation.
    /// Simplified: m_H = v / N_w = v/2 (leading order).
    pub fn higgs_mass(&self) -> f64 {
        self.vev / N_W as f64
    }

    /// W boson mass: M_W = v × N_c / (2(N_c²−1)) = v × 3/16.
    pub fn w_mass(&self) -> f64 {
        self.vev * N_C as f64 / (2 * (N_C * N_C - 1)) as f64
    }

    /// Z boson mass: M_Z = v × N_c / (N_c²−1) = v × 3/8.
    pub fn z_mass(&self) -> f64 {
        self.vev * N_C as f64 / (N_C * N_C - 1) as f64
    }

    /// Bohr radius (fm): a₀ = ℏc / (m_e · α), with m_e in MeV.
    pub fn bohr_radius(&self) -> f64 {
        vev::HBAR_C / (self.electron_mass() * 1.0e3 * self.alpha())
    }

    // ═════════════════════════════════════════════════════════
    // VEV-INDEPENDENT: dimensionless constants
    // (same regardless of which VEV you use)
    // ═════════════════════════════════════════════════════════

    /// Fine structure constant: α = 1/((D+1)π + ln β₀).
    pub fn alpha(&self) -> f64 {
        1.0 / self.alpha_inv()
    }

    /// α⁻¹ = (D+1)π + ln(β₀) = 43π + ln7.
    pub fn alpha_inv(&self) -> f64 {
        (TOWER_D as f64 + 1.0) * std::f64::consts::PI + (BETA0 as f64).ln()
    }

    /// sin²θ_W = N_c/gauss + β₀/(d₄ · Σd²).
    pub fn sin2_theta_w(&self) -> f64 {
        N_C as f64 / GAUSS as f64 + BETA0 as f64 / (D4 * SIGMA_D2) as f64
    }

    /// κ = ln(N_c)/ln(N_w) = ln3/ln2.
    pub fn kappa(&self) -> f64 {
        (N_C as f64).ln() / (N_W as f64).ln()
    }

    /// C_F = (N_c²−1)/(2N_c) = 4/3.
    pub fn c_f(&self) -> f64 {
        (N_C * N_C - 1) as f64 / (2 * N_C) as f64
    }

    /// Spectral tower coupling at layer d.
    pub fn alpha_at_layer(&self, d: u64) -> f64 {
        1.0 / ((d as f64 + 1.0) * std::f64::consts::PI + (BETA0 as f64).ln())
    }

    /// Proton-to-electron mass ratio (full Seeley-DeWitt formula).
    ///
    /// m_p/m_e = 2(D² + Σd)/d₃ + gauss^N_c/κ + κ/(N_w·χ·Σd²·D)
    ///
    /// This is DIMENSIONLESS — does NOT depend on VEV.
    /// NOT computed as proton_mass()/electron_mass() because those
    /// simplified formulas don't reproduce the full result.
    pub fn mp_me_ratio(&self) -> f64 {
        let kappa = self.kappa();
        let base = 2.0 * (TOWER_D * TOWER_D + SIGMA_D) as f64 / D3 as f64;
        let mid = (GAUSS as f64).powi(N_C as i32) / kappa;
        let correction = kappa / (N_W * CHI * SIGMA_D2 * TOWER_D) as f64;
        base + mid + correction
    }
}

impl Default for Toe {
    fn default() -> Self {
        Self::new()
    }
}

impl std::fmt::Display for Toe {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        write!(f, "Toe(v={:.2} GeV{})",
               self.vev,
               if self.is_crystal_default() { " [crystal]" } else { "" })
    }
}
