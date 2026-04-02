// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// protein.rs — Protein force field from A_F
//
// Every energy from α = 1/(43π+ln7). Zero fitted parameters.
// 13 MERA layers → 13 force field terms.

use crate::atoms::*;
use crate::toe::Toe;

// ═══════════════════════════════════════════════════════════════════
// FUNDAMENTAL ENERGY SCALES
// ═══════════════════════════════════════════════════════════════════

/// Hartree energy: E_H = α² · m_e · c² (eV).
pub fn hartree(toe: &Toe) -> f64 {
    let alpha = toe.alpha();
    let me_ev = toe.electron_mass() * 1e9; // GeV → eV
    alpha * alpha * me_ev
}

/// VdW energy: ε_vdw = α · E_H / N_c² (eV).
pub fn eps_vdw(toe: &Toe) -> f64 {
    toe.alpha() * hartree(toe) / (N_C * N_C) as f64
}

/// H-bond energy: E_hbond = α · E_H (eV).
pub fn e_hbond(toe: &Toe) -> f64 {
    toe.alpha() * hartree(toe)
}

/// Angle bending stiffness: k_ω = N_c · α · E_H (eV/rad²).
pub fn k_omega(toe: &Toe) -> f64 {
    N_C as f64 * toe.alpha() * hartree(toe)
}

/// Hydrophobic burial energy: E_burial = N_c² · α · E_H · geometry (eV).
/// Geometry factor: 1 − cos(water)/cos(sp3).
pub fn e_burial(toe: &Toe) -> f64 {
    let water = (-1.0_f64 / (N_W * N_W) as f64).acos();
    let sp3 = (-1.0_f64 / N_C as f64).acos();
    let geom = 1.0 - water.cos() / sp3.cos();
    (N_C * N_C) as f64 * toe.alpha() * hartree(toe) * geom
}

/// Protein dielectric constant: ε_r = N_w² · (N_c + 1) = 16.
pub const PROTEIN_DIELECTRIC: u64 = N_W * N_W * (N_C + 1); // 16

// ═══════════════════════════════════════════════════════════════════
// MOLECULAR GEOMETRY (all from arccos of A_F rationals)
// ═══════════════════════════════════════════════════════════════════

/// sp3 bond angle: arccos(−1/N_c) = 109.47°.
pub fn sp3_angle() -> f64 {
    (-1.0_f64 / N_C as f64).acos()
}

/// Water bond angle: arccos(−1/N_w²) = 104.48°.
pub fn water_angle() -> f64 {
    (-1.0_f64 / (N_W * N_W) as f64).acos()
}

/// sp2 bond angle: 2π/N_c = 120°.
pub fn sp2_angle() -> f64 {
    2.0 * std::f64::consts::PI / N_C as f64
}

/// α-helix residues per turn: 18/5 = N_c²·N_w/(χ−1) = 3.6.
pub fn helix_per_turn() -> f64 {
    (N_C * N_C * N_W) as f64 / (CHI - 1) as f64
}

/// Flory exponent: ν = N_w/(χ−1) = 2/5 = 0.4.
pub fn flory_nu() -> f64 {
    N_W as f64 / (CHI - 1) as f64
}

/// Base pairs per DNA turn: N_w · (χ−1) = 10.
pub fn bp_per_turn() -> u64 {
    N_W * (CHI - 1) // 10
}

// ═══════════════════════════════════════════════════════════════════
// VDW RADII (from Bohr radius + Crystal scaling)
// ═══════════════════════════════════════════════════════════════════

/// Bohr radius in Å: a₀ = ℏc/(m_e · α).
pub fn bohr_radius_angstrom(toe: &Toe) -> f64 {
    toe.bohr_radius() / 100.0 // fm → Å (1 Å = 100 fm)
}

/// VdW radius of Carbon: a₀ × N_c/N_w × correction.
pub fn vdw_radius_c(toe: &Toe) -> f64 {
    bohr_radius_angstrom(toe) * N_C as f64 / N_W as f64
        * (1.0 - 1.0 / (2.0 * D3 as f64 * SIGMA_D as f64)) // 575/576 correction
}

/// H-bond distance: a₀ × N_c/N_w² × 53/54 correction.
pub fn hbond_distance(toe: &Toe) -> f64 {
    bohr_radius_angstrom(toe) * N_C as f64 / (N_W * N_W) as f64
        * 53.0 / 54.0
}

// ═══════════════════════════════════════════════════════════════════
// ENERGY HIERARCHY
// ═══════════════════════════════════════════════════════════════════

/// Print the force field hierarchy.
pub fn energy_hierarchy(toe: &Toe) -> Vec<(&'static str, f64)> {
    vec![
        ("ε_vdw (eV)",     eps_vdw(toe)),
        ("E_hbond (eV)",    e_hbond(toe)),
        ("k_ω (eV/rad²)",  k_omega(toe)),
        ("E_burial (eV)",   e_burial(toe)),
        ("ε_r (dimless)",   PROTEIN_DIELECTRIC as f64),
    ]
}

/// Folding energy: E_fold = v / 2^D (eV).
pub fn e_fold(toe: &Toe) -> f64 {
    toe.vev() * 1e9 / (1u64 << TOWER_D) as f64 // GeV → eV, then /2^42
}
