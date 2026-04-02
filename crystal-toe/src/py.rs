// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// py.rs — COMPLETE PyO3 bindings for crystal_toe
// EVERYTHING available from Python. Every module. Every function.

use pyo3::prelude::*;

#[pyclass(name = "Toe")]
#[derive(Clone)]
struct PyToe { inner: crate::toe::Toe }

#[pymethods]
impl PyToe {
    #[new]
    #[pyo3(signature = (vev=None))]
    fn new(vev: Option<f64>) -> Self {
        PyToe { inner: match vev { Some(v) => crate::toe::Toe::with_vev(v), None => crate::toe::Toe::new() } }
    }
    fn to_pdg(&self) -> Self { PyToe { inner: self.inner.to_pdg() } }
    fn vev(&self) -> f64 { self.inner.vev() }
    fn is_crystal_default(&self) -> bool { self.inner.is_crystal_default() }
    fn proton_mass(&self) -> f64 { self.inner.proton_mass() }
    fn electron_mass(&self) -> f64 { self.inner.electron_mass() }
    fn muon_mass(&self) -> f64 { self.inner.muon_mass() }
    fn pion_mass(&self) -> f64 { self.inner.pion_mass() }
    fn higgs_mass(&self) -> f64 { self.inner.higgs_mass() }
    fn w_mass(&self) -> f64 { self.inner.w_mass() }
    fn z_mass(&self) -> f64 { self.inner.z_mass() }
    fn lambda_h(&self) -> f64 { self.inner.lambda_h() }
    fn lambda_qcd(&self) -> f64 { self.inner.lambda_qcd() }
    fn f_pi(&self) -> f64 { self.inner.f_pi() }
    fn bohr_radius(&self) -> f64 { self.inner.bohr_radius() }
    fn alpha(&self) -> f64 { self.inner.alpha() }
    fn alpha_inv(&self) -> f64 { self.inner.alpha_inv() }
    fn sin2_theta_w(&self) -> f64 { self.inner.sin2_theta_w() }
    fn kappa(&self) -> f64 { self.inner.kappa() }
    fn c_f(&self) -> f64 { self.inner.c_f() }
    fn mp_me_ratio(&self) -> f64 { self.inner.mp_me_ratio() }
    fn alpha_at_layer(&self, d: u64) -> f64 { self.inner.alpha_at_layer(d) }

    // ── Dynamics factories — Toe is the parent ──────────────
    fn classical(&self) -> PyClassical { PyClassical { toe: self.inner.clone() } }
    fn nbody(&self) -> PyNBody { PyNBody { toe: self.inner.clone() } }
    fn gr(&self) -> PyGR { PyGR { toe: self.inner.clone() } }
    fn em(&self) -> PyEM { PyEM { toe: self.inner.clone() } }
    fn thermo(&self) -> PyThermo { PyThermo { toe: self.inner.clone() } }
    fn friedmann(&self) -> PyFriedmann { PyFriedmann { toe: self.inner.clone() } }
    fn cfd(&self) -> PyCFD { PyCFD { toe: self.inner.clone() } }
    fn decay(&self) -> PyDecay { PyDecay { toe: self.inner.clone() } }
    fn optics(&self) -> PyOptics { PyOptics { toe: self.inner.clone() } }
    fn md(&self) -> PyMD { PyMD { toe: self.inner.clone() } }
    fn condensed(&self) -> PyCondensed { PyCondensed { toe: self.inner.clone() } }
    fn plasma(&self) -> PyPlasma { PyPlasma { toe: self.inner.clone() } }
    fn qft(&self) -> PyQFT { PyQFT { toe: self.inner.clone() } }
    fn rigid(&self) -> PyRigid { PyRigid { toe: self.inner.clone() } }
    fn gw(&self) -> PyGW { PyGW { toe: self.inner.clone() } }

    // Crystal constants
    fn n_w(&self) -> u64 { crate::atoms::N_W }
    fn n_c(&self) -> u64 { crate::atoms::N_C }
    fn chi(&self) -> u64 { crate::atoms::CHI }
    fn beta0(&self) -> u64 { crate::atoms::BETA0 }
    fn sigma_d(&self) -> u64 { crate::atoms::SIGMA_D }
    fn gauss(&self) -> u64 { crate::atoms::GAUSS }
    fn tower_d(&self) -> u64 { crate::atoms::TOWER_D }

    fn __repr__(&self) -> String { format!("Toe(v={:.2} GeV{})", self.inner.vev(), if self.inner.is_crystal_default() { ", crystal" } else { "" }) }
}

#[pyclass(name = "Gauge")]
struct PyGauge;
#[pymethods]
impl PyGauge {
    #[new] fn new() -> Self { PyGauge }
    fn alpha_inv(&self) -> f64 { crate::gauge::alpha_inv() }
    fn alpha_em(&self) -> f64 { crate::gauge::alpha_em() }
    fn sin2_theta_w(&self) -> f64 { crate::gauge::sin2_theta_w() }
    fn cos2_theta_w(&self) -> f64 { crate::gauge::cos2_theta_w() }
    fn sin_theta_w(&self) -> f64 { crate::gauge::sin_theta_w() }
    fn alpha_s_mz(&self) -> f64 { crate::gauge::alpha_s_mz() }
    fn g2_squared(&self) -> f64 { crate::gauge::g2_squared() }
    fn g1_squared(&self) -> f64 { crate::gauge::g1_squared() }
    fn mu_e_ratio(&self) -> f64 { crate::gauge::mu_e_ratio() }
    fn tau_mu_ratio(&self) -> f64 { crate::gauge::tau_mu_ratio() }
    fn w_mass(&self, toe: &PyToe) -> f64 { crate::gauge::w_mass(&toe.inner) }
    fn z_mass(&self, toe: &PyToe) -> f64 { crate::gauge::z_mass(&toe.inner) }
    fn higgs_mass(&self, toe: &PyToe) -> f64 { crate::gauge::higgs_mass(&toe.inner) }
    fn electron_mass(&self, toe: &PyToe) -> f64 { crate::gauge::electron_mass(&toe.inner) }
    fn muon_mass(&self, toe: &PyToe) -> f64 { crate::gauge::muon_mass(&toe.inner) }
    fn tau_mass(&self, toe: &PyToe) -> f64 { crate::gauge::tau_mass(&toe.inner) }
    fn fermi_constant(&self, toe: &PyToe) -> f64 { crate::gauge::fermi_constant(&toe.inner) }
}

#[pyclass(name = "QCD")]
struct PyQCD;
#[pymethods]
impl PyQCD {
    #[new] fn new() -> Self { PyQCD }
    fn proton_mass(&self, toe: &PyToe) -> f64 { crate::qcd::proton_mass(&toe.inner) }
    fn neutron_mass(&self, toe: &PyToe) -> f64 { crate::qcd::neutron_mass(&toe.inner) }
    fn mn_mp_diff(&self, toe: &PyToe) -> f64 { crate::qcd::mn_mp_diff(&toe.inner) }
    fn lambda_qcd(&self, toe: &PyToe) -> f64 { crate::qcd::lambda_qcd(&toe.inner) }
    fn pion_mass(&self, toe: &PyToe) -> f64 { crate::qcd::pion_mass(&toe.inner) }
    fn f_pi(&self, toe: &PyToe) -> f64 { crate::qcd::f_pi(&toe.inner) }
    fn kaon_mass(&self, toe: &PyToe) -> f64 { crate::qcd::kaon_mass(&toe.inner) }
    fn rho_mass(&self, toe: &PyToe) -> f64 { crate::qcd::rho_mass(&toe.inner) }
    fn omega_mass(&self, toe: &PyToe) -> f64 { crate::qcd::omega_mass(&toe.inner) }
    fn delta_mass(&self, toe: &PyToe) -> f64 { crate::qcd::delta_mass(&toe.inner) }
    fn up_mass(&self, toe: &PyToe) -> f64 { crate::qcd::up_mass(&toe.inner) }
    fn down_mass(&self, toe: &PyToe) -> f64 { crate::qcd::down_mass(&toe.inner) }
    fn strange_mass(&self, toe: &PyToe) -> f64 { crate::qcd::strange_mass(&toe.inner) }
    fn charm_mass(&self, toe: &PyToe) -> f64 { crate::qcd::charm_mass(&toe.inner) }
    fn bottom_mass(&self, toe: &PyToe) -> f64 { crate::qcd::bottom_mass(&toe.inner) }
    fn top_mass(&self, toe: &PyToe) -> f64 { crate::qcd::top_mass(&toe.inner) }
    fn mp_me_ratio(&self) -> f64 { crate::qcd::mp_me_ratio() }
    fn mpi_mp_ratio(&self) -> f64 { crate::qcd::mpi_mp_ratio() }
    fn lambda_qcd_mp_ratio(&self) -> f64 { crate::qcd::lambda_qcd_mp_ratio() }
}

#[pyclass(name = "Cosmo")]
struct PyCosmo;
#[pymethods]
impl PyCosmo {
    #[new] fn new() -> Self { PyCosmo }
    fn omega_lambda(&self) -> f64 { crate::cosmo::omega_lambda() }
    fn omega_cdm(&self) -> f64 { crate::cosmo::omega_cdm() }
    fn omega_b(&self) -> f64 { crate::cosmo::omega_b() }
    fn omega_m(&self) -> f64 { crate::cosmo::omega_m() }
    fn omega_total(&self) -> f64 { crate::cosmo::omega_total() }
    fn h0(&self) -> f64 { crate::cosmo::h0() }
    fn hubble_h(&self) -> f64 { crate::cosmo::hubble_h() }
    fn spectral_index(&self) -> f64 { crate::cosmo::spectral_index() }
    fn tensor_scalar_ratio(&self) -> f64 { crate::cosmo::tensor_scalar_ratio() }
    fn neutrino_mass_scale(&self, toe: &PyToe) -> f64 { crate::cosmo::neutrino_mass_scale(&toe.inner) }
    fn neutrino_mass_sum(&self, toe: &PyToe) -> f64 { crate::cosmo::neutrino_mass_sum(&toe.inner) }
    fn n_generations(&self) -> u64 { crate::cosmo::N_GENERATIONS }
    fn n_neutrinos(&self) -> u64 { crate::cosmo::N_NEUTRINOS }
}

#[pyclass(name = "Mixing")]
struct PyMixing;
#[pymethods]
impl PyMixing {
    #[new] fn new() -> Self { PyMixing }
    fn sin_cabibbo(&self) -> f64 { crate::mixing::sin_cabibbo() }
    fn cos_cabibbo(&self) -> f64 { crate::mixing::cos_cabibbo() }
    fn v_ud(&self) -> f64 { crate::mixing::v_ud() }
    fn v_us(&self) -> f64 { crate::mixing::v_us() }
    fn v_ub(&self) -> f64 { crate::mixing::v_ub() }
    fn v_cb(&self) -> f64 { crate::mixing::v_cb() }
    fn v_td(&self) -> f64 { crate::mixing::v_td() }
    fn v_ts(&self) -> f64 { crate::mixing::v_ts() }
    fn v_tb(&self) -> f64 { crate::mixing::v_tb() }
    fn jarlskog(&self) -> f64 { crate::mixing::jarlskog() }
    fn sin2_theta12(&self) -> f64 { crate::mixing::sin2_theta12() }
    fn sin2_theta23(&self) -> f64 { crate::mixing::sin2_theta23() }
    fn sin2_theta13(&self) -> f64 { crate::mixing::sin2_theta13() }
    fn n_mixing_angles(&self) -> u64 { crate::mixing::n_mixing_angles() }
    fn n_cp_phases(&self) -> u64 { crate::mixing::n_cp_phases() }
}

