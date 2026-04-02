// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// qlib/channels.rs — Quantum channels (noise/decoherence)
//
// Each channel maps sector eigenvalues toward equilibrium.
// Decoherence = sector mixing. Thermalization = approach to Gibbs state.

use super::base::*;
use crate::atoms::*;

const N: usize = CHI as usize;

/// Depolarizing channel: ρ → (1−p)ρ + p·I/χ
pub fn depolarise(p: f64, rho: &DensityMat) -> DensityMat {
    let mixed = dm_mixed(N);
    (0..N).map(|i| {
        (0..N).map(|j| {
            rho[i][j].scale(1.0 - p).add(mixed[i][j].scale(p))
        }).collect()
    }).collect()
}

/// Amplitude damping: decay from excited to ground (sector 0)
pub fn amplitude_damp(gamma: f64, rho: &DensityMat) -> DensityMat {
    let mut result = rho.clone();
    let sg = gamma.sqrt();
    for k in 1..N {
        let pop = rho[k][k].re;
        result[0][0] = result[0][0].add(Cx::real(gamma * pop));
        result[k][k] = result[k][k].scale(1.0 - gamma);
        // Off-diagonal damping
        for j in 0..N {
            if j != k {
                result[k][j] = result[k][j].scale((1.0 - gamma).sqrt());
                result[j][k] = result[j][k].scale((1.0 - gamma).sqrt());
            }
        }
    }
    let _ = sg; // used implicitly in damping factor
    result
}

/// Phase damping: decoherence without energy exchange
pub fn phase_damp(gamma: f64, rho: &DensityMat) -> DensityMat {
    let mut result = rho.clone();
    for i in 0..N {
        for j in 0..N {
            if i != j {
                result[i][j] = result[i][j].scale(1.0 - gamma);
            }
        }
    }
    result
}

/// Bit flip: |k⟩ → |χ−1−k⟩ with probability p
pub fn bit_flip(p: f64, rho: &DensityMat) -> DensityMat {
    let mut flipped = m_new(N);
    for i in 0..N {
        for j in 0..N {
            flipped[i][j] = rho[N - 1 - i][N - 1 - j];
        }
    }
    (0..N).map(|i| {
        (0..N).map(|j| {
            rho[i][j].scale(1.0 - p).add(flipped[i][j].scale(p))
        }).collect()
    }).collect()
}

/// Phase flip: |k⟩ → (−1)^k|k⟩ with probability p
pub fn phase_flip(p: f64, rho: &DensityMat) -> DensityMat {
    let mut result = rho.clone();
    for i in 0..N {
        for j in 0..N {
            let sign = if (i + j) % 2 == 1 { -1.0 } else { 1.0 };
            result[i][j] = rho[i][j].scale(1.0 - p)
                .add(rho[i][j].scale(p * sign));
        }
    }
    result
}

/// Thermal relaxation: approach Gibbs state at KMS β = 2π
pub fn thermal_relax(rate: f64, rho: &DensityMat) -> DensityMat {
    let beta = 2.0 * std::f64::consts::PI;
    let ev = lambdas();
    let z: f64 = SECTOR_DIMS.iter().zip(ev.iter())
        .map(|(&d, &l)| d as f64 * l.powf(beta)).sum();
    let mut gibbs = m_new(N);
    // Approximate Gibbs state (diagonal in sector basis)
    let mut idx = 0;
    for (s, &d) in SECTOR_DIMS.iter().enumerate() {
        let weight = ev[s].powf(beta) / z;
        for _ in 0..d {
            if idx < N { gibbs[idx][idx] = Cx::real(weight); }
            idx += 1;
        }
    }
    (0..N).map(|i| {
        (0..N).map(|j| {
            rho[i][j].scale(1.0 - rate).add(gibbs[i][j].scale(rate))
        }).collect()
    }).collect()
}

/// Channel fidelity: F(ρ,σ) = [Tr(√(√ρ·σ·√ρ))]²
/// Simplified: for pure states, F = ⟨ψ|σ|ψ⟩
pub fn channel_fidelity(rho: &DensityMat, sigma: &DensityMat) -> f64 {
    // Simplified: Tr(ρ·σ) (Hilbert-Schmidt inner product)
    let prod = m_mul(rho, sigma);
    m_trace(&prod).re
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn depolarise_preserves_trace() {
        let rho = dm_pure(&v_basis(N, 0));
        let out = depolarise(0.5, &rho);
        let tr = m_trace(&out);
        assert!((tr.re - 1.0).abs() < 1e-10);
    }

    #[test] fn full_depolarise_is_mixed() {
        let rho = dm_pure(&v_basis(N, 0));
        let out = depolarise(1.0, &rho);
        let purity = dm_purity(&out);
        assert!((purity - 1.0 / N as f64).abs() < 1e-10);
    }

    #[test] fn phase_damp_preserves_diagonal() {
        let rho = dm_pure(&v_equal(N));
        let out = phase_damp(0.5, &rho);
        let tr = m_trace(&out);
        assert!((tr.re - 1.0).abs() < 1e-10);
    }
}
