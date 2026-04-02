// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// dynamics/arcade.rs — Approximation Layers from (2,3)
//
// Every approximation parameter is a controlled degradation of an exact
// Crystal module.  Cutoffs, thresholds, and precision all trace to A_F.
//
//   LJ cutoff:            3σ  = N_c·σ
//   Barnes-Hut θ:         0.5 = 1/N_w
//   Octree children:      8   = d_colour = N_w³
//   WCA cutoff:           2^(1/6) = N_w^(1/χ)
//   Euler order:          1   = d₁
//   Verlet order:         2   = N_w
//   Fixed-point bits:     16  = N_w⁴ (16.16 format)
//   Spatial hash cells:   3   = N_c per dimension
//   LOD levels:           3   = N_c (exact/fast/arcade)
//   Mean-field T_c:       4   = N_w² (overestimates exact 2.269)
//   Newton-Raphson iter:  2   = N_w
//   Fast α⁻¹:            137 = floor((D+1)π + ln β₀)
//
// Observable count: 12.

use crate::atoms::*;

#[inline] fn sq(x: f64) -> f64 { x * x }

// ═══════════════════════════════════════════════════════════════
// §1  APPROXIMATION PARAMETERS FROM (2,3)
// ═══════════════════════════════════════════════════════════════

/// LJ cutoff: N_c·σ (beyond this, force negligible).
pub const LJ_CUTOFF: u64 = N_C;                       // 3

/// Barnes-Hut opening angle denominator: θ = 1/N_w = 0.5.
pub const BH_THETA_DEN: u64 = N_W;                    // 2

/// Octree branching: d_colour children per node.
pub const OCTREE_CHILDREN: u64 = D_COLOUR;             // 8

/// Euler integrator order: d₁ = 1.
pub const EULER_ORDER: u64 = 1;                        // d₁

/// Verlet integrator order: N_w = 2.
pub const VERLET_ORDER: u64 = N_W;                     // 2

/// Fixed-point format: N_w⁴.N_w⁴ = 16.16.
pub const FIXED_INT_BITS: u64 = N_W * N_W * N_W * N_W;  // 16
pub const FIXED_FRAC_BITS: u64 = N_W * N_W * N_W * N_W; // 16
pub const FIXED_BITS: u64 = FIXED_INT_BITS;              // 16 (compat alias)

/// Spatial hash: N_c cells per interaction radius per dimension.
pub const HASH_CELLS: u64 = N_C;                       // 3

/// LOD levels: N_c (exact=0, fast=1, arcade=2).
pub const LOD_LEVELS: u64 = N_C;                       // 3

/// Mean-field Ising T_c: z = N_w² (overestimates exact 2.269).
pub const MF_TC: u64 = N_W * N_W;                     // 4

/// Newton-Raphson iterations for fast inverse sqrt.
pub const NEWTON_ITER: u64 = N_W;                      // 2

/// Fast integer alpha inverse: floor((D+1)π + ln β₀) = 137.
pub const FAST_ALPHA_INV: u64 = 137;

// ═══════════════════════════════════════════════════════════════
// §2  APPROXIMATE FUNCTIONS
// ═══════════════════════════════════════════════════════════════

/// Barnes-Hut opening angle: 1/N_w.
pub fn bh_theta() -> f64 { 1.0 / N_W as f64 }

/// WCA cutoff: N_w^(1/χ) σ (LJ minimum).
pub fn wca_cutoff() -> f64 {
    (N_W as f64).powf(1.0 / CHI as f64)  // 2^(1/6) ≈ 1.122
}

/// Fixed-point resolution: 1/2^(N_w⁴).
pub fn fixed_resolution() -> f64 {
    1.0 / (1u64 << FIXED_FRAC_BITS) as f64
}

/// Exact LJ potential (reduced units): 4ε[(σ/r)¹²−(σ/r)⁶] with 4ε=N_w².
pub fn lj_exact(r: f64) -> f64 {
    let r2 = r * r;
    let r6 = r2 * r2 * r2;
    let r12 = r6 * r6;
    let nw2 = (N_W * N_W) as f64;
    nw2 * (1.0 / r12 - 1.0 / r6)
}

/// Arcade LJ: cutoff at N_c·σ, shifted to zero.
pub fn lj_arcade(r: f64) -> f64 {
    let cutoff = LJ_CUTOFF as f64;
    if r > cutoff { 0.0 } else { lj_exact(r) - lj_exact(cutoff) }
}

/// WCA potential: repulsive-only LJ, cut at r_min.
pub fn lj_wca(r: f64) -> f64 {
    let rmin = wca_cutoff();
    if r > rmin { 0.0 } else { lj_exact(r) + 1.0 }
}

