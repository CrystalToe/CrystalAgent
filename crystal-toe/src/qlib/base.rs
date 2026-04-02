// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// qlib/base.rs — Shared quantum types from CrystalQBase.hs
//
// Complex ℂ, Vec = ℂ^n, Mat = M_n(ℂ). All from N_w=2, N_c=3.

use crate::atoms::*;

// ═══════════════════════════════════════════════════════════════
// COMPLEX ARITHMETIC
// ═══════════════════════════════════════════════════════════════

#[derive(Clone, Copy, Debug)]
pub struct Cx {
    pub re: f64,
    pub im: f64,
}

pub const CX_ZERO: Cx = Cx { re: 0.0, im: 0.0 };
pub const CX_ONE: Cx = Cx { re: 1.0, im: 0.0 };
pub const CX_I: Cx = Cx { re: 0.0, im: 1.0 };

impl Cx {
    pub fn new(re: f64, im: f64) -> Self { Cx { re, im } }
    pub fn real(r: f64) -> Self { Cx { re: r, im: 0.0 } }
    pub fn add(self, other: Cx) -> Cx { Cx { re: self.re + other.re, im: self.im + other.im } }
    pub fn sub(self, other: Cx) -> Cx { Cx { re: self.re - other.re, im: self.im - other.im } }
    pub fn mul(self, other: Cx) -> Cx {
        Cx { re: self.re * other.re - self.im * other.im,
             im: self.re * other.im + self.im * other.re }
    }
    pub fn scale(self, s: f64) -> Cx { Cx { re: self.re * s, im: self.im * s } }
    pub fn conj(self) -> Cx { Cx { re: self.re, im: -self.im } }
    pub fn norm2(self) -> f64 { self.re * self.re + self.im * self.im }
    pub fn norm(self) -> f64 { self.norm2().sqrt() }
    pub fn exp(self) -> Cx {
        let r = self.re.exp();
        Cx { re: r * self.im.cos(), im: r * self.im.sin() }
    }
}

// ═══════════════════════════════════════════════════════════════
// VECTOR OPERATIONS (ℂ^n)
// ═══════════════════════════════════════════════════════════════

pub type Vec_ = Vec<Cx>;

/// Zero vector of dimension n
pub fn v_new(n: usize) -> Vec_ { vec![CX_ZERO; n] }

/// Basis vector |k⟩ in ℂ^n
pub fn v_basis(n: usize, k: usize) -> Vec_ {
    let mut v = v_new(n);
    if k < n { v[k] = CX_ONE; }
    v
}

/// Equal superposition |+⟩ = 1/√n Σ|k⟩
pub fn v_equal(n: usize) -> Vec_ {
    let s = 1.0 / (n as f64).sqrt();
    vec![Cx::real(s); n]
}

/// Vector addition
pub fn v_add(a: &[Cx], b: &[Cx]) -> Vec_ {
    a.iter().zip(b.iter()).map(|(x, y)| x.add(*y)).collect()
}

/// Scalar multiply
pub fn v_scale(s: f64, v: &[Cx]) -> Vec_ {
    v.iter().map(|x| x.scale(s)).collect()
}

/// Norm: ||v|| = √(Σ|v_k|²)
pub fn v_norm(v: &[Cx]) -> f64 {
    v.iter().map(|x| x.norm2()).sum::<f64>().sqrt()
}

/// Normalize
pub fn v_normalize(v: &[Cx]) -> Vec_ {
    let n = v_norm(v);
    if n > 1e-15 { v.iter().map(|x| x.scale(1.0 / n)).collect() }
    else { v.to_vec() }
}

/// Inner product ⟨a|b⟩
pub fn v_dot(a: &[Cx], b: &[Cx]) -> Cx {
    a.iter().zip(b.iter())
        .fold(CX_ZERO, |acc, (x, y)| acc.add(x.conj().mul(*y)))
}

/// Probability of outcome k: |v_k|²
pub fn v_prob(v: &[Cx], k: usize) -> f64 { v[k].norm2() }

/// Shannon entropy of probability distribution |v_k|²
pub fn v_entropy(v: &[Cx]) -> f64 {
    -v.iter().map(|a| {
        let p = a.norm2();
        if p > 1e-15 { p * p.ln() } else { 0.0 }
    }).sum::<f64>()
}

// ═══════════════════════════════════════════════════════════════
// MATRIX OPERATIONS (M_n(ℂ))
// ═══════════════════════════════════════════════════════════════

pub type Mat = Vec<Vec<Cx>>; // row-major

/// Zero matrix n×n
pub fn m_new(n: usize) -> Mat { vec![vec![CX_ZERO; n]; n] }

/// Identity matrix n×n
pub fn m_identity(n: usize) -> Mat {
    (0..n).map(|i| {
        (0..n).map(|j| if i == j { CX_ONE } else { CX_ZERO }).collect()
    }).collect()
}

/// Matrix multiply
pub fn m_mul(a: &Mat, b: &Mat) -> Mat {
    let n = a.len();
    (0..n).map(|i| {
        (0..n).map(|j| {
            (0..n).fold(CX_ZERO, |acc, k| acc.add(a[i][k].mul(b[k][j])))
        }).collect()
    }).collect()
}

