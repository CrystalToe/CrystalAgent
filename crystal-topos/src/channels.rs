// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later

//! 10 quantum channels: depolarising, damping, flip, thermal, Kraus, Lindblad.

use crate::base::*;
use std::f64::consts::PI;

/// ρ → (1-p)ρ + (p/χ)I
pub fn depolarise(p: f64, rho: &Mat) -> Mat {
    let n = rho.rows;
    let mut out = Mat::new(n);
    let mixed = 1.0 / n as f64;
    for i in 0..n {
        for j in 0..n {
            let orig = rho.get(i, j).scale(1.0 - p);
            let noise = if i == j { Cx::from_real(p * mixed) } else { Cx::ZERO };
            out.set(i, j, orig + noise);
        }
    }
    out
}

/// Amplitude damping: excited sectors decay to singlet
pub fn amplitude_damp(p: f64, rho: &Mat) -> Mat {
    let en = energies();
    let me = max_entropy();
    let gammas: Vec<f64> = (0..CHI).map(|k| p * en[k.min(3)] / me).collect();
    let n = rho.rows.min(CHI);
    let mut out = Mat::new(n);
    // Diagonal
    let mut gain = Cx::ZERO;
    for j in 1..n { gain = gain + rho.get(j, j).scale(gammas[j]); }
    out.set(0, 0, rho.get(0, 0) + gain);
    for k in 1..n { out.set(k, k, rho.get(k, k).scale(1.0 - gammas[k])); }
    // Off-diagonal
    for i in 0..n {
        for j in 0..n {
            if i != j {
                let factor = ((1.0 - gammas[i]) * (1.0 - gammas[j])).sqrt();
                out.set(i, j, rho.get(i, j).scale(factor));
            }
        }
    }
    out
}

/// Phase damping: off-diagonal decay
pub fn phase_damp(p: f64, rho: &Mat) -> Mat {
    let n = rho.rows;
    let mut out = Mat::new(n);
    for i in 0..n {
        for j in 0..n {
            out.set(i, j, if i == j { rho.get(i, j) } else { rho.get(i, j).scale(1.0 - p) });
        }
    }
    out
}

/// Bit flip: sector cyclic shift with probability p
pub fn bit_flip(p: f64, rho: &Mat) -> Mat {
    let n = rho.rows;
    let mut xrx = Mat::new(n);
    for i in 0..n { for j in 0..n {
        xrx.set(i, j, rho.get((i + n - 1) % n, (j + n - 1) % n));
    }}
    let mut out = Mat::new(n);
    for i in 0..n { for j in 0..n {
        out.set(i, j, rho.get(i, j).scale(1.0 - p) + xrx.get(i, j).scale(p));
    }}
    out
}

/// Phase flip: Z ρ Z† with probability p
pub fn phase_flip(p: f64, rho: &Mat) -> Mat {
    let n = rho.rows;
    let mut out = Mat::new(n);
    for i in 0..n {
        for j in 0..n {
            let omega = Cx::new(0.0, 2.0 * PI * (i as f64 - j as f64) / n as f64).exp();
            let zrz = omega * rho.get(i, j);
            out.set(i, j, rho.get(i, j).scale(1.0 - p) + zrz.scale(p));
        }
    }
    out
}

/// Thermal relaxation to Gibbs state at KMS β = 2π
pub fn thermal_relax(p: f64, rho: &Mat) -> Mat {
    let beta = 2.0 * PI;
    let boltz: Vec<f64> = (0..CHI).map(|k| DIMS[k.min(3)] as f64 * LAMBDAS[k.min(3)].powf(beta)).collect();
    let z: f64 = boltz.iter().sum();
    let n = rho.rows.min(CHI);
    let mut out = Mat::new(n);
    for i in 0..n {
        for j in 0..n {
            let orig = rho.get(i, j).scale(1.0 - p);
            let therm = if i == j { Cx::from_real(p * boltz[i] / z) } else { Cx::ZERO };
            out.set(i, j, orig + therm);
        }
    }
    out
}

/// Lindblad step: dρ/dt = -i[H,ρ] + γ(LρL† - ½{L†L,ρ})
pub fn lindblad_step(dt: f64, gamma: f64, rho: &Mat) -> Mat {
    let n = rho.rows.min(CHI);
    let en = energies();
    let h = Mat::from_diag(&(0..n).map(|k| Cx::from_real(en[k.min(3)])).collect::<Vec<_>>());
    let hr = h.mul_mat(rho);
    let rh = rho.mul_mat(&h);
    let mut out = rho.clone();
    for i in 0..n {
        for j in 0..n {
            let comm = Cx::new(0.0, -1.0) * (hr.get(i, j) - rh.get(i, j));
            // Lindblad: â₀ = |0⟩⟨1|
            let lrl = if i == 0 && j == 0 { rho.get(1, 1).scale(gamma) } else { Cx::ZERO };
            let anti = if (i == 1 && j < n) || (j == 1 && i < n) {
                rho.get(i, j).scale(-0.5 * gamma)
            } else { Cx::ZERO };
            out.set(i, j, out.get(i, j) + (comm + lrl + anti).scale(dt));
        }
    }
    out
}

/// Channel fidelity: |Tr(ρσ)|²
pub fn channel_fidelity(rho: &Mat, sigma: &Mat) -> f64 {
    rho.mul_mat(sigma).trace().norm2()
}

/// Process matrix dimension: χ⁴ = 1296
pub fn process_matrix_dim() -> usize { CHI * CHI * CHI * CHI }
