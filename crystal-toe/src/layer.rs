// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// layer.rs — Pure spectral tower D=0→D=42
//
// Each layer D has:
//   - α⁻¹(D) = (D+1)π + ln(β₀) — running coupling
//   - sites(D) = χ^(42−D) — coarse-graining
//   - entropy S(D) = (42−D) × ln(χ)

use crate::atoms::*;

/// A MERA layer at depth D (0 = boundary/UV, 42 = bulk/IR)
pub struct Layer {
    pub depth: u64,
}

impl Layer {
    pub fn new(depth: u64) -> Self {
        assert!(depth <= TOWER_D, "Layer depth {} > D={}", depth, TOWER_D);
        Layer { depth }
    }

    /// Running coupling at this layer
    pub fn alpha_inv(&self) -> f64 {
        (self.depth as f64 + 1.0) * std::f64::consts::PI + (BETA0 as f64).ln()
    }

    /// Number of sites at this layer
    pub fn sites(&self) -> f64 {
        (CHI as f64).powi((TOWER_D - self.depth) as i32)
    }

    /// Entanglement entropy at this layer
    pub fn entropy(&self) -> f64 {
        (TOWER_D - self.depth) as f64 * (CHI as f64).ln()
    }

    /// Is this the UV boundary?
    pub fn is_boundary(&self) -> bool { self.depth == 0 }

    /// Is this the IR bulk?
    pub fn is_bulk(&self) -> bool { self.depth == TOWER_D }
}

/// Spectral tower: all 43 layers from D=0 to D=42
pub fn spectral_tower() -> Vec<Layer> {
    (0..=TOWER_D).map(Layer::new).collect()
}

/// Total tower height = D = 42
pub const TOWER_HEIGHT: u64 = TOWER_D;

/// Number of layers = D + 1 = 43
pub const N_LAYERS: u64 = TOWER_D + 1;

/// UV-IR duality: α⁻¹(0) × α⁻¹(42) product
pub fn uv_ir_product() -> f64 {
    let uv = Layer::new(0).alpha_inv();
    let ir = Layer::new(TOWER_D).alpha_inv();
    uv * ir
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn tower_43_layers() {
        assert_eq!(spectral_tower().len(), 43);
    }
    #[test] fn boundary_layer() {
        let l = Layer::new(0);
        assert!(l.is_boundary());
        assert!(!l.is_bulk());
    }
    #[test] fn bulk_layer() {
        let l = Layer::new(42);
        assert!(l.is_bulk());
        assert_eq!(l.sites(), 1.0);
    }
    #[test] fn alpha_inv_monotone() {
        for d in 0..TOWER_D {
            let a = Layer::new(d).alpha_inv();
            let b = Layer::new(d + 1).alpha_inv();
            assert!(b > a, "α⁻¹ not monotone at d={}", d);
        }
    }
    #[test] fn alpha_inv_42_is_137() {
        let val = Layer::new(42).alpha_inv();
        assert!((val - 137.036).abs() / 137.036 < 0.001);
    }
    #[test] fn entropy_decreases() {
        let s0 = Layer::new(0).entropy();
        let s42 = Layer::new(42).entropy();
        assert!(s0 > s42);
        assert_eq!(s42, 0.0);
    }
}
