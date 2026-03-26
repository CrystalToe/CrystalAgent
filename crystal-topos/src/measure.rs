//! 8 measurement operators: projective, POVM, weak, parity, Bell,
//! homodyne, heterodyne, state tomography.

use crate::base::*;
use std::f64::consts::PI;

/// Projective measurement: returns (outcome, probability)
pub fn measure_projective(psi: &Vec_, rand_val: f64) -> (usize, f64) {
    let probs: Vec<f64> = psi.data.iter().map(|c| c.norm2()).collect();
    let mut cum = 0.0;
    for (k, &p) in probs.iter().enumerate() {
        cum += p;
        if rand_val < cum { return (k, p); }
    }
    (probs.len() - 1, *probs.last().unwrap_or(&0.0))
}

/// POVM: sector-weighted probabilities. Weights = d_k/Σd.
pub fn measure_povm(psi: &Vec_) -> Vec<(String, f64)> {
    let probs = sector_probs(psi);
    SECTOR_NAMES.iter().zip(DIMS.iter()).zip(probs.iter())
        .map(|((name, &d), &p)| (name.to_string(), d as f64 * p / SIGMA_D as f64))
        .collect()
}

/// Weak measurement: partial collapse with strength ε
pub fn measure_weak(epsilon: f64, k: usize, psi: &Vec_) -> Vec_ {
    let p = psi.prob(k).max(1e-15);
    let mut out = Vec_::new(psi.dim());
    for i in 0..psi.dim() {
        let orig = psi.data[i].scale((1.0 - epsilon).sqrt());
        let proj = if i == k { Cx::from_real((epsilon * p).sqrt()) } else { Cx::ZERO };
        out.data[i] = orig + proj;
    }
    out.normalized()
}

/// Parity measurement: even sectors (d=1,8) vs odd (d=3,24)
pub fn measure_parity(psi: &Vec_) -> (String, f64) {
    let probs = sector_probs(psi);
    let p_even = probs[0] + if probs.len() > 2 { probs[2] } else { 0.0 };
    let p_odd = if probs.len() > 1 { probs[1] } else { 0.0 }
              + if probs.len() > 3 { probs[3] } else { 0.0 };
    if p_even >= p_odd { ("Even".to_string(), p_even) }
    else { ("Odd".to_string(), p_odd) }
}

/// Bell measurement: overlap with Bell state |Φ_k⟩
pub fn measure_bell(psi: &Vec_, k: usize) -> f64 {
    if psi.dim() != CHI * CHI { return 0.0; }
    let s = 1.0 / (CHI as f64).sqrt();
    let mut overlap = Cx::ZERO;
    for n in 0..CHI {
        let omega = Cx::new(0.0, 2.0 * PI * (n * k) as f64 / CHI as f64).exp();
        let bell_amp = omega.scale(s);
        overlap = overlap + bell_amp.conj() * psi.data[n * CHI + n];
    }
    overlap.norm2()
}

/// Homodyne: measure in sector eigenvalue basis
pub fn measure_homodyne(psi: &Vec_) -> Vec<(f64, f64)> {
    (0..psi.dim().min(CHI))
        .map(|k| (LAMBDAS[k.min(3)], psi.prob(k)))
        .collect()
}

/// Heterodyne: Q-function at χ phase points
pub fn measure_heterodyne(psi: &Vec_) -> Vec<f64> {
    let n = psi.dim().min(CHI);
    (0..n).map(|k| {
        let mut overlap = Cx::ZERO;
        for j in 0..n {
            let coh = Cx::new(0.0, 2.0 * PI * (k * j) as f64 / n as f64).exp().scale(1.0 / (n as f64).sqrt());
            overlap = overlap + coh.conj() * psi.data[j];
        }
        overlap.norm2() / n as f64
    }).collect()
}

/// Tomography: number of bases needed = χ²-1 = 35
pub fn tomography_bases() -> usize { CHI * CHI - 1 }

/// Collapse to basis state |k⟩
pub fn collapse(k: usize) -> Vec_ { Vec_::basis(CHI, k) }

/// Sector probabilities (sum within sectors for multi-particle)
pub fn sector_probs(psi: &Vec_) -> Vec<f64> {
    if psi.dim() <= CHI {
        psi.data.iter().map(|c| c.norm2()).collect()
    } else {
        (0..CHI.min(4)).map(|i| {
            (0..CHI).map(|j| psi.data[i * CHI + j].norm2()).sum()
        }).collect()
    }
}

/// Born probabilities for all basis states
pub fn born_probs(psi: &Vec_) -> Vec<f64> {
    psi.data.iter().map(|c| c.norm2()).collect()
}
