//! 27 quantum gates: 12 single-particle + 15 multi-particle.
//! All generalised from ℂ² to ℂ^χ = ℂ⁶.

use crate::base::*;
use std::f64::consts::PI;

// ═══════════════════════════════════════════════════════════════
// SINGLE-PARTICLE GATES ON ℂ^χ
// ═══════════════════════════════════════════════════════════════

/// Identity on ℂ^χ
pub fn gate_i() -> Mat { Mat::identity(CHI) }

/// Pauli X: cyclic shift |k⟩ → |k+1 mod χ⟩
pub fn gate_x() -> Mat {
    let mut m = Mat::new(CHI);
    for i in 0..CHI { m.set(i, (i + 1) % CHI, Cx::ONE); }
    m
}

/// Pauli Z: phase gate diag(1, ω, ω², ...) where ω = e^(2πi/χ)
pub fn gate_z() -> Mat {
    let diag: Vec<Cx> = (0..CHI)
        .map(|k| Cx::new(0.0, 2.0 * PI * k as f64 / CHI as f64).exp())
        .collect();
    Mat::from_diag(&diag)
}

/// Pauli Y: -i × X × Z
pub fn gate_y() -> Mat {
    let xz = gate_x().mul_mat(&gate_z());
    let minus_i = Cx::new(0.0, -1.0);
    Mat { rows: CHI, cols: CHI,
          data: xz.data.iter().map(|c| minus_i * *c).collect() }
}

/// Crystal Hadamard: (1/√χ) DFT matrix
pub fn gate_h() -> Mat {
    let s = 1.0 / (CHI as f64).sqrt();
    let mut m = Mat::new(CHI);
    for i in 0..CHI {
        for j in 0..CHI {
            let phase = Cx::new(0.0, 2.0 * PI * (i * j) as f64 / CHI as f64).exp();
            m.set(i, j, phase.scale(s));
        }
    }
    m
}

/// Phase S gate: diag(1, e^(iπ/χ), e^(2iπ/χ), ...)
pub fn gate_s() -> Mat {
    let diag: Vec<Cx> = (0..CHI)
        .map(|k| Cx::new(0.0, PI * k as f64 / CHI as f64).exp())
        .collect();
    Mat::from_diag(&diag)
}

/// T gate: diag(1, e^(iπ/(2χ)), ...)
pub fn gate_t() -> Mat {
    let diag: Vec<Cx> = (0..CHI)
        .map(|k| Cx::new(0.0, PI * k as f64 / (2.0 * CHI as f64)).exp())
        .collect();
    Mat::from_diag(&diag)
}

/// Rx(θ): rotation around X = cos(θ/2)I - i sin(θ/2)X
pub fn gate_rx(theta: f64) -> Mat {
    let c = (theta / 2.0).cos();
    let s = (theta / 2.0).sin();
    let id = Mat::identity(CHI).scale(c);
    let xm = gate_x();
    let mut result = Mat::new(CHI);
    for i in 0..CHI {
        for j in 0..CHI {
            let ix = Cx::new(0.0, -s) * xm.get(i, j);
            result.set(i, j, id.get(i, j) + ix);
        }
    }
    result
}

/// Ry(θ): rotation around Y
pub fn gate_ry(theta: f64) -> Mat {
    let c = (theta / 2.0).cos();
    let s = (theta / 2.0).sin();
    let id = Mat::identity(CHI).scale(c);
    let ym = gate_y();
    let mut result = Mat::new(CHI);
    for i in 0..CHI {
        for j in 0..CHI {
            result.set(i, j, id.get(i, j) + ym.get(i, j).scale(s));
        }
    }
    result
}

/// Rz(θ): phase rotation diag(e^(-iθk/χ))
pub fn gate_rz(theta: f64) -> Mat {
    let diag: Vec<Cx> = (0..CHI)
        .map(|k| Cx::new(0.0, -theta * k as f64 / CHI as f64).exp())
        .collect();
    Mat::from_diag(&diag)
}

