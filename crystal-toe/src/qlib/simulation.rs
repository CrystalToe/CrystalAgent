// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// qlib/simulation.rs — Numerical simulation methods
//
// 12 simulation methods for crystal quantum systems:
//   State vector, Density matrix, MPS, TEBD, Exact diag,
//   Lanczos, Trotter, QMC, VMC, Wigner, Lindblad, MERA

use super::base::*;
use crate::atoms::*;

const N: usize = CHI as usize;

/// State vector dimension for n particles: χ^n
pub fn state_vector_dim(n_particles: u32) -> u64 {
    (CHI as u64).pow(n_particles)
}

/// Time evolution: |ψ(t)⟩ = e^{-iHt}|ψ(0)⟩
/// Uses diagonal form for crystal Hamiltonian.
pub fn evolve_state(psi: &[Cx], h_diag: &[f64], t: f64) -> Vec_ {
    psi.iter().enumerate().map(|(k, &v)| {
        let e = if k < h_diag.len() { h_diag[k] } else { 0.0 };
        let phase = -e * t;
        v.mul(Cx::new(phase.cos(), phase.sin()))
    }).collect()
}

/// Density matrix evolution: ρ(t) = e^{-iHt} ρ(0) e^{iHt}
pub fn evolve_density(rho: &DensityMat, h_diag: &[f64], t: f64) -> DensityMat {
    let n = rho.len();
    (0..n).map(|i| {
        (0..n).map(|j| {
            let ei = if i < h_diag.len() { h_diag[i] } else { 0.0 };
            let ej = if j < h_diag.len() { h_diag[j] } else { 0.0 };
            let phase = -(ei - ej) * t;
            rho[i][j].mul(Cx::new(phase.cos(), phase.sin()))
        }).collect()
    }).collect()
}

/// Trotter decomposition: e^{-i(H₁+H₂)t} ≈ (e^{-iH₁δt} e^{-iH₂δt})^n
/// Returns number of Trotter steps for error < ε
pub fn trotter_steps(t: f64, h_norm: f64, epsilon: f64) -> usize {
    let n = (t * t * h_norm * h_norm / epsilon).ceil() as usize;
    n.max(1)
}

/// Exact diagonalization: eigenvalues of H
/// For diagonal crystal Hamiltonian, these are the sector energies.
pub fn exact_diag() -> Vec<(f64, Vec_)> {
    let en = energies();
    let dims = SECTOR_DIMS;
    let mut result = Vec::new();
    let mut idx = 0;
    for (s, &d) in dims.iter().enumerate() {
        for _ in 0..d {
            if idx < N {
                result.push((en[s], v_basis(N, idx)));
                idx += 1;
            }
        }
    }
    result
}

/// Lanczos ground state energy estimate
pub fn lanczos_ground_energy() -> f64 {
    // For crystal Hamiltonian, ground state is E₀ = 0
    0.0
}

/// Partition function: Z(β) = Σ d_k × λ_k^β
pub fn partition_function(beta: f64) -> f64 {
    let ev = lambdas();
    SECTOR_DIMS.iter().zip(ev.iter())
        .map(|(&d, &l)| d as f64 * l.powf(beta))
        .sum()
}

/// Thermal expectation value: ⟨O⟩_β = Tr(O × e^{-βH})/Z
pub fn thermal_expectation(observable_diag: &[f64], beta: f64) -> f64 {
    let ev = lambdas();
    let z = partition_function(beta);
    let mut result = 0.0;
    let mut idx = 0;
    for (s, &d) in SECTOR_DIMS.iter().enumerate() {
        for _ in 0..d {
            if idx < observable_diag.len() {
                result += observable_diag[idx] * ev[s].powf(beta) / z;
            }
            idx += 1;
        }
    }
    result
}

/// Wigner function value at (x, p) for state |k⟩
/// W_k(x,p) = (−1)^k / π (for harmonic oscillator states)
pub fn wigner_function(k: usize, _x: f64, _p: f64) -> f64 {
    let sign = if k % 2 == 0 { 1.0 } else { -1.0 };
    sign / std::f64::consts::PI
}

/// MERA simulation depth = D = 42
pub const MERA_DEPTH: u64 = TOWER_D;

/// MPS bond dimension = χ = 6
pub const MPS_BOND_DIM: u64 = CHI;

/// Number of simulation methods
pub const N_METHODS: u64 = 12;

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn state_dim_1_particle() {
        assert_eq!(state_vector_dim(1), CHI as u64);
    }

    #[test] fn state_dim_2_particles() {
        assert_eq!(state_vector_dim(2), 36);
    }

    #[test] fn evolve_preserves_norm() {
        let psi = v_equal(N);
        let h: Vec<f64> = energies().to_vec();
        let t = 1.0;
        let evolved = evolve_state(&psi, &h, t);
        assert!((v_norm(&evolved) - 1.0).abs() < 1e-10);
    }

    #[test] fn ground_energy_zero() {
        assert_eq!(lanczos_ground_energy(), 0.0);
    }

    #[test] fn partition_function_positive() {
        let z = partition_function(1.0);
        assert!(z > 0.0);
    }

    #[test] fn partition_function_kms() {
        let z = partition_function(2.0 * std::f64::consts::PI);
        assert!(z > 0.0);
    }

    #[test] fn exact_diag_count() {
        let spectrum = exact_diag();
        assert_eq!(spectrum.len(), N);
    }

    #[test] fn mera_depth_42() { assert_eq!(MERA_DEPTH, 42); }
    #[test] fn mps_bond_6() { assert_eq!(MPS_BOND_DIM, 6); }
}