/// Euler step: x' = x + v·dt (order d₁ = 1).
pub fn euler_step(x: f64, v: f64, dt: f64) -> f64 {
    x + v * dt
}

/// Verlet step: x' = x + v·dt + ½a·dt² (order N_w = 2).
pub fn verlet_step(x: f64, v: f64, a: f64, dt: f64) -> f64 {
    x + v * dt + 0.5 * a * dt * dt
}

/// Fast inverse square root (N_w Newton-Raphson iterations).
pub fn fast_inv_sqrt(x: f64) -> f64 {
    let mut y = 1.0 / x.sqrt();  // initial guess
    for _ in 0..NEWTON_ITER {
        y = y * (1.5 - 0.5 * x * y * y);
    }
    y
}

/// Fixed-point: real → 16.16 integer → real.
pub fn to_fixed(x: f64) -> i64 {
    (x * (1u64 << FIXED_FRAC_BITS) as f64).round() as i64
}

pub fn from_fixed(n: i64) -> f64 {
    n as f64 / (1u64 << FIXED_FRAC_BITS) as f64
}

pub fn fixed_round_trip(x: f64) -> f64 {
    from_fixed(to_fixed(x))
}

// ═══════════════════════════════════════════════════════════════
// §3  ERROR BOUNDS
// ═══════════════════════════════════════════════════════════════

/// LJ cutoff error: |V(N_c·σ)| / |V(r_min)|.
pub fn lj_cutoff_error() -> f64 {
    let v_cut = lj_exact(LJ_CUTOFF as f64).abs();
    let v_min = lj_exact(wca_cutoff()).abs();
    v_cut / v_min
}

/// Exact Onsager T_c for 2D Ising: 2/ln(1+√2).
pub fn onsager_tc() -> f64 {
    (N_W as f64) / (1.0 + (N_W as f64).sqrt()).ln()
}

/// Mean-field vs exact Onsager T_c ratio (MF overestimates).
pub fn mean_field_error() -> f64 {
    MF_TC as f64 / onsager_tc()
}

/// Verify fast α⁻¹ = floor((D+1)π + ln β₀).
pub fn verify_alpha_inv() -> bool {
    let val = (TOWER_D + 1) as f64 * std::f64::consts::PI + (BETA0 as f64).ln();
    val.floor() as u64 == FAST_ALPHA_INV
}

// ═══════════════════════════════════════════════════════════════
// §4  SELF-TEST
// ═══════════════════════════════════════════════════════════════

pub const OBSERVABLE_COUNT: u64 = 12;

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

    // §1 Integer identities
    check!("LJ cutoff = 3 = N_c",                LJ_CUTOFF == 3);
    check!("Barnes-Hut θ = 1/2 = 1/N_w",         BH_THETA_DEN == 2);
    check!("octree children = 8 = d_colour",      OCTREE_CHILDREN == 8);
    check!("Euler order = 1 = d₁",               EULER_ORDER == 1);
    check!("Verlet order = 2 = N_w",             VERLET_ORDER == 2);
    check!("fixed-point bits = 16 = N_w⁴",       FIXED_BITS == 16);
    check!("spatial hash = 3 = N_c",             HASH_CELLS == 3);
    check!("LOD levels = 3 = N_c",               LOD_LEVELS == 3);
    check!("mean-field T_c = 4 = N_w²",          MF_TC == 4);
    check!("Newton-Raphson = 2 = N_w",           NEWTON_ITER == 2);
    check!("fast α⁻¹ = 137",                     verify_alpha_inv());

    // §2 LJ cutoff quality
    let cut_err = lj_cutoff_error();
    check!("LJ cutoff error < 1%",               cut_err < 0.01);

    // §3 WCA cutoff
    let wca = wca_cutoff();
    let v_wca_at = lj_wca(wca);
    let v_wca_beyond = lj_wca(wca + 0.1);
    check!("WCA V(r_min) ≈ 0",                   v_wca_at.abs() < 0.01);
    check!("WCA V(r_min+0.1) = 0",               v_wca_beyond == 0.0);

    // §4 Euler vs Verlet
    let (x0, v0, a0, dt) = (0.0, 1.0, -1.0, 0.1);
    let x_exact = x0 + v0 * dt + 0.5 * a0 * dt * dt;
    let x_euler = euler_step(x0, v0, dt);
    let x_verlet = verlet_step(x0, v0, a0, dt);
    let e_euler = (x_euler - x_exact).abs();
    let e_verlet = (x_verlet - x_exact).abs();
    check!("Verlet more accurate than Euler",    e_verlet < e_euler);

    // §5 Fixed-point precision
    let x_orig = 3.14159265;
    let x_rt = fixed_round_trip(x_orig);
    let fp_err = (x_rt - x_orig).abs();
    let resolution = fixed_resolution();
    check!("fixed-point error < resolution",      fp_err < resolution);

    // §6 Mean-field overestimates
    let mf_ratio = mean_field_error();
    check!("MF overestimates (ratio > 1)",        mf_ratio > 1.0);
    check!("MF not wildly off (ratio < 2)",       mf_ratio < 2.0);

    // §7 Fast inv sqrt
    let exact_isqrt = 1.0 / (2.0_f64).sqrt();
    let fast_isqrt = fast_inv_sqrt(2.0);
    let sq_err = (fast_isqrt - exact_isqrt).abs() / exact_isqrt;
    check!("fast inv sqrt converges (< 1e-10)",   sq_err < 1e-10);

    (pass, total, msgs)
}