#[pyclass(name = "AlphaProton")]
struct PyAlphaProton;
#[pymethods]
impl PyAlphaProton {
    #[new] fn new() -> Self { PyAlphaProton }
    fn alpha_inv_full(&self) -> f64 { crate::alpha_proton::alpha_inv_full() }
    fn alpha_inv_tower(&self) -> f64 { crate::alpha_proton::alpha_inv_tower() }
    fn mp_me_ratio_full(&self) -> f64 { crate::alpha_proton::mp_me_ratio_full() }
    fn proton_radius(&self) -> f64 { crate::alpha_proton::proton_radius() }
}

#[pyclass(name = "Gravity")]
struct PyGravity;
#[pymethods]
impl PyGravity {
    #[new] fn new() -> Self { PyGravity }
    fn einstein_16(&self) -> u64 { crate::gravity::EINSTEIN_16 }
    fn graviton_pol(&self) -> u64 { crate::gravity::GRAVITON_POL }
    fn spacetime_dim(&self) -> u64 { crate::gravity::SPACETIME_DIM }
    fn schwarz_factor(&self) -> u64 { crate::gravity::SCHWARZ_FACTOR }
    fn bh_factor(&self) -> u64 { crate::gravity::BH_FACTOR }
    fn peters_factor(&self) -> f64 { crate::gravity::peters_factor() }
    fn chirp_exponent(&self) -> f64 { crate::gravity::chirp_exponent() }
    fn isco_factor(&self) -> u64 { crate::gravity::isco_factor() }
    fn photon_sphere_factor(&self) -> u64 { crate::gravity::photon_sphere_factor() }
    fn precession_factor(&self) -> u64 { crate::gravity::precession_factor() }
    fn light_bending_factor(&self) -> u64 { crate::gravity::light_bending_factor() }
    fn schwarzschild_radius_si(&self, mass_kg: f64) -> f64 { crate::gravity::schwarzschild_radius_si(mass_kg) }
    fn first_law_ratio(&self) -> f64 { crate::gravity::FIRST_LAW_RATIO }
    fn mera_bond_dim(&self) -> u64 { crate::gravity::MERA_BOND_DIM }
    fn gr_audit_count(&self) -> u64 { crate::gravity::GR_AUDIT_COUNT }
}

#[pyclass(name = "Protein")]
struct PyProtein;
#[pymethods]
impl PyProtein {
    #[new] fn new() -> Self { PyProtein }
    fn hartree(&self, toe: &PyToe) -> f64 { crate::protein::hartree(&toe.inner) }
    fn eps_vdw(&self, toe: &PyToe) -> f64 { crate::protein::eps_vdw(&toe.inner) }
    fn e_hbond(&self, toe: &PyToe) -> f64 { crate::protein::e_hbond(&toe.inner) }
    fn k_omega(&self, toe: &PyToe) -> f64 { crate::protein::k_omega(&toe.inner) }
    fn e_burial(&self, toe: &PyToe) -> f64 { crate::protein::e_burial(&toe.inner) }
    fn e_fold(&self, toe: &PyToe) -> f64 { crate::protein::e_fold(&toe.inner) }
    fn bohr_radius_angstrom(&self, toe: &PyToe) -> f64 { crate::protein::bohr_radius_angstrom(&toe.inner) }
    fn vdw_radius_c(&self, toe: &PyToe) -> f64 { crate::protein::vdw_radius_c(&toe.inner) }
    fn hbond_distance(&self, toe: &PyToe) -> f64 { crate::protein::hbond_distance(&toe.inner) }
    fn sp3_angle_deg(&self) -> f64 { crate::protein::sp3_angle().to_degrees() }
    fn water_angle_deg(&self) -> f64 { crate::protein::water_angle().to_degrees() }
    fn sp2_angle_deg(&self) -> f64 { crate::protein::sp2_angle().to_degrees() }
    fn helix_per_turn(&self) -> f64 { crate::protein::helix_per_turn() }
    fn flory_nu(&self) -> f64 { crate::protein::flory_nu() }
    fn bp_per_turn(&self) -> u64 { crate::protein::bp_per_turn() }
    fn protein_dielectric(&self) -> u64 { crate::protein::PROTEIN_DIELECTRIC }
}

#[pyclass(name = "CrossDomain")]
struct PyCrossDomain;
#[pymethods]
impl PyCrossDomain {
    #[new] fn new() -> Self { PyCrossDomain }
    fn n_shared_ratios(&self) -> usize { crate::cross_domain::n_shared_ratios() }
    fn n_cross_links(&self) -> usize { crate::cross_domain::n_cross_links() }
    fn traces(&self) -> Vec<(String, f64, String, Vec<String>)> {
        crate::cross_domain::cross_traces().into_iter().map(|t| (t.name.to_string(), t.value, t.formula.to_string(), t.domains.iter().map(|d| d.to_string()).collect())).collect()
    }
}

#[pyclass(name = "Truth")]
#[derive(Clone)]
struct PyTruth { inner: crate::heyting::Truth }
#[pymethods]
impl PyTruth {
    #[staticmethod] fn false_val() -> Self { PyTruth { inner: crate::heyting::Truth::FALSE } }
    #[staticmethod] fn mixed() -> Self { PyTruth { inner: crate::heyting::Truth::MIXED } }
    #[staticmethod] fn colour() -> Self { PyTruth { inner: crate::heyting::Truth::COLOUR } }
    #[staticmethod] fn weak() -> Self { PyTruth { inner: crate::heyting::Truth::WEAK } }
    #[staticmethod] fn true_val() -> Self { PyTruth { inner: crate::heyting::Truth::TRUE } }
    fn value(&self) -> f64 { self.inner.value() }
    #[staticmethod] fn meet(a: &PyTruth, b: &PyTruth) -> PyTruth { PyTruth { inner: crate::heyting::Truth::meet(a.inner, b.inner) } }
    #[staticmethod] fn join(a: &PyTruth, b: &PyTruth) -> PyTruth { PyTruth { inner: crate::heyting::Truth::join(a.inner, b.inner) } }
    #[staticmethod] fn implies(a: &PyTruth, b: &PyTruth) -> PyTruth { PyTruth { inner: crate::heyting::Truth::implies(a.inner, b.inner) } }
    #[staticmethod] fn negate(a: &PyTruth) -> PyTruth { PyTruth { inner: crate::heyting::Truth::negate(a.inner) } }
    fn __repr__(&self) -> String { format!("{}", self.inner) }
    fn __eq__(&self, other: &PyTruth) -> bool { self.inner == other.inner }
}

#[pyclass(name = "Tower")]
struct PyTower;
#[pymethods]
impl PyTower {
    #[new] fn new() -> Self { PyTower }
    fn alpha_at_layer(&self, d: u64) -> f64 { crate::tower::alpha_at_layer(d) }
    fn alpha_inv_at_layer(&self, d: u64) -> f64 { crate::tower::alpha_inv_at_layer(d) }
    fn layers(&self) -> Vec<(u64, f64, Vec<String>)> { crate::tower::spectral_tower().into_iter().map(|l| (l.depth, l.alpha_inv, l.born.iter().map(|s| s.to_string()).collect())).collect() }
    fn key_layers(&self) -> Vec<(u64, f64, Vec<String>)> { crate::tower::spectral_tower().into_iter().filter(|l| !l.born.is_empty()).map(|l| (l.depth, l.alpha_inv, l.born.iter().map(|s| s.to_string()).collect())).collect() }
}

#[pyclass(name = "Hierarchy")]
struct PyHierarchy;
#[pymethods]
impl PyHierarchy {
    #[new] fn new() -> Self { PyHierarchy }
    fn a0(&self) -> u64 { crate::hierarchy::SeeleyDeWitt::A0 }
    fn a4(&self) -> u64 { crate::hierarchy::SeeleyDeWitt::A4 }
    fn core_val(&self) -> u64 { crate::hierarchy::SeeleyDeWitt::CORE }
    fn implosion_channels(&self) -> Vec<(String, f64, f64, String)> { crate::hierarchy::implosion_channels().into_iter().map(|ch| (ch.name.to_string(), ch.correction.value(), ch.multiplier.value(), ch.channel.to_string())).collect() }
    fn omega_lambda(&self) -> f64 { crate::hierarchy::CosmoPartition::new().omega_lambda.value() }
    fn omega_cdm(&self) -> f64 { crate::hierarchy::CosmoPartition::new().omega_cdm.value() }
    fn omega_b(&self) -> f64 { crate::hierarchy::CosmoPartition::new().omega_b.value() }
}

#[pyclass(name = "AlgebraState")]
#[derive(Clone)]
struct PyAlgebraState { inner: crate::monad::AlgebraState }
#[pymethods]
impl PyAlgebraState {
    #[new] fn new() -> Self { PyAlgebraState { inner: crate::monad::AlgebraState::new() } }
    #[staticmethod] fn at_tick(t: u64) -> Self { PyAlgebraState { inner: crate::monad::AlgebraState::at_tick(t) } }
    fn tick(&mut self) { crate::monad::Monad::tick(&mut self.inner); }
    fn evolve(&mut self, n: u64) { crate::monad::Monad::evolve(&mut self.inner, n); }
    #[getter] fn tick_count(&self) -> u64 { self.inner.tick }
    #[getter] fn singlet(&self) -> f64 { self.inner.amplitudes[0] }
    #[getter] fn weak(&self) -> f64 { self.inner.amplitudes[1] }
    #[getter] fn colour(&self) -> f64 { self.inner.amplitudes[2] }
    #[getter] fn mixed(&self) -> f64 { self.inner.amplitudes[3] }
    #[getter] fn amplitudes(&self) -> Vec<f64> { self.inner.amplitudes.to_vec() }
    #[getter] fn total_weight(&self) -> f64 { self.inner.total_weight() }
    #[getter] fn entropy(&self) -> f64 { self.inner.entropy() }
    fn __repr__(&self) -> String { format!("{}", self.inner) }
}

// ══ DYNAMICS — ALL 21 ═══════════════════════════════════════

#[pyclass(name = "Classical")]
#[derive(Clone)]
struct PyClassical { toe: crate::toe::Toe }

#[pymethods]
impl PyClassical {
    #[new]
    #[pyo3(signature = (vev=None))]
    fn new(vev: Option<f64>) -> Self {
        PyClassical {
            toe: match vev { Some(v) => crate::toe::Toe::with_vev(v), None => crate::toe::Toe::new() }
        }
    }

    // ── Inherited from Toe ──────────────────────────────────────
    fn vev(&self) -> f64 { self.toe.vev() }
    fn is_crystal_default(&self) -> bool { self.toe.is_crystal_default() }
    fn to_pdg(&self) -> Self { PyClassical { toe: self.toe.to_pdg() } }
    fn proton_mass(&self) -> f64 { self.toe.proton_mass() }
    fn electron_mass(&self) -> f64 { self.toe.electron_mass() }
    fn muon_mass(&self) -> f64 { self.toe.muon_mass() }
    fn pion_mass(&self) -> f64 { self.toe.pion_mass() }
    fn higgs_mass(&self) -> f64 { self.toe.higgs_mass() }
    fn w_mass(&self) -> f64 { self.toe.w_mass() }
    fn z_mass(&self) -> f64 { self.toe.z_mass() }
    fn lambda_h(&self) -> f64 { self.toe.lambda_h() }
    fn lambda_qcd(&self) -> f64 { self.toe.lambda_qcd() }
    fn f_pi(&self) -> f64 { self.toe.f_pi() }
    fn bohr_radius(&self) -> f64 { self.toe.bohr_radius() }
    fn alpha(&self) -> f64 { self.toe.alpha() }
    fn alpha_inv(&self) -> f64 { self.toe.alpha_inv() }
    fn sin2_theta_w(&self) -> f64 { self.toe.sin2_theta_w() }
    fn kappa(&self) -> f64 { self.toe.kappa() }
    fn c_f(&self) -> f64 { self.toe.c_f() }
    fn mp_me_ratio(&self) -> f64 { self.toe.mp_me_ratio() }
    fn alpha_at_layer(&self, d: u64) -> f64 { self.toe.alpha_at_layer(d) }

