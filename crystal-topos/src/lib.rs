//! # Crystal Topos
//!
//! 136 physical constants from two primes. Zero free parameters.
//! Quantum simulation library derived entirely from N_w=2, N_c=3.
//!
//! ```
//! use crystal_topos::*;
//!
//! // Everything from 2 and 3
//! let psi = entangle::max_entangled();
//! let s = entangle::von_neumann_entropy(&entangle::partial_trace(&psi));
//! assert!((s - base::max_entropy()).abs() < 1e-10);  // ln(6) = arrow of time
//! ```

pub mod base;
pub mod gates;
pub mod channels;
pub mod hamiltonians;
pub mod measure;
pub mod entangle;
pub mod algorithms;
pub mod simulation;

// ═══════════════════════════════════════════════════════════════
// PyO3 Python bindings (enabled with --features python)
// ═══════════════════════════════════════════════════════════════

#[cfg(feature = "python")]
mod python_bindings {
    use pyo3::prelude::*;
    use crate::base::*;
    use crate::entangle;
    use crate::gates;
    use crate::measure;
    use crate::algorithms;

    /// Crystal quantum state: wraps Vec_ for Python
    #[pyclass]
    #[derive(Clone)]
    struct QuantumState {
        inner: Vec_,
    }

    #[pymethods]
    impl QuantumState {
        /// Create |singlet⟩ (ground state)
        #[staticmethod]
        fn singlet() -> Self { QuantumState { inner: Vec_::basis(CHI, 0) } }

        /// Create |weak⟩
        #[staticmethod]
        fn weak() -> Self { QuantumState { inner: Vec_::basis(CHI, 1) } }

        /// Create |colour⟩
        #[staticmethod]
        fn colour() -> Self { QuantumState { inner: Vec_::basis(CHI, 2) } }

        /// Create |mixed⟩
        #[staticmethod]
        fn mixed() -> Self { QuantumState { inner: Vec_::basis(CHI, 3) } }

        /// Equal superposition of all sectors
        #[staticmethod]
        fn superposition() -> Self { QuantumState { inner: Vec_::equal(CHI) } }

        /// Maximally entangled 2-particle state: (1/√6)Σ|k,k⟩
        #[staticmethod]
        fn max_entangled() -> Self { QuantumState { inner: entangle::max_entangled() } }

        /// Bell state: (|a,b⟩ + |b,a⟩)/√2
        #[staticmethod]
        fn bell(a: usize, b: usize) -> Self { QuantumState { inner: entangle::bell_state(a, b) } }

        /// Dimension of the Hilbert space
        fn dim(&self) -> usize { self.inner.dim() }

        /// Probability of measuring sector k
        fn prob(&self, k: usize) -> f64 { self.inner.prob(k) }

        /// All probabilities
        fn probs(&self) -> Vec<f64> { measure::born_probs(&self.inner) }

        /// Sector probabilities (4 values)
        fn sector_probs(&self) -> Vec<f64> { measure::sector_probs(&self.inner) }

        /// Von Neumann entropy
        fn entropy(&self) -> f64 { self.inner.entropy() }

        /// Apply crystal Hadamard
        fn hadamard(&self) -> Self {
            QuantumState { inner: gates::gate_h().apply(&self.inner).into() }
        }

        /// Apply creation operator
        fn create(&self) -> Self {
            let mut out = Vec_::new(CHI);
            for k in 0..3 {
                let f = (DIMS[k + 1] as f64 / DIMS[k] as f64).sqrt();
                out.data[k + 1] = out.data[k + 1] + self.inner.data[k].scale(f);
            }
            out.normalize();
            QuantumState { inner: out }
        }

        /// Apply annihilation operator
        fn annihilate(&self) -> Self {
            let mut out = Vec_::new(CHI);
            for k in 1..4.min(CHI) {
                let f = (DIMS[k - 1] as f64 / DIMS[k] as f64).sqrt();
                out.data[k - 1] = out.data[k - 1] + self.inner.data[k].scale(f);
            }
            out.normalize();
            QuantumState { inner: out }
        }

        /// Time evolution under crystal Hamiltonian
        fn evolve(&self, dt: f64) -> Self {
            let en = energies();
            let mut out = self.inner.clone();
            for k in 0..out.dim() {
                let phase = Cx::new(0.0, -en[k.min(3)] * dt).exp();
                out.data[k] = phase * out.data[k];
            }
            QuantumState { inner: out }
        }

        /// Entanglement entropy (for 2-particle states)
        fn entanglement_entropy(&self) -> f64 {
            entangle::ent_formation(&self.inner)
        }

        /// Concurrence
        fn concurrence(&self) -> f64 { entangle::concurrence(&self.inner) }

        /// PPT test: True = separable, False = entangled
        fn ppt_test(&self) -> bool { entangle::ppt_test(&self.inner) }

        /// Grover search for target sector
        fn grover(&self, target: usize) -> Self {
            QuantumState { inner: algorithms::grover_search(target, &self.inner) }
        }

        /// QFT
        fn qft(&self) -> Self {
            QuantumState { inner: algorithms::qft(&self.inner) }
        }

        fn __repr__(&self) -> String {
            format!("QuantumState(dim={}, entropy={:.4})", self.dim(), self.entropy())
        }
    }

    /// Crystal constants
    #[pyfunction] fn n_w() -> usize { NW }
    #[pyfunction] fn n_c() -> usize { NC }
    #[pyfunction] fn chi() -> usize { CHI }
    #[pyfunction] fn beta0() -> usize { BETA0 }
    #[pyfunction] fn sigma_d() -> usize { SIGMA_D }
    #[pyfunction] fn sigma_d2() -> usize { SIGMA_D2 }
    #[pyfunction] fn gauss() -> usize { GAUSS }
    #[pyfunction] fn d_total() -> usize { D_TOTAL }
    #[pyfunction] fn crystal_kappa() -> f64 { kappa() }
    #[pyfunction] fn crystal_max_entropy() -> f64 { max_entropy() }
    #[pyfunction] fn crystal_energies() -> Vec<f64> { energies().to_vec() }

    #[pymodule]
    fn crystal_topos(m: &Bound<'_, PyModule>) -> PyResult<()> {
        m.add_class::<QuantumState>()?;
        m.add_function(wrap_pyfunction!(n_w, m)?)?;
        m.add_function(wrap_pyfunction!(n_c, m)?)?;
        m.add_function(wrap_pyfunction!(chi, m)?)?;
        m.add_function(wrap_pyfunction!(beta0, m)?)?;
        m.add_function(wrap_pyfunction!(sigma_d, m)?)?;
        m.add_function(wrap_pyfunction!(sigma_d2, m)?)?;
        m.add_function(wrap_pyfunction!(gauss, m)?)?;
        m.add_function(wrap_pyfunction!(d_total, m)?)?;
        m.add_function(wrap_pyfunction!(crystal_kappa, m)?)?;
        m.add_function(wrap_pyfunction!(crystal_max_entropy, m)?)?;
        m.add_function(wrap_pyfunction!(crystal_energies, m)?)?;
        Ok(())
    }
}
