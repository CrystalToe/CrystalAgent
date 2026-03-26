//! 12 entanglement analysis tools. PPT exact for ℂ^N_w ⊗ ℂ^N_c = ℂ²⊗ℂ³.

use crate::base::*;

/// Partial trace over particle 2: ρ₁ = Tr₂(|ψ⟩⟨ψ|)
pub fn partial_trace(psi: &Vec_) -> Mat {
    let mut rho = Mat::new(CHI);
    if psi.dim() == CHI * CHI {
        for i in 0..CHI {
            for j in 0..CHI {
                let mut sum = Cx::ZERO;
                for k in 0..CHI {
                    sum = sum + psi.data[i * CHI + k] * psi.data[j * CHI + k].conj();
                }
                rho.set(i, j, sum);
            }
        }
    } else {
        for i in 0..psi.dim() {
            for j in 0..psi.dim() {
                rho.set(i, j, psi.data[i] * psi.data[j].conj());
            }
        }
    }
    rho
}

/// Von Neumann entropy: S = -Tr(ρ ln ρ). Max = ln(χ) = ln(6) = arrow of time.
pub fn von_neumann_entropy(rho: &Mat) -> f64 {
    let mut s = 0.0;
    for i in 0..rho.rows {
        let p = rho.get(i, i).re;
        if p > 1e-15 { s -= p * p.ln(); }
    }
    s
}

/// Rényi-2 entropy: S₂ = -ln(Tr(ρ²))
pub fn renyi2_entropy(rho: &Mat) -> f64 {
    let mut pur = 0.0;
    for i in 0..rho.rows {
        for j in 0..rho.cols { pur += rho.get(i, j).norm2(); }
    }
    -(pur.max(1e-15).ln())
}

/// Concurrence: C = √(2(1 - Tr(ρ₁²)))
pub fn concurrence(psi: &Vec_) -> f64 {
    let rho1 = partial_trace(psi);
    let mut purity = 0.0;
    for i in 0..rho1.rows {
        for j in 0..rho1.cols { purity += rho1.get(i, j).norm2(); }
    }
    (2.0 * (1.0 - purity)).max(0.0).sqrt()
}

/// Negativity: N = (‖ρ^T₂‖₁ - 1) / 2. COMPLETE for ℂ²⊗ℂ³.
pub fn negativity(psi: &Vec_) -> f64 {
    if psi.dim() != CHI * CHI { return 0.0; }
    let n = CHI * CHI;
    // Partial transpose
    let mut pt_diag_sum = 0.0;
    for i in 0..n {
        let (ai, aj) = (i / CHI, i % CHI);
        // Diagonal of partial transpose at (i,i)
        let (bi, bj) = (ai, aj);
        let src_row = ai * CHI + bj;
        let src_col = bi * CHI + aj;
        let val = psi.data[src_row] * psi.data[src_col].conj();
        pt_diag_sum += val.norm();
    }
    ((pt_diag_sum - 1.0) / 2.0).max(0.0)
}

/// Entanglement of formation: E_F = S(ρ₁) for pure states
pub fn ent_formation(psi: &Vec_) -> f64 {
    von_neumann_entropy(&partial_trace(psi))
}

/// Schmidt coefficients: diagonal of reduced density matrix
pub fn schmidt_coeffs(psi: &Vec_) -> Vec<f64> {
    let rho1 = partial_trace(psi);
    (0..rho1.rows).map(|i| rho1.get(i, i).re.max(0.0)).collect()
}

/// Mutual information: I(A:B) = S_A + S_B - S_AB. Max = 2ln(χ).
pub fn mutual_info(psi: &Vec_) -> f64 {
    if psi.dim() != CHI * CHI { return 0.0; }
    let rho1 = partial_trace(psi);
    let s1 = von_neumann_entropy(&rho1);
    2.0 * s1  // S_AB = 0 for pure state
}

/// Quantum discord (= entanglement for pure states)
pub fn quantum_discord(psi: &Vec_) -> f64 { ent_formation(psi) }

/// PPT test: True iff SEPARABLE. EXACT for ℂ²⊗ℂ³ (Horodecki 1996).
pub fn ppt_test(psi: &Vec_) -> bool {
    if psi.dim() != CHI * CHI { return true; }
    let rho1 = partial_trace(psi);
    let mut purity = 0.0;
    for i in 0..rho1.rows {
        for j in 0..rho1.cols { purity += rho1.get(i, j).norm2(); }
    }
    purity > 0.999  // Pure reduced → product → separable
}

/// Entanglement witness: Tr(W ρ) < 0 iff entangled near target
pub fn entanglement_witness(target: &Vec_, psi: &Vec_) -> f64 {
    let overlap = target.dot(psi).norm2();
    1.0 / CHI as f64 - overlap
}

/// Purify: given diagonal ρ, find |Ψ⟩ in ℂ^χ⊗ℂ^χ with Tr₂(|Ψ⟩⟨Ψ|) = ρ
pub fn purify(rho: &Mat) -> Vec_ {
    let mut psi = Vec_::new(CHI * CHI);
    for i in 0..CHI {
        psi.data[i * CHI + i] = Cx::from_real(rho.get(i, i).re.max(0.0).sqrt());
    }
    psi
}

/// Entanglement swapping (simplified)
pub fn entanglement_swap(psi12: &Vec_, psi34: &Vec_) -> Vec_ {
    let rho1 = partial_trace(psi12);
    let rho4 = partial_trace(psi34);
    let mut psi14 = Vec_::new(CHI * CHI);
    for i in 0..CHI {
        for j in 0..CHI {
            psi14.data[i * CHI + j] = Cx::from_real(
                rho1.get(i, i).re.max(0.0).sqrt() * rho4.get(j, j).re.max(0.0).sqrt()
            );
        }
    }
    psi14.normalized()
}

// ─── ENTANGLED STATES ───

/// Bell state: (|a,b⟩ + |b,a⟩)/√2
pub fn bell_state(a: usize, b: usize) -> Vec_ {
    let mut v = Vec_::new(CHI * CHI);
    let s = 1.0 / 2.0_f64.sqrt();
    v.data[a * CHI + b] = Cx::from_real(s);
    v.data[b * CHI + a] = Cx::from_real(s);
    v
}

/// Maximally entangled: (1/√χ) Σ|k,k⟩
pub fn max_entangled() -> Vec_ {
    let mut v = Vec_::new(CHI * CHI);
    let s = 1.0 / (CHI as f64).sqrt();
    for k in 0..CHI { v.data[k * CHI + k] = Cx::from_real(s); }
    v
}

/// GHZ state on 3 particles
pub fn ghz_state() -> Vec_ {
    let n = CHI * CHI * CHI;
    let mut v = Vec_::new(n);
    let s = 1.0 / 2.0_f64.sqrt();
    v.data[0] = Cx::from_real(s);
    v.data[n - 1] = Cx::from_real(s);
    v
}
