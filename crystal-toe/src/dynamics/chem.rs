// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// dynamics/chem.rs — Chemistry and Materials from (2,3)
//
// Orbital structure, hybridization, Arrhenius kinetics.
// Every chemical constant from A_F.
//
//   s-shell capacity:     2   = N_w
//   p-shell capacity:     6   = χ
//   d-shell capacity:     10  = N_w(χ−1)
//   f-shell capacity:     14  = N_w·β₀
//   sp3 bond angle:       109.47° = arccos(−1/N_c)
//   sp2 bond angle:       120°    = 2π/N_c
//   sp  bond angle:       180°    = π
//   Water bond angle:     104.48° = arccos(−1/N_w²)
//   Noble He Z=2:         N_w
//   Noble Ne Z=10:        N_w(χ−1)
//   Noble Ar Z=18:        N_w·N_c²
//   Noble Kr Z=36:        Σ_d
//   Neutral pH:           7 = β₀
//   Hartree energy:       α²·m_e·c² ≈ 27.2 eV
//   Bohr radius:          ℏc/(m_e·c²·α) ≈ 0.529 Å
//   ε_vdW:                α·E_H/N_c² ≈ kT(300K)
//   E_hbond:              α·E_H ≈ 0.2 eV
//   Protein dielectric:   16 = N_w²(N_c+1)
//
// Observable count: 14+. Every number from (2,3).

use crate::atoms::*;
use std::f64::consts::PI;

#[inline] fn sq(x: f64) -> f64 { x * x }

// ═══════════════════════════════════════════════════════════════
// §1  ORBITAL QUANTUM NUMBERS FROM (2,3)
//
// Angular momentum l = 0,1,...,N_c−1  (s,p,d,f)
// Magnetic degeneracy: 2l+1
// Subshell capacity: N_w(2l+1)
// Shell capacity: N_w·n²
// ═══════════════════════════════════════════════════════════════

pub const MAX_ORBITAL_L: u64 = N_C - 1;  // 3 (s,p,d,f)

pub const S_CAPACITY: u64 = N_W;                     // 2  = N_w(2·0+1)
pub const P_CAPACITY: u64 = CHI;                      // 6  = N_w·N_c = χ
pub const D_CAPACITY: u64 = N_W * (CHI - 1);         // 10 = N_w(χ−1)
pub const F_CAPACITY: u64 = N_W * BETA0;              // 14 = N_w·β₀

/// Subshell capacity for angular momentum quantum number l: N_w(2l+1).
pub fn subshell_capacity(l: u64) -> u64 {
    N_W * (2 * l + 1)
}

/// Principal shell capacity: N_w·n².
pub fn shell_capacity(n: u64) -> u64 {
    N_W * n * n
}

// ═══════════════════════════════════════════════════════════════
// §2  HYBRIDIZATION ANGLES
//
// sp3: arccos(−1/N_c) = 109.47° (tetrahedral, methane)
// sp2: 2π/N_c = 120° (trigonal planar, ethylene)
// sp:  π = 180° (linear, acetylene)
// water: arccos(−1/N_w²) = 104.48° (bent, 2 lone pairs)
// ═══════════════════════════════════════════════════════════════

/// sp3 tetrahedral angle: arccos(−1/N_c).
pub fn sp3_angle() -> f64 { (-1.0 / N_C as f64).acos() }

/// sp2 trigonal planar angle: 2π/N_c.
pub fn sp2_angle() -> f64 { 2.0 * PI / N_C as f64 }

/// sp linear angle: π.
pub fn sp_angle() -> f64 { PI }

/// Water bond angle: arccos(−1/N_w²).
pub fn water_angle() -> f64 { (-1.0 / (N_W * N_W) as f64).acos() }

// ═══════════════════════════════════════════════════════════════
// §3  ENERGY SCALES
//
// α = 1/((D+1)π + ln β₀)
// Hartree: E_H = α²·m_e·c²
// Bohr radius: a₀ = ℏc/(m_e·c²·α)
// ε_vdW = α·E_H/N_c²  ≈ kT at 300K
// E_hbond = α·E_H      ≈ 0.2 eV
// ═══════════════════════════════════════════════════════════════

/// Fine structure constant from Crystal.
pub fn alpha_em() -> f64 {
    1.0 / ((TOWER_D + 1) as f64 * PI + (BETA0 as f64).ln())
}

/// Electron mass (MeV/c²).
pub const M_ELECTRON: f64 = 0.51099895;

/// ℏc (MeV·fm).
pub const HBARC: f64 = 197.3269804;

/// Hartree energy (eV): α²·m_e·c².
pub fn hartree_ev() -> f64 {
    sq(alpha_em()) * M_ELECTRON * 1.0e6
}

/// Bohr radius (Ångström): ℏc/(m_e·c²·α).
pub fn bohr_radius() -> f64 {
    HBARC / (M_ELECTRON * alpha_em()) * 1.0e-5
}