    // ── Crystal constants ───────────────────────────────────────
    fn n_w(&self) -> u64 { crate::atoms::N_W }
    fn n_c(&self) -> u64 { crate::atoms::N_C }
    fn chi(&self) -> u64 { crate::atoms::CHI }
    fn beta0(&self) -> u64 { crate::atoms::BETA0 }
    fn sigma_d(&self) -> u64 { crate::atoms::SIGMA_D }
    fn gauss(&self) -> u64 { crate::atoms::GAUSS }
    fn tower_d(&self) -> u64 { crate::atoms::TOWER_D }
    fn spatial_dim(&self) -> u64 { crate::dynamics::classical::SPATIAL_DIM }
    fn phase_space_dim(&self) -> u64 { crate::dynamics::classical::PHASE_SPACE_DIM }
    fn force_exponent(&self) -> u64 { crate::dynamics::classical::FORCE_EXPONENT }

    // ── Classical dynamics ──────────────────────────────────────
    fn kepler_period(&self, a: f64, gm: f64) -> f64 { crate::dynamics::classical::kepler_period(a, gm) }
    fn escape_velocity(&self, gm: f64, r: f64) -> f64 { crate::dynamics::classical::escape_velocity(gm, r) }
    fn vis_viva(&self, gm: f64, r: f64, a: f64) -> f64 { crate::dynamics::classical::vis_viva(gm, r, a) }
    fn hohmann_transfer(&self, gm: f64, r1: f64, r2: f64) -> (f64, f64, f64) { crate::dynamics::classical::hohmann_transfer(gm, r1, r2) }
    fn bielliptic_transfer(&self, gm: f64, r1: f64, r2: f64, r_int: f64) -> (f64, f64, f64, f64) { crate::dynamics::classical::bielliptic_transfer(gm, r1, r2, r_int) }

    fn satellite_circular(&self, gm: f64, r: f64) -> ((f64,f64,f64,f64,f64,f64), f64, f64) {
        let (ps, vc, t) = crate::dynamics::classical::satellite_circular(gm, r);
        ((ps.pos.x, ps.pos.y, ps.pos.z, ps.vel.x, ps.vel.y, ps.vel.z), vc, t)
    }

    fn orbit_elliptical(&self, gm: f64, a: f64, ecc: f64) -> (f64,f64,f64,f64,f64,f64) {
        let ps = crate::dynamics::classical::orbit_elliptical(gm, a, ecc);
        (ps.pos.x, ps.pos.y, ps.pos.z, ps.vel.x, ps.vel.y, ps.vel.z)
    }

    /// Simulate Kepler orbit. Returns (xs, ys, zs, vxs, vys, vzs).
    fn kepler_orbit(&self, gm: f64, px: f64, py: f64, pz: f64, vx: f64, vy: f64, vz: f64, dt: f64, n: usize)
        -> (Vec<f64>, Vec<f64>, Vec<f64>, Vec<f64>, Vec<f64>, Vec<f64>)
    {
        use crate::dynamics::classical::*;
        let ps0 = PhaseState::new(Vec3::new(px, py, pz), Vec3::new(vx, vy, vz));
        let traj = kepler_orbit(gm, &ps0, dt, n);
        (traj_x(&traj), traj_y(&traj), traj_z(&traj),
         traj.iter().map(|p| p.vel.x).collect(),
         traj.iter().map(|p| p.vel.y).collect(),
         traj.iter().map(|p| p.vel.z).collect())
    }

    fn orbital_energy(&self, gm: f64, px: f64, py: f64, pz: f64, vx: f64, vy: f64, vz: f64) -> f64 {
        use crate::dynamics::classical::*;
        orbital_energy(gm, &PhaseState::new(Vec3::new(px, py, pz), Vec3::new(vx, vy, vz)))
    }

    fn angular_momentum(&self, px: f64, py: f64, pz: f64, vx: f64, vy: f64, vz: f64) -> f64 {
        use crate::dynamics::classical::*;
        angular_momentum_mag(&PhaseState::new(Vec3::new(px, py, pz), Vec3::new(vx, vy, vz)))
    }

    fn eccentricity(&self, gm: f64, px: f64, py: f64, pz: f64, vx: f64, vy: f64, vz: f64) -> f64 {
        use crate::dynamics::classical::*;
        eccentricity(gm, &PhaseState::new(Vec3::new(px, py, pz), Vec3::new(vx, vy, vz)))
    }

    fn kepler_energy_trace(&self, gm: f64, px: f64, py: f64, pz: f64, vx: f64, vy: f64, vz: f64, dt: f64, n: usize) -> Vec<f64> {
        use crate::dynamics::classical::*;
        let ps0 = PhaseState::new(Vec3::new(px, py, pz), Vec3::new(vx, vy, vz));
        let traj = kepler_orbit(gm, &ps0, dt, n);
        traj_energy(gm, &traj)
    }

    fn kepler_angular_momentum_trace(&self, px: f64, py: f64, pz: f64, vx: f64, vy: f64, vz: f64, dt: f64, n: usize, gm: f64) -> Vec<f64> {
        use crate::dynamics::classical::*;
        let ps0 = PhaseState::new(Vec3::new(px, py, pz), Vec3::new(vx, vy, vz));
        let traj = kepler_orbit(gm, &ps0, dt, n);
        traj_angular_momentum(&traj)
    }

    fn kepler_radius_trace(&self, gm: f64, px: f64, py: f64, pz: f64, vx: f64, vy: f64, vz: f64, dt: f64, n: usize) -> Vec<f64> {
        use crate::dynamics::classical::*;
        let ps0 = PhaseState::new(Vec3::new(px, py, pz), Vec3::new(vx, vy, vz));
        let traj = kepler_orbit(gm, &ps0, dt, n);
        traj_r(&traj)
    }

    fn kepler_speed_trace(&self, gm: f64, px: f64, py: f64, pz: f64, vx: f64, vy: f64, vz: f64, dt: f64, n: usize) -> Vec<f64> {
        use crate::dynamics::classical::*;
        let ps0 = PhaseState::new(Vec3::new(px, py, pz), Vec3::new(vx, vy, vz));
        let traj = kepler_orbit(gm, &ps0, dt, n);
        traj_speed(&traj)
    }

    fn time_array(&self, dt: f64, n: usize) -> Vec<f64> { crate::dynamics::classical::traj_time(dt, n) }

    fn slingshot(&self, gm_primary: f64, gm_secondary: f64, sec_x: f64, sec_y: f64, sec_z: f64,
                 px: f64, py: f64, pz: f64, vx: f64, vy: f64, vz: f64, dt: f64, n: usize)
        -> (Vec<f64>, Vec<f64>, Vec<f64>)
    {
        use crate::dynamics::classical::*;
        let ps0 = PhaseState::new(Vec3::new(px, py, pz), Vec3::new(vx, vy, vz));
        let traj = slingshot(gm_primary, gm_secondary, Vec3::new(sec_x, sec_y, sec_z), &ps0, dt, n);
        (traj_x(&traj), traj_y(&traj), traj_z(&traj))
    }

    fn __repr__(&self) -> String {
        format!("Classical(vev={:.2} GeV{})", self.toe.vev(),
                if self.toe.is_crystal_default() { ", crystal" } else { "" })
    }
}

#[pyclass(name = "NBody")]
#[derive(Clone)]
struct PyNBody { toe: crate::toe::Toe }

#[pymethods]
impl PyNBody {
    #[new]
    #[pyo3(signature = (vev=None))]
    fn new(vev: Option<f64>) -> Self {
        PyNBody { toe: match vev { Some(v) => crate::toe::Toe::with_vev(v), None => crate::toe::Toe::new() } }
    }

    // ── Inherited from Toe ──
    fn vev(&self) -> f64 { self.toe.vev() }
    fn proton_mass(&self) -> f64 { self.toe.proton_mass() }
    fn electron_mass(&self) -> f64 { self.toe.electron_mass() }
    fn alpha(&self) -> f64 { self.toe.alpha() }
    fn alpha_inv(&self) -> f64 { self.toe.alpha_inv() }
    fn n_w(&self) -> u64 { crate::atoms::N_W }
    fn n_c(&self) -> u64 { crate::atoms::N_C }
    fn chi(&self) -> u64 { crate::atoms::CHI }

    // ── N-Body constants ──
    fn octree_children(&self) -> u64 { crate::dynamics::nbody::OCTREE_CHILDREN }
    fn force_exponent(&self) -> u64 { crate::dynamics::nbody::FORCE_EXPONENT }
    fn phase_per_body(&self) -> u64 { crate::dynamics::nbody::PHASE_PER_BODY }
    fn should_open_node(&self, size: f64, dist: f64) -> bool { crate::dynamics::nbody::should_open_node(size, dist) }

    // ── Initial conditions ──
    /// Two-body Kepler: returns [(px,py,pz,vx,vy,vz,m), ...]
    fn two_body_kepler(&self, m1: f64, m2: f64, sep: f64) -> Vec<(f64,f64,f64,f64,f64,f64,f64)> {
        crate::dynamics::nbody::two_body_kepler(m1, m2, sep).iter()
            .map(|b| (b.px, b.py, b.pz, b.vx, b.vy, b.vz, b.m)).collect()
    }

    fn three_body_figure_eight(&self) -> Vec<(f64,f64,f64,f64,f64,f64,f64)> {
        crate::dynamics::nbody::three_body_figure_eight().iter()
            .map(|b| (b.px, b.py, b.pz, b.vx, b.vy, b.vz, b.m)).collect()
    }

    fn plummer_sphere(&self, n: usize, total_m: f64, r_scale: f64) -> Vec<(f64,f64,f64,f64,f64,f64,f64)> {
        crate::dynamics::nbody::plummer_sphere(n, total_m, r_scale).iter()
            .map(|b| (b.px, b.py, b.pz, b.vx, b.vy, b.vz, b.m)).collect()
    }

    fn solar_system_inner(&self) -> Vec<(f64,f64,f64,f64,f64,f64,f64)> {
        crate::dynamics::nbody::solar_system_inner().iter()
            .map(|b| (b.px, b.py, b.pz, b.vx, b.vy, b.vz, b.m)).collect()
    }

    // ── Simulation ──
    /// Evolve bodies for n steps (direct O(N²)). Returns all snapshots as list of body-lists.
    fn evolve_direct(&self, dt: f64, eps: f64, n_steps: usize,
                     bodies: Vec<(f64,f64,f64,f64,f64,f64,f64)>)
        -> Vec<Vec<(f64,f64,f64,f64,f64,f64,f64)>>
    {
        let bs: Vec<crate::dynamics::nbody::Body> = bodies.iter()
            .map(|&(px,py,pz,vx,vy,vz,m)| crate::dynamics::nbody::Body::new(px,py,pz,vx,vy,vz,m)).collect();
        let snaps = crate::dynamics::nbody::evolve_direct(dt, eps, n_steps, &bs);
        snaps.iter().map(|s| s.iter().map(|b| (b.px,b.py,b.pz,b.vx,b.vy,b.vz,b.m)).collect()).collect()
    }

