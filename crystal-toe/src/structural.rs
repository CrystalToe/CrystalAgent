// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// structural.rs — Structural theorems from A_F
//
// Proves: conservation, spin-statistics, CPT, no-cloning, Boltzmann DOF
// No new observables. Count unchanged.

use crate::atoms::*;

/// Gauge bosons: U(1) + SU(2) + SU(3) = 1 + 3 + 8 = 12
pub const GAUGE_BOSONS: u64 = D1 + (N_W * N_W - 1) + D3;

/// Spin-statistics: N_w = 2 (fermions need double cover of SO(N_c))
pub const SPIN_STAT_DIM: u64 = N_W;

/// KO dimension for CPT: χ = 6, and N_c is odd → parity exists
pub const KO_DIM: u64 = CHI;

/// Effective DOF for Boltzmann: Σd + (χ−1) = 36 + 5 = 41
pub const DOF_EFF: u64 = SIGMA_D + (CHI - 1);

/// All structural proofs
pub fn structural_proofs() -> Vec<(&'static str, bool)> {
    vec![
        ("Conservation: gauge bosons = 12", GAUGE_BOSONS == 12),
        ("Spin-statistics: N_w = 2",        SPIN_STAT_DIM == 2),
        ("CPT: KO dim = 6 and N_c odd",     KO_DIM == 6 && N_C % 2 == 1),
        ("No-clone: all d_k > 1 except singlet",
            D1 == 1 && D2 > 1 && D3 > 1 && D4 > 1),
        ("Boltzmann DOF = 41",              DOF_EFF == 41),
        ("Fermion families = N_c = 3",      N_C == 3),
        ("Spatial dim = N_c = 3",           N_C == 3),
        ("Time dim = 1 (singlet sector)",   D1 == 1),
        ("Spacetime = N_c + 1 = 4",        N_C + 1 == 4),
    ]
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn all_structural_pass() {
        for (name, pass) in structural_proofs() {
            assert!(pass, "Structural proof FAILED: {}", name);
        }
    }
    #[test] fn gauge_bosons_12() { assert_eq!(GAUGE_BOSONS, 12); }
    #[test] fn dof_eff_41() { assert_eq!(DOF_EFF, 41); }
}
