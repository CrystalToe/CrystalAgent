// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// cross_domain.rs — Ratios that appear across multiple physics domains
//
// These are NOT imposed. They follow from the algebra.
// Each ratio is a polynomial in (N_w, N_c).

use crate::atoms::*;

/// A ratio that appears in multiple domains.
#[derive(Debug, Clone)]
pub struct CrossTrace {
    pub name: &'static str,
    pub value: f64,
    pub formula: &'static str,
    pub domains: &'static [&'static str],
}

/// All known cross-domain traces.
pub fn cross_traces() -> Vec<CrossTrace> {
    vec![
        CrossTrace {
            name: "2/5",
            value: N_W as f64 / (CHI - 1) as f64,
            formula: "N_w/(χ−1)",
            domains: &["Rigid: I_sphere", "MD: Flory ν", "Bio: polymer scaling", "CFD: Von Kármán"],
        },
        CrossTrace {
            name: "3/4",
            value: N_C as f64 / (N_W * N_W) as f64,
            formula: "N_c/N_w²",
            domains: &["Bio: Kleiber metabolic", "Astro: Chandrasekhar"],
        },
        CrossTrace {
            name: "2/3",
            value: N_W as f64 / N_C as f64,
            formula: "N_w/N_c",
            domains: &["Bio: surface area", "Rigid: I_shell", "EM: Larmor", "Nuclear: SEMF surface"],
        },
        CrossTrace {
            name: "7/2",
            value: BETA0 as f64 / N_W as f64,
            formula: "β₀/N_w",
            domains: &["Astro: MS luminosity L∝M^(7/2)"],
        },
        CrossTrace {
            name: "5/2",
            value: (CHI - 1) as f64 / N_W as f64,
            formula: "(χ−1)/N_w",
            domains: &["Astro: MS lifetime t∝M^(-5/2)"],
        },
        CrossTrace {
            name: "1/6",
            value: 1.0 / CHI as f64,
            formula: "1/χ",
            domains: &["QInfo: uncertainty meet", "Monad: mixed eigenvalue"],
        },
        CrossTrace {
            name: "8",
            value: D_COLOUR as f64,
            formula: "N_w³ = d_colour",
            domains: &["QFT: gluons", "Nuclear: magic 8", "Astro: Hawking", "Arcade: octree", "Condensed: BH tree"],
        },
        CrossTrace {
            name: "4",
            value: (N_W * N_W) as f64,
            formula: "N_w²",
            domains: &["QFT: spacetime", "Rigid: quaternion", "QInfo: Bell states", "Bio: DNA bases", "Condensed: Ising z", "Astro: Eddington"],
        },
        CrossTrace {
            name: "6",
            value: CHI as f64,
            formula: "χ = N_w·N_c",
            domains: &["QFT: Lorentz gen", "Rigid: inertia tensor", "QInfo: MERA bond", "Classical: phase space", "EM: field components"],
        },
        CrossTrace {
            name: "7",
            value: BETA0 as f64,
            formula: "β₀ = (11N_c−2χ)/3",
            domains: &["QFT: QCD β₀", "Chem: neutral pH", "Nuclear: Fe-56/8", "QInfo: Steane qubits"],
        },
        CrossTrace {
            name: "36",
            value: SIGMA_D as f64,
            formula: "Σd = 1+3+8+24",
            domains: &["Chem: Krypton Z", "Nuclear: sector sum", "Monad: DOF count a₀"],
        },
        CrossTrace {
            name: "3/5",
            value: N_C as f64 / (CHI - 1) as f64,
            formula: "N_c/(χ−1)",
            domains: &["Nuclear: SEMF Coulomb", "Astro: gravitational PE"],
        },
        CrossTrace {
            name: "1/12",
            value: 1.0 / (2 * CHI) as f64,
            formula: "1/(2χ)",
            domains: &["Rigid: I_rod", "Thermo: LJ repulsive 12=2χ"],
        },
        CrossTrace {
            name: "42",
            value: TOWER_D as f64,
            formula: "D = Σd + χ",
            domains: &["Tower: total depth", "QInfo: MERA layers", "Cosmo: partition denominator"],
        },
    ]
}

/// Count of unique shared ratios.
pub fn n_shared_ratios() -> usize {
    cross_traces().len()
}

/// Count of total cross-links (sum of domain appearances).
pub fn n_cross_links() -> usize {
    cross_traces().iter().map(|t| t.domains.len()).sum()
}