/// U3(θ,φ,λ): universal = Rz(φ) Ry(θ) Rz(λ)
pub fn gate_u3(theta: f64, phi: f64, lam: f64) -> Mat {
    gate_rz(phi).mul_mat(&gate_ry(theta)).mul_mat(&gate_rz(lam))
}

/// √X: square root of cyclic shift
pub fn gate_sx() -> Mat {
    let h = gate_h();
    let mut diag: Vec<Cx> = (0..CHI)
        .map(|k| Cx::new(0.0, PI * k as f64 / CHI as f64).exp())
        .collect();
    let phase_mat = Mat::from_diag(&diag);
    h.dagger().mul_mat(&phase_mat).mul_mat(&h)
}

// ═══════════════════════════════════════════════════════════════
// MULTI-PARTICLE GATES ON ℂ^χ ⊗ ℂ^χ = ℂ^36
// ═══════════════════════════════════════════════════════════════

const DIM2: usize = CHI * CHI;  // 36

/// CNOT: if sector₁ > 0, rotate sector₂ by one level
pub fn gate_cnot() -> Mat {
    let mut m = Mat::new(DIM2);
    for i in 0..DIM2 {
        let (ci, cj) = (i / CHI, i % CHI);
        let target = if ci > 0 { (cj + 1) % CHI } else { cj };
        m.set(i, ci * CHI + target, Cx::ONE);
    }
    m
}

/// CZ: if sector₁ = k, apply Z^k to particle 2
pub fn gate_cz() -> Mat {
    let diag: Vec<Cx> = (0..DIM2)
        .map(|k| {
            let (ci, cj) = (k / CHI, k % CHI);
            Cx::new(0.0, 2.0 * PI * (ci * cj) as f64 / CHI as f64).exp()
        })
        .collect();
    Mat::from_diag(&diag)
}

/// SWAP: |i,j⟩ → |j,i⟩
pub fn gate_swap() -> Mat {
    let mut m = Mat::new(DIM2);
    for i in 0..CHI {
        for j in 0..CHI {
            m.set(i * CHI + j, j * CHI + i, Cx::ONE);
        }
    }
    m
}

/// iSWAP: SWAP with i phase on swapped elements
pub fn gate_iswap() -> Mat {
    let mut m = Mat::new(DIM2);
    for i in 0..CHI {
        for j in 0..CHI {
            if i == j { m.set(i * CHI + j, i * CHI + j, Cx::ONE); }
            else { m.set(i * CHI + j, j * CHI + i, Cx::I); }
        }
    }
    m
}

/// √SWAP: half swap, generates entanglement
pub fn gate_sqrt_swap() -> Mat {
    let s = gate_swap();
    let id = Mat::identity(DIM2);
    let half_plus = Cx::new(0.5, 0.5);
    let half_minus = Cx::new(0.5, -0.5);
    let mut m = Mat::new(DIM2);
    for i in 0..DIM2 {
        for j in 0..DIM2 {
            m.set(i, j, half_plus * id.get(i, j) + half_minus * s.get(i, j));
        }
    }
    m
}

/// Toffoli (CCX): applied as function on ℂ^(χ³)
pub fn gate_toffoli(psi: &Vec_) -> Vec_ {
    let n = CHI * CHI * CHI;
    assert_eq!(psi.dim(), n);
    let mut out = Vec_::new(n);
    for k in 0..n {
        let a = k / (CHI * CHI);
        let bc = k % (CHI * CHI);
        let (b, c) = (bc / CHI, bc % CHI);
        let tc = if a > 0 && b > 0 { (c + 1) % CHI } else { c };
        out.data[k] = psi.data[a * CHI * CHI + b * CHI + tc];
    }
    out
}

