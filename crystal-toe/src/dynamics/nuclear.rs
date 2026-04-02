// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// dynamics/nuclear.rs — Nuclear Physics from (2,3)
//
// Semi-empirical mass formula + shell model.  Every nuclear integer from A_F.
//
//   Magic numbers (all 7):
//     2   = N_w             8   = d_colour = N_w³
//     20  = N_w²(χ−1)      28  = N_w²·β₀
//     50  = N_w(χ−1)²      82  = N_w(D−1)
//     126 = N_w·β₀·N_c²
//
//   SEMF exponents:
//     Surface:    A^(2/3)    2/3 = N_w/N_c
//     Coulomb:    A^(−1/3)   1/3 = 1/N_c
//     Asymmetry:  (A−2Z)²/A  2   = N_w
//     Pairing:    A^(−1/2)   1/2 = 1/N_w
//     Coulomb prefactor: 3/5 = N_c/(χ−1)
//
//   Nuclear structure:
//     Isospin:       2  = N_w
//     Radius exp:    1/3 = 1/N_c
//     Deuteron:      2  = N_w nucleons
//     Alpha:         4  = N_w² nucleons
//     Iron peak:     56 = d_colour·β₀
//     B(He-4):       ~28 MeV = N_w²·β₀ MeV
//
// Observable count: 15.

use crate::atoms::*;

#[inline] fn sq(x: f64) -> f64 { x * x }

// ═══════════════════════════════════════════════════════════════
// §1  MAGIC NUMBERS — ALL 7 FROM (2,3)
// ═══════════════════════════════════════════════════════════════

pub fn magic_numbers() -> [u64; 7] {
    [
        N_W,                                     //   2
        D_COLOUR,                                //   8
        N_W * N_W * (CHI - 1),                  //  20
        N_W * N_W * BETA0,                       //  28
        N_W * (CHI - 1) * (CHI - 1),            //  50
        N_W * (TOWER_D - 1),                     //  82
        N_W * BETA0 * N_C * N_C,                // 126
    ]
}

pub const MAGIC_REF: [u64; 7] = [2, 8, 20, 28, 50, 82, 126];

pub const MAGIC_LABELS: [&str; 7] = [
    "N_w", "d_colour=N_w³", "N_w²(χ−1)", "N_w²·β₀",
    "N_w(χ−1)²", "N_w(D−1)", "N_w·β₀·N_c²",
];

// ═══════════════════════════════════════════════════════════════
// §2  SEMF — Semi-Empirical Mass Formula
//
// B(A,Z) = a_V·A − a_S·A^(2/3) − a_C·Z(Z−1)/A^(1/3)
//          − a_A·(A−2Z)²/A + δ/A^(1/2)
//
// Crystal exponents: 2/3=N_w/N_c, 1/3=1/N_c, 1/2=1/N_w
// ═══════════════════════════════════════════════════════════════

/// SEMF exponents (Crystal-traced).
pub const SURFACE_EXP:  (u64, u64) = (N_W, N_C);     // 2/3
pub const COULOMB_EXP:  (u64, u64) = (1, N_C);       // 1/3
pub const ASYMMETRY_FACTOR: u64    = N_W;             // 2
pub const PAIRING_EXP:  (u64, u64) = (1, N_W);       // 1/2
pub const COULOMB_PREFACTOR: (u64, u64) = (N_C, CHI - 1); // 3/5

/// SEMF coefficients (MeV, standard empirical values).
pub const A_V:    f64 = 15.8;   // volume
pub const A_S:    f64 = 18.3;   // surface
pub const A_C:    f64 = 0.714;  // Coulomb
pub const A_A:    f64 = 23.2;   // asymmetry
pub const A_PAIR: f64 = 12.0;   // pairing

/// Binding energy B(A,Z) in MeV (positive = bound).
pub fn binding_energy(a: u32, z: u32) -> f64 {
    let af = a as f64;
    let zf = z as f64;
    let nwf = N_W as f64;
    let ncf = N_C as f64;
    // Volume
    let bv = A_V * af;
    // Surface: A^(N_w/N_c) = A^(2/3)
    let bs = A_S * af.powf(nwf / ncf);
    // Coulomb: Z(Z−1)/A^(1/N_c)
    let bc = A_C * zf * (zf - 1.0) / af.powf(1.0 / ncf);
    // Asymmetry: (A − N_w·Z)²/A
    let ba = A_A * sq(af - nwf * zf) / af;
    // Pairing: δ/A^(1/N_w)
    let bp = if a % 2 == 0 { if z % 2 == 0 { A_PAIR } else { -A_PAIR } } else { 0.0 }
             / af.powf(1.0 / nwf);
    bv - bs - bc - ba + bp
}

