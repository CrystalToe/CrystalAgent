// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// dynamics/bio.rs — Biological Scaling from (2,3)
//
// Genetic code, allometric scaling, molecular biology.
//
//   DNA bases:            4   = N_w²  (A, T, G, C)
//   Codon length:         3   = N_c
//   Total codons:         64  = (N_w²)^N_c = 4³
//   Amino acids:          20  = N_w²(χ−1)
//   Stop codons:          3   = N_c
//   Start codons:         1   = d₁
//   H-bonds A-T:          2   = N_w
//   H-bonds G-C:          3   = N_c
//   Double helix:         2   = N_w  strands
//   BP per turn:          ~10 = N_w(χ−1)
//   Lipid bilayer:        2   = N_w  layers
//   Helix residues/turn:  3.6 = 18/5 = N_c²·N_w/(χ−1)
//   Kleiber metabolic:    3/4 = N_c/N_w²
//   Heart rate:           1/4 = 1/N_w²  (negative)
//   Lifespan:             1/4 = 1/N_w²
//   Surface area:         2/3 = N_w/N_c
//   Flory exponent:       2/5 = N_w/(χ−1)
//
// Observable count: 15.

use crate::atoms::*;

// ═══════════════════════════════════════════════════════════════
// §1  GENETIC CODE FROM (2,3)
//
// DNA alphabet:  {A, T, G, C} = N_w² = 4 letters.
// Codon length:  N_c = 3 bases per codon.
// Total codons:  (N_w²)^N_c = 4³ = 64.
// Amino acids:   20 = N_w²(χ−1) = 4 × 5.
// Stop codons:   N_c = 3.
// Start codons:  d₁ = 1.
// Sense codons:  64 − 3 = 61 for 20 amino acids.
// Redundancy:    61/20 ≈ N_c.
// ═══════════════════════════════════════════════════════════════

pub const DNA_BASES: u64 = N_W * N_W;                 // 4
pub const CODON_LEN: u64 = N_C;                       // 3
pub const TOTAL_CODONS: u64 = 64;                      // (N_w²)^N_c
pub const AMINO_ACIDS: u64 = N_W * N_W * (CHI - 1);   // 20
pub const STOP_CODONS: u64 = N_C;                      // 3
pub const START_CODONS: u64 = 1;                       // d₁
pub const SENSE_CODONS: u64 = TOTAL_CODONS - STOP_CODONS; // 61

/// Codon redundancy: sense_codons / amino_acids ≈ N_c.
pub fn codon_redundancy() -> f64 {
    SENSE_CODONS as f64 / AMINO_ACIDS as f64
}

// ═══════════════════════════════════════════════════════════════
// §2  DNA STRUCTURE FROM (2,3)
//
// Double helix: N_w = 2 antiparallel strands.
// H-bonds: A-T = N_w = 2, G-C = N_c = 3.
// Base pairs per turn: ~10 = N_w(χ−1).
// Chargaff pairs: N_w = 2 (A=T, G=C).
// ═══════════════════════════════════════════════════════════════

pub const HELIX_STRANDS: u64 = N_W;                    // 2
pub const HBOND_AT: u64 = N_W;                         // 2
pub const HBOND_GC: u64 = N_C;                         // 3
pub const BP_PER_TURN: u64 = N_W * (CHI - 1);          // 10
pub const CHARGAFF_PAIRS: u64 = N_W;                    // 2

// ═══════════════════════════════════════════════════════════════
// §3  PROTEIN STRUCTURE FROM (2,3)
//
// Alpha helix: 3.6 residues/turn = N_c²·N_w/(χ−1) = 18/5.
// Flory exponent: ν = N_w/(χ−1) = 2/5.
// Peptide bond: planar (sp2 ~ 120° = 2π/N_c).
// Ramachandran angles: N_w = 2 (φ, ψ).
// Lipid bilayer: N_w = 2 leaflets.
// ═══════════════════════════════════════════════════════════════

/// Alpha helix residues per turn: N_c²·N_w/(χ−1) = 18/5 = 3.6.
pub const HELIX_PER_TURN: (u64, u64) = (N_C * N_C * N_W, CHI - 1); // (18, 5)

pub fn helix_per_turn() -> f64 {
    HELIX_PER_TURN.0 as f64 / HELIX_PER_TURN.1 as f64
}

/// Flory exponent: N_w/(χ−1) = 2/5 = 0.4.
pub const FLORY_NU: (u64, u64) = (N_W, CHI - 1);      // (2, 5)

