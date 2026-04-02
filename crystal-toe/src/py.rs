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

#[pyclass(name = "Classical")] struct PyClassical;
#[pymethods] impl PyClassical {
    #[new] fn new() -> Self { PyClassical }
    fn spatial_dim(&self) -> u64 { crate::dynamics::classical::SPATIAL_DIM }
    fn phase_space_dim(&self) -> u64 { crate::dynamics::classical::PHASE_SPACE_DIM }
    fn force_exponent(&self) -> u64 { crate::dynamics::classical::FORCE_EXPONENT }
    fn verlet_step(&self, x: f64, v: f64, a: f64, dt: f64) -> (f64, f64) { crate::dynamics::classical::verlet_step(x, v, a, dt) }
    fn gravitational_accel(&self, m: f64, r: f64) -> f64 { crate::dynamics::classical::gravitational_accel(m, r) }
    fn kepler_period(&self, a: f64, m: f64) -> f64 { crate::dynamics::classical::kepler_period(a, m) }
}

#[pyclass(name = "GR")] struct PyGR;
#[pymethods] impl PyGR {
    #[new] fn new() -> Self { PyGR }
    fn isco_factor(&self) -> u64 { crate::dynamics::gr::ISCO_FACTOR }
    fn precession_factor(&self) -> u64 { crate::dynamics::gr::PRECESSION_FACTOR }
    fn bending_factor(&self) -> u64 { crate::dynamics::gr::BENDING_FACTOR }
    fn photon_sphere(&self) -> u64 { crate::dynamics::gr::PHOTON_SPHERE }
    fn schwarzschild_metric(&self, r: f64, rs: f64) -> f64 { crate::dynamics::gr::schwarzschild_metric(r, rs) }
    fn perihelion_precession(&self, gm: f64, a: f64, e: f64) -> f64 { crate::dynamics::gr::perihelion_precession(gm, a, e) }
    fn light_deflection(&self, gm: f64, b: f64) -> f64 { crate::dynamics::gr::light_deflection(gm, b) }
    fn gravitational_redshift(&self, rs: f64, r: f64) -> f64 { crate::dynamics::gr::gravitational_redshift(rs, r) }
}

#[pyclass(name = "GW")] struct PyGW;
#[pymethods] impl PyGW {
    #[new] fn new() -> Self { PyGW }
    fn peters_coefficient(&self) -> f64 { crate::dynamics::gw::peters_coefficient() }
    fn chirp_exponent(&self) -> f64 { crate::dynamics::gw::chirp_exponent() }
    fn gw_polarizations(&self) -> u64 { crate::dynamics::gw::GW_POLARIZATIONS }
    fn chirp_mass(&self, m1: f64, m2: f64) -> f64 { crate::dynamics::gw::chirp_mass(m1, m2) }
    fn orbital_decay_rate(&self, m1: f64, m2: f64, a: f64) -> f64 { crate::dynamics::gw::orbital_decay_rate(m1, m2, a) }
}

#[pyclass(name = "EM")] struct PyEM;
#[pymethods] impl PyEM {
    #[new] fn new() -> Self { PyEM }
    fn em_components(&self) -> u64 { crate::dynamics::em::EM_COMPONENTS }
    fn maxwell_equations(&self) -> u64 { crate::dynamics::em::MAXWELL_EQUATIONS }
    fn polarization_states(&self) -> u64 { crate::dynamics::em::POLARIZATION_STATES }
    fn larmor_power(&self, q: f64, a: f64) -> f64 { crate::dynamics::em::larmor_power(q, a) }
    fn coulomb_force(&self, q1: f64, q2: f64, r: f64) -> f64 { crate::dynamics::em::coulomb_force(q1, q2, r) }
}

#[pyclass(name = "Friedmann")] struct PyFriedmann;
#[pymethods] impl PyFriedmann {
    #[new] fn new() -> Self { PyFriedmann }
    fn omega_lambda(&self) -> f64 { crate::dynamics::friedmann::omega_lambda() }
    fn omega_matter(&self) -> f64 { crate::dynamics::friedmann::omega_matter() }
    fn omega_baryon(&self) -> f64 { crate::dynamics::friedmann::omega_baryon() }
    fn hubble_parameter(&self, a: f64) -> f64 { crate::dynamics::friedmann::hubble_parameter(a) }
    fn deceleration_parameter(&self) -> f64 { crate::dynamics::friedmann::deceleration_parameter() }
}

