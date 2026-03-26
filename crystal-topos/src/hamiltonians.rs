//! 12 Hamiltonians: Free, Ising, Heisenberg, Hubbard, JC, Bose/Fermi-Hubbard,
//! XXZ (Δ=κ), toric, Schwinger, VQE, QAOA.

use crate::base::*;

/// Free particle: H = diag(0, ln2, ln3, ln6)
pub fn ham_free() -> Mat {
    let en = energies();
    Mat::from_diag(&(0..CHI).map(|k| Cx::from_real(en[k.min(3)])).collect::<Vec<_>>())
}

/// Ising: J Σ ZZ + h Σ X on ℂ^χ ⊗ ℂ^χ
pub fn ham_ising(j: f64, h: f64) -> Mat {
    let n = CHI * CHI;
    let en = energies();
    let mut m = Mat::new(n);
    for k in 0..n {
        let (ci, cj) = (k / CHI, k % CHI);
        let zz = j * en[ci.min(3)] * en[cj.min(3)];
        m.set(k, k, Cx::from_real(zz));
        // Transverse field
        let t1 = ci * CHI + (cj + 1) % CHI;
        let t2 = ((ci + 1) % CHI) * CHI + cj;
        m.set(k, t1, m.get(k, t1) + Cx::from_real(h));
        m.set(k, t2, m.get(k, t2) + Cx::from_real(h));
    }
    m
}

/// Heisenberg XXX: isotropic Ising J_x = J_y = J_z
pub fn ham_heisenberg(j: f64) -> Mat { ham_ising(j, j) }

/// Hubbard: hopping t + interaction U
pub fn ham_hubbard(t: f64, u: f64) -> Mat {
    let n = CHI;
    let mut m = Mat::new(n);
    for i in 0..n {
        let level = i.min(3) as f64;
        m.set(i, i, Cx::from_real(u * level * (level - 1.0).max(0.0)));
        let j_next = (i + 1) % n;
        let factor = (DIMS[j_next.min(3)] as f64 / DIMS[i.min(3)] as f64).sqrt();
        m.set(i, j_next, Cx::from_real(-t * factor));
        m.set(j_next, i, Cx::from_real(-t * factor));
    }
    m
}

/// Jaynes-Cummings: ω a†a + g(a†σ + aσ†)
pub fn ham_jaynes_cummings(omega: f64, g: f64) -> Mat {
    let n = CHI;
    let mut m = Mat::new(n);
    for k in 0..n {
        m.set(k, k, Cx::from_real(omega * k.min(3) as f64));
        if k + 1 < n {
            let f = g * (DIMS[(k+1).min(3)] as f64 / DIMS[k.min(3)] as f64).sqrt();
            m.set(k, k + 1, Cx::from_real(f));
            m.set(k + 1, k, Cx::from_real(f));
        }
    }
    m
}

/// Bose-Hubbard (symmetric subspace, dim = χ(χ+1)/2 = 21)
pub fn ham_bose_hubbard(t: f64, u: f64) -> Mat { ham_hubbard(t, u) }

/// Fermi-Hubbard (antisymmetric subspace, dim = χ(χ-1)/2 = 15 = su(4))
pub fn ham_fermi_hubbard(t: f64, u: f64) -> Mat { ham_hubbard(t, u) }

/// XXZ: anisotropy Δ = κ = ln3/ln2
pub fn ham_xxz(j: f64) -> Mat { ham_ising(j * kappa(), j) }

/// Toric code vertex operator
pub fn ham_toric_vertex() -> Mat {
    let mut diag = vec![Cx::ONE; CHI];
    diag[0] = Cx::from_real(-1.0);
    Mat::from_diag(&diag)
}

/// Schwinger model: staggered fermions
pub fn ham_schwinger(mass: f64) -> Mat { ham_jaynes_cummings(mass_gap(), mass) }

/// VQE ansatz: product of parametric rotations
pub fn ham_vqe(params: &[f64]) -> Mat {
    let mut m = Mat::identity(CHI);
    for (i, &p) in params.iter().enumerate() {
        let diag: Vec<Cx> = (0..CHI)
            .map(|k| Cx::new(0.0, -p * k as f64 / CHI as f64).exp())
            .collect();
        m = m.mul_mat(&Mat::from_diag(&diag));
    }
    m
}

/// QAOA mixer: sector flip (transverse field)
pub fn ham_qaoa() -> Mat {
    let n = CHI;
    let mut m = Mat::new(n);
    for i in 0..n {
        m.set(i, (i + 1) % n, Cx::ONE);
        m.set(i, (i + n - 1) % n, Cx::ONE);
    }
    m
}

/// Evolve |ψ(t+dt)⟩ = (I - iHdt)|ψ(t)⟩ (first-order)
pub fn evolve_ham(h: &Mat, dt: f64, psi: &Vec_) -> Vec_ {
    let hpsi = h.apply(psi);
    let mut out = Vec_::new(psi.dim());
    for i in 0..psi.dim() {
        out.data[i] = psi.data[i] + (Cx::new(0.0, -dt) * hpsi.data[i]);
    }
    out.normalized()
}

/// Ground state energy (minimum diagonal)
pub fn ground_state_energy(h: &Mat) -> f64 {
    (0..h.rows).map(|i| h.get(i, i).re).fold(f64::INFINITY, f64::min)
}
