// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// mixing.rs — CKM and PMNS mixing matrices
//
// Matrix elements from A_F invariants. N_c×N_c = 3×3 matrices.

use crate::atoms::*;

// ═══════════════════════════════════════════════════════════════════
// CKM MATRIX (quark mixing)
// ═══════════════════════════════════════════════════════════════════

/// Cabibbo angle: sin(θ_C) = √(m_d/m_s) ≈ 1/√gauss.
/// θ_C ≈ 13° (Cabibbo angle).
pub fn sin_cabibbo() -> f64 {
    1.0 / (GAUSS as f64).sqrt()
}

pub fn cos_cabibbo() -> f64 {
    (1.0 - sin_cabibbo().powi(2)).sqrt()
}

/// |V_us| = sin(θ_C) = 1/√gauss ≈ 0.2774.
pub fn v_us() -> f64 {
    sin_cabibbo()
}

/// |V_ud| = cos(θ_C) ≈ 0.9608.
pub fn v_ud() -> f64 {
    cos_cabibbo()
}

/// |V_cb| ≈ sin(θ_C) × N_c/D = 1/√gauss × 3/42.
pub fn v_cb() -> f64 {
    sin_cabibbo() * N_C as f64 / TOWER_D as f64
}

/// |V_ub| ≈ sin(θ_C) × N_w/D = 1/√gauss × 2/42.
pub fn v_ub() -> f64 {
    sin_cabibbo() * N_W as f64 / TOWER_D as f64
}

/// |V_td| ≈ |V_cb| (approximate symmetry).
pub fn v_td() -> f64 {
    v_cb()
}

/// |V_ts| ≈ |V_cb| (approximate symmetry).
pub fn v_ts() -> f64 {
    v_cb()
}

/// |V_tb| ≈ 1 − |V_cb|²/2.
pub fn v_tb() -> f64 {
    1.0 - v_cb().powi(2) / 2.0
}

/// Jarlskog invariant: J ≈ sin²(θ_C) × |V_cb|² × sin(δ).
/// Crystal: J ≈ N_c²/(gauss · D²).
pub fn jarlskog() -> f64 {
    (N_C * N_C) as f64 / (GAUSS * TOWER_D * TOWER_D) as f64
}

// ═══════════════════════════════════════════════════════════════════
// PMNS MATRIX (neutrino mixing)
// ═══════════════════════════════════════════════════════════════════

/// sin²θ₁₂ (solar) ≈ N_c/gauss + correction.
pub fn sin2_theta12() -> f64 {
    N_C as f64 / GAUSS as f64 + N_W as f64 / (GAUSS * D3) as f64
}

/// sin²θ₂₃ (atmospheric) ≈ 1/N_w = 1/2 (maximal).
pub fn sin2_theta23() -> f64 {
    1.0 / N_W as f64
}

/// sin²θ₁₃ (reactor) ≈ N_w/(N_c · D) = 2/(3·42) = 1/63.
pub fn sin2_theta13() -> f64 {
    N_W as f64 / (N_C * TOWER_D) as f64
}

/// Number of mixing angles = N_c(N_c−1)/2 = 3.
pub fn n_mixing_angles() -> u64 {
    N_C * (N_C - 1) / 2
}

/// Number of CP phases (Dirac) = (N_c−1)(N_c−2)/2 = 1.
pub fn n_cp_phases() -> u64 {
    (N_C - 1) * (N_C - 2) / 2
}