#[pyclass(name = "NBody")] struct PyNBody;
#[pymethods] impl PyNBody {
    #[new] fn new() -> Self { PyNBody }
    fn octree_children(&self) -> u64 { crate::dynamics::nbody::OCTREE_CHILDREN }
    fn should_open_node(&self, size: f64, dist: f64) -> bool { crate::dynamics::nbody::should_open_node(size, dist) }
}

#[pyclass(name = "Thermo")] struct PyThermo;
#[pymethods] impl PyThermo {
    #[new] fn new() -> Self { PyThermo }
    fn lj_attract(&self) -> u64 { crate::dynamics::thermo::LJ_ATTRACT }
    fn lj_repel(&self) -> u64 { crate::dynamics::thermo::LJ_REPEL }
    fn lj_potential(&self, r: f64, sigma: f64, eps: f64) -> f64 { crate::dynamics::thermo::lj_potential(r, sigma, eps) }
    fn maxwell_speed_rms(&self, kt: f64, m: f64) -> f64 { crate::dynamics::thermo::maxwell_speed_rms(kt, m) }
    fn equipartition_energy(&self, dof: u64, kt: f64) -> f64 { crate::dynamics::thermo::equipartition_energy(dof, kt) }
}

#[pyclass(name = "CFD")] struct PyCFD;
#[pymethods] impl PyCFD {
    #[new] fn new() -> Self { PyCFD }
    fn d2q9_velocities(&self) -> u64 { crate::dynamics::cfd::D2Q9_VELOCITIES }
    fn stokes_drag(&self) -> u64 { crate::dynamics::cfd::STOKES_DRAG }
    fn reynolds_number(&self, rho: f64, v: f64, l: f64, mu: f64) -> f64 { crate::dynamics::cfd::reynolds_number(rho, v, l, mu) }
    fn kolmogorov_spectrum(&self, k: f64, eps: f64) -> f64 { crate::dynamics::cfd::kolmogorov_spectrum(k, eps) }
}

#[pyclass(name = "Decay")] struct PyDecay;
#[pymethods] impl PyDecay {
    #[new] fn new() -> Self { PyDecay }
    fn beta_factor(&self) -> u64 { crate::dynamics::decay::BETA_FACTOR }
    fn fermi_golden_rule(&self, me_sq: f64, dos: f64) -> f64 { crate::dynamics::decay::fermi_golden_rule(me_sq, dos) }
    fn beta_decay_rate(&self, gf: f64, energy: f64) -> f64 { crate::dynamics::decay::beta_decay_rate(gf, energy) }
}

#[pyclass(name = "Optics")] struct PyOptics;
#[pymethods] impl PyOptics {
    #[new] fn new() -> Self { PyOptics }
    fn n_water(&self) -> f64 { crate::dynamics::optics::n_water() }
    fn n_glass(&self) -> f64 { crate::dynamics::optics::n_glass() }
    fn n_diamond(&self) -> f64 { crate::dynamics::optics::n_diamond() }
    fn rayleigh_lambda_exp(&self) -> u64 { crate::dynamics::optics::RAYLEIGH_LAMBDA_EXP }
    fn planck_lambda_exp(&self) -> u64 { crate::dynamics::optics::PLANCK_LAMBDA_EXP }
    fn snell(&self, n1: f64, theta1: f64, n2: f64) -> f64 { crate::dynamics::optics::snell(n1, theta1, n2) }
    fn brewster_angle(&self, n1: f64, n2: f64) -> f64 { crate::dynamics::optics::brewster_angle(n1, n2) }
}

#[pyclass(name = "MD")] struct PyMD;
#[pymethods] impl PyMD {
    #[new] fn new() -> Self { PyMD }
    fn tetrahedral_angle_deg(&self) -> f64 { crate::dynamics::md::tetrahedral_angle().to_degrees() }
    fn water_angle_deg(&self) -> f64 { crate::dynamics::md::water_angle().to_degrees() }
    fn helix_per_turn(&self) -> f64 { crate::dynamics::md::helix_per_turn() }
    fn flory_nu(&self) -> f64 { crate::dynamics::md::flory_nu() }
    fn amino_acids(&self) -> u64 { crate::dynamics::md::AMINO_ACIDS }
    fn dna_bases(&self) -> u64 { crate::dynamics::md::DNA_BASES }
    fn lj_force(&self, r: f64, sigma: f64, eps: f64) -> f64 { crate::dynamics::md::lj_force(r, sigma, eps) }
}