    /// Evolve returning only final state.
    fn evolve_direct_final(&self, dt: f64, eps: f64, n_steps: usize,
                           bodies: Vec<(f64,f64,f64,f64,f64,f64,f64)>)
        -> Vec<(f64,f64,f64,f64,f64,f64,f64)>
    {
        let bs: Vec<crate::dynamics::nbody::Body> = bodies.iter()
            .map(|&(px,py,pz,vx,vy,vz,m)| crate::dynamics::nbody::Body::new(px,py,pz,vx,vy,vz,m)).collect();
        let final_b = crate::dynamics::nbody::evolve_direct_final(dt, eps, n_steps, &bs);
        final_b.iter().map(|b| (b.px,b.py,b.pz,b.vx,b.vy,b.vz,b.m)).collect()
    }

    // ── Conservation ──
    fn kinetic_energy(&self, bodies: Vec<(f64,f64,f64,f64,f64,f64,f64)>) -> f64 {
        let bs: Vec<crate::dynamics::nbody::Body> = bodies.iter()
            .map(|&(px,py,pz,vx,vy,vz,m)| crate::dynamics::nbody::Body::new(px,py,pz,vx,vy,vz,m)).collect();
        crate::dynamics::nbody::kinetic_energy(&bs)
    }

    fn potential_energy(&self, eps: f64, bodies: Vec<(f64,f64,f64,f64,f64,f64,f64)>) -> f64 {
        let bs: Vec<crate::dynamics::nbody::Body> = bodies.iter()
            .map(|&(px,py,pz,vx,vy,vz,m)| crate::dynamics::nbody::Body::new(px,py,pz,vx,vy,vz,m)).collect();
        crate::dynamics::nbody::potential_energy(eps, &bs)
    }

    fn total_energy(&self, eps: f64, bodies: Vec<(f64,f64,f64,f64,f64,f64,f64)>) -> f64 {
        let bs: Vec<crate::dynamics::nbody::Body> = bodies.iter()
            .map(|&(px,py,pz,vx,vy,vz,m)| crate::dynamics::nbody::Body::new(px,py,pz,vx,vy,vz,m)).collect();
        crate::dynamics::nbody::total_energy(eps, &bs)
    }

    fn total_momentum(&self, bodies: Vec<(f64,f64,f64,f64,f64,f64,f64)>) -> (f64, f64, f64) {
        let bs: Vec<crate::dynamics::nbody::Body> = bodies.iter()
            .map(|&(px,py,pz,vx,vy,vz,m)| crate::dynamics::nbody::Body::new(px,py,pz,vx,vy,vz,m)).collect();
        crate::dynamics::nbody::total_momentum(&bs)
    }

    fn __repr__(&self) -> String {
        format!("NBody(vev={:.2} GeV{})", self.toe.vev(),
                if self.toe.is_crystal_default() { ", crystal" } else { "" })
    }
}

#[pyclass(name = "GR")]
#[derive(Clone)]
struct PyGR { toe: crate::toe::Toe }

#[pymethods]
impl PyGR {
    #[new]
    #[pyo3(signature = (vev=None))]
    fn new(vev: Option<f64>) -> Self {
        PyGR { toe: match vev { Some(v) => crate::toe::Toe::with_vev(v), None => crate::toe::Toe::new() } }
    }

    // ── Inherited from Toe ──
    fn vev(&self) -> f64 { self.toe.vev() }
    fn proton_mass(&self) -> f64 { self.toe.proton_mass() }
    fn alpha(&self) -> f64 { self.toe.alpha() }
    fn alpha_inv(&self) -> f64 { self.toe.alpha_inv() }
    fn n_w(&self) -> u64 { crate::atoms::N_W }
    fn n_c(&self) -> u64 { crate::atoms::N_C }
    fn chi(&self) -> u64 { crate::atoms::CHI }

    // ── GR constants ──
    fn isco_factor(&self) -> u64 { crate::dynamics::gr::ISCO_FACTOR }
    fn precession_factor(&self) -> u64 { crate::dynamics::gr::PRECESSION_FACTOR }
    fn bending_factor(&self) -> u64 { crate::dynamics::gr::BENDING_FACTOR }
    fn photon_sphere(&self) -> u64 { crate::dynamics::gr::PHOTON_SPHERE }
    fn spacetime_dim(&self) -> u64 { crate::dynamics::gr::SPACETIME_DIM }

    // ── Schwarzschild ──
    fn schwarzschild_r(&self, gm: f64) -> f64 { crate::dynamics::gr::schwarzschild_r(gm) }
    fn schwarzschild_metric(&self, r: f64, rs: f64) -> f64 { crate::dynamics::gr::schwarzschild_metric(r, rs) }
    fn gravitational_redshift(&self, rs: f64, r: f64) -> f64 { crate::dynamics::gr::gravitational_redshift(rs, r) }
    fn frequency_ratio(&self, rs: f64, r_emit: f64, r_recv: f64) -> f64 { crate::dynamics::gr::frequency_ratio(rs, r_emit, r_recv) }

    // ── Effective potentials ──
    fn v_eff_massive(&self, rs: f64, ang_l: f64, r: f64) -> f64 { crate::dynamics::gr::v_eff_massive(rs, ang_l, r) }
    fn v_eff_photon(&self, rs: f64, ang_l: f64, r: f64) -> f64 { crate::dynamics::gr::v_eff_photon(rs, ang_l, r) }

    // ── ISCO ──
    fn isco_radius(&self, gm: f64) -> f64 { crate::dynamics::gr::isco_radius(gm) }
    fn isco_angular_momentum(&self, gm: f64) -> f64 { crate::dynamics::gr::isco_angular_momentum(gm) }
    fn isco_energy(&self) -> f64 { crate::dynamics::gr::isco_energy() }

    // ── Precession & bending (analytic) ──
    fn precession_analytic(&self, rs: f64, a: f64, e: f64) -> f64 { crate::dynamics::gr::precession_analytic(rs, a, e) }
    fn light_bending_analytic(&self, rs: f64, b: f64) -> f64 { crate::dynamics::gr::light_bending_analytic(rs, b) }
    fn shapiro_delay(&self, gm: f64, r1: f64, r2: f64, b: f64) -> f64 { crate::dynamics::gr::shapiro_delay(gm, r1, r2, b) }

    // ── Orbit simulation ──
    /// Simulate GR orbit. Returns (rs, phis, xs, ys).
    fn evolve_orbit(&self, gm: f64, a: f64, e: f64, dtau: f64, n_steps: usize)
        -> (Vec<f64>, Vec<f64>, Vec<f64>, Vec<f64>)
    {
        use crate::dynamics::gr::*;
        let rs = schwarzschild_r(gm);
        let r_peri = a * (1.0 - e);
        let ang_l = (gm * a * (1.0 - e * e)).sqrt();
        let e_sq = (1.0 - rs / r_peri).powi(2) * (1.0 + ang_l * ang_l / (r_peri * r_peri));
        let energy = e_sq.sqrt();
        let gs0 = GRState { r: r_peri, vr: 0.0, phi: 0.0, t: 0.0, tau: 0.0 };
        let traj = evolve_gr(dtau, rs, ang_l, energy, n_steps, &gs0);
        let (xs, ys) = traj_xy(&traj);
        (traj_r(&traj), traj_phi(&traj), xs, ys)
    }

    /// V_eff curve for plotting. Returns (rs_array, veff_array).
    fn effective_potential_curve(&self, gm: f64, ang_l: f64, r_min: f64, r_max: f64, n_points: usize)
        -> (Vec<f64>, Vec<f64>)
    {
        let rs = crate::dynamics::gr::schwarzschild_r(gm);
        let dr = (r_max - r_min) / n_points as f64;
        let rs_arr: Vec<f64> = (0..n_points).map(|i| r_min + i as f64 * dr).collect();
        let veff: Vec<f64> = rs_arr.iter().map(|&r| crate::dynamics::gr::v_eff_massive(rs, ang_l, r)).collect();
        (rs_arr, veff)
    }

    fn __repr__(&self) -> String {
        format!("GR(vev={:.2} GeV{})", self.toe.vev(),
                if self.toe.is_crystal_default() { ", crystal" } else { "" })
    }
}

#[pyclass(name = "GW")]
#[derive(Clone)]
struct PyGW { toe: crate::toe::Toe }

#[pymethods]
impl PyGW {
    #[new]
    #[pyo3(signature = (vev=None))]
    fn new(vev: Option<f64>) -> Self {
        PyGW { toe: match vev { Some(v) => crate::toe::Toe::with_vev(v), None => crate::toe::Toe::new() } }
    }

    // ── Inherited from Toe ──
    fn vev(&self) -> f64 { self.toe.vev() }
    fn proton_mass(&self) -> f64 { self.toe.proton_mass() }
    fn alpha(&self) -> f64 { self.toe.alpha() }
    fn n_w(&self) -> u64 { crate::atoms::N_W }
    fn n_c(&self) -> u64 { crate::atoms::N_C }
    fn chi(&self) -> u64 { crate::atoms::CHI }

    // ── GW constants & formulas ──
    fn peters_coefficient(&self) -> f64 { crate::dynamics::gw::peters_coefficient() }
    fn chirp_exponent(&self) -> f64 { crate::dynamics::gw::chirp_exponent() }
    fn gw_polarizations(&self) -> u64 { crate::dynamics::gw::GW_POLARIZATIONS }
    fn amplitude_factor(&self) -> u64 { crate::dynamics::gw::AMPLITUDE_FACTOR }
    fn chirp_mass(&self, m1: f64, m2: f64) -> f64 { crate::dynamics::gw::chirp_mass(m1, m2) }
    fn gw_frequency(&self, total_m: f64, a: f64) -> f64 { crate::dynamics::gw::gw_frequency(total_m, a) }
    fn chirp_rate(&self, mc: f64, f_gw: f64) -> f64 { crate::dynamics::gw::chirp_rate(mc, f_gw) }
    fn time_to_merger(&self, mc: f64, f_gw: f64) -> f64 { crate::dynamics::gw::time_to_merger(mc, f_gw) }
    fn isco_frequency(&self, total_m: f64) -> f64 { crate::dynamics::gw::isco_frequency(total_m) }
    fn gw_power(&self, mu: f64, total_m: f64, a: f64) -> f64 { crate::dynamics::gw::gw_power(mu, total_m, a) }
    fn orbit_decay_rate(&self, mu: f64, total_m: f64, a: f64) -> f64 { crate::dynamics::gw::orbit_decay_rate(mu, total_m, a) }
    fn separation_from_freq(&self, total_m: f64, f_gw: f64) -> f64 { crate::dynamics::gw::separation_from_freq(total_m, f_gw) }

    /// Inspiral waveform. Returns (times, freqs, h_plus, h_cross).
    fn inspiral_waveform(&self, m1: f64, m2: f64, dist: f64, iota: f64, f0: f64, dt: f64)
        -> (Vec<f64>, Vec<f64>, Vec<f64>, Vec<f64>)
    {
        let wf = crate::dynamics::gw::inspiral_waveform(m1, m2, dist, iota, f0, dt);
        (crate::dynamics::gw::wf_time(&wf), crate::dynamics::gw::wf_freq(&wf),
         crate::dynamics::gw::wf_h_plus(&wf), crate::dynamics::gw::wf_h_cross(&wf))
    }

