// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// mera.rs — Multi-scale Entanglement Renormalization Ansatz
//
// MERA tensor network: 42 layers from UV (boundary) to IR (bulk).
// Isometries W: ℂ^χ → ℂ^(Σd) at each layer.
// Bond dimension = χ = 6.

use crate::atoms::*;

/// Total MERA layers = D = 42
pub const TOTAL_LAYERS: u64 = TOWER_D;

/// Bond dimension = χ = 6
pub const BOND_DIM: u64 = CHI;

/// Boundary sites at layer 0: χ^D
pub fn boundary_sites() -> f64 {
    (CHI as f64).powi(TOWER_D as i32)
}

/// Bulk site at layer D: 1
pub const BULK_SITES: u64 = 1;

/// Isometry dimension: W maps ℂ^χ → ℂ^(Σd) at each layer
pub const ISOMETRY_IN: u64 = CHI;
pub const ISOMETRY_OUT: u64 = SIGMA_D;

/// Disentanglers per layer: χ/2 = 3
pub const DISENTANGLERS_PER_LAYER: u64 = CHI / N_W;

/// RT coefficient: N_w² = 4 (S = A/(4G))
pub const RT_4: u64 = N_W * N_W;

/// EFE coefficient: d_colour = 8 (G = 8πG T)
pub const EFE_8: u64 = D3;

/// 16πG coefficient: N_w⁴ = 16
pub const COEFF_16PI_G: u64 = N_W * N_W * N_W * N_W;

/// MERA depth = 42 = Σd + χ
pub fn mera_proofs() -> Vec<(&'static str, bool)> {
    vec![
        ("Tower depth = 42",            TOTAL_LAYERS == 42),
        ("D = Σd + χ",                  TOWER_D == SIGMA_D + CHI),
        ("Bond dim = χ = 6",            BOND_DIM == 6),
        ("Bulk = 1",                    BULK_SITES == 1),
        ("Isometry: χ → Σd",           ISOMETRY_IN == CHI && ISOMETRY_OUT == SIGMA_D),
        ("RT 4 = N_w²",                RT_4 == 4),
        ("EFE 8 = d₃",                 EFE_8 == 8),
        ("16πG = N_w⁴",                COEFF_16PI_G == 16),
        ("Disentanglers = 3",           DISENTANGLERS_PER_LAYER == 3),
    ]
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn all_mera_pass() {
        for (name, pass) in mera_proofs() {
            assert!(pass, "MERA FAILED: {}", name);
        }
    }
    #[test] fn depth_42() { assert_eq!(TOTAL_LAYERS, 42); }
    #[test] fn bond_6() { assert_eq!(BOND_DIM, 6); }
}