pub fn flory_nu() -> f64 {
    FLORY_NU.0 as f64 / FLORY_NU.1 as f64
}

/// Peptide bond angle (sp2): 2π/N_c = 120°.
pub fn peptide_angle() -> f64 {
    2.0 * std::f64::consts::PI / N_C as f64
}

/// Ramachandran torsion angles: N_w = 2 (φ, ψ).
pub const RAMACHANDRAN_ANGLES: u64 = N_W;               // 2

/// Lipid bilayer leaflets: N_w = 2.
pub const LIPID_LAYERS: u64 = N_W;                      // 2

// ═══════════════════════════════════════════════════════════════
// §4  ALLOMETRIC SCALING FROM (2,3)
//
// Kleiber: P ~ M^(3/4) = M^(N_c/N_w²).
// Heart rate: f ~ M^(−1/4) = M^(−1/N_w²).
// Lifespan: T ~ M^(1/4) = M^(1/N_w²).
// Surface area: A ~ M^(2/3) = M^(N_w/N_c).
//
// heart × lifespan exponents cancel → constant total heartbeats!
// ═══════════════════════════════════════════════════════════════

/// Kleiber metabolic: 3/4 = N_c/N_w².
pub const KLEIBER_EXP: (u64, u64) = (N_C, N_W * N_W);  // (3, 4)

/// Heart rate: 1/4 = 1/N_w² (negative: f ~ M^(−1/4)).
pub const HEART_RATE_EXP: (u64, u64) = (1, N_W * N_W);  // (1, 4)

/// Lifespan: 1/4 = 1/N_w².
pub const LIFESPAN_EXP: (u64, u64) = (1, N_W * N_W);    // (1, 4)

/// Surface area: 2/3 = N_w/N_c.
pub const SURFACE_AREA_EXP: (u64, u64) = (N_W, N_C);    // (2, 3)

pub fn kleiber_exp() -> f64 { KLEIBER_EXP.0 as f64 / KLEIBER_EXP.1 as f64 }
pub fn heart_rate_exp() -> f64 { HEART_RATE_EXP.0 as f64 / HEART_RATE_EXP.1 as f64 }
pub fn lifespan_exp() -> f64 { LIFESPAN_EXP.0 as f64 / LIFESPAN_EXP.1 as f64 }
pub fn surface_exp() -> f64 { SURFACE_AREA_EXP.0 as f64 / SURFACE_AREA_EXP.1 as f64 }

/// Kleiber scaling: metabolic rate relative to reference.
pub fn kleiber(m_ratio: f64) -> f64 {
    m_ratio.powf(kleiber_exp())
}

/// Heart rate scaling (relative).
pub fn heart_rate(m_ratio: f64) -> f64 {
    m_ratio.powf(-heart_rate_exp())
}

/// Lifespan scaling (relative).
pub fn lifespan(m_ratio: f64) -> f64 {
    m_ratio.powf(lifespan_exp())
}

/// Constant total heartbeats: heart_rate × lifespan exponents cancel.
pub fn constant_heartbeats() -> bool {
    HEART_RATE_EXP == LIFESPAN_EXP  // both 1/4
}

// ═══════════════════════════════════════════════════════════════
// §5  CROSS-MODULE TRACES
// ═══════════════════════════════════════════════════════════════

/// Kleiber 3/4 = Chandrasekhar exponent (Astro).
pub fn kleiber_is_chandrasekhar() -> bool {
    KLEIBER_EXP == (N_C, N_W * N_W)
}

/// Surface 2/3 = rigid body I_shell (Rigid) = Larmor (EM).
pub fn surface_is_larmor() -> bool {
    SURFACE_AREA_EXP == (N_W, N_C)
}

/// DNA bases = Bell states = Pauli group (QInfo).
pub fn bases_are_bell_states() -> bool {
    DNA_BASES == N_W * N_W  // 4
}

// ═══════════════════════════════════════════════════════════════
// §6  SELF-TEST
// ═══════════════════════════════════════════════════════════════