    /// Orbital inspiral. Returns (times, separations, frequencies).
    fn integrate_inspiral(&self, m1: f64, m2: f64, a0: f64, dt: f64)
        -> (Vec<f64>, Vec<f64>, Vec<f64>)
    {
        let bs = crate::dynamics::gw::integrate_inspiral(m1, m2, a0, dt);
        (crate::dynamics::gw::insp_time(&bs), crate::dynamics::gw::insp_a(&bs),
         crate::dynamics::gw::insp_freq(&bs))
    }

    fn __repr__(&self) -> String {
        format!("GW(vev={:.2} GeV{})", self.toe.vev(),
                if self.toe.is_crystal_default() { ", crystal" } else { "" })
    }
}

#[pyclass(name = "EM")]
#[derive(Clone)]
struct PyEM { toe: crate::toe::Toe }
#[pymethods]
impl PyEM {
    #[new] #[pyo3(signature = (vev=None))]
    fn new(vev: Option<f64>) -> Self {
        PyEM { toe: match vev { Some(v) => crate::toe::Toe::with_vev(v), None => crate::toe::Toe::new() } }
    }
    fn vev(&self) -> f64 { self.toe.vev() }
    fn alpha(&self) -> f64 { self.toe.alpha() }
    fn n_w(&self) -> u64 { crate::atoms::N_W }
    fn n_c(&self) -> u64 { crate::atoms::N_C }
    fn chi(&self) -> u64 { crate::atoms::CHI }
    fn em_components(&self) -> u64 { crate::dynamics::em::EM_COMPONENTS }
    fn maxwell_equations(&self) -> u64 { crate::dynamics::em::MAXWELL_EQUATIONS }
    fn polarization_states(&self) -> u64 { crate::dynamics::em::POLARIZATION_STATES }
    fn planck_exponent(&self) -> u64 { crate::dynamics::em::PLANCK_EXPONENT }
    fn stefan_exponent(&self) -> u64 { crate::dynamics::em::STEFAN_EXPONENT }
    fn stefan_denom(&self) -> u64 { crate::dynamics::em::STEFAN_DENOM }
    fn rayleigh_wave_exp(&self) -> u64 { crate::dynamics::em::RAYLEIGH_WAVE_EXP }
    fn rayleigh_size_exp(&self) -> u64 { crate::dynamics::em::RAYLEIGH_SIZE_EXP }
    fn wave_impedance(&self) -> f64 { crate::dynamics::em::wave_impedance() }
    fn larmor_power(&self, q: f64, a: f64) -> f64 { crate::dynamics::em::larmor_power(q, a) }
    fn coulomb_force(&self, q1: f64, q2: f64, r: f64) -> f64 { crate::dynamics::em::coulomb_force(q1, q2, r) }
    fn rayleigh_sigma(&self, d: f64, lam: f64) -> f64 { crate::dynamics::em::rayleigh_sigma(d, lam) }
    fn sky_blue_ratio(&self, lb: f64, lr: f64) -> f64 { crate::dynamics::em::sky_blue_ratio(lb, lr) }
    fn stefan_boltzmann_power(&self, t: f64) -> f64 { crate::dynamics::em::stefan_boltzmann_power(t) }

    /// Yee FDTD: simulate Gaussian pulse. Returns (ey_snapshots, energies).
    fn simulate_pulse(&self, n_grid: usize, center: f64, width: f64, amp: f64,
                      courant: f64, n_steps: usize, snap_every: usize) -> (Vec<Vec<f64>>, Vec<f64>) {
        let st0 = crate::dynamics::em::gaussian_pulse(n_grid, center, width, amp);
        let snaps = crate::dynamics::em::evolve_em(courant, n_steps, snap_every, &st0);
        (crate::dynamics::em::snap_ey(&snaps), crate::dynamics::em::snap_energy(&snaps))
    }
}

#[pyclass(name = "Friedmann")]
#[derive(Clone)]
struct PyFriedmann { toe: crate::toe::Toe }
#[pymethods]
impl PyFriedmann {
    #[new] #[pyo3(signature = (vev=None))]
    fn new(vev: Option<f64>) -> Self {
        PyFriedmann { toe: match vev { Some(v) => crate::toe::Toe::with_vev(v), None => crate::toe::Toe::new() } }
    }
    fn vev(&self) -> f64 { self.toe.vev() }
    fn n_w(&self) -> u64 { crate::atoms::N_W }
    fn n_c(&self) -> u64 { crate::atoms::N_C }
    fn chi(&self) -> u64 { crate::atoms::CHI }
    fn omega_lambda(&self) -> f64 { crate::dynamics::friedmann::omega_lambda() }
    fn omega_matter(&self) -> f64 { crate::dynamics::friedmann::omega_matter() }
    fn omega_baryon(&self) -> f64 { crate::dynamics::friedmann::omega_baryon() }
    fn omega_dm(&self) -> f64 { crate::dynamics::friedmann::omega_dm() }
    fn omega_rad(&self) -> f64 { crate::dynamics::friedmann::omega_rad() }
    fn dm_baryon_ratio(&self) -> f64 { crate::dynamics::friedmann::dm_baryon_ratio() }
    fn hubble_norm(&self, a: f64) -> f64 { crate::dynamics::friedmann::hubble_norm(a) }
    fn deceleration_param(&self, a: f64) -> f64 { crate::dynamics::friedmann::deceleration_param(a) }
    fn h0_crystal(&self) -> f64 { crate::dynamics::friedmann::h0_crystal() }
    fn cmb_100_theta(&self) -> f64 { crate::dynamics::friedmann::cmb_100_theta() }
    fn cmb_temperature(&self) -> f64 { crate::dynamics::friedmann::cmb_temperature() }
    fn spectral_index(&self) -> f64 { crate::dynamics::friedmann::spectral_index() }
    fn ln_scalar_amplitude(&self) -> f64 { crate::dynamics::friedmann::ln_scalar_amplitude() }
    fn age_analytic(&self) -> f64 { crate::dynamics::friedmann::age_analytic() }
    fn n_effective(&self) -> f64 { crate::dynamics::friedmann::n_effective() }
    fn comoving_distance(&self, z: f64, n: usize) -> f64 { crate::dynamics::friedmann::comoving_distance(z, n) }
    fn luminosity_distance(&self, z: f64, n: usize) -> f64 { crate::dynamics::friedmann::luminosity_distance(z, n) }
    fn acceleration_onset(&self) -> f64 { crate::dynamics::friedmann::acceleration_onset(0.001, 1e-4, 5000000) }

    /// Integrate Friedmann. Returns (scale_factors, times, redshifts).
    fn integrate(&self, a_init: f64, a_final: f64, dt: f64, max_steps: usize) -> (Vec<f64>, Vec<f64>, Vec<f64>) {
        let traj = crate::dynamics::friedmann::integrate_friedmann(a_init, a_final, dt, max_steps);
        (crate::dynamics::friedmann::traj_a(&traj),
         crate::dynamics::friedmann::traj_time(&traj),
         crate::dynamics::friedmann::traj_z(&traj))
    }
}

#[pyclass(name = "Thermo")]
#[derive(Clone)]
struct PyThermo { toe: crate::toe::Toe }
#[pymethods]
impl PyThermo {
    #[new] #[pyo3(signature = (vev=None))]
    fn new(vev: Option<f64>) -> Self {
        PyThermo { toe: match vev { Some(v) => crate::toe::Toe::with_vev(v), None => crate::toe::Toe::new() } }
    }
    fn vev(&self) -> f64 { self.toe.vev() }
    fn alpha(&self) -> f64 { self.toe.alpha() }
    fn n_w(&self) -> u64 { crate::atoms::N_W }
    fn n_c(&self) -> u64 { crate::atoms::N_C }
    fn chi(&self) -> u64 { crate::atoms::CHI }
    fn lj_attract(&self) -> u64 { crate::dynamics::thermo::LJ_ATTRACT }
    fn lj_repel(&self) -> u64 { crate::dynamics::thermo::LJ_REPEL }
    fn lj_force_prefactor(&self) -> u64 { crate::dynamics::thermo::LJ_FORCE_PREFACTOR }
    fn dof_mono(&self) -> u64 { crate::dynamics::thermo::DOF_MONO }
    fn dof_di(&self) -> u64 { crate::dynamics::thermo::DOF_DI }
    fn gamma_monatomic(&self) -> f64 { crate::dynamics::thermo::gamma_monatomic() }
    fn gamma_diatomic(&self) -> f64 { crate::dynamics::thermo::gamma_diatomic() }
    fn carnot_efficiency(&self) -> f64 { crate::dynamics::thermo::carnot_efficiency() }
    fn entropy_per_tick(&self) -> f64 { crate::dynamics::thermo::entropy_per_tick() }
    fn maxwell_speed_rms(&self, kt: f64, m: f64) -> f64 { crate::dynamics::thermo::maxwell_speed_rms(kt, m) }
    fn equipartition_energy(&self, dof: u64, kt: f64) -> f64 { crate::dynamics::thermo::equipartition_energy(dof, kt) }
    fn lj_potential(&self, eps: f64, sigma: f64, r: f64) -> f64 { crate::dynamics::thermo::lj_potential(eps, sigma, r) }
    fn lj_force_mag(&self, eps: f64, sigma: f64, r: f64) -> f64 { crate::dynamics::thermo::lj_force_mag(eps, sigma, r) }

    /// Run MD simulation. bodies = [(x,y,z,vx,vy,vz,m),...]. Returns snapshots.
    fn simulate(&self, dt: f64, eps: f64, sigma: f64, cutoff: f64, n_steps: usize, snap_every: usize,
                bodies: Vec<(f64,f64,f64,f64,f64,f64,f64)>)
        -> Vec<Vec<(f64,f64,f64,f64,f64,f64,f64)>>
    {
        let parts: Vec<crate::dynamics::thermo::Particle> = bodies.iter()
            .map(|&(x,y,z,vx,vy,vz,m)| crate::dynamics::thermo::Particle::new(x,y,z,vx,vy,vz,m)).collect();
        let snaps = crate::dynamics::thermo::evolve_thermo(dt, eps, sigma, cutoff, n_steps, snap_every, &parts);
        snaps.iter().map(|s| s.iter().map(|p| (p.x,p.y,p.z,p.vx,p.vy,p.vz,p.m)).collect()).collect()
    }

    fn make_gas(&self, n: usize, temp: f64, spacing: f64) -> Vec<(f64,f64,f64,f64,f64,f64,f64)> {
        crate::dynamics::thermo::make_gas(n, temp, spacing).iter()
            .map(|p| (p.x,p.y,p.z,p.vx,p.vy,p.vz,p.m)).collect()
    }

    fn make_lattice_2d(&self, nx: usize, ny: usize, spacing: f64, temp: f64) -> Vec<(f64,f64,f64,f64,f64,f64,f64)> {
        crate::dynamics::thermo::make_lattice_2d(nx, ny, spacing, temp).iter()
            .map(|p| (p.x,p.y,p.z,p.vx,p.vy,p.vz,p.m)).collect()
    }

    fn kinetic_energy(&self, bodies: Vec<(f64,f64,f64,f64,f64,f64,f64)>) -> f64 {
        let parts: Vec<crate::dynamics::thermo::Particle> = bodies.iter()
            .map(|&(x,y,z,vx,vy,vz,m)| crate::dynamics::thermo::Particle::new(x,y,z,vx,vy,vz,m)).collect();
        crate::dynamics::thermo::kinetic_energy(&parts)
    }

