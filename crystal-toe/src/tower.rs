// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// tower.rs — Spectral tower D=0 → D=42
//
// Each layer is a monad tick. Physics crystallizes at specific depths.

use crate::atoms::*;
use crate::monad::{AlgebraState, Monad};

/// Coupling at layer d: α(d) = 1/((d+1)π + ln(β₀)).
pub fn alpha_at_layer(d: u64) -> f64 {
    1.0 / ((d as f64 + 1.0) * std::f64::consts::PI + (BETA0 as f64).ln())
}

/// α⁻¹ at layer d.
pub fn alpha_inv_at_layer(d: u64) -> f64 {
    (d as f64 + 1.0) * std::f64::consts::PI + (BETA0 as f64).ln()
}

/// A layer in the spectral tower.
#[derive(Debug, Clone)]
pub struct TowerLayer {
    pub depth: u64,
    pub alpha_inv: f64,
    pub state: AlgebraState,
    pub born: &'static [&'static str],
}

/// What physics is born at each key layer.
fn births(d: u64) -> &'static [&'static str] {
    match d {
        0 => &["A_F → χ=6, β₀=7, Σd=36, D=42, κ=ln3/ln2"],
        5 => &["α = 1/(43π+ln7)", "m_e = m_μ/208"],
        10 => &["m_p = v/256×53/54", "hadron scale"],
        18 => &["a₀ = ℏc/(m_e·α)", "Bohr radius"],
        20 => &["sp3 = arccos(-1/3) = 109.47°"],
        22 => &["VdW radii FIXED", "Pauli envelope"],
        24 => &["water = arccos(-1/N_w²) = 104.48°"],
        25 => &["H-bond distance = 2.76 Å"],
        32 => &["α-helix = 18/5 residues/turn"],
        33 => &["Flory ν = 2/5"],
        38 => &["linearized Einstein □h = -16πG T"],
        42 => &["E_fold = v/2⁴²", "hierarchy complete"],
        _ => &[],
    }
}

/// Build the full spectral tower.
pub fn spectral_tower() -> Vec<TowerLayer> {
    let mut layers = Vec::with_capacity(TOWER_D as usize + 1);
    let mut state = AlgebraState::new();

    for d in 0..=TOWER_D {
        layers.push(TowerLayer {
            depth: d,
            alpha_inv: alpha_inv_at_layer(d),
            state: state.clone(),
            born: births(d),
        });
        Monad::tick(&mut state);
    }
    layers
}

/// Iterator that ascends the tower, yielding (layer, state) pairs.
pub struct TowerAscent {
    state: AlgebraState,
    depth: u64,
}

impl TowerAscent {
    pub fn new() -> Self {
        TowerAscent {
            state: AlgebraState::new(),
            depth: 0,
        }
    }
}

impl Iterator for TowerAscent {
    type Item = TowerLayer;

    fn next(&mut self) -> Option<TowerLayer> {
        if self.depth > TOWER_D {
            return None;
        }
        let layer = TowerLayer {
            depth: self.depth,
            alpha_inv: alpha_inv_at_layer(self.depth),
            state: self.state.clone(),
            born: births(self.depth),
        };
        Monad::tick(&mut self.state);
        self.depth += 1;
        Some(layer)
    }

    fn size_hint(&self) -> (usize, Option<usize>) {
        let remaining = (TOWER_D + 1 - self.depth) as usize;
        (remaining, Some(remaining))
    }
}

impl ExactSizeIterator for TowerAscent {}
