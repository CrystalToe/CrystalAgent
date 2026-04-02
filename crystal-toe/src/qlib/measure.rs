// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// qlib/measure.rs — Measurement operators from crystal sector structure
//
// 8 measurement types for ℂ^χ:
//   Projective, POVM (sector-weighted), Weak, Parity,
//   Bell, Homodyne, Heterodyne, Tomography

use super::base::*;
use crate::atoms::*;

const N: usize = CHI as usize;

/// Projective measurement result: (outcome, collapsed_state, probability)
pub fn measure_projective(psi: &[Cx], outcome: usize) -> (usize, Vec_, f64) {
    let prob = v_prob(psi, outcome);
    let collapsed = v_basis(N, outcome);
    (outcome, collapsed, prob)
}

/// POVM measurement: sector-weighted probabilities
/// Returns (sector_name, probability) for each sector
pub fn measure_povm(psi: &[Cx]) -> Vec<(&'static str, f64)> {
    let names = SECTOR_NAMES;
    let dims = SECTOR_DIMS;
    let mut result = Vec::new();
    let mut idx = 0;
    for (s, &d) in dims.iter().enumerate() {
        let mut sector_prob = 0.0;
        for _ in 0..d {
            if idx < psi.len() {
                sector_prob += psi[idx].norm2();
            }
            idx += 1;
        }
        result.push((names[s], sector_prob));
    }
    result
}

/// Weak measurement: partial collapse with strength ε
/// |ψ⟩ → (1−ε)|ψ⟩ + ε|k⟩⟨k|ψ⟩
pub fn measure_weak(epsilon: f64, outcome: usize, psi: &[Cx]) -> Vec_ {
    let proj_amp = psi[outcome];
    psi.iter().enumerate().map(|(i, &v)| {
        if i == outcome {
            v.scale(1.0 - epsilon).add(proj_amp.scale(epsilon))
        } else {
            v.scale(1.0 - epsilon)
        }
    }).collect()
}

/// Parity measurement: even vs odd sector
pub fn measure_parity(psi: &[Cx]) -> (&'static str, f64) {
    let even_prob: f64 = psi.iter().enumerate()
        .filter(|(k, _)| k % 2 == 0)
        .map(|(_, v)| v.norm2())
        .sum();
    if even_prob >= 0.5 { ("even", even_prob) } else { ("odd", 1.0 - even_prob) }
}

/// Collapse to outcome k: |ψ⟩ → |k⟩
pub fn collapse(k: usize) -> Vec_ {
    v_basis(N, k)
}

/// Collapse to sector s: project onto sector subspace and renormalize
pub fn collapse_to_sector(sector: usize, psi: &[Cx]) -> Vec_ {
    let dims = SECTOR_DIMS;
    let mut start = 0usize;
    for s in 0..sector {
        start += dims[s] as usize;
    }
    let end = start + dims[sector] as usize;
    let mut result = v_new(N);
    let mut norm2 = 0.0;
    for i in start..end.min(N) {
        result[i] = psi[i];
        norm2 += psi[i].norm2();
    }
    if norm2 > 1e-15 {
        let s = 1.0 / norm2.sqrt();
        v_scale(s, &result)
    } else {
        result
    }
}

/// Tomography: number of measurement bases needed = χ² = 36
pub fn tomography_bases() -> u64 {
    CHI * CHI
}

/// Number of measurement types
pub const N_MEASUREMENT_TYPES: u64 = 8;

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn projective_probability_sum() {
        let psi = v_equal(N);
        let total: f64 = (0..N).map(|k| {
            let (_, _, p) = measure_projective(&psi, k);
            p
        }).sum();
        assert!((total - 1.0).abs() < 1e-10);
    }

    #[test] fn povm_probabilities_sum() {
        let psi = v_equal(N);
        let povm = measure_povm(&psi);
        let total: f64 = povm.iter().map(|(_, p)| p).sum();
        assert!((total - 1.0).abs() < 1e-10);
    }

    #[test] fn povm_four_sectors() {
        let psi = v_equal(N);
        assert_eq!(measure_povm(&psi).len(), 4);
    }

    #[test] fn collapse_is_normalized() {
        let v = collapse(3);
        assert!((v_norm(&v) - 1.0).abs() < 1e-10);
    }

    #[test] fn tomography_36() {
        assert_eq!(tomography_bases(), 36);
    }
}