    fn temperature(&self, bodies: Vec<(f64,f64,f64,f64,f64,f64,f64)>) -> f64 {
        let parts: Vec<crate::dynamics::thermo::Particle> = bodies.iter()
            .map(|&(x,y,z,vx,vy,vz,m)| crate::dynamics::thermo::Particle::new(x,y,z,vx,vy,vz,m)).collect();
        crate::dynamics::thermo::temperature(&parts)
    }

    fn total_energy(&self, eps: f64, sigma: f64, cutoff: f64, bodies: Vec<(f64,f64,f64,f64,f64,f64,f64)>) -> f64 {
        let parts: Vec<crate::dynamics::thermo::Particle> = bodies.iter()
            .map(|&(x,y,z,vx,vy,vz,m)| crate::dynamics::thermo::Particle::new(x,y,z,vx,vy,vz,m)).collect();
        crate::dynamics::thermo::total_energy(eps, sigma, cutoff, &parts)
    }
}

#[pyclass(name = "CFD")]
#[derive(Clone)]
struct PyCFD { toe: crate::toe::Toe }
#[pymethods]
impl PyCFD {
    #[new] #[pyo3(signature = (vev=None))]
    fn new(vev: Option<f64>) -> Self {
        PyCFD { toe: match vev { Some(v) => crate::toe::Toe::with_vev(v), None => crate::toe::Toe::new() } }
    }
    fn vev(&self) -> f64 { self.toe.vev() }
    fn n_w(&self) -> u64 { crate::atoms::N_W }
    fn n_c(&self) -> u64 { crate::atoms::N_C }
    fn chi(&self) -> u64 { crate::atoms::CHI }
    fn d2q9_velocities(&self) -> u64 { crate::dynamics::cfd::D2Q9_VELOCITIES }
    fn stokes_drag(&self) -> u64 { crate::dynamics::cfd::STOKES_DRAG }
    fn reynolds_number(&self, rho: f64, v: f64, l: f64, mu: f64) -> f64 { crate::dynamics::cfd::reynolds_number(rho, v, l, mu) }
    fn kolmogorov_spectrum(&self, k: f64, eps: f64) -> f64 { crate::dynamics::cfd::kolmogorov_spectrum(k, eps) }
    fn stokes_drag_force(&self, mu: f64, r: f64, v: f64) -> f64 { crate::dynamics::cfd::stokes_drag_force(mu, r, v) }
    fn blasius_exponent(&self) -> f64 { crate::dynamics::cfd::blasius_exponent() }
    fn von_karman(&self) -> f64 { crate::dynamics::cfd::von_karman() }

    /// Run Poiseuille simulation. Returns (velocity_profile, analytical_profile).
    fn poiseuille(&self, nx: usize, ny: usize, tau: f64, force_x: f64, n_steps: usize) -> (Vec<f64>, Vec<f64>) {
        let st = crate::dynamics::cfd::lbm_init(nx, ny, 1.0);
        let st2 = crate::dynamics::cfd::lbm_evolve(tau, force_x, n_steps, &st);
        let num = crate::dynamics::cfd::velocity_profile_x(&st2, nx/2);
        let ana: Vec<f64> = (0..ny).map(|j| crate::dynamics::cfd::poiseuille_profile(force_x, tau, ny, j)).collect();
        (num, ana)
    }

    /// Run LBM and return density + speed fields. Returns (density_flat, speed_flat, nx, ny).
    fn simulate(&self, nx: usize, ny: usize, tau: f64, force_x: f64, n_steps: usize) -> (Vec<f64>, Vec<f64>) {
        let st = crate::dynamics::cfd::lbm_init(nx, ny, 1.0);
        let st2 = crate::dynamics::cfd::lbm_evolve(tau, force_x, n_steps, &st);
        (crate::dynamics::cfd::density_field(&st2), crate::dynamics::cfd::speed_field(&st2))
    }
}

#[pyclass(name = "Decay")]
#[derive(Clone)]
struct PyDecay { toe: crate::toe::Toe }
#[pymethods]
impl PyDecay {
    #[new] #[pyo3(signature = (vev=None))]
    fn new(vev: Option<f64>) -> Self {
        PyDecay { toe: match vev { Some(v) => crate::toe::Toe::with_vev(v), None => crate::toe::Toe::new() } }
    }
    fn vev(&self) -> f64 { self.toe.vev() }
    fn n_w(&self) -> u64 { crate::atoms::N_W }
    fn n_c(&self) -> u64 { crate::atoms::N_C }
    fn chi(&self) -> u64 { crate::atoms::CHI }
    fn beta_factor(&self) -> u64 { crate::dynamics::decay::BETA_FACTOR }
    fn sin2_theta_w(&self) -> f64 { crate::dynamics::decay::sin2_theta_w() }
    fn sin2_theta_12(&self) -> f64 { crate::dynamics::decay::sin2_theta_12() }
    fn sin2_theta_23(&self) -> f64 { crate::dynamics::decay::sin2_theta_23() }
    fn sin2_2theta_23(&self) -> f64 { crate::dynamics::decay::sin2_2theta_23() }
    fn phase_space_dim(&self, n: u64) -> u64 { crate::dynamics::decay::phase_space_dim(n) }
    fn fermi_golden_rule(&self, me_sq: f64, dos: f64) -> f64 { crate::dynamics::decay::fermi_golden_rule(me_sq, dos) }
    fn beta_decay_rate(&self, gf: f64, energy: f64) -> f64 { crate::dynamics::decay::beta_decay_rate(gf, energy) }
    fn g_fermi(&self) -> f64 { crate::dynamics::decay::g_fermi() }
    fn neutron_lifetime(&self) -> f64 { crate::dynamics::decay::neutron_lifetime() }
    fn oscill_prob(&self, sin2_2th: f64, dm2: f64, l_over_e: f64) -> f64 { crate::dynamics::decay::oscill_prob(sin2_2th, dm2, l_over_e) }
    fn atmos_oscillation(&self) -> f64 { crate::dynamics::decay::atmos_oscillation() }
    fn beta_endpoint(&self) -> f64 { crate::dynamics::decay::beta_endpoint() }

    /// Beta spectrum curve. Returns (energies_mev, spectrum).
    fn beta_spectrum_curve(&self, n_points: usize) -> (Vec<f64>, Vec<f64>) {
        crate::dynamics::decay::beta_spectrum_curve(n_points)
    }
}

#[pyclass(name = "Optics")]
#[derive(Clone)]
struct PyOptics { toe: crate::toe::Toe }
#[pymethods]
impl PyOptics {
    #[new] #[pyo3(signature = (vev=None))]
    fn new(vev: Option<f64>) -> Self {
        PyOptics { toe: match vev { Some(v) => crate::toe::Toe::with_vev(v), None => crate::toe::Toe::new() } }
    }
    fn vev(&self) -> f64 { self.toe.vev() }
    fn n_w(&self) -> u64 { crate::atoms::N_W }
    fn n_c(&self) -> u64 { crate::atoms::N_C }
    fn chi(&self) -> u64 { crate::atoms::CHI }
    fn n_water(&self) -> f64 { crate::dynamics::optics::n_water() }
    fn n_glass(&self) -> f64 { crate::dynamics::optics::n_glass() }
    fn n_diamond(&self) -> f64 { crate::dynamics::optics::n_diamond() }
    fn rayleigh_lambda_exp(&self) -> u64 { crate::dynamics::optics::RAYLEIGH_LAMBDA_EXP }
    fn rayleigh_size_exp(&self) -> u64 { crate::dynamics::optics::RAYLEIGH_SIZE_EXP }
    fn planck_lambda_exp(&self) -> u64 { crate::dynamics::optics::PLANCK_LAMBDA_EXP }
    fn sky_blue_ratio(&self) -> f64 { crate::dynamics::optics::sky_blue_ratio() }
    fn rayleigh_intensity(&self, l0: f64, l: f64) -> f64 { crate::dynamics::optics::rayleigh_intensity(l0, l) }
    fn snell(&self, n1: f64, n2: f64, theta: f64) -> Option<f64> { crate::dynamics::optics::snell(n1, n2, theta) }
    fn critical_angle(&self, n1: f64, n2: f64) -> Option<f64> { crate::dynamics::optics::critical_angle(n1, n2) }
    fn brewster_angle(&self, n1: f64, n2: f64) -> f64 { crate::dynamics::optics::brewster_angle(n1, n2) }
    fn fresnel_rs(&self, n1: f64, n2: f64, t: f64) -> f64 { crate::dynamics::optics::fresnel_rs(n1, n2, t) }
    fn fresnel_rp(&self, n1: f64, n2: f64, t: f64) -> f64 { crate::dynamics::optics::fresnel_rp(n1, n2, t) }
    fn fresnel_r(&self, n1: f64, n2: f64, t: f64) -> f64 { crate::dynamics::optics::fresnel_r(n1, n2, t) }
    fn normal_reflectance(&self, n1: f64, n2: f64) -> f64 { crate::dynamics::optics::normal_reflectance(n1, n2) }
    fn planck_radiance(&self, lam: f64, t: f64) -> f64 { crate::dynamics::optics::planck_radiance(lam, t) }
    fn wien_displacement(&self, t: f64) -> f64 { crate::dynamics::optics::wien_displacement(t) }
    fn thin_lens_focal(&self, n: f64, r1: f64, r2: f64) -> f64 { crate::dynamics::optics::thin_lens_focal(n, r1, r2) }
    fn airy_radius(&self, lam: f64, aperture: f64) -> f64 { crate::dynamics::optics::airy_radius(lam, aperture) }

    /// Fresnel reflectance curve. Returns (angles_deg, rs, rp, r_avg).
    fn fresnel_curve(&self, n1: f64, n2: f64, n_points: usize) -> (Vec<f64>, Vec<f64>, Vec<f64>, Vec<f64>) {
        crate::dynamics::optics::fresnel_curve(n1, n2, n_points)
    }

    /// Planck curves at given temperatures. Returns (lambdas_nm, [spectra]).
    fn planck_curves(&self, temps: Vec<f64>, n_points: usize) -> (Vec<f64>, Vec<Vec<f64>>) {
        crate::dynamics::optics::planck_curves(&temps, n_points)
    }
}

#[pyclass(name = "MD")]
#[derive(Clone)]
struct PyMD { toe: crate::toe::Toe }
#[pymethods]
impl PyMD {
    #[new] #[pyo3(signature = (vev=None))]
    fn new(vev: Option<f64>) -> Self {
        PyMD { toe: match vev { Some(v) => crate::toe::Toe::with_vev(v), None => crate::toe::Toe::new() } }
    }
    fn vev(&self) -> f64 { self.toe.vev() }
    fn n_w(&self) -> u64 { crate::atoms::N_W }
    fn n_c(&self) -> u64 { crate::atoms::N_C }
    fn chi(&self) -> u64 { crate::atoms::CHI }
    fn tetrahedral_angle_deg(&self) -> f64 { crate::dynamics::md::tetrahedral_angle().to_degrees() }
    fn water_angle_deg(&self) -> f64 { crate::dynamics::md::water_angle().to_degrees() }
    fn helix_per_turn(&self) -> f64 { crate::dynamics::md::helix_per_turn() }
    fn flory_nu(&self) -> f64 { crate::dynamics::md::flory_nu() }
    fn amino_acids(&self) -> u64 { crate::dynamics::md::AMINO_ACIDS }
    fn dna_bases(&self) -> u64 { crate::dynamics::md::DNA_BASES }
    fn codons(&self) -> u64 { crate::dynamics::md::CODONS }
    fn hbond_at(&self) -> u64 { crate::dynamics::md::HBOND_AT }
    fn hbond_gc(&self) -> u64 { crate::dynamics::md::HBOND_GC }
    fn bp_per_turn(&self) -> u64 { crate::dynamics::md::BP_PER_TURN }
    fn lj_force(&self, r: f64, sigma: f64, eps: f64) -> f64 { crate::dynamics::md::lj_force(r, sigma, eps) }
    fn lj_potential(&self, r: f64) -> f64 { crate::dynamics::md::lj_potential(r) }

