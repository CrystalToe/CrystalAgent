// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// monad.rs — The time monad S = W∘U
//
// Time is ℕ. Each tick multiplies sector amplitudes by eigenvalues.
// No calculus. No Hamiltonian. Just S applied to ℕ.

use crate::atoms::*;

/// State of the algebra at a given tick.
#[derive(Debug, Clone)]
pub struct AlgebraState {
    /// Amplitude in each sector: [singlet, weak, colour, mixed].
    pub amplitudes: [f64; 4],
    /// Current tick.
    pub tick: u64,
}

impl AlgebraState {
    /// Initial state: all sectors at unit amplitude.
    pub fn new() -> Self {
        AlgebraState {
            amplitudes: [1.0; 4],
            tick: 0,
        }
    }

    /// State at tick t (direct computation, no iteration).
    pub fn at_tick(t: u64) -> Self {
        let mut amps = [0.0f64; 4];
        for (i, s) in Sector::ALL.iter().enumerate() {
            amps[i] = s.lambda().powi(t as i32);
        }
        AlgebraState {
            amplitudes: amps,
            tick: t,
        }
    }

    /// Amplitude in a specific sector.
    pub fn amplitude(&self, s: Sector) -> f64 {
        self.amplitudes[s.index()]
    }

    /// Total weight: Σ d_k × amplitude_k.
    pub fn total_weight(&self) -> f64 {
        Sector::ALL
            .iter()
            .enumerate()
            .map(|(i, s)| s.dim() as f64 * self.amplitudes[i])
            .sum()
    }

    /// Shannon entropy: -Σ p_k ln(p_k).
    pub fn entropy(&self) -> f64 {
        let total = self.total_weight();
        if total <= 0.0 {
            return 0.0;
        }
        Sector::ALL
            .iter()
            .enumerate()
            .map(|(i, s)| {
                let p = s.dim() as f64 * self.amplitudes[i] / total;
                if p > 1e-30 { -p * p.ln() } else { 0.0 }
            })
            .sum()
    }
}

impl Default for AlgebraState {
    fn default() -> Self {
        Self::new()
    }
}

impl std::fmt::Display for AlgebraState {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        write!(
            f,
            "t={}: S={:.6} W={:.6} C={:.6} M={:.2e}",
            self.tick,
            self.amplitudes[0],
            self.amplitudes[1],
            self.amplitudes[2],
            self.amplitudes[3]
        )
    }
}

// ═══════════════════════════════════════════════════════════════════
// MONAD S = W∘U
// ═══════════════════════════════════════════════════════════════════

/// The monad. Stateless — all operations are on AlgebraState.
pub struct Monad;

impl Monad {
    /// Apply one tick of S = W∘U.
    pub fn tick(state: &mut AlgebraState) {
        for (i, s) in Sector::ALL.iter().enumerate() {
            state.amplitudes[i] *= s.lambda();
        }
        state.tick += 1;
    }

    /// Apply n ticks.
    pub fn evolve(state: &mut AlgebraState, n: u64) {
        // Direct computation is faster than iteration for large n.
        for (i, s) in Sector::ALL.iter().enumerate() {
            state.amplitudes[i] *= s.lambda().powi(n as i32);
        }
        state.tick += n;
    }

    /// Iterator over ticks from an initial state.
    pub fn ticks(initial: AlgebraState) -> TickIterator {
        TickIterator { state: initial }
    }
}

/// Zero-cost iterator over monad ticks.
pub struct TickIterator {
    state: AlgebraState,
}

impl Iterator for TickIterator {
    type Item = AlgebraState;

    fn next(&mut self) -> Option<AlgebraState> {
        let current = self.state.clone();
        Monad::tick(&mut self.state);
        Some(current)
    }

    fn size_hint(&self) -> (usize, Option<usize>) {
        (usize::MAX, None) // infinite
    }
}

// ═══════════════════════════════════════════════════════════════════
// HOLOGRON POTENTIAL
// ═══════════════════════════════════════════════════════════════════

/// Scaling dimension of the weak sector.
/// Δ_weak = ln(N_w) / ln(χ) = ln2/ln6 ≈ 0.387.
pub fn delta_weak() -> f64 {
    (N_W as f64).ln() / (CHI as f64).ln()
}

/// Hologron potential: V(L) = -C × L^(-2Δ_weak).
/// Leading term of the entanglement-mediated attraction.
pub fn hologron_potential(l: f64) -> f64 {
    -l.powf(-2.0 * delta_weak())
}