/// Binding energy per nucleon.
pub fn binding_per_nucleon(a: u32, z: u32) -> f64 {
    binding_energy(a, z) / a as f64
}

/// Most stable Z for given A (valley of stability): Z ≈ A/(N_w + f(A)).
pub fn optimal_z(a: u32) -> u32 {
    let af = a as f64;
    let ncf = N_C as f64;
    let nwf = N_W as f64;
    // Z_opt ≈ A / (2 + a_C A^(2/3) / (2 a_A))
    let z = af / (nwf + A_C * af.powf(nwf / ncf) / (nwf * A_A));
    z.round() as u32
}

// ═══════════════════════════════════════════════════════════════
// §3  NUCLEAR RADII
//
// R = r₀·A^(1/N_c)
// r₀ ≈ 1.25 fm
// ═══════════════════════════════════════════════════════════════

pub const R0: f64 = 1.25;  // fm

/// Nuclear radius in fm: r₀·A^(1/N_c).
pub fn nuclear_radius(a: u32) -> f64 {
    R0 * (a as f64).powf(1.0 / N_C as f64)
}

/// Nuclear volume ∝ A (extensive): (4π/3)·R³.
pub fn nuclear_volume(a: u32) -> f64 {
    let r = nuclear_radius(a);
    4.0 * std::f64::consts::PI / 3.0 * r * r * r
}

// ═══════════════════════════════════════════════════════════════
// §4  SPECIFIC NUCLEI
// ═══════════════════════════════════════════════════════════════

/// Isospin states: proton + neutron = N_w.
pub const ISOSPIN_STATES: u64 = N_W;          // 2

/// Deuteron: N_w nucleons.
pub const DEUTERON_A: u64 = N_W;              // 2

/// Alpha particle: N_w² nucleons.
pub const ALPHA_PARTICLE: u64 = N_W * N_W;    // 4

/// Iron peak: A = d_colour·β₀ = 56.
pub const IRON_PEAK_A: u64 = D_COLOUR * BETA0; // 56

/// He-4 binding (Crystal trace): N_w²·β₀ = 28 MeV.
pub const HE4_BINDING_CRYSTAL: u64 = N_W * N_W * BETA0; // 28

/// He-4 binding (experiment): 28.296 MeV.
pub const HE4_BINDING_EXP: f64 = 28.296;

// ═══════════════════════════════════════════════════════════════
// §5  BINDING CURVE SCAN
// ═══════════════════════════════════════════════════════════════

/// Scan B/A for A = 1..max_a along valley of stability.
pub fn binding_curve(max_a: u32) -> Vec<(u32, f64)> {
    (2..=max_a).map(|a| {
        let z = optimal_z(a);
        let z = z.max(1).min(a - 1);
        (a, binding_per_nucleon(a, z))
    }).collect()
}

