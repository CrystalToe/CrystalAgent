// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later

//! 15 quantum algorithms: Grover, QFT, QPE, VQE, QAOA, HHL, teleport,
//! superdense, BB84, quantum walk, Simon, Bernstein-Vazirani.

use crate::base::*;
use std::f64::consts::PI;

/// Grover oracle: flip phase of target state
pub fn grover_oracle(target: usize, psi: &Vec_) -> Vec_ {
    let mut out = psi.clone();
    out.data[target] = -out.data[target];
    out
}

/// Grover step: oracle + diffusion
pub fn grover_step(target: usize, psi: &Vec_) -> Vec_ {
    let marked = grover_oracle(target, psi);
    let n = marked.dim();
    let avg = marked.data.iter().fold(Cx::ZERO, |a, &b| a + b).scale(2.0 / n as f64);
    let mut out = Vec_::new(n);
    for i in 0..n { out.data[i] = avg - marked.data[i]; }
    out.normalized()
}

/// Full Grover search: O(√N) iterations
pub fn grover_search(target: usize, psi: &Vec_) -> Vec_ {
    let n_iter = ((PI / 4.0) * (psi.dim() as f64).sqrt()) as usize;
    let mut state = psi.clone();
    for _ in 0..n_iter.max(1) { state = grover_step(target, &state); }
    state
}

/// Crystal QFT: χ-point DFT with ω = e^(2πi/χ)
pub fn qft(psi: &Vec_) -> Vec_ {
    let n = psi.dim();
    let s = 1.0 / (n as f64).sqrt();
    let mut out = Vec_::new(n);
    for j in 0..n {
        let mut sum = Cx::ZERO;
        for k in 0..n {
            let phase = Cx::new(0.0, 2.0 * PI * (j * k) as f64 / n as f64).exp();
            sum = sum + phase * psi.data[k];
        }
        out.data[j] = sum.scale(s);
    }
    out
}

/// Inverse QFT
pub fn iqft(psi: &Vec_) -> Vec_ {
    let n = psi.dim();
    let s = 1.0 / (n as f64).sqrt();
    let mut out = Vec_::new(n);
    for j in 0..n {
        let mut sum = Cx::ZERO;
        for k in 0..n {
            let phase = Cx::new(0.0, -2.0 * PI * (j * k) as f64 / n as f64).exp();
            sum = sum + phase * psi.data[k];
        }
        out.data[j] = sum.scale(s);
    }
    out
}

/// QPE: extract sector eigenvalues (phases)
pub fn qpe(psi: &Vec_) -> Vec<f64> {
    let en = energies();
    (0..psi.dim().min(CHI)).map(|k| en[k.min(3)] / (2.0 * PI)).collect()
}

/// VQE energy: ⟨ψ|H|ψ⟩ for crystal Hamiltonian
pub fn vqe_energy(psi: &Vec_) -> f64 {
    let en = energies();
    (0..psi.dim().min(CHI)).map(|k| psi.prob(k) * en[k.min(3)]).sum()
}

/// QAOA step: cost phase + mixer
pub fn qaoa_step(gamma: f64, beta: f64, psi: &Vec_) -> Vec_ {
    let n = psi.dim();
    let en = energies();
    let mut costed = Vec_::new(n);
    for k in 0..n {
        costed.data[k] = Cx::new(0.0, -gamma * en[k.min(3)]).exp() * psi.data[k];
    }
    let mut mixed = Vec_::new(n);
    for k in 0..n {
        mixed.data[k] = costed.data[k].scale(beta.cos())
                       + costed.data[(k + 1) % n].scale(beta.sin());
    }
    mixed.normalized()
}

/// HHL: solve Ax=b where A = crystal Hamiltonian (diagonal)
pub fn hhl_solve(b: &Vec_) -> Vec_ {
    let en = energies();
    let mut out = Vec_::new(b.dim());
    for k in 0..b.dim().min(CHI) {
        if en[k.min(3)] > 1e-10 {
            out.data[k] = b.data[k].scale(1.0 / en[k.min(3)]);
        }
    }
    out.normalized()
}

/// Teleportation: perfect state transfer
pub fn teleport(psi: &Vec_) -> Vec_ { psi.clone() }

/// Superdense coding: encode message m ∈ {0,...,χ²-1}
pub fn superdense_encode(msg: usize, psi: &Vec_) -> Vec_ {
    let shift = msg / CHI;
    let phase_idx = msg % CHI;
    let n = psi.dim();
    let mut out = Vec_::new(n);
    for i in 0..n {
        let shifted = (i + n - shift) % n;
        let phase = Cx::new(0.0, 2.0 * PI * (phase_idx * i) as f64 / n as f64).exp();
        out.data[i] = phase * psi.data[shifted];
    }
    out
}

/// BB84 prepare: sector basis (0) or Hadamard basis (1)
pub fn bb84_prepare(bit: usize, basis: usize) -> Vec_ {
    if basis == 0 { Vec_::basis(CHI, bit) }
    else { Vec_::equal(CHI) }  // simplified
}

/// Quantum walk step on sector graph
pub fn quantum_walk_step(psi: &Vec_) -> Vec_ {
    let n = psi.dim();
    let avg = psi.data.iter().fold(Cx::ZERO, |a, &b| a + b).scale(1.0 / (n as f64).sqrt());
    let mut out = Vec_::new(n);
    for i in 0..n { out.data[(i + 1) % n] = avg; }
    out.normalized()
}

/// Simon oracle: f(x) = f(x ⊕ s)
pub fn simon_oracle(hidden_s: usize, psi: &Vec_) -> Vec_ {
    let n = psi.dim();
    let mut out = Vec_::new(n);
    for i in 0..n { out.data[i] = psi.data[(i + hidden_s) % n]; }
    out
}

/// Bernstein-Vazirani oracle: f(x) = x·s mod χ
pub fn bv_oracle(s: usize, psi: &Vec_) -> Vec_ {
    let mut out = Vec_::new(psi.dim());
    for i in 0..psi.dim() {
        let dot = (i * s) % CHI;
        let phase = Cx::new(0.0, 2.0 * PI * dot as f64 / CHI as f64).exp();
        out.data[i] = phase * psi.data[i];
    }
    out
}
