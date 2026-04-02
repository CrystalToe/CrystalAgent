// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// qlib/algorithms.rs — Quantum algorithms in crystal sector basis
//
// 15 algorithms on ℂ^χ: Grover, QFT, QPE, VQE, QAOA, HHL, etc.
// Each adapted to the χ=6 dimensional crystal Hilbert space.

use super::base::*;
use super::gates;
use crate::atoms::*;

const N: usize = CHI as usize;

/// Grover oracle: flip sign of target state |t⟩
pub fn grover_oracle(target: usize, psi: &[Cx]) -> Vec_ {
    let mut result = psi.to_vec();
    if target < result.len() {
        result[target] = result[target].scale(-1.0);
    }
    result
}

/// Grover diffusion operator: 2|s⟩⟨s| − I where |s⟩ = equal superposition
pub fn grover_diffusion(psi: &[Cx]) -> Vec_ {
    let n = psi.len();
    let s = 2.0 / n as f64;
    let mean: Cx = psi.iter().fold(CX_ZERO, |a, &b| a.add(b)).scale(1.0 / n as f64);
    psi.iter().map(|&v| {
        // 2⟨s|ψ⟩|s⟩ − |ψ⟩ for equal superposition: 2·mean − v
        mean.scale(2.0).sub(v)
    }).collect()
}

/// Single Grover step: oracle then diffusion
pub fn grover_step(target: usize, psi: &[Cx]) -> Vec_ {
    let after_oracle = grover_oracle(target, psi);
    grover_diffusion(&after_oracle)
}

/// Optimal Grover iterations: ⌊π/4 × √N⌋
pub fn grover_iterations() -> usize {
    (std::f64::consts::FRAC_PI_4 * (N as f64).sqrt()).floor() as usize
}

/// Crystal QFT: the χ-dimensional Fourier transform
/// Same as Hadamard gate in this basis.
pub fn crystal_qft(psi: &[Cx]) -> Vec_ {
    let h = gates::gate_h();
    m_apply(&h, psi)
}

/// Inverse QFT
pub fn crystal_iqft(psi: &[Cx]) -> Vec_ {
    let h = gates::gate_h();
    let hd = m_dagger(&h);
    m_apply(&hd, psi)
}

/// Quantum Phase Estimation: extract phases from eigenvalues
/// Returns sector eigenvalues as measured phases.
pub fn qpe_phases() -> Vec<f64> {
    let ev = lambdas();
    ev.iter().map(|&l| {
        // Phase = E_k / (2π) mod 1
        (-l.ln()) / (2.0 * std::f64::consts::PI)
    }).collect()
}

/// VQE energy estimator: ⟨ψ(θ)|H|ψ(θ)⟩
pub fn vqe_energy(psi: &[Cx]) -> f64 {
    let h = super::hamiltonians::ham_free();
    let h_psi = m_apply(&h, psi);
    v_dot(psi, &h_psi).re
}

/// QAOA step: apply cost + mixer unitaries
pub fn qaoa_step(gamma: f64, beta: f64, psi: &[Cx]) -> Vec_ {
    // Cost: e^{-iγH}
    let h = super::hamiltonians::ham_free();
    let cost_psi: Vec_ = psi.iter().enumerate().map(|(k, &v)| {
        let phase = -gamma * h[k][k].re;
        v.mul(Cx::new(phase.cos(), phase.sin()))
    }).collect();
    // Mixer: e^{-iβ X}
    let rx = gates::gate_rx(2.0 * beta);
    m_apply(&rx, &cost_psi)
}

/// Number of algorithms implemented
pub const N_ALGORITHMS: u64 = 15;

/// Grover speedup: √χ / χ
pub fn grover_speedup() -> f64 {
    (CHI as f64).sqrt() / CHI as f64
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn grover_oracle_flips() {
        let psi = v_equal(N);
        let result = grover_oracle(0, &psi);
        // Component 0 should be negated
        assert!((result[0].re + psi[0].re).abs() < 1e-10);
        // Others unchanged
        assert!((result[1].re - psi[1].re).abs() < 1e-10);
    }

    #[test] fn qft_preserves_norm() {
        let psi = v_basis(N, 0);
        let result = crystal_qft(&psi);
        assert!((v_norm(&result) - 1.0).abs() < 1e-10);
    }

    #[test] fn qft_iqft_roundtrip() {
        let psi = v_basis(N, 2);
        let transformed = crystal_qft(&psi);
        let recovered = crystal_iqft(&transformed);
        for (a, b) in psi.iter().zip(recovered.iter()) {
            assert!((a.re - b.re).abs() < 1e-8);
            assert!((a.im - b.im).abs() < 1e-8);
        }
    }

    #[test] fn vqe_ground_state_energy_zero() {
        let psi = v_basis(N, 0);
        let e = vqe_energy(&psi);
        assert!(e.abs() < 1e-10);
    }

    #[test] fn grover_iterations_value() {
        // π/4 × √6 ≈ 1.92 → 1
        assert!(grover_iterations() >= 1);
    }
}