/// Matrix-vector multiply
pub fn m_apply(m: &Mat, v: &[Cx]) -> Vec_ {
    m.iter().map(|row| {
        row.iter().zip(v.iter())
            .fold(CX_ZERO, |acc, (a, b)| acc.add(a.mul(*b)))
    }).collect()
}

/// Conjugate transpose (dagger)
pub fn m_dagger(m: &Mat) -> Mat {
    let n = m.len();
    (0..n).map(|i| {
        (0..n).map(|j| m[j][i].conj()).collect()
    }).collect()
}

/// Trace
pub fn m_trace(m: &Mat) -> Cx {
    (0..m.len()).fold(CX_ZERO, |acc, i| acc.add(m[i][i]))
}

/// Diagonal matrix from entries
pub fn m_from_diag(ds: &[Cx]) -> Mat {
    let n = ds.len();
    (0..n).map(|i| {
        (0..n).map(|j| if i == j { ds[i] } else { CX_ZERO }).collect()
    }).collect()
}

// ═══════════════════════════════════════════════════════════════
// CRYSTAL CONSTANTS (re-exported from atoms for Q* convenience)
// ═══════════════════════════════════════════════════════════════

/// Sector eigenvalues: {1, 1/2, 1/3, 1/6}
pub fn lambdas() -> [f64; 4] {
    [1.0, 1.0 / N_W as f64, 1.0 / N_C as f64, 1.0 / CHI as f64]
}

/// Energy eigenvalues: {0, ln2, ln3, ln6}
pub fn energies() -> [f64; 4] {
    lambdas().map(|l| -l.ln())
}

/// Maximum entropy: ln(χ) = ln(6)
pub fn max_entropy() -> f64 { (CHI as f64).ln() }

/// Mass gap: ln(N_w) = ln(2)
pub fn mass_gap() -> f64 { (N_W as f64).ln() }

/// Sector names
pub const SECTOR_NAMES: [&str; 4] = ["Singlet", "Weak", "Colour", "Mixed"];

// ═══════════════════════════════════════════════════════════════
// DENSITY MATRIX TYPE
// ═══════════════════════════════════════════════════════════════

pub type DensityMat = Mat;

/// Pure state → density matrix: ρ = |ψ⟩⟨ψ|
pub fn dm_pure(v: &[Cx]) -> DensityMat {
    let n = v.len();
    (0..n).map(|i| {
        (0..n).map(|j| v[i].mul(v[j].conj())).collect()
    }).collect()
}

/// Maximally mixed state: ρ = I/n
pub fn dm_mixed(n: usize) -> DensityMat {
    let s = 1.0 / n as f64;
    (0..n).map(|i| {
        (0..n).map(|j| if i == j { Cx::real(s) } else { CX_ZERO }).collect()
    }).collect()
}

/// Purity: Tr(ρ²)
pub fn dm_purity(rho: &DensityMat) -> f64 {
    m_trace(&m_mul(rho, rho)).re
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn cx_arithmetic() {
        let a = Cx::new(1.0, 2.0);
        let b = Cx::new(3.0, -1.0);
        let c = a.mul(b); // (1+2i)(3-i) = 5+5i
        assert!((c.re - 5.0).abs() < 1e-10);
        assert!((c.im - 5.0).abs() < 1e-10);
    }

    #[test] fn v_basis_orthonormal() {
        let e0 = v_basis(CHI as usize, 0);
        let e1 = v_basis(CHI as usize, 1);
        let d00 = v_dot(&e0, &e0);
        let d01 = v_dot(&e0, &e1);
        assert!((d00.re - 1.0).abs() < 1e-10);
        assert!(d01.norm2() < 1e-20);
    }

    #[test] fn v_equal_normalized() {
        let v = v_equal(CHI as usize);
        assert!((v_norm(&v) - 1.0).abs() < 1e-10);
    }

    #[test] fn m_identity_works() {
        let id = m_identity(3);
        let v = vec![Cx::real(1.0), Cx::real(2.0), Cx::real(3.0)];
        let result = m_apply(&id, &v);
        for (a, b) in result.iter().zip(v.iter()) {
            assert!((a.re - b.re).abs() < 1e-10);
        }
    }

    #[test] fn dm_pure_is_rank_1() {
        let v = v_basis(CHI as usize, 0);
        let rho = dm_pure(&v);
        let purity = dm_purity(&rho);
        assert!((purity - 1.0).abs() < 1e-10);
    }

    #[test] fn dm_mixed_purity() {
        let n = CHI as usize;
        let rho = dm_mixed(n);
        let purity = dm_purity(&rho);
        assert!((purity - 1.0 / n as f64).abs() < 1e-10);
    }

    #[test] fn energies_correct() {
        let e = energies();
        assert!((e[0] - 0.0).abs() < 1e-10);
        assert!((e[1] - 2.0_f64.ln()).abs() < 1e-10);
        assert!((e[2] - 3.0_f64.ln()).abs() < 1e-10);
        assert!((e[3] - 6.0_f64.ln()).abs() < 1e-10);
    }
}