    /// LJ potential + force curves. Returns (r, V, F).
    fn lj_curves(&self, r_min: f64, r_max: f64, n: usize) -> (Vec<f64>, Vec<f64>, Vec<f64>) {
        crate::dynamics::md::lj_curves(r_min, r_max, n)
    }

    /// 2-particle MD simulation. Returns (separations, energies).
    fn md2_evolve(&self, x1: f64, v1: f64, x2: f64, v2: f64, dt: f64, n: usize) -> (Vec<f64>, Vec<f64>) {
        let st = crate::dynamics::md::MD2::new(x1, v1, x2, v2);
        crate::dynamics::md::md2_evolve(dt, n, &st)
    }
}

#[pyclass(name = "Condensed")]
#[derive(Clone)]
struct PyCondensed { toe: crate::toe::Toe }
#[pymethods]
impl PyCondensed {
    #[new] #[pyo3(signature = (vev=None))]
    fn new(vev: Option<f64>) -> Self {
        PyCondensed { toe: match vev { Some(v) => crate::toe::Toe::with_vev(v), None => crate::toe::Toe::new() } }
    }
    fn vev(&self) -> f64 { self.toe.vev() }
    fn n_w(&self) -> u64 { crate::atoms::N_W }
    fn n_c(&self) -> u64 { crate::atoms::N_C }
    fn chi(&self) -> u64 { crate::atoms::CHI }
    fn ising_z_square(&self) -> u64 { crate::dynamics::condensed::ISING_Z_SQUARE }
    fn ising_z_cubic(&self) -> u64 { crate::dynamics::condensed::ISING_Z_CUBIC }
    fn ising_states(&self) -> u64 { crate::dynamics::condensed::ISING_STATES }
    fn onsager_tc(&self) -> f64 { crate::dynamics::condensed::onsager_tc() }
    fn critical_beta(&self) -> f64 { crate::dynamics::condensed::critical_beta() }
    fn bcs_ratio(&self) -> f64 { crate::dynamics::condensed::bcs_ratio() }
    fn bcs_gap(&self, nv: f64) -> f64 { crate::dynamics::condensed::bcs_gap(nv) }
    fn ising_magnetization(&self, t: f64) -> f64 { crate::dynamics::condensed::ising_magnetization(t) }

    /// Run Ising MC. Returns (magnetizations, energies).
    fn ising_simulate(&self, n: usize, inv_t: f64, n_sweeps: usize, sample_every: usize) -> (Vec<f64>, Vec<i64>) {
        let mut lat = crate::dynamics::condensed::Lattice::new(n, 1);
        let mut seed = crate::atoms::TOWER_D as u64;
        crate::dynamics::condensed::ising_run(&mut lat, n_sweeps, inv_t, &mut seed, sample_every)
    }
}

#[pyclass(name = "Plasma")]
#[derive(Clone)]
struct PyPlasma { toe: crate::toe::Toe }
#[pymethods]
impl PyPlasma {
    #[new] #[pyo3(signature = (vev=None))]
    fn new(vev: Option<f64>) -> Self {
        PyPlasma { toe: match vev { Some(v) => crate::toe::Toe::with_vev(v), None => crate::toe::Toe::new() } }
    }
    fn vev(&self) -> f64 { self.toe.vev() }
    fn n_w(&self) -> u64 { crate::atoms::N_W }
    fn n_c(&self) -> u64 { crate::atoms::N_C }
    fn chi(&self) -> u64 { crate::atoms::CHI }
    fn mhd_states(&self) -> u64 { crate::dynamics::plasma::MHD_STATES }
    fn wave_types(&self) -> u64 { crate::dynamics::plasma::WAVE_TYPES }
    fn propagating_modes(&self) -> u64 { crate::dynamics::plasma::PROPAGATING_MODES }
    fn non_propagating(&self) -> u64 { crate::dynamics::plasma::NON_PROPAGATING }
    fn alfven_speed(&self, b: f64, rho: f64) -> f64 { crate::dynamics::plasma::alfven_speed(b, rho) }
    fn mag_pressure(&self, b: f64) -> f64 { crate::dynamics::plasma::mag_pressure(b) }
    fn plasma_beta(&self, p: f64, b: f64) -> f64 { crate::dynamics::plasma::plasma_beta(p, b) }
    fn total_pressure(&self, p: f64, b: f64) -> f64 { crate::dynamics::plasma::total_pressure(p, b) }
    fn cyclotron_frequency(&self, q: f64, b: f64, m: f64) -> f64 { crate::dynamics::plasma::cyclotron_frequency(q, b, m) }
    fn debye_length(&self, kt: f64, n: f64, q: f64) -> f64 { crate::dynamics::plasma::debye_length(kt, n, q) }
    fn plasma_frequency(&self, n: f64, m: f64) -> f64 { crate::dynamics::plasma::plasma_frequency(n, m) }
    fn larmor_radius(&self, m: f64, v: f64, q: f64, b: f64) -> f64 { crate::dynamics::plasma::larmor_radius(m, v, q, b) }

    /// Alfvén wave simulation. Returns (vy_snapshots, by_snapshots, energies).
    fn simulate_alfven(&self, n_grid: usize, cfl: f64, n_steps: usize, snap_every: usize, pulse: bool)
        -> (Vec<Vec<f64>>, Vec<Vec<f64>>, Vec<f64>)
    {
        let st0 = if pulse { crate::dynamics::plasma::mhd_pulse(n_grid, 0.3, 0.05) }
                  else { crate::dynamics::plasma::mhd_init(n_grid) };
        let snaps = crate::dynamics::plasma::mhd_evolve(n_grid, cfl, n_steps, snap_every, &st0);
        let vys: Vec<Vec<f64>> = snaps.iter().map(|s| s.vy.clone()).collect();
        let bys: Vec<Vec<f64>> = snaps.iter().map(|s| s.by.clone()).collect();
        let ens: Vec<f64> = snaps.iter().map(|s| crate::dynamics::plasma::mhd_energy(s)).collect();
        (vys, bys, ens)
    }
}

#[pyclass(name = "QFT")]
#[derive(Clone)]
struct PyQFT { toe: crate::toe::Toe }
#[pymethods]
impl PyQFT {
    #[new] #[pyo3(signature = (vev=None))]
    fn new(vev: Option<f64>) -> Self {
        PyQFT { toe: match vev { Some(v) => crate::toe::Toe::with_vev(v), None => crate::toe::Toe::new() } }
    }
    fn vev(&self) -> f64 { self.toe.vev() }
    fn n_w(&self) -> u64 { crate::atoms::N_W }
    fn n_c(&self) -> u64 { crate::atoms::N_C }
    fn chi(&self) -> u64 { crate::atoms::CHI }
    fn spacetime_dim(&self) -> u64 { crate::dynamics::qft::SPACETIME_DIM }
    fn lorentz_generators(&self) -> u64 { crate::dynamics::qft::LORENTZ_GEN }
    fn dirac_gammas(&self) -> u64 { crate::dynamics::qft::DIRAC_GAMMAS }
    fn spinor_comp(&self) -> u64 { crate::dynamics::qft::SPINOR_COMP }
    fn photon_pol(&self) -> u64 { crate::dynamics::qft::PHOTON_POL }
    fn gluon_colours(&self) -> u64 { crate::dynamics::qft::GLUON_COLOURS }
    fn qcd_beta0(&self) -> u64 { crate::dynamics::qft::QCD_BETA0 }
    fn one_loop_factor(&self) -> u64 { crate::dynamics::qft::ONE_LOOP_FACTOR }
    fn propagator_exp(&self) -> u64 { crate::dynamics::qft::PROPAGATOR_EXP }
    fn alpha_inv(&self) -> f64 { crate::dynamics::qft::alpha_inv() }
    fn alpha_em(&self) -> f64 { crate::dynamics::qft::alpha_em() }
    fn sigma_ee_mumu(&self, sqrt_s: f64) -> f64 { crate::dynamics::qft::sigma_ee_mumu(sqrt_s) }
    fn thomson_cs(&self) -> f64 { crate::dynamics::qft::thomson_cs() }
    fn pair_threshold(&self, m: f64) -> f64 { crate::dynamics::qft::pair_threshold(m) }
    fn alpha_qed(&self, mu: f64, q: f64) -> f64 { crate::dynamics::qft::alpha_qed(mu, q) }
    fn alpha_qcd(&self, lambda: f64, q: f64) -> f64 { crate::dynamics::qft::alpha_qcd(lambda, q) }
    fn alpha_s_mz(&self) -> f64 { crate::dynamics::qft::alpha_s_mz() }

    /// σ(e⁺e⁻→μ⁺μ⁻) curve. Returns (sqrt_s, sigma_nb).
    fn sigma_curve(&self, s_min: f64, s_max: f64, n: usize) -> (Vec<f64>, Vec<f64>) {
        crate::dynamics::qft::sigma_curve(s_min, s_max, n)
    }
    /// α_s(Q) curve. Returns (Q, alpha_s).
    fn alpha_s_curve(&self, q_min: f64, q_max: f64, lambda: f64, n: usize) -> (Vec<f64>, Vec<f64>) {
        crate::dynamics::qft::alpha_s_curve(q_min, q_max, lambda, n)
    }
}

#[pyclass(name = "Rigid")]
#[derive(Clone)]
struct PyRigid { toe: crate::toe::Toe }
#[pymethods]
impl PyRigid {
    #[new] #[pyo3(signature = (vev=None))]
    fn new(vev: Option<f64>) -> Self {
        PyRigid { toe: match vev { Some(v) => crate::toe::Toe::with_vev(v), None => crate::toe::Toe::new() } }
    }
    fn vev(&self) -> f64 { self.toe.vev() }
    fn n_w(&self) -> u64 { crate::atoms::N_W }
    fn n_c(&self) -> u64 { crate::atoms::N_C }
    fn chi(&self) -> u64 { crate::atoms::CHI }
    fn quat_components(&self) -> u64 { crate::dynamics::rigid::QUAT_COMPONENTS }
    fn inertia_indep(&self) -> u64 { crate::dynamics::rigid::INERTIA_INDEP }
    fn rigid_dof(&self) -> u64 { crate::dynamics::rigid::RIGID_DOF }
    fn euler_angles(&self) -> u64 { crate::dynamics::rigid::EULER_ANGLES }
    fn rot_matrix(&self) -> u64 { crate::dynamics::rigid::ROT_MATRIX }
    fn i_sphere(&self, m: f64, r: f64) -> f64 { crate::dynamics::rigid::i_sphere(m, r) }
    fn i_rod(&self, m: f64, l: f64) -> f64 { crate::dynamics::rigid::i_rod(m, l) }
    fn i_disk(&self, m: f64, r: f64) -> f64 { crate::dynamics::rigid::i_disk(m, r) }
    fn i_shell(&self, m: f64, r: f64) -> f64 { crate::dynamics::rigid::i_shell(m, r) }
    fn i_sphere_factor(&self) -> f64 { crate::dynamics::rigid::i_sphere_factor() }
    fn i_rod_factor(&self) -> f64 { crate::dynamics::rigid::i_rod_factor() }
    fn i_disk_factor(&self) -> f64 { crate::dynamics::rigid::i_disk_factor() }
    fn i_shell_factor(&self) -> f64 { crate::dynamics::rigid::i_shell_factor() }

