// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// hierarchy.rs — Hierarchical implosion: a₄ corrections → a₂ bases.
//
// Every energy E = E_base(a₂) × (1 ± correction(a₄)).
// Corrections are exact rational fractions from A_F atoms.

use crate::atoms::*;

// ═══════════════════════════════════════════════════════════════════
// SEELEY-DEWITT COEFFICIENTS
// ═══════════════════════════════════════════════════════════════════

/// Heat kernel expansion coefficients.
pub struct SeeleyDeWitt;

impl SeeleyDeWitt {
    /// a₀ = Σd = 36 (DOF count, topological).
    pub const A0: u64 = SIGMA_D;

    /// a₂ = per-sector dimensions (base formulas).
    pub const A2: [u64; 4] = SECTOR_DIMS;

    /// a₄ = Σd² = 650 (correction scale).
    pub const A4: u64 = SIGMA_D2;

    /// Shared core = Σd² × D = 27300.
    pub const CORE: u64 = SHARED_CORE;
}

// ═══════════════════════════════════════════════════════════════════
// IMPLOSION CHANNELS
// ═══════════════════════════════════════════════════════════════════

/// An implosion channel: E = E_base × multiplier.
#[derive(Debug, Clone)]
pub struct Implosion {
    pub name: &'static str,
    pub correction: Frac,
    pub multiplier: Frac,
    pub channel: &'static str,
}

impl std::fmt::Display for Implosion {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        write!(
            f,
            "{:<12} → × {:<8} (correction {})  [{}]",
            self.name, self.multiplier, self.correction, self.channel
        )
    }
}

/// Build all implosion channels. Every fraction computed from A_F atoms.
pub fn implosion_channels() -> Vec<Implosion> {
    vec![
        // ε_vdw × (1 − N_c³/(χ·Σd)) = × 7/8
        Implosion {
            name: "ε_vdw",
            correction: Frac::new(
                (N_C * N_C * N_C) as i64,
                (CHI * SIGMA_D) as i64,
            )
            .reduce(), // 27/216 = 1/8
            multiplier: Frac::one_minus(
                Frac::new((N_C * N_C * N_C) as i64, (CHI * SIGMA_D) as i64).reduce(),
            ), // 7/8
            channel: "m_Υ",
        },
        // E_hbond × (1 − T_F/(χ)) = × 11/12
        Implosion {
            name: "E_hbond",
            correction: Frac::new(T_F.0 as i64, (T_F.1 * CHI) as i64).reduce(), // 1/12
            multiplier: Frac::one_minus(
                Frac::new(T_F.0 as i64, (T_F.1 * CHI) as i64).reduce(),
            ), // 11/12
            channel: "m_ρ",
        },
        // K_angle × (1 + D/(d₄·Σd)) = × 151/144
        Implosion {
            name: "K_angle",
            correction: Frac::new(TOWER_D as i64, (D4 * SIGMA_D) as i64).reduce(), // 7/144
            multiplier: Frac::one_plus(
                Frac::new(TOWER_D as i64, (D4 * SIGMA_D) as i64).reduce(),
            ), // 151/144
            channel: "m_D",
        },
        // E_burial × (1 + β₀/(d₄·Σd²)) = × 15607/15600
        Implosion {
            name: "E_burial",
            correction: Frac::new(BETA0 as i64, (D4 * SIGMA_D2) as i64).reduce(), // 7/15600
            multiplier: Frac::one_plus(
                Frac::new(BETA0 as i64, (D4 * SIGMA_D2) as i64).reduce(),
            ),
            channel: "r_p",
        },
        // r_vdw × (1 − T_F/(d₃·Σd)) = × 575/576
        Implosion {
            name: "r_vdw",
            correction: Frac::new(T_F.0 as i64, (T_F.1 * D3 * SIGMA_D) as i64).reduce(), // 1/576
            multiplier: Frac::one_minus(
                Frac::new(T_F.0 as i64, (T_F.1 * D3 * SIGMA_D) as i64).reduce(),
            ), // 575/576
            channel: "r_p",
        },
        // r_hbond × (1 − N_w/(N_c·Σd)) = × 53/54
        Implosion {
            name: "r_hbond",
            correction: Frac::new(N_W as i64, (N_C * SIGMA_D) as i64).reduce(), // 1/54
            multiplier: Frac::one_minus(
                Frac::new(N_W as i64, (N_C * SIGMA_D) as i64).reduce(),
            ), // 53/54
            channel: "m_p",
        },
    ]
}

// ═══════════════════════════════════════════════════════════════════
// COSMOLOGICAL PARTITION
// ═══════════════════════════════════════════════════════════════════

/// The tower partitions into vacuum, dark matter, and baryonic sectors.
///
/// Ω_Λ   = (D − gauss)/D = 29/42  ≈ 0.690
/// Ω_cdm = (gauss − N_w)/D = 11/42 ≈ 0.262
/// Ω_b   = N_w/D = 2/42 = 1/21    ≈ 0.048
///
/// Sum = 42/42 = 1. Exact.
pub struct CosmoPartition {
    pub omega_lambda: Frac,
    pub omega_cdm: Frac,
    pub omega_b: Frac,
}

impl CosmoPartition {
    pub fn new() -> Self {
        CosmoPartition {
            omega_lambda: Frac::new((TOWER_D - GAUSS) as i64, TOWER_D as i64).reduce(),
            omega_cdm: Frac::new((GAUSS - N_W) as i64, TOWER_D as i64).reduce(),
            omega_b: Frac::new(N_W as i64, TOWER_D as i64).reduce(),
        }
    }

    pub fn verify_sum(&self) -> bool {
        (TOWER_D - GAUSS) + (GAUSS - N_W) + N_W == TOWER_D
    }
}

impl Default for CosmoPartition {
    fn default() -> Self {
        Self::new()
    }
}
