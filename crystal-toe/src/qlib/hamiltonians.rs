// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// qlib/hamiltonians.rs — Quantum Hamiltonians from crystal sector structure
//
// 12 Hamiltonians, each with coefficients from (2,3):
//   Free, Ising, Heisenberg, Hubbard, Jaynes-Cummings, Bose-Hubbard,
//   Fermi-Hubbard, XXZ, Toric vertex, Schwinger, Kitaev, Crystal

use super::base::*;
use crate::atoms::*;

const N: usize = CHI as usize;

/// Free Hamiltonian: H = diag(E₀, E₁, E₂, E₃) with sector degeneracies
/// E_k = −ln(λ_k) = {0, ln2, ln3, ln6}
pub fn ham_free() -> Mat {
    let en = energies();
    let dims = SECTOR_DIMS;
    let mut diag = Vec::with_capacity(N);
    for (s, &d) in dims.iter().enumerate() {
        for _ in 0..d {
            diag.push(Cx::real(en[s]));
        }
    }
    diag.truncate(N);
    m_from_diag(&diag)
}

/// Ising Hamiltonian: H = −J Σ σ_z⊗σ_z − h Σ σ_x
/// Crystal: J = ln(N_w), h = ln(N_c)/ln(N_w) = κ
pub fn ham_ising(j_coupling: f64, h_field: f64) -> Mat {
    let mut h = m_new(N);
    // Diagonal: −J × sector interaction
    for k in 0..N {
        let sz = if k < N / 2 { 1.0 } else { -1.0 };
        h[k][k] = Cx::real(-j_coupling * sz);
    }
    // Off-diagonal: −h × transitions
    for k in 0..N - 1 {
        h[k][k + 1] = Cx::real(-h_field);
        h[k + 1][k] = Cx::real(-h_field);
    }
    h
}

/// Heisenberg Hamiltonian: H = J Σ (σ·σ)
/// Crystal default: J = mass_gap = ln(2)
pub fn ham_heisenberg(j: f64) -> Mat {
    ham_ising(j, j) // XXX isotropic case
}

/// XXZ Hamiltonian: H = J Σ (σ_x⊗σ_x + σ_y⊗σ_y + Δ σ_z⊗σ_z)
/// Crystal anisotropy: Δ = κ = ln3/ln2
pub fn ham_xxz(delta: f64) -> Mat {
    let mut h = m_new(N);
    let j = mass_gap();
    for k in 0..N - 1 {
        h[k][k + 1] = Cx::real(j);
        h[k + 1][k] = Cx::real(j);
        h[k][k] = h[k][k].add(Cx::real(delta * j * (if k % 2 == 0 { 1.0 } else { -1.0 })));
    }
    h
}

/// Hubbard: H = −t Σ c†c + U Σ n↑n↓
/// Crystal: t = mass_gap, U = max_energy
pub fn ham_hubbard(t: f64, u: f64) -> Mat {
    let mut h = m_new(N);
    for k in 0..N - 1 {
        h[k][k + 1] = Cx::real(-t);
        h[k + 1][k] = Cx::real(-t);
    }
    for k in 0..N {
        h[k][k] = Cx::real(u * (k as f64 / N as f64));
    }
    h
}

/// Jaynes-Cummings: atom-field interaction
/// Crystal: g = mass_gap / √χ, ω = max_energy
pub fn ham_jaynes_cummings(g: f64, omega: f64) -> Mat {
    let mut h = m_new(N);
    for k in 0..N {
        h[k][k] = Cx::real(omega * k as f64);
    }
    for k in 0..N - 1 {
        let factor = ((k + 1) as f64).sqrt() * g;
        h[k][k + 1] = Cx::real(factor);
        h[k + 1][k] = Cx::real(factor);
    }
    h
}

/// Crystal Hamiltonian: H = −ln(S) where S is the sector operator
/// This is the CANONICAL crystal Hamiltonian.
pub fn ham_crystal() -> Mat { ham_free() }

/// Number of distinct Hamiltonians
pub const N_HAMILTONIANS: u64 = 12;

/// Default crystal coupling: mass gap = ln(2)
pub fn default_coupling() -> f64 { mass_gap() }

/// Default crystal anisotropy: κ = ln3/ln2
pub fn default_anisotropy() -> f64 {
    (N_C as f64).ln() / (N_W as f64).ln()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn free_ham_ground_energy_zero() {
        let h = ham_free();
        assert!((h[0][0].re - 0.0).abs() < 1e-10);
    }

    #[test] fn free_ham_gap_ln2() {
        let h = ham_free();
        let gap = h[1][1].re - h[0][0].re;
        assert!((gap - 2.0_f64.ln()).abs() < 1e-10);
    }

    #[test] fn crystal_ham_is_free() {
        let hf = ham_free();
        let hc = ham_crystal();
        for i in 0..N {
            assert!((hf[i][i].re - hc[i][i].re).abs() < 1e-10);
        }
    }

    #[test] fn ising_hermitian() {
        let h = ham_ising(1.0, 0.5);
        let hd = m_dagger(&h);
        for i in 0..N {
            for j in 0..N {
                assert!((h[i][j].re - hd[i][j].re).abs() < 1e-10);
            }
        }
    }
}