/// CSWAP (Fredkin): controlled swap on 3 particles
pub fn gate_cswap(psi: &Vec_) -> Vec_ {
    let n = CHI * CHI * CHI;
    assert_eq!(psi.dim(), n);
    let mut out = Vec_::new(n);
    for k in 0..n {
        let a = k / (CHI * CHI);
        let bc = k % (CHI * CHI);
        let (b, c) = (bc / CHI, bc % CHI);
        let (sb, sc) = if a > 0 { (c, b) } else { (b, c) };
        out.data[k] = psi.data[a * CHI * CHI + sb * CHI + sc];
    }
    out
}

/// XX(θ): coupled sector flips
pub fn gate_xx(theta: f64) -> Mat {
    let c = theta.cos();
    let s = theta.sin();
    let id = Mat::identity(DIM2).scale(c);
    let x1x2 = tensor_product(&gate_x(), &gate_x());
    let mut m = Mat::new(DIM2);
    for i in 0..DIM2 {
        for j in 0..DIM2 {
            m.set(i, j, id.get(i, j) + (Cx::new(0.0, -s) * x1x2.get(i, j)));
        }
    }
    m
}

/// YY(θ): coupled Y-rotations
pub fn gate_yy(theta: f64) -> Mat {
    let c = theta.cos();
    let s = theta.sin();
    let id = Mat::identity(DIM2).scale(c);
    let y1y2 = tensor_product(&gate_y(), &gate_y());
    let mut m = Mat::new(DIM2);
    for i in 0..DIM2 {
        for j in 0..DIM2 {
            m.set(i, j, id.get(i, j) + (Cx::new(0.0, -s) * y1y2.get(i, j)));
        }
    }
    m
}

/// ZZ(θ): correlated phase evolution
pub fn gate_zz(theta: f64) -> Mat {
    let diag: Vec<Cx> = (0..DIM2)
        .map(|k| {
            let (ci, cj) = (k / CHI, k % CHI);
            let ph = theta * (ci * cj) as f64 / (CHI * CHI) as f64;
            Cx::new(0.0, -ph).exp()
        })
        .collect();
    Mat::from_diag(&diag)
}

/// ECR: echoed cross-resonance = XX(π/4) × CNOT
pub fn gate_ecr() -> Mat {
    gate_xx(PI / 4.0).mul_mat(&gate_cnot())
}

/// Givens rotation between levels i and j
pub fn gate_givens(li: usize, lj: usize, theta: f64) -> Mat {
    let mut m = Mat::identity(CHI);
    let (c, s) = (theta.cos(), theta.sin());
    m.set(li, li, Cx::from_real(c));
    m.set(li, lj, Cx::from_real(-s));
    m.set(lj, li, Cx::from_real(s));
    m.set(lj, lj, Cx::from_real(c));
    m
}

/// Fermionic SWAP: SWAP × (-1)^parity
pub fn gate_fswap() -> Mat {
    let mut m = Mat::new(DIM2);
    for i in 0..CHI {
        for j in 0..CHI {
            let phase = if i != j { Cx::from_real(-1.0) } else { Cx::ONE };
            m.set(i * CHI + j, j * CHI + i, phase);
        }
    }
    m
}

/// Matchgate: parity-preserving
pub fn gate_matchgate(theta: f64, phi: f64) -> Mat {
    gate_givens(0, 1, theta).mul_mat(&gate_rz(phi))
}

// ═══════════════════════════════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════════════════════════════

/// Tensor product of two matrices: A ⊗ B
pub fn tensor_product(a: &Mat, b: &Mat) -> Mat {
    let na = a.rows;
    let nb = b.rows;
    let n = na * nb;
    let mut m = Mat::new(n);
    for i in 0..na {
        for j in 0..na {
            for k in 0..nb {
                for l in 0..nb {
                    m.set(i * nb + k, j * nb + l, a.get(i, j) * b.get(k, l));
                }
            }
        }
    }
    m
}