    /// Torque-free rigid body simulation. Returns (energies, ang_mom, quat_norms).
    fn simulate(&self, ix: f64, iy: f64, iz: f64, wx: f64, wy: f64, wz: f64, dt: f64, n_steps: usize)
        -> (Vec<f64>, Vec<f64>, Vec<f64>)
    {
        let rb = crate::dynamics::rigid::RigidBody::new((ix,iy,iz), (wx,wy,wz));
        crate::dynamics::rigid::rigid_evolve(dt, n_steps, &rb)
    }
}

#[pyclass(name = "Chem")] struct PyChem;
#[pymethods] impl PyChem {
    #[new] fn new() -> Self { PyChem }
    fn s_capacity(&self) -> u64 { crate::dynamics::chem::S_CAPACITY }
    fn p_capacity(&self) -> u64 { crate::dynamics::chem::P_CAPACITY }
    fn d_capacity(&self) -> u64 { crate::dynamics::chem::D_CAPACITY }
    fn f_capacity(&self) -> u64 { crate::dynamics::chem::F_CAPACITY }
    fn noble_he(&self) -> u64 { crate::dynamics::chem::NOBLE_HE }
    fn noble_ne(&self) -> u64 { crate::dynamics::chem::NOBLE_NE }
    fn noble_ar(&self) -> u64 { crate::dynamics::chem::NOBLE_AR }
    fn noble_kr(&self) -> u64 { crate::dynamics::chem::NOBLE_KR }
    fn neutral_ph(&self) -> u64 { crate::dynamics::chem::NEUTRAL_PH }
    fn sp3_angle_deg(&self) -> f64 { crate::dynamics::chem::sp3_angle().to_degrees() }
    fn sp2_angle_deg(&self) -> f64 { crate::dynamics::chem::sp2_angle().to_degrees() }
    fn water_angle_deg(&self) -> f64 { crate::dynamics::chem::water_angle().to_degrees() }
    fn shell_capacity(&self, n: u64) -> u64 { crate::dynamics::chem::shell_capacity(n) }
    fn arrhenius(&self, ea: f64, kt: f64) -> f64 { crate::dynamics::chem::arrhenius(ea, kt) }
}

#[pyclass(name = "Nuclear")] struct PyNuclear;
#[pymethods] impl PyNuclear {
    #[new] fn new() -> Self { PyNuclear }
    fn magic_numbers(&self) -> Vec<u64> { crate::dynamics::nuclear::magic_numbers().to_vec() }
    fn iron_peak(&self) -> u64 { crate::dynamics::nuclear::IRON_PEAK_A }
    fn isospin_states(&self) -> u64 { crate::dynamics::nuclear::ISOSPIN_STATES }
    fn alpha_particle(&self) -> u64 { crate::dynamics::nuclear::ALPHA_PARTICLE }
    fn binding_energy(&self, a: u32, z: u32) -> f64 { crate::dynamics::nuclear::binding_energy(a, z) }
    fn binding_per_nucleon(&self, a: u32, z: u32) -> f64 { crate::dynamics::nuclear::binding_per_nucleon(a, z) }
}

#[pyclass(name = "Astro")] struct PyAstro;
#[pymethods] impl PyAstro {
    #[new] fn new() -> Self { PyAstro }
    fn polytrope_nr(&self) -> f64 { crate::atoms::N_C as f64 / crate::atoms::N_W as f64 }
    fn polytrope_rel(&self) -> u64 { crate::dynamics::astro::POLYTROPE_REL }
    fn hawking_factor(&self) -> u64 { crate::dynamics::astro::HAWKING }
    fn sb_denominator(&self) -> u64 { crate::dynamics::astro::SB_DENOM }
    fn eddington_factor(&self) -> u64 { crate::dynamics::astro::EDDINGTON }
    fn virial(&self) -> u64 { crate::dynamics::astro::VIRIAL }
    fn lane_emden(&self, n: f64) -> (f64, f64) { crate::dynamics::astro::lane_emden(n) }
}

#[pyclass(name = "QInfo")] struct PyQInfo;
#[pymethods] impl PyQInfo {
    #[new] fn new() -> Self { PyQInfo }
    fn qubit_states(&self) -> u64 { crate::dynamics::qinfo::QUBIT_STATES }
    fn pauli_matrices(&self) -> u64 { crate::dynamics::qinfo::PAULI_MATRICES }
    fn bell_states(&self) -> u64 { crate::dynamics::qinfo::BELL_STATES }
    fn steane_code(&self) -> (u64, u64, u64) { (crate::dynamics::qinfo::STEANE_N, crate::dynamics::qinfo::STEANE_K, crate::dynamics::qinfo::STEANE_D) }
    fn shor_n(&self) -> u64 { crate::dynamics::qinfo::SHOR_N }
    fn toffoli(&self) -> u64 { crate::dynamics::qinfo::TOFFOLI }
    fn mera_bond(&self) -> u64 { crate::dynamics::qinfo::MERA_BOND }
    fn mera_depth(&self) -> u64 { crate::dynamics::qinfo::MERA_DEPTH }
    fn teleport_bits(&self) -> u64 { crate::dynamics::qinfo::TELEPORT_BITS }
    fn bell_entropy(&self) -> f64 { crate::dynamics::qinfo::bell_entropy() }
    fn mera_link_entropy(&self) -> f64 { crate::dynamics::qinfo::mera_link_entropy() }
    fn hamming_check(&self) -> bool { crate::dynamics::qinfo::hamming_check() }
}

#[pyclass(name = "Bio")] struct PyBio;
#[pymethods] impl PyBio {
    #[new] fn new() -> Self { PyBio }
    fn dna_bases(&self) -> u64 { crate::dynamics::bio::DNA_BASES }
    fn codon_len(&self) -> u64 { crate::dynamics::bio::CODON_LEN }
    fn codons(&self) -> u64 { crate::dynamics::bio::TOTAL_CODONS }
    fn amino_acids(&self) -> u64 { crate::dynamics::bio::AMINO_ACIDS }
    fn stop_codons(&self) -> u64 { crate::dynamics::bio::STOP_CODONS }
    fn hbond_at(&self) -> u64 { crate::dynamics::bio::HBOND_AT }
    fn hbond_gc(&self) -> u64 { crate::dynamics::bio::HBOND_GC }
    fn helix_strands(&self) -> u64 { crate::dynamics::bio::HELIX_STRANDS }
    fn bp_per_turn(&self) -> u64 { crate::dynamics::bio::BP_PER_TURN }
    fn lipid_layers(&self) -> u64 { crate::dynamics::bio::LIPID_LAYERS }
    fn kleiber_exponent(&self) -> f64 { crate::dynamics::bio::kleiber_exp() }
    fn surface_exponent(&self) -> f64 { crate::dynamics::bio::surface_exp() }
    fn heart_rate_exponent(&self) -> f64 { crate::dynamics::bio::heart_rate_exp() }
    fn helix_per_turn(&self) -> f64 { crate::dynamics::bio::helix_per_turn() }
    fn flory_nu(&self) -> f64 { crate::dynamics::bio::flory_nu() }
    fn codon_redundancy(&self) -> f64 { crate::dynamics::bio::codon_redundancy() }
}

#[pyclass(name = "Arcade")] struct PyArcade;
#[pymethods] impl PyArcade {
    #[new] fn new() -> Self { PyArcade }
    fn lj_cutoff(&self) -> u64 { crate::dynamics::arcade::LJ_CUTOFF }
    fn octree_children(&self) -> u64 { crate::dynamics::arcade::OCTREE_CHILDREN }
    fn fixed_bits(&self) -> u64 { crate::dynamics::arcade::FIXED_BITS }
    fn lod_levels(&self) -> u64 { crate::dynamics::arcade::LOD_LEVELS }
    fn fast_alpha_inv(&self) -> u64 { crate::dynamics::arcade::FAST_ALPHA_INV }
    fn wca_cutoff(&self) -> f64 { crate::dynamics::arcade::wca_cutoff() }
    fn bh_theta(&self) -> f64 { crate::dynamics::arcade::bh_theta() }
    fn fixed_resolution(&self) -> f64 { crate::dynamics::arcade::fixed_resolution() }
}

// ══ MODULE REGISTRATION ═════════════════════════════════════

#[pymodule]
fn crystal_toe(m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add("N_W", crate::atoms::N_W)?;
    m.add("N_C", crate::atoms::N_C)?;
    m.add("CHI", crate::atoms::CHI)?;
    m.add("BETA0", crate::atoms::BETA0)?;
    m.add("D1", crate::atoms::D1)?;
    m.add("D2", crate::atoms::D2)?;
    m.add("D3", crate::atoms::D3)?;
    m.add("D4", crate::atoms::D4)?;
    m.add("SIGMA_D", crate::atoms::SIGMA_D)?;
    m.add("SIGMA_D2", crate::atoms::SIGMA_D2)?;
    m.add("GAUSS", crate::atoms::GAUSS)?;
    m.add("TOWER_D", crate::atoms::TOWER_D)?;
    m.add("D_COLOUR", crate::atoms::D_COLOUR)?;
    m.add("D_MIXED", crate::atoms::D_MIXED)?;
    m.add("SHARED_CORE", crate::atoms::SHARED_CORE)?;
    m.add("FERMAT3", crate::atoms::FERMAT3)?;
    m.add("VEV_CRYSTAL", crate::vev::VEV_CRYSTAL)?;
    m.add("M_PL", crate::vev::M_PL)?;

    m.add_class::<PyToe>()?;
    m.add_class::<PyAlgebraState>()?;
    m.add_class::<PyTruth>()?;
    m.add_class::<PyGauge>()?;
    m.add_class::<PyQCD>()?;
    m.add_class::<PyCosmo>()?;
    m.add_class::<PyMixing>()?;
    m.add_class::<PyAlphaProton>()?;
    m.add_class::<PyGravity>()?;
    m.add_class::<PyProtein>()?;
    m.add_class::<PyCrossDomain>()?;
    m.add_class::<PyTower>()?;
    m.add_class::<PyHierarchy>()?;
    m.add_class::<PyClassical>()?;
    m.add_class::<PyGR>()?;
    m.add_class::<PyGW>()?;
    m.add_class::<PyEM>()?;
    m.add_class::<PyFriedmann>()?;
    m.add_class::<PyNBody>()?;
    m.add_class::<PyThermo>()?;
    m.add_class::<PyCFD>()?;
    m.add_class::<PyDecay>()?;
    m.add_class::<PyOptics>()?;
    m.add_class::<PyMD>()?;
    m.add_class::<PyCondensed>()?;
    m.add_class::<PyPlasma>()?;
    m.add_class::<PyQFT>()?;
    m.add_class::<PyRigid>()?;
    m.add_class::<PyChem>()?;
    m.add_class::<PyNuclear>()?;
    m.add_class::<PyAstro>()?;
    m.add_class::<PyQInfo>()?;
    m.add_class::<PyBio>()?;
    m.add_class::<PyArcade>()?;

    m.add_function(wrap_pyfunction!(py_conversion_factor, m)?)?;
    m.add_function(wrap_pyfunction!(py_hologron_potential, m)?)?;
    m.add_function(wrap_pyfunction!(py_kappa, m)?)?;
    Ok(())
}

#[pyfunction] fn py_conversion_factor() -> f64 { crate::vev::conversion_factor() }
#[pyfunction] fn py_hologron_potential(l: f64) -> f64 { crate::monad::hologron_potential(l) }
#[pyfunction] fn py_kappa() -> f64 { crate::atoms::kappa() }
