// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// vev.rs — VEV derivation + conversion factor

use crate::atoms::*;

/// Planck mass (GeV) — the ONE measurement.
pub const M_PL: f64 = 1.22089e19;

/// Crystal-derived Higgs VEV (GeV).
///
/// v = M_Pl × (Σd−1) / ((D+1) × Σd × 2^(D+d₃))
///   = M_Pl × 35 / (43 × 36 × 2⁵⁰)
pub const VEV_CRYSTAL: f64 = M_PL * 35.0 / (43.0 * 36.0 * (1u64 << 50) as f64);

/// ℏc in MeV·fm (unit conversion, not physics).
pub const HBAR_C: f64 = 197.3269804;

/// VEV conversion factor: Crystal → PDG.
///
/// factor = 1 + N_c · y_t² / (16π²) · ln(√N_w · d₃ / N_c²)
///        = 1 + 3/(16π²) · ln(√2 · 8/9)
///        ≈ 1.00435
///
/// Every piece from A_F:
///   N_c = 3, y_t = 1, 16π² (one-loop in d=N_w²=4),
///   √N_w · d₃/N_c² = √2 · 8/9 (scale ratio μ_H/M_Z).
pub fn conversion_factor() -> f64 {
    let nc = N_C as f64;
    let nw = N_W as f64;
    let d3 = D3 as f64;
    let one_loop = 16.0 * std::f64::consts::PI * std::f64::consts::PI;
    let ratio = nw.sqrt() * d3 / (nc * nc); // √2 · 8/9
    1.0 + nc / one_loop * ratio.ln()
}

/// VEV at PDG scale.
pub fn vev_pdg() -> f64 {
    VEV_CRYSTAL * conversion_factor()
}