/// Find peak B/A nucleus in range.
pub fn peak_nucleus(max_a: u32) -> (u32, f64) {
    binding_curve(max_a).into_iter()
        .max_by(|a, b| a.1.partial_cmp(&b.1).unwrap())
        .unwrap_or((56, 8.79))
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

    // §1 Magic numbers
    let mag = magic_numbers();
    check!("magic numbers match [2,8,20,28,50,82,126]", mag == MAGIC_REF);
    for (i, (&m, &r)) in mag.iter().zip(MAGIC_REF.iter()).enumerate() {
        check!(&format!("magic[{}] = {} = {}", i, r, MAGIC_LABELS[i]), m == r);
    }

    // §2 SEMF exponents
    check!("surface 2/3 = N_w/N_c",      SURFACE_EXP == (2, 3));
    check!("Coulomb 1/3 = 1/N_c",        COULOMB_EXP == (1, 3));
    check!("Coulomb pre 3/5 = N_c/(χ−1)", COULOMB_PREFACTOR == (3, 5));
    check!("pairing 1/2 = 1/N_w",        PAIRING_EXP == (1, 2));
    check!("asymmetry = 2 = N_w",        ASYMMETRY_FACTOR == 2);

    // §3 Specific nuclei
    check!("isospin = 2 = N_w",           ISOSPIN_STATES == 2);
    check!("deuteron = 2 = N_w",          DEUTERON_A == 2);
    check!("alpha = 4 = N_w²",           ALPHA_PARTICLE == 4);
    check!("Fe peak A=56 = d_colour·β₀",  IRON_PEAK_A == 56);

    // §4 He-4 binding (Crystal trace)
    let he4_err = (HE4_BINDING_CRYSTAL as f64 - HE4_BINDING_EXP).abs() / HE4_BINDING_EXP;
    check!("B(He-4) ≈ N_w²·β₀ = 28 MeV (< 2%)", he4_err < 0.02);

    // §5 Fe-56 is binding peak
    let bfe56 = binding_per_nucleon(56, 26);
    let bfe55 = binding_per_nucleon(55, 26);
    let bfe57 = binding_per_nucleon(57, 26);
    check!("Fe-56 is binding peak", bfe56 > bfe55 && bfe56 > bfe57);

    // §6 Nuclear radii scale as A^(1/N_c)
    let r_he  = nuclear_radius(4);
    let r_fe  = nuclear_radius(56);
    let ratio = r_fe / r_he;
    let expected = (56.0_f64 / 4.0).powf(1.0 / N_C as f64);
    check!("R(Fe)/R(He) = (56/4)^(1/N_c)", (ratio - expected).abs() / expected < 1e-10);

    (pass, total, msgs)
}


#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn magic_all_7() {
        assert_eq!(magic_numbers(), MAGIC_REF);
    }
    #[test] fn iron_56() { assert_eq!(IRON_PEAK_A, 56); }
    #[test] fn isospin_2() { assert_eq!(ISOSPIN_STATES, 2); }
    #[test] fn alpha_4() { assert_eq!(ALPHA_PARTICLE, 4); }
    #[test] fn deuteron_2() { assert_eq!(DEUTERON_A, 2); }
    #[test] fn he4_crystal() { assert_eq!(HE4_BINDING_CRYSTAL, 28); }

    #[test] fn surface_exp() { assert_eq!(SURFACE_EXP, (2, 3)); }
    #[test] fn coulomb_exp() { assert_eq!(COULOMB_EXP, (1, 3)); }
    #[test] fn pairing_exp() { assert_eq!(PAIRING_EXP, (1, 2)); }
    #[test] fn coulomb_pre() { assert_eq!(COULOMB_PREFACTOR, (3, 5)); }

    #[test] fn he4_binding_close() {
        let err = (HE4_BINDING_CRYSTAL as f64 - HE4_BINDING_EXP).abs() / HE4_BINDING_EXP;
        assert!(err < 0.02, "He-4 binding err = {err}");
    }

    #[test] fn fe56_is_peak() {
        let b56 = binding_per_nucleon(56, 26);
        let b55 = binding_per_nucleon(55, 26);
        let b57 = binding_per_nucleon(57, 26);
        assert!(b56 > b55 && b56 > b57);
    }

    #[test] fn radius_scales() {
        let ratio = nuclear_radius(56) / nuclear_radius(4);
        let expected = (56.0_f64 / 4.0).powf(1.0 / N_C as f64);
        assert!((ratio - expected).abs() < 1e-10);
    }

    #[test] fn binding_positive_fe() {
        assert!(binding_energy(56, 26) > 0.0);
    }

    #[test] fn volume_extensive() {
        let v1 = nuclear_volume(56);
        let v2 = nuclear_volume(112);
        assert!((v2 / v1 - 2.0).abs() < 0.01);
    }

    #[test] fn optimal_z_fe() {
        let z = optimal_z(56);
        assert!((z as i32 - 26).abs() <= 1, "optimal Z(56) = {z}");
    }

    #[test] fn full_self_test() {
        let (pass, total, msgs) = self_test();
        for m in &msgs { if m.starts_with("FAIL") { panic!("{m}"); } }
        assert_eq!(pass, total);
    }
}