#[pyclass(name = "Condensed")] struct PyCondensed;
#[pymethods] impl PyCondensed {
    #[new] fn new() -> Self { PyCondensed }
    fn ising_z_square(&self) -> u64 { crate::dynamics::condensed::ISING_Z_SQUARE }
    fn onsager_tc(&self) -> f64 { crate::dynamics::condensed::onsager_tc() }
    fn bcs_gap_ratio(&self) -> f64 { crate::dynamics::condensed::bcs_gap_ratio() }
    fn ising_magnetization(&self, t: f64) -> f64 { crate::dynamics::condensed::ising_magnetization(t) }
}

#[pyclass(name = "Plasma")] struct PyPlasma;
#[pymethods] impl PyPlasma {
    #[new] fn new() -> Self { PyPlasma }
    fn mhd_states(&self) -> u64 { crate::dynamics::plasma::MHD_STATES }
    fn wave_types(&self) -> u64 { crate::dynamics::plasma::WAVE_TYPES }
    fn propagating_modes(&self) -> u64 { crate::dynamics::plasma::PROPAGATING_MODES }
    fn alfven_speed(&self, b: f64, rho: f64) -> f64 { crate::dynamics::plasma::alfven_speed(b, rho) }
    fn plasma_beta(&self, p: f64, b: f64) -> f64 { crate::dynamics::plasma::plasma_beta(p, b) }
    fn cyclotron_frequency(&self, q: f64, b: f64, m: f64) -> f64 { crate::dynamics::plasma::cyclotron_frequency(q, b, m) }
    fn debye_length(&self, kt: f64, n: f64, q: f64) -> f64 { crate::dynamics::plasma::debye_length(kt, n, q) }
}

#[pyclass(name = "QFT")] struct PyQFT;
#[pymethods] impl PyQFT {
    #[new] fn new() -> Self { PyQFT }
    fn spacetime_dim(&self) -> u64 { crate::dynamics::qft::SPACETIME_DIM }
    fn lorentz_generators(&self) -> u64 { crate::dynamics::qft::LORENTZ_GEN }
    fn dirac_gammas(&self) -> u64 { crate::dynamics::qft::DIRAC_GAMMAS }
    fn photon_pol(&self) -> u64 { crate::dynamics::qft::PHOTON_POL }
    fn gluon_colours(&self) -> u64 { crate::dynamics::qft::GLUON_COLOURS }
    fn qcd_beta0(&self) -> u64 { crate::dynamics::qft::QCD_BETA0 }
    fn one_loop_factor(&self) -> u64 { crate::dynamics::qft::ONE_LOOP_FACTOR }
    fn sigma_ee_mumu(&self, sqrt_s: f64) -> f64 { crate::dynamics::qft::sigma_ee_mumu(sqrt_s) }
    fn thomson_cs(&self) -> f64 { crate::dynamics::qft::thomson_cs() }
    fn alpha_qcd(&self, lambda: f64, q: f64) -> f64 { crate::dynamics::qft::alpha_qcd(lambda, q) }
}

#[pyclass(name = "Rigid")] struct PyRigid;
#[pymethods] impl PyRigid {
    #[new] fn new() -> Self { PyRigid }
    fn quat_components(&self) -> u64 { crate::dynamics::rigid::QUAT_COMPONENTS }
    fn inertia_indep(&self) -> u64 { crate::dynamics::rigid::INERTIA_INDEP }
    fn rigid_dof(&self) -> u64 { crate::dynamics::rigid::RIGID_DOF }
    fn euler_angles(&self) -> u64 { crate::dynamics::rigid::EULER_ANGLES }
    fn i_sphere(&self, m: f64, r: f64) -> f64 { crate::dynamics::rigid::i_sphere(m, r) }
    fn i_rod(&self, m: f64, l: f64) -> f64 { crate::dynamics::rigid::i_rod(m, l) }
    fn i_disk(&self, m: f64, r: f64) -> f64 { crate::dynamics::rigid::i_disk(m, r) }
    fn i_shell(&self, m: f64, r: f64) -> f64 { crate::dynamics::rigid::i_shell(m, r) }
    fn i_sphere_factor(&self) -> f64 { crate::dynamics::rigid::i_sphere_factor() }
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
