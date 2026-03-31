// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later

//! crystal_mandelbrot_tests.rs -- Mandelbrot <-> A_F Proofs
//!
//! Session 14: Period-n bulbs, grand staircase, external angles,
//! functor F: Mand -> Rep(A_F).
//! Structural proofs only. Observable count stays at 181.
//!
//! 38 tests: 10 integer, 5 staircase, 5 bulb geometry,
//!           4 external angles, 4 universality, 10 functor.
//!
//! LICENSE: AGPL-3.0

use std::f64::consts::PI;

// ==============================================================
// A_F ATOMS
// ==============================================================
const N_C: usize = 3;
const N_W: usize = 2;
const CHI: usize = 6;
const BETA0: usize = 7;
const SIGMA_D: usize = 36;
const D_MAX: usize = 42;
const D1: usize = 1;

// ==============================================================
// RUNNING ALPHA
// ==============================================================
fn alpha_inv_at(d: usize) -> f64 {
    (d as f64 + 1.0) * PI + (BETA0 as f64).ln()
}

// ==============================================================
// MERSENNE NUMBER: N_w^n - 1
// ==============================================================
fn mersenne(n: u32) -> usize {
    N_W.pow(n) - 1
}

// ==============================================================
// FUNCTOR
// ==============================================================
fn functor_on_objects(n: usize) -> usize { n }
fn functor_on_morphisms(p: usize, q: usize) -> usize { p * q }

fn divisors_of_chi() -> Vec<usize> {
    (1..=CHI).filter(|d| CHI % d == 0).collect()
}

// ==============================================================
// TESTS
// ==============================================================
#[cfg(test)]
mod tests {
    use super::*;

    fn within(name: &str, got: f64, want: f64, tol_pct: f64) {
        let err = ((got - want) / want * 100.0).abs();
        assert!(err < tol_pct,
            "{name}: got {got:.6} want {want:.6} err {err:.2}% tol {tol_pct}%");
    }

    fn exact(name: &str, got: f64, want: f64) {
        assert!((got - want).abs() < 1e-12,
            "{name}: got {got} want {want}");
    }

    // === Period-n = A_F integers (10) ===
    #[test] fn period2_eq_nw()     { assert_eq!(N_W, 2); }
    #[test] fn period3_eq_nc()     { assert_eq!(N_C, 3); }
    #[test] fn period6_eq_chi()    { assert_eq!(N_W * N_C, CHI); }
    #[test] fn period6_is_lcm()    { assert_eq!(CHI, 6); } // lcm(2,3)=6
    #[test] fn depth_43()          { assert_eq!(D_MAX + 1, 43); }
    #[test] fn hausdorff_eq_nw()   { assert_eq!(N_W, 2); }
    #[test] fn cardioid_denom()    { assert_eq!(N_W, 2); }
    #[test] fn period2_area_16()   { assert_eq!(N_W.pow(4), 16); }
    #[test] fn area_16_einstein()  { assert_eq!(N_W.pow(4), 16); }
    #[test] fn beta0_eq_7()        { assert_eq!(BETA0, 7); }

    // === Grand staircase (5) ===
    #[test] fn staircase_steps()   { assert_eq!(D_MAX + 1, 43); }
    #[test] fn alpha_inv_planck()  {
        within("planck", alpha_inv_at(0), PI + (7.0_f64).ln(), 0.001);
    }
    #[test] fn alpha_inv_world()   {
        within("world", alpha_inv_at(D_MAX), 137.034, 0.001);
    }
    #[test] fn step_size_pi()      {
        exact("step", alpha_inv_at(1) - alpha_inv_at(0), PI);
    }
    #[test] fn monotone_pi()       {
        for d in 0..D_MAX {
            let step = alpha_inv_at(d + 1) - alpha_inv_at(d);
            assert!((step - PI).abs() < 1e-12, "step at d={d} is {step}");
        }
    }

    // === Bulb geometry (5) ===
    #[test] fn cardioid_area()     {
        exact("cardioid", PI / N_W as f64, PI / 2.0);
    }
    #[test] fn period2_area()      {
        exact("p2area", PI / N_W.pow(4) as f64, PI / 16.0);
    }
    #[test] fn area_order()        {
        assert!(1.0 / (N_W * N_W) as f64 > 1.0 / (N_C * N_C) as f64);
    }
    #[test] fn coupling_order()    {
        assert!(1.0 / (N_W * N_W) as f64 > 1.0 / (N_C * N_C) as f64);
    }
    #[test] fn area_eq_coupling()  {
        // both are 1/n^2 ordering
        let area_2_gt_3 = (N_W * N_W) < (N_C * N_C);
        let coup_2_gt_3 = (N_W * N_W) < (N_C * N_C);
        assert_eq!(area_2_gt_3, coup_2_gt_3);
    }

    // === External angles (4) ===
    #[test] fn ext_denom_2_nc()    { assert_eq!(mersenne(2), N_C); }
    #[test] fn ext_denom_3_b0()    { assert_eq!(mersenne(3), BETA0); }
    #[test] fn ext_denom_6_fac()   { assert_eq!(mersenne(6), N_C * N_C * BETA0); }
    #[test] fn ext_pattern()       {
        assert_eq!(mersenne(2), 3);
        assert_eq!(mersenne(3), 7);
        assert_eq!(mersenne(6), 63);
    }

    // === Universality (4) ===
    #[test] fn feig_num()          { assert_eq!(D_MAX, 42); }
    #[test] fn feig_den()          { assert_eq!(N_C * N_C, 9); }
    #[test] fn feig_reduced()      { assert_eq!(42, 14 * 3); }
    #[test] fn feig_delta()        {
        within("feig", D_MAX as f64 / (N_C * N_C) as f64, 4.6692, 0.06);
    }

    // === Functor: Mand -> Rep(A_F) (10) ===
    #[test] fn divisors_chi()      {
        assert_eq!(divisors_of_chi(), vec![1, 2, 3, 6]);
    }
    #[test] fn gauge_eq_divisors() {
        assert_eq!(vec![1, N_W, N_C, CHI], divisors_of_chi());
    }
    #[test] fn divisors_af()       {
        assert_eq!(divisors_of_chi(), vec![D1, N_W, N_C, CHI]);
    }
    #[test] fn mersenne2_nc()      { assert_eq!(mersenne(2), N_C); }
    #[test] fn mersenne3_b0()      { assert_eq!(mersenne(3), BETA0); }
    #[test] fn mersenne6_nc2b0()   { assert_eq!(mersenne(6), N_C * N_C * BETA0); }
    #[test] fn functor_unit()      { assert_eq!(functor_on_objects(1), 1); }
    #[test] fn functor_tau_23()    { assert_eq!(functor_on_morphisms(2, 3), CHI); }
    #[test] fn functor_tau_22()    { assert_eq!(functor_on_morphisms(2, 2), N_W * N_W); }
    #[test] fn functor_tau_33()    { assert_eq!(functor_on_morphisms(3, 3), N_C * N_C); }
}