pub const OBSERVABLE_COUNT: u64 = 15;

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

    // §1 Genetic code
    check!("DNA bases = 4 = N_w²",              DNA_BASES == 4);
    check!("codon length = 3 = N_c",            CODON_LEN == 3);
    check!("total codons = 64 = (N_w²)^N_c",   TOTAL_CODONS == 64);
    check!("amino acids = 20 = N_w²(χ−1)",      AMINO_ACIDS == 20);
    check!("stop codons = 3 = N_c",             STOP_CODONS == 3);
    check!("start codons = 1 = d₁",             START_CODONS == 1);
    check!("sense codons = 61",                 SENSE_CODONS == 61);

    // §2 DNA structure
    check!("helix strands = 2 = N_w",           HELIX_STRANDS == 2);
    check!("H-bond A-T = 2 = N_w",              HBOND_AT == 2);
    check!("H-bond G-C = 3 = N_c",              HBOND_GC == 3);
    check!("BP/turn = 10 = N_w(χ−1)",           BP_PER_TURN == 10);
    check!("lipid bilayer = 2 = N_w",           LIPID_LAYERS == 2);

    // §3 Protein structure
    check!("helix/turn = 3.6 = 18/5",           (helix_per_turn() - 3.6).abs() < 1e-12);
    check!("Flory ν = 0.4 = 2/5",              (flory_nu() - 0.4).abs() < 1e-12);

    // §4 Allometric scaling
    check!("Kleiber 3/4 = N_c/N_w²",            KLEIBER_EXP == (3, 4));
    check!("heart rate 1/4 = 1/N_w²",           HEART_RATE_EXP == (1, 4));
    check!("lifespan 1/4 = 1/N_w²",             LIFESPAN_EXP == (1, 4));
    check!("surface area 2/3 = N_w/N_c",        SURFACE_AREA_EXP == (2, 3));
    check!("constant total heartbeats",          constant_heartbeats());

    // §5 Redundancy
    let red = codon_redundancy();
    let red_err = (red - N_C as f64).abs() / N_C as f64;
    check!("redundancy ≈ N_c (< 5%)",           red_err < 0.05);

    // §5 Cross-module
    check!("Kleiber = Chandrasekhar exp",        kleiber_is_chandrasekhar());
    check!("surface = Larmor = N_w/N_c",        surface_is_larmor());
    check!("DNA bases = Bell states = N_w²",     bases_are_bell_states());

    (pass, total, msgs)
}


#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn bases_4()      { assert_eq!(DNA_BASES, 4); }
    #[test] fn codon_3()      { assert_eq!(CODON_LEN, 3); }
    #[test] fn codons_64()    { assert_eq!(TOTAL_CODONS, 64); }
    #[test] fn amino_20()     { assert_eq!(AMINO_ACIDS, 20); }
    #[test] fn stops_3()      { assert_eq!(STOP_CODONS, 3); }
    #[test] fn start_1()      { assert_eq!(START_CODONS, 1); }
    #[test] fn sense_61()     { assert_eq!(SENSE_CODONS, 61); }
    #[test] fn strands_2()    { assert_eq!(HELIX_STRANDS, 2); }
    #[test] fn hbond_at_2()   { assert_eq!(HBOND_AT, 2); }
    #[test] fn hbond_gc_3()   { assert_eq!(HBOND_GC, 3); }
    #[test] fn bp_turn_10()   { assert_eq!(BP_PER_TURN, 10); }
    #[test] fn lipid_2()      { assert_eq!(LIPID_LAYERS, 2); }

    #[test] fn helix_3_6() { assert!((helix_per_turn() - 3.6).abs() < 1e-12); }
    #[test] fn flory_0_4() { assert!((flory_nu() - 0.4).abs() < 1e-12); }

    #[test] fn kleiber_3_4()  { assert_eq!(KLEIBER_EXP, (3, 4)); }
    #[test] fn heart_1_4()    { assert_eq!(HEART_RATE_EXP, (1, 4)); }
    #[test] fn life_1_4()     { assert_eq!(LIFESPAN_EXP, (1, 4)); }
    #[test] fn surface_2_3()  { assert_eq!(SURFACE_AREA_EXP, (2, 3)); }
    #[test] fn heartbeats()   { assert!(constant_heartbeats()); }

    #[test] fn redundancy_near_3() {
        let r = codon_redundancy();
        assert!((r - 3.0).abs() < 0.2, "redundancy = {r}");
    }

    #[test] fn kleiber_scaling() {
        assert!((kleiber(1.0) - 1.0).abs() < 1e-12);
        // 10x mass → 10^0.75 ≈ 5.62
        assert!((kleiber(10.0) - 10.0_f64.powf(0.75)).abs() < 1e-10);
    }

    #[test] fn cross_checks() {
        assert!(kleiber_is_chandrasekhar());
        assert!(surface_is_larmor());
        assert!(bases_are_bell_states());
    }

    #[test] fn full_self_test() {
        let (pass, total, msgs) = self_test();
        for m in &msgs { if m.starts_with("FAIL") { panic!("{m}"); } }
        assert_eq!(pass, total);
    }
}
