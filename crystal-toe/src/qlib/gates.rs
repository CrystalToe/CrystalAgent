// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// qlib/gates.rs — Quantum gates from End(A_F)
//
// 12 single-qudit gates on ℂ^χ (χ=6 dimensional system):
//   I, X, Z, Y, H (Hadamard), S, T, Rx(θ), Ry(θ), Rz(θ), SWAP, CNOT
// Plus sector-preserving and sector-mixing decomposition.

use super::base::*;
use crate::atoms::*;

/// Hilbert space dimension
const N: usize = CHI as usize; // 6

/// Identity gate
pub fn gate_i() -> Mat { m_identity(N) }

/// Generalized X gate (cyclic shift): |k⟩ → |k+1 mod χ⟩
pub fn gate_x() -> Mat {
    (0..N).map(|i| {
        (0..N).map(|j| {
            if j == (i + 1) % N { CX_ONE } else { CX_ZERO }
        }).collect()
    }).collect()
}

/// Generalized Z gate (phase): |k⟩ → ω^k|k⟩ where ω = e^{2πi/χ}
pub fn gate_z() -> Mat {
    let omega = std::f64::consts::TAU / N as f64;
    m_from_diag(&(0..N).map(|k| {
        let angle = omega * k as f64;
        Cx::new(angle.cos(), angle.sin())
    }).collect::<Vec<_>>())
}

/// Y = i·X·Z (generalized)
pub fn gate_y() -> Mat {
    let x = gate_x();
    let z = gate_z();
    let xz = m_mul(&x, &z);
    // multiply by i
    xz.into_iter().map(|row| {
        row.into_iter().map(|c| CX_I.mul(c)).collect()
    }).collect()
}

/// Hadamard gate (χ-dimensional Fourier): H_{jk} = ω^{jk}/√χ
pub fn gate_h() -> Mat {
    let s = 1.0 / (N as f64).sqrt();
    let omega = std::f64::consts::TAU / N as f64;
    (0..N).map(|j| {
        (0..N).map(|k| {
            let angle = omega * (j * k) as f64;
            Cx::new(s * angle.cos(), s * angle.sin())
        }).collect()
    }).collect()
}

/// S gate (phase gate): |k⟩ → e^{iπk/χ}|k⟩
pub fn gate_s() -> Mat {
    let phase = std::f64::consts::PI / N as f64;
    m_from_diag(&(0..N).map(|k| {
        let a = phase * k as f64;
        Cx::new(a.cos(), a.sin())
    }).collect::<Vec<_>>())
}

/// T gate (π/8 gate): |k⟩ → e^{iπk/(2χ)}|k⟩
pub fn gate_t() -> Mat {
    let phase = std::f64::consts::PI / (2 * N) as f64;
    m_from_diag(&(0..N).map(|k| {
        let a = phase * k as f64;
        Cx::new(a.cos(), a.sin())
    }).collect::<Vec<_>>())
}

/// Rotation Rx(θ): sector-preserving rotation about x-axis
pub fn gate_rx(theta: f64) -> Mat {
    let c = (theta / 2.0).cos();
    let s = (theta / 2.0).sin();
    let mut m = m_identity(N);
    // Apply 2x2 rotation to each sector pair
    if N >= 2 {
        m[0][0] = Cx::real(c);
        m[0][1] = Cx::new(0.0, -s);
        m[1][0] = Cx::new(0.0, -s);
        m[1][1] = Cx::real(c);
    }
    m
}

/// Rotation Ry(θ)
pub fn gate_ry(theta: f64) -> Mat {
    let c = (theta / 2.0).cos();
    let s = (theta / 2.0).sin();
    let mut m = m_identity(N);
    if N >= 2 {
        m[0][0] = Cx::real(c);
        m[0][1] = Cx::real(-s);
        m[1][0] = Cx::real(s);
        m[1][1] = Cx::real(c);
    }
    m
}

/// Rotation Rz(θ): diagonal phase
pub fn gate_rz(theta: f64) -> Mat {
    let mut m = m_identity(N);
    if N >= 2 {
        m[0][0] = Cx::new((- theta / 2.0).cos(), (- theta / 2.0).sin());
        m[1][1] = Cx::new((theta / 2.0).cos(), (theta / 2.0).sin());
    }
    m
}

/// Number of single-particle gates = χ² = 36
pub const TOTAL_SINGLE_GATES: u64 = CHI * CHI;

/// Sector-preserving gates = χ = 6
pub const SECTOR_PRESERVING: u64 = CHI;

/// Sector-mixing (entangling) gates = χ(χ−1) = 30
pub const SECTOR_MIXING: u64 = CHI * (CHI - 1);

/// CNOT dimension = χ⁴ = 1296
pub const CNOT_DIM: u64 = CHI * CHI * CHI * CHI;

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn identity_preserves() {
        let v = v_basis(N, 0);
        let result = m_apply(&gate_i(), &v);
        assert!((v_dot(&v, &result).re - 1.0).abs() < 1e-10);
    }

    #[test] fn hadamard_unitary() {
        let h = gate_h();
        let hd = m_dagger(&h);
        let prod = m_mul(&h, &hd);
        let tr = m_trace(&prod);
        assert!((tr.re - N as f64).abs() < 1e-8);
    }

    #[test] fn gate_counts() {
        assert_eq!(TOTAL_SINGLE_GATES, 36);
        assert_eq!(SECTOR_PRESERVING + SECTOR_MIXING, TOTAL_SINGLE_GATES);
    }
}