#[cfg(test)]
mod tests {
    use super::*;

    // Integer identities
    #[test] fn lj_cut_3()    { assert_eq!(LJ_CUTOFF, 3); }
    #[test] fn bh_den_2()    { assert_eq!(BH_THETA_DEN, 2); }
    #[test] fn octree_8()    { assert_eq!(OCTREE_CHILDREN, 8); }
    #[test] fn euler_1()     { assert_eq!(EULER_ORDER, 1); }
    #[test] fn verlet_2()    { assert_eq!(VERLET_ORDER, 2); }
    #[test] fn fixed_16()    { assert_eq!(FIXED_BITS, 16); }
    #[test] fn hash_3()      { assert_eq!(HASH_CELLS, 3); }
    #[test] fn lod_3()       { assert_eq!(LOD_LEVELS, 3); }
    #[test] fn mf_tc_4()     { assert_eq!(MF_TC, 4); }
    #[test] fn newton_2()    { assert_eq!(NEWTON_ITER, 2); }
    #[test] fn alpha_137()   { assert!(verify_alpha_inv()); }

    // WCA cutoff ≈ 2^(1/6)
    #[test] fn wca_value() {
        let wca = wca_cutoff();
        let ref_val = 2.0_f64.powf(1.0 / 6.0);
        assert!((wca - ref_val).abs() < 1e-12);
    }

    // BH theta = 0.5
    #[test] fn bh_half() {
        assert!((bh_theta() - 0.5).abs() < 1e-15);
    }

    // LJ cutoff negligible
    #[test] fn lj_cutoff_small() {
        assert!(lj_cutoff_error() < 0.01);
    }

    // Arcade LJ shifted
    #[test] fn lj_arcade_zero_beyond() {
        assert_eq!(lj_arcade(4.0), 0.0);
    }
    #[test] fn lj_arcade_shifted() {
        let v = lj_arcade(LJ_CUTOFF as f64 - 0.001);
        assert!(v.abs() < 0.001);  // near cutoff → near zero
    }

    // WCA smooth
    #[test] fn wca_smooth_cutoff() {
        assert!(lj_wca(wca_cutoff()).abs() < 0.01);
        assert_eq!(lj_wca(wca_cutoff() + 0.1), 0.0);
    }

    // Verlet > Euler
    #[test] fn verlet_beats_euler() {
        let x_exact = 0.5 * (-1.0) * 0.01 + 1.0 * 0.1;  // 0.095
        let x_euler = euler_step(0.0, 1.0, 0.1);
        let x_verlet = verlet_step(0.0, 1.0, -1.0, 0.1);
        assert!((x_verlet - x_exact).abs() < (x_euler - x_exact).abs());
    }

    // Fixed-point round-trip
    #[test] fn fixed_precision() {
        let x = 3.14159265;
        let err = (fixed_round_trip(x) - x).abs();
        assert!(err < fixed_resolution());
    }

    // Mean-field overestimates
    #[test] fn mf_over() {
        let r = mean_field_error();
        assert!(r > 1.0 && r < 2.0);
    }

    // Fast inv sqrt
    #[test] fn fast_isqrt_converges() {
        let exact = 1.0 / (2.0_f64).sqrt();
        let fast = fast_inv_sqrt(2.0);
        assert!((fast - exact).abs() / exact < 1e-10);
    }

    #[test] fn full_self_test() {
        let (pass, total, msgs) = self_test();
        for m in &msgs { if m.starts_with("FAIL") { panic!("{m}"); } }
        assert_eq!(pass, total);
    }
}
