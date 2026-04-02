// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later

// Friedmann ODE — Ω_Λ=13/19, Ω_m=6/19, uses tower partition
use crate::atoms::*;

pub fn omega_lambda() -> f64 { (TOWER_D - GAUSS) as f64 / TOWER_D as f64 }
pub fn omega_matter() -> f64 { GAUSS as f64 / TOWER_D as f64 }
pub fn omega_baryon() -> f64 { N_W as f64 / TOWER_D as f64 }

pub fn hubble_parameter(a: f64) -> f64 {
    // H²(a) = H₀² [Ω_m/a³ + Ω_Λ]
    (omega_matter() / (a*a*a) + omega_lambda()).sqrt()
}

pub fn scale_factor_dot(a: f64, h0: f64) -> f64 {
    a * h0 * hubble_parameter(a)
}

pub fn deceleration_parameter() -> f64 {
    0.5 * omega_matter() - omega_lambda()
}