/// Rydberg energy (eV): E_H / N_w.
pub fn rydberg_ev() -> f64 {
    hartree_ev() / N_W as f64
}

/// Van der Waals energy (eV): α·E_H/N_c².
pub fn eps_vdw() -> f64 {
    alpha_em() * hartree_ev() / (N_C * N_C) as f64
}

/// Hydrogen bond energy (eV): α·E_H.
pub fn e_hbond() -> f64 {
    alpha_em() * hartree_ev()
}

/// kT at 300 K (eV).
pub fn kt_300() -> f64 {
    8.617333e-5 * 300.0
}

/// Protein dielectric: N_w²(N_c + 1) = 16.
pub const DIELECTRIC_PROTEIN: u64 = N_W * N_W * (N_C + 1);

// ═══════════════════════════════════════════════════════════════
// §4  ARRHENIUS KINETICS
//
// k = A·exp(−E_a/kT)
// Crystal prediction: kT_bio ≈ ε_vdW = α·E_H/N_c²
// ═══════════════════════════════════════════════════════════════

/// Arrhenius rate constant (relative): exp(−E_a/kT).
pub fn arrhenius(ea: f64, kt: f64) -> f64 {
    (-ea / kt).exp()
}

/// Arrhenius at biological temperature: exp(−E_a / kT(300K)).
pub fn arrhenius_bio(ea: f64) -> f64 {
    arrhenius(ea, kt_300())
}

// ═══════════════════════════════════════════════════════════════
// §5  NOBLE GASES FROM (2,3)
// ═══════════════════════════════════════════════════════════════

pub const NOBLE_HE: u64 = N_W;                        // 2
pub const NOBLE_NE: u64 = N_W * (CHI - 1);           // 10
pub const NOBLE_AR: u64 = N_W * N_C * N_C;           // 18
pub const NOBLE_KR: u64 = SIGMA_D;                    // 36!

/// Neutral pH = β₀ = 7.
pub const NEUTRAL_PH: u64 = BETA0;

/// Bohr energy factor: Ry = E_H/N_w.
pub const BOHR_FACTOR: u64 = N_W;

/// All noble gas atomic numbers from Crystal.
pub fn noble_gases() -> [u64; 4] {
    [NOBLE_HE, NOBLE_NE, NOBLE_AR, NOBLE_KR]
}

// ═══════════════════════════════════════════════════════════════
// §6  SHELL FILLING TABLE
// ═══════════════════════════════════════════════════════════════

/// Period lengths of the periodic table.
pub fn period_lengths() -> [u64; 7] {
    let s1 = shell_capacity(1);
    let s2 = shell_capacity(2);
    let s3 = shell_capacity(3);
    let s4 = shell_capacity(4);
    [s1, s2, s2, s3, s3, s4, s4]
}

/// Cumulative noble gas Z values from shell filling.
pub fn cumulative_shells(n_shells: usize) -> Vec<u64> {
    let mut acc = 0u64;
    let pl = period_lengths();
    (0..n_shells.min(pl.len())).map(|i| { acc += pl[i]; acc }).collect()
}

// ═══════════════════════════════════════════════════════════════
// §7  DERIVED ANGLES & GEOMETRY
// ═══════════════════════════════════════════════════════════════

/// Peptide bond angle (sp2 planar): 2π/N_c = 120°.
pub fn peptide_angle() -> f64 { sp2_angle() }

/// sp3 angle in degrees.
pub fn sp3_angle_deg() -> f64 { sp3_angle().to_degrees() }
/// sp2 angle in degrees.
pub fn sp2_angle_deg() -> f64 { sp2_angle().to_degrees() }
/// Water bond angle in degrees.
pub fn water_angle_deg() -> f64 { water_angle().to_degrees() }

// ═══════════════════════════════════════════════════════════════
// §8  THERMAL–VDW COINCIDENCE
// ═══════════════════════════════════════════════════════════════

/// Ratio ε_vdW / kT(300K). Crystal predicts ≈ 1.
pub fn vdw_kt_ratio() -> f64 {
    eps_vdw() / kt_300()
}

// ═══════════════════════════════════════════════════════════════
// §9  OBSERVABLES
// ═══════════════════════════════════════════════════════════════

pub const OBSERVABLE_COUNT: u64 = 14;

