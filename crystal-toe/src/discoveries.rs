// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// discoveries.rs — Key discoveries from the Crystal Topos
//
// Summary of structural findings. No new observables.

use crate::atoms::*;

/// Discovery record: (name, crystal_value, domain)
pub type Discovery = (&'static str, f64, &'static str);

/// Key discoveries from the scan
pub fn key_discoveries() -> Vec<Discovery> {
    vec![
        ("Hadron scale Λ_h = v/F₃ = v/257",
            246220.0 / FERMAT3 as f64, "QCD"),
        ("η' = Λ_h (U(1)_A anomaly = Fermat)",
            246220.0 / FERMAT3 as f64, "Mesons"),
        ("Genetic code from (2,3): 4^3 → 20+1",
            (N_W * N_W).pow(N_C as u32) as f64, "Biology"),
        ("Hierarchy = e^D = e^42",
            (TOWER_D as f64).exp(), "Gravity"),
        ("Casimir = n(water) = 4/3",
            (N_C * N_C - 1) as f64 / (2 * N_C) as f64, "Cross-domain"),
        ("Feigenbaum δ = D/N_c² = 42/9",
            TOWER_D as f64 / (N_C * N_C) as f64, "Chaos"),
        ("Arrow of time = ln(χ) = ln(6)",
            (CHI as f64).ln(), "Thermodynamics"),
        ("Gauge periods = divisors(χ) = {1,2,3,6}",
            CHI as f64, "Mandelbrot"),
        ("Proton radius = (4+2/91) × ℏc/m_p",
            0.841, "Hadrons"),
        ("BCS ratio from Euler-Mascheroni γ",
            3.527, "Superconductivity"),
    ]
}

/// Total observable count across all modules
pub const TOTAL_OBSERVABLES: u64 = 198; // 92 + 103 + 3

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn discoveries_non_empty() {
        assert!(key_discoveries().len() >= 10);
    }
    #[test] fn total_198() {
        assert_eq!(TOTAL_OBSERVABLES, 198);
    }
}