/// Self-test: returns (n_pass, n_total, messages).
pub fn self_test() -> (usize, usize, Vec<String>) {
    let mut msgs = Vec::new();
    let mut pass = 0usize;
    let mut total = 0usize;

    macro_rules! check {
        ($name:expr, $cond:expr) => {{
            total += 1;
            let ok = $cond;
            if ok { pass += 1; }
            msgs.push(format!("{}  {}", if ok { "PASS" } else { "FAIL" }, $name));
        }}
    }

    check!("s-shell = 2 = N_w",                S_CAPACITY == 2);
    check!("p-shell = 6 = χ",                  P_CAPACITY == 6);
    check!("d-shell = 10 = N_w(χ−1)",          D_CAPACITY == 10);
    check!("f-shell = 14 = N_w·β₀",            F_CAPACITY == 14);
    check!("subshell(0)=2,(1)=6,(2)=10,(3)=14",
           subshell_capacity(0) == 2 && subshell_capacity(1) == 6
           && subshell_capacity(2) == 10 && subshell_capacity(3) == 14);
    check!("sp3 = 109.47°",                   (sp3_angle_deg() - 109.4712).abs() < 0.01);
    check!("sp2 = 120°",                       (sp2_angle_deg() - 120.0).abs() < 1e-10);
    check!("sp  = 180°",                       (sp_angle().to_degrees() - 180.0).abs() < 1e-10);
    check!("water = 104.48°",                 (water_angle_deg() - 104.4775).abs() < 0.01);
    check!("E_H ≈ 27.2 eV (< 1%)",           (hartree_ev() - 27.2).abs() / 27.2 < 0.01);
    check!("a₀ ≈ 0.529 Å (< 1%)",            (bohr_radius() - 0.529).abs() / 0.529 < 0.01);
    check!("ε_vdW/kT(300) ≈ 1",              { let r = vdw_kt_ratio(); r > 0.5 && r < 2.0 });
    check!("He Z=2 = N_w",                     NOBLE_HE == 2);
    check!("Ne Z=10 = N_w(χ−1)",               NOBLE_NE == 10);
    check!("Ar Z=18 = N_w·N_c²",               NOBLE_AR == 18);
    check!("Kr Z=36 = Σ_d",                     NOBLE_KR == 36);
    check!("pH = 7 = β₀",                       NEUTRAL_PH == 7);
    check!("Bohr factor = 2 = N_w",             BOHR_FACTOR == 2);
    check!("dielectric = 16 = N_w²(N_c+1)",     DIELECTRIC_PROTEIN == 16);
    check!("shell(1)=2, (2)=8, (3)=18",
           shell_capacity(1) == 2 && shell_capacity(2) == 8 && shell_capacity(3) == 18);
    check!("Arrhenius: low barrier → fast", {
        let r1 = arrhenius(0.5, kt_300());
        let r2 = arrhenius(0.025, kt_300());
        r2 > r1 && r2 > 0.1
    });

    (pass, total, msgs)
}


#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn s_cap_2()  { assert_eq!(S_CAPACITY, 2); }
    #[test] fn p_cap_6()  { assert_eq!(P_CAPACITY, 6); }
    #[test] fn d_cap_10() { assert_eq!(D_CAPACITY, 10); }
    #[test] fn f_cap_14() { assert_eq!(F_CAPACITY, 14); }
    #[test] fn he_2()     { assert_eq!(NOBLE_HE, 2); }
    #[test] fn ne_10()    { assert_eq!(NOBLE_NE, 10); }
    #[test] fn ar_18()    { assert_eq!(NOBLE_AR, 18); }
    #[test] fn kr_36()    { assert_eq!(NOBLE_KR, 36); }
    #[test] fn ph_7()     { assert_eq!(NEUTRAL_PH, 7); }
    #[test] fn diel_16()  { assert_eq!(DIELECTRIC_PROTEIN, 16); }

    #[test] fn subshell_formula() {
        assert_eq!(subshell_capacity(0), S_CAPACITY);
        assert_eq!(subshell_capacity(1), P_CAPACITY);
        assert_eq!(subshell_capacity(2), D_CAPACITY);
        assert_eq!(subshell_capacity(3), F_CAPACITY);
    }

    #[test] fn shell_cap() {
        assert_eq!(shell_capacity(1), 2);
        assert_eq!(shell_capacity(2), 8);
        assert_eq!(shell_capacity(3), 18);
        assert_eq!(shell_capacity(4), 32);
    }

    #[test] fn sp3_109() { assert!((sp3_angle_deg() - 109.4712).abs() < 0.01); }
    #[test] fn sp2_120() { assert!((sp2_angle_deg() - 120.0).abs() < 1e-10); }
    #[test] fn water_104() { assert!((water_angle_deg() - 104.4775).abs() < 0.01); }

    #[test] fn hartree_27() { assert!((hartree_ev() - 27.2).abs() / 27.2 < 0.01); }
    #[test] fn bohr_0529() { assert!((bohr_radius() - 0.529).abs() / 0.529 < 0.01); }
    #[test] fn vdw_matches_kt() {
        let r = vdw_kt_ratio();
        assert!(r > 0.5 && r < 2.0, "ε_vdW/kT(300) = {r}");
    }

    #[test] fn arrhenius_monotone() {
        assert!(arrhenius(0.025, kt_300()) > arrhenius(0.5, kt_300()));
    }
    #[test] fn arrhenius_zero_barrier() {
        assert!((arrhenius(0.0, 1.0) - 1.0).abs() < 1e-15);
    }

    #[test] fn full_self_test() {
        let (pass, total, msgs) = self_test();
        for m in &msgs { if m.starts_with("FAIL") { panic!("{m}"); } }
        assert_eq!(pass, total);
    }
}
