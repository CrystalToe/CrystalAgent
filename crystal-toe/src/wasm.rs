// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// wasm.rs — COMPLETE WebAssembly bindings for crystal_toe
// EVERYTHING exposed. Every module. Every function. 100%.
//
// Build: wasm-pack build --target web --features wasm

use wasm_bindgen::prelude::*;
use serde::Serialize;

fn to_js<T: Serialize>(val: &T) -> JsValue {
    serde_wasm_bindgen::to_value(val).unwrap_or(JsValue::NULL)
}

#[derive(Serialize)] struct SelfTestResult { pass: usize, total: usize, msgs: Vec<String> }

// ══════════════════════════════════════════════════════════════
// TOE
// ══════════════════════════════════════════════════════════════
#[wasm_bindgen] pub struct WasmToe { inner: crate::toe::Toe }
#[wasm_bindgen] impl WasmToe {
    #[wasm_bindgen(constructor)] pub fn new(vev: Option<f64>) -> Self {
        WasmToe { inner: match vev { Some(v) => crate::toe::Toe::with_vev(v), None => crate::toe::Toe::new() } }
    }
    pub fn to_pdg(&self) -> WasmToe { WasmToe { inner: self.inner.to_pdg() } }
    pub fn n_w(&self) -> u64 { crate::atoms::N_W }
    pub fn n_c(&self) -> u64 { crate::atoms::N_C }
    pub fn chi(&self) -> u64 { crate::atoms::CHI }
    pub fn beta0(&self) -> u64 { crate::atoms::BETA0 }
    pub fn sigma_d(&self) -> u64 { crate::atoms::SIGMA_D }
    pub fn tower_d(&self) -> u64 { crate::atoms::TOWER_D }
    pub fn d_colour(&self) -> u64 { crate::atoms::D_COLOUR }
    pub fn gauss(&self) -> u64 { crate::atoms::GAUSS }
    pub fn vev(&self) -> f64 { self.inner.vev() }
    pub fn alpha(&self) -> f64 { self.inner.alpha() }
    pub fn alpha_inv(&self) -> f64 { self.inner.alpha_inv() }
    pub fn sin2_theta_w(&self) -> f64 { self.inner.sin2_theta_w() }
    pub fn proton_mass(&self) -> f64 { self.inner.proton_mass() }
    pub fn electron_mass(&self) -> f64 { self.inner.electron_mass() }
    pub fn higgs_mass(&self) -> f64 { self.inner.higgs_mass() }
    pub fn w_mass(&self) -> f64 { self.inner.w_mass() }
    pub fn z_mass(&self) -> f64 { self.inner.z_mass() }
}

// ══════════════════════════════════════════════════════════════
// CHEM — full
// ══════════════════════════════════════════════════════════════
#[wasm_bindgen] pub struct WasmChem;
#[wasm_bindgen] impl WasmChem {
    #[wasm_bindgen(constructor)] pub fn new() -> Self { WasmChem }
    pub fn s_capacity(&self) -> u64 { crate::dynamics::chem::S_CAPACITY }
    pub fn p_capacity(&self) -> u64 { crate::dynamics::chem::P_CAPACITY }
    pub fn d_capacity(&self) -> u64 { crate::dynamics::chem::D_CAPACITY }
    pub fn f_capacity(&self) -> u64 { crate::dynamics::chem::F_CAPACITY }
    pub fn subshell_capacity(&self, l: u64) -> u64 { crate::dynamics::chem::subshell_capacity(l) }
    pub fn shell_capacity(&self, n: u64) -> u64 { crate::dynamics::chem::shell_capacity(n) }
    pub fn sp3_angle_deg(&self) -> f64 { crate::dynamics::chem::sp3_angle_deg() }
    pub fn sp2_angle_deg(&self) -> f64 { crate::dynamics::chem::sp2_angle_deg() }
    pub fn water_angle_deg(&self) -> f64 { crate::dynamics::chem::water_angle_deg() }
    pub fn alpha_em(&self) -> f64 { crate::dynamics::chem::alpha_em() }
    pub fn hartree_ev(&self) -> f64 { crate::dynamics::chem::hartree_ev() }
    pub fn bohr_radius(&self) -> f64 { crate::dynamics::chem::bohr_radius() }
    pub fn rydberg_ev(&self) -> f64 { crate::dynamics::chem::rydberg_ev() }
    pub fn eps_vdw(&self) -> f64 { crate::dynamics::chem::eps_vdw() }
    pub fn e_hbond(&self) -> f64 { crate::dynamics::chem::e_hbond() }
    pub fn kt_300(&self) -> f64 { crate::dynamics::chem::kt_300() }
    pub fn vdw_kt_ratio(&self) -> f64 { crate::dynamics::chem::vdw_kt_ratio() }
    pub fn arrhenius(&self, ea: f64, kt: f64) -> f64 { crate::dynamics::chem::arrhenius(ea, kt) }
    pub fn arrhenius_bio(&self, ea: f64) -> f64 { crate::dynamics::chem::arrhenius_bio(ea) }
    pub fn noble_gases(&self) -> JsValue { to_js(&crate::dynamics::chem::noble_gases()) }
    pub fn neutral_ph(&self) -> u64 { crate::dynamics::chem::NEUTRAL_PH }
    pub fn dielectric_protein(&self) -> u64 { crate::dynamics::chem::DIELECTRIC_PROTEIN }
    pub fn period_lengths(&self) -> JsValue { to_js(&crate::dynamics::chem::period_lengths()) }
    pub fn self_test(&self) -> JsValue { let (p,t,m)=crate::dynamics::chem::self_test(); to_js(&SelfTestResult{pass:p,total:t,msgs:m}) }
}

// ══════════════════════════════════════════════════════════════
// NUCLEAR — full
// ══════════════════════════════════════════════════════════════
#[wasm_bindgen] pub struct WasmNuclear;
#[wasm_bindgen] impl WasmNuclear {
    #[wasm_bindgen(constructor)] pub fn new() -> Self { WasmNuclear }
    pub fn magic_numbers(&self) -> JsValue { to_js(&crate::dynamics::nuclear::magic_numbers()) }
    pub fn iron_peak(&self) -> u64 { crate::dynamics::nuclear::IRON_PEAK_A }
    pub fn isospin_states(&self) -> u64 { crate::dynamics::nuclear::ISOSPIN_STATES }
    pub fn deuteron_a(&self) -> u64 { crate::dynamics::nuclear::DEUTERON_A }
    pub fn alpha_particle(&self) -> u64 { crate::dynamics::nuclear::ALPHA_PARTICLE }
    pub fn binding_energy(&self, a: u32, z: u32) -> f64 { crate::dynamics::nuclear::binding_energy(a,z) }
    pub fn binding_per_nucleon(&self, a: u32, z: u32) -> f64 { crate::dynamics::nuclear::binding_per_nucleon(a,z) }
    pub fn optimal_z(&self, a: u32) -> u32 { crate::dynamics::nuclear::optimal_z(a) }
    pub fn nuclear_radius(&self, a: u32) -> f64 { crate::dynamics::nuclear::nuclear_radius(a) }
    pub fn nuclear_volume(&self, a: u32) -> f64 { crate::dynamics::nuclear::nuclear_volume(a) }
    pub fn binding_curve(&self, max_a: u32) -> JsValue { to_js(&crate::dynamics::nuclear::binding_curve(max_a)) }
    pub fn peak_nucleus(&self, max_a: u32) -> JsValue { to_js(&crate::dynamics::nuclear::peak_nucleus(max_a)) }
    pub fn self_test(&self) -> JsValue { let (p,t,m)=crate::dynamics::nuclear::self_test(); to_js(&SelfTestResult{pass:p,total:t,msgs:m}) }
}

// ══════════════════════════════════════════════════════════════
// ASTRO — full
// ══════════════════════════════════════════════════════════════
#[wasm_bindgen] pub struct WasmAstro;
#[wasm_bindgen] impl WasmAstro {
    #[wasm_bindgen(constructor)] pub fn new() -> Self { WasmAstro }
    pub fn schwarz(&self) -> u64 { crate::dynamics::astro::SCHWARZ }
    pub fn hawking(&self) -> u64 { crate::dynamics::astro::HAWKING }
    pub fn sb_denom(&self) -> u64 { crate::dynamics::astro::SB_DENOM }
    pub fn eddington(&self) -> u64 { crate::dynamics::astro::EDDINGTON }
    pub fn virial(&self) -> u64 { crate::dynamics::astro::VIRIAL }
    pub fn lane_emden(&self, n: f64) -> JsValue { to_js(&crate::dynamics::astro::lane_emden(n)) }
    pub fn lane_emden_profile(&self, n: f64) -> JsValue { to_js(&crate::dynamics::astro::lane_emden_profile(n)) }
    pub fn lane_emden_nr(&self) -> JsValue { to_js(&crate::dynamics::astro::lane_emden_nr()) }
    pub fn lane_emden_rel(&self) -> JsValue { to_js(&crate::dynamics::astro::lane_emden_rel()) }
    pub fn ms_luminosity(&self, m: f64) -> f64 { crate::dynamics::astro::ms_luminosity(m) }
    pub fn ms_lifetime(&self, m: f64) -> f64 { crate::dynamics::astro::ms_lifetime(m) }
    pub fn schwarzschild_radius(&self, m: f64) -> f64 { crate::dynamics::astro::schwarzschild_radius(m) }
    pub fn hawking_temperature(&self, m: f64) -> f64 { crate::dynamics::astro::hawking_temperature(m) }
    pub fn ms_exponent_identity(&self) -> bool { crate::dynamics::astro::ms_exponent_identity() }
    pub fn hawking_eddington_product(&self) -> u64 { crate::dynamics::astro::hawking_eddington_product() }
    pub fn self_test(&self) -> JsValue { let (p,t,m)=crate::dynamics::astro::self_test(); to_js(&SelfTestResult{pass:p,total:t,msgs:m}) }
}

// ══════════════════════════════════════════════════════════════
// QINFO — full
// ══════════════════════════════════════════════════════════════
#[wasm_bindgen] pub struct WasmQInfo;
#[wasm_bindgen] impl WasmQInfo {
    #[wasm_bindgen(constructor)] pub fn new() -> Self { WasmQInfo }
    pub fn qubit_states(&self) -> u64 { crate::dynamics::qinfo::QUBIT_STATES }
    pub fn pauli_matrices(&self) -> u64 { crate::dynamics::qinfo::PAULI_MATRICES }
    pub fn pauli_group(&self) -> u64 { crate::dynamics::qinfo::PAULI_GROUP }
    pub fn bell_states(&self) -> u64 { crate::dynamics::qinfo::BELL_STATES }
    pub fn toffoli(&self) -> u64 { crate::dynamics::qinfo::TOFFOLI }
    pub fn steane_n(&self) -> u64 { crate::dynamics::qinfo::STEANE_N }
    pub fn steane_d(&self) -> u64 { crate::dynamics::qinfo::STEANE_D }
    pub fn steane_corrects(&self) -> u64 { crate::dynamics::qinfo::steane_corrects() }
    pub fn shor_n(&self) -> u64 { crate::dynamics::qinfo::SHOR_N }
    pub fn mera_bond(&self) -> u64 { crate::dynamics::qinfo::MERA_BOND }
    pub fn mera_depth(&self) -> u64 { crate::dynamics::qinfo::MERA_DEPTH }
    pub fn bell_entropy(&self) -> f64 { crate::dynamics::qinfo::bell_entropy() }
    pub fn mera_link_entropy(&self) -> f64 { crate::dynamics::qinfo::mera_link_entropy() }
    pub fn hamming_check(&self) -> bool { crate::dynamics::qinfo::hamming_check() }
    pub fn coprimality_check(&self) -> bool { crate::dynamics::qinfo::coprimality_check() }
    pub fn heyting_meet(&self, a: f64, b: f64) -> f64 { crate::dynamics::qinfo::heyting_meet(a,b) }
    pub fn heyting_join(&self, a: f64, b: f64) -> f64 { crate::dynamics::qinfo::heyting_join(a,b) }
    pub fn tomography_min(&self) -> u64 { crate::dynamics::qinfo::tomography_min() }
    pub fn self_test(&self) -> JsValue { let (p,t,m)=crate::dynamics::qinfo::self_test(); to_js(&SelfTestResult{pass:p,total:t,msgs:m}) }
}

// ══════════════════════════════════════════════════════════════
// BIO — full
// ══════════════════════════════════════════════════════════════
#[wasm_bindgen] pub struct WasmBio;
#[wasm_bindgen] impl WasmBio {
    #[wasm_bindgen(constructor)] pub fn new() -> Self { WasmBio }
    pub fn dna_bases(&self) -> u64 { crate::dynamics::bio::DNA_BASES }
    pub fn codon_len(&self) -> u64 { crate::dynamics::bio::CODON_LEN }
    pub fn total_codons(&self) -> u64 { crate::dynamics::bio::TOTAL_CODONS }
    pub fn amino_acids(&self) -> u64 { crate::dynamics::bio::AMINO_ACIDS }
    pub fn stop_codons(&self) -> u64 { crate::dynamics::bio::STOP_CODONS }
    pub fn sense_codons(&self) -> u64 { crate::dynamics::bio::SENSE_CODONS }
    pub fn bp_per_turn(&self) -> u64 { crate::dynamics::bio::BP_PER_TURN }
    pub fn lipid_layers(&self) -> u64 { crate::dynamics::bio::LIPID_LAYERS }
    pub fn helix_per_turn(&self) -> f64 { crate::dynamics::bio::helix_per_turn() }
    pub fn flory_nu(&self) -> f64 { crate::dynamics::bio::flory_nu() }
    pub fn kleiber_exp(&self) -> f64 { crate::dynamics::bio::kleiber_exp() }
    pub fn heart_rate_exp(&self) -> f64 { crate::dynamics::bio::heart_rate_exp() }
    pub fn surface_exp(&self) -> f64 { crate::dynamics::bio::surface_exp() }
    pub fn codon_redundancy(&self) -> f64 { crate::dynamics::bio::codon_redundancy() }
    pub fn kleiber(&self, m: f64) -> f64 { crate::dynamics::bio::kleiber(m) }
    pub fn heart_rate(&self, m: f64) -> f64 { crate::dynamics::bio::heart_rate(m) }
    pub fn lifespan(&self, m: f64) -> f64 { crate::dynamics::bio::lifespan(m) }
    pub fn constant_heartbeats(&self) -> bool { crate::dynamics::bio::constant_heartbeats() }
    pub fn self_test(&self) -> JsValue { let (p,t,m)=crate::dynamics::bio::self_test(); to_js(&SelfTestResult{pass:p,total:t,msgs:m}) }
}

// ══════════════════════════════════════════════════════════════
// ARCADE — full
// ══════════════════════════════════════════════════════════════
#[wasm_bindgen] pub struct WasmArcade;
#[wasm_bindgen] impl WasmArcade {
    #[wasm_bindgen(constructor)] pub fn new() -> Self { WasmArcade }
    pub fn lj_cutoff(&self) -> u64 { crate::dynamics::arcade::LJ_CUTOFF }
    pub fn octree_children(&self) -> u64 { crate::dynamics::arcade::OCTREE_CHILDREN }
    pub fn fixed_bits(&self) -> u64 { crate::dynamics::arcade::FIXED_BITS }
    pub fn lod_levels(&self) -> u64 { crate::dynamics::arcade::LOD_LEVELS }
    pub fn fast_alpha_inv(&self) -> u64 { crate::dynamics::arcade::FAST_ALPHA_INV }
    pub fn bh_theta(&self) -> f64 { crate::dynamics::arcade::bh_theta() }
    pub fn wca_cutoff(&self) -> f64 { crate::dynamics::arcade::wca_cutoff() }
    pub fn fixed_resolution(&self) -> f64 { crate::dynamics::arcade::fixed_resolution() }
    pub fn mean_field_error(&self) -> f64 { crate::dynamics::arcade::mean_field_error() }
    pub fn onsager_tc(&self) -> f64 { crate::dynamics::arcade::onsager_tc() }
    pub fn verify_alpha_inv(&self) -> bool { crate::dynamics::arcade::verify_alpha_inv() }
    pub fn lj_exact(&self, r: f64) -> f64 { crate::dynamics::arcade::lj_exact(r) }
    pub fn lj_arcade(&self, r: f64) -> f64 { crate::dynamics::arcade::lj_arcade(r) }
    pub fn lj_wca(&self, r: f64) -> f64 { crate::dynamics::arcade::lj_wca(r) }
    pub fn euler_step(&self, x: f64, v: f64, dt: f64) -> f64 { crate::dynamics::arcade::euler_step(x,v,dt) }
    pub fn verlet_step(&self, x: f64, v: f64, a: f64, dt: f64) -> f64 { crate::dynamics::arcade::verlet_step(x,v,a,dt) }
    pub fn fast_inv_sqrt(&self, x: f64) -> f64 { crate::dynamics::arcade::fast_inv_sqrt(x) }
    pub fn fixed_round_trip(&self, x: f64) -> f64 { crate::dynamics::arcade::fixed_round_trip(x) }
    pub fn lj_scan(&self, r_min: f64, r_max: f64, n: usize) -> JsValue {
        let dr=(r_max-r_min)/n as f64;
        let d:Vec<[f64;4]>=(0..n).map(|i|{let r=r_min+i as f64*dr;
            [r,crate::dynamics::arcade::lj_exact(r),crate::dynamics::arcade::lj_arcade(r),crate::dynamics::arcade::lj_wca(r)]}).collect();
        to_js(&d)
    }
    pub fn self_test(&self) -> JsValue { let (p,t,m)=crate::dynamics::arcade::self_test(); to_js(&SelfTestResult{pass:p,total:t,msgs:m}) }
}

// ══════════════════════════════════════════════════════════════
// CLASSICAL — Kepler, Hohmann, slingshot, conservation
// ══════════════════════════════════════════════════════════════
#[wasm_bindgen] pub struct WasmClassical;
#[wasm_bindgen] impl WasmClassical {
    #[wasm_bindgen(constructor)] pub fn new() -> Self { WasmClassical }
    pub fn spatial_dim(&self) -> u64 { crate::dynamics::classical::SPATIAL_DIM }
    pub fn phase_space_dim(&self) -> u64 { crate::dynamics::classical::PHASE_SPACE_DIM }
    pub fn force_exponent(&self) -> u64 { crate::dynamics::classical::FORCE_EXPONENT }
    pub fn kepler_period(&self, a: f64, gm: f64) -> f64 { crate::dynamics::classical::kepler_period(a,gm) }
    pub fn vis_viva(&self, gm: f64, r: f64, a: f64) -> f64 { crate::dynamics::classical::vis_viva(gm,r,a) }
    pub fn escape_velocity(&self, gm: f64, r: f64) -> f64 { crate::dynamics::classical::escape_velocity(gm,r) }
    pub fn hohmann_transfer(&self, gm: f64, r1: f64, r2: f64) -> JsValue { to_js(&crate::dynamics::classical::hohmann_transfer(gm,r1,r2)) }
    /// Evolve circular orbit and return [[x,y],...] for D3
    pub fn kepler_orbit(&self, gm: f64, r: f64, dt: f64, n: usize) -> JsValue {
        let ps0 = crate::dynamics::classical::satellite_circular(gm, r).0;
        let accel = move |p: &crate::dynamics::classical::Vec3| crate::dynamics::classical::newton_accel(gm, p);
        let traj = crate::dynamics::classical::evolve(dt, &accel, n, &ps0);
        let pts: Vec<[f64;2]> = traj.iter().map(|p| [p.pos.x, p.pos.y]).collect();
        to_js(&pts)
    }
    /// Slingshot trajectory [[x,y,speed],...] 
    pub fn slingshot_traj(&self, gm_star: f64, gm_planet: f64, r_planet: f64,
                          r_ship: f64, v_ship: f64, dt: f64, n: usize) -> JsValue {
        let planet_pos = crate::dynamics::classical::Vec3::new(r_planet, 0.0, 0.0);
        let sc0 = crate::dynamics::classical::PhaseState::new(
            crate::dynamics::classical::Vec3::new(-r_ship, 0.0, 0.0),
            crate::dynamics::classical::Vec3::new(v_ship, 0.0, 0.0),
        );
        let traj = crate::dynamics::classical::slingshot(gm_star, gm_planet, planet_pos, &sc0, dt, n);
        let pts: Vec<[f64;3]> = traj.iter().map(|p| [p.pos.x, p.pos.y, p.vel.norm()]).collect();
        to_js(&pts)
    }
}

// ══════════════════════════════════════════════════════════════
// GR — Schwarzschild geodesics, precession, light bending
// ══════════════════════════════════════════════════════════════
#[wasm_bindgen] pub struct WasmGR;
#[wasm_bindgen] impl WasmGR {
    #[wasm_bindgen(constructor)] pub fn new() -> Self { WasmGR }
    pub fn schwarz_factor(&self) -> u64 { crate::dynamics::gr::SCHWARZ_FACTOR }
    pub fn isco_factor(&self) -> u64 { crate::dynamics::gr::ISCO_FACTOR }
    pub fn precession_factor(&self) -> u64 { crate::dynamics::gr::PRECESSION_FACTOR }
    pub fn bending_factor(&self) -> u64 { crate::dynamics::gr::BENDING_FACTOR }
    pub fn photon_sphere(&self) -> u64 { crate::dynamics::gr::PHOTON_SPHERE }
    pub fn spacetime_dim(&self) -> u64 { crate::dynamics::gr::SPACETIME_DIM }
    pub fn schwarzschild_r(&self, gm: f64) -> f64 { crate::dynamics::gr::schwarzschild_r(gm) }
    pub fn isco_radius(&self, gm: f64) -> f64 { crate::dynamics::gr::isco_radius(gm) }
    pub fn isco_energy(&self) -> f64 { crate::dynamics::gr::isco_energy() }
    pub fn gravitational_redshift(&self, rs: f64, r: f64) -> f64 { crate::dynamics::gr::gravitational_redshift(rs,r) }
    pub fn precession_analytic(&self, rs: f64, a: f64, e: f64) -> f64 { crate::dynamics::gr::precession_analytic(rs,a,e) }
    pub fn light_bending_analytic(&self, rs: f64, b: f64) -> f64 { crate::dynamics::gr::light_bending_analytic(rs,b) }
    pub fn shapiro_delay(&self, gm: f64, r1: f64, r2: f64, b: f64) -> f64 { crate::dynamics::gr::shapiro_delay(gm,r1,r2,b) }
    pub fn v_eff_massive(&self, rs: f64, l: f64, r: f64) -> f64 { crate::dynamics::gr::v_eff_massive(rs,l,r) }
    pub fn v_eff_photon(&self, rs: f64, l: f64, r: f64) -> f64 { crate::dynamics::gr::v_eff_photon(rs,l,r) }
    /// Geodesic orbit [[r,phi],...] for D3 polar plot
    pub fn geodesic(&self, rs: f64, ang_l: f64, energy: f64, dtau: f64, n: usize) -> JsValue {
        let gs0 = crate::dynamics::gr::GRState { r: 20.0*rs, phi: 0.0, vr: -0.01, t: 0.0, tau: 0.0 };
        let traj = crate::dynamics::gr::evolve_gr(dtau, rs, ang_l, energy, n, &gs0);
        let pts: Vec<[f64;2]> = traj.iter().map(|g| [g.r*g.phi.cos(), g.r*g.phi.sin()]).collect();
        to_js(&pts)
    }
    /// Effective potential curve [[r, V_eff],...] for D3
    pub fn veff_curve(&self, rs: f64, l: f64, r_min: f64, r_max: f64, n: usize) -> JsValue {
        let dr = (r_max-r_min)/n as f64;
        let pts: Vec<[f64;2]> = (0..n).map(|i| { let r=r_min+i as f64*dr; [r, crate::dynamics::gr::v_eff_massive(rs,l,r)] }).collect();
        to_js(&pts)
    }
}

// ══════════════════════════════════════════════════════════════
// GW — Gravitational waves, inspiral, chirp
// ══════════════════════════════════════════════════════════════
#[wasm_bindgen] pub struct WasmGW;
#[wasm_bindgen] impl WasmGW {
    #[wasm_bindgen(constructor)] pub fn new() -> Self { WasmGW }
    pub fn polarizations(&self) -> u64 { crate::dynamics::gw::GW_POLARIZATIONS }
    pub fn quadrupole_order(&self) -> u64 { crate::dynamics::gw::QUADRUPOLE_ORDER }
    pub fn peters_coefficient(&self) -> f64 { crate::dynamics::gw::peters_coefficient() }
    pub fn chirp_mass(&self, m1: f64, m2: f64) -> f64 { crate::dynamics::gw::chirp_mass(m1,m2) }
    pub fn gw_power(&self, mu: f64, m: f64, a: f64) -> f64 { crate::dynamics::gw::gw_power(mu,m,a) }
    pub fn gw_frequency(&self, m: f64, a: f64) -> f64 { crate::dynamics::gw::gw_frequency(m,a) }
    pub fn time_to_merger(&self, mc: f64, f: f64) -> f64 { crate::dynamics::gw::time_to_merger(mc,f) }
    pub fn isco_frequency(&self, m: f64) -> f64 { crate::dynamics::gw::isco_frequency(m) }
    /// Inspiral waveform [[t,h+,h×,freq],...] for D3
    pub fn waveform(&self, m1: f64, m2: f64, dist: f64, iota: f64, f0: f64, dt: f64) -> JsValue {
        let wf = crate::dynamics::gw::inspiral_waveform(m1,m2,dist,iota,f0,dt);
        let pts: Vec<[f64;4]> = wf.iter().map(|s| [s.time, s.h_plus, s.h_cross, s.freq]).collect();
        to_js(&pts)
    }
    /// Binary inspiral [[t,a,freq],...] for D3
    pub fn inspiral(&self, m1: f64, m2: f64, a0: f64, dt: f64) -> JsValue {
        let bs = crate::dynamics::gw::integrate_inspiral(m1,m2,a0,dt);
        let pts: Vec<[f64;3]> = bs.iter().map(|s| [s.time, s.a, s.freq]).collect();
        to_js(&pts)
    }
}

// ══════════════════════════════════════════════════════════════
// EM — Yee FDTD
// ══════════════════════════════════════════════════════════════
#[wasm_bindgen] pub struct WasmEM { ey: Vec<f64>, bz: Vec<f64>, time: f64, courant: f64, n_grid: usize, step: usize }
#[wasm_bindgen] impl WasmEM {
    #[wasm_bindgen(constructor)] pub fn new(n_grid: usize, center: f64, width: f64, amp: f64, courant: f64) -> Self {
        let st = crate::dynamics::em::gaussian_pulse(n_grid, center, width, amp);
        WasmEM { ey: st.ey, bz: st.bz, time: 0.0, courant, n_grid, step: 0 }
    }
    pub fn tick(&mut self) {
        let n=self.ey.len();
        let c=self.courant;
        let bz:Vec<f64>=self.bz.iter().enumerate().map(|(i,&b)|b-c*(self.ey[i+1]-self.ey[i])).collect();
        let mut ey=vec![0.0;n]; for i in 1..n-1{ey[i]=self.ey[i]-c*(bz[i]-bz[i-1])}
        self.ey=ey;self.bz=bz;self.time+=c;self.step+=1;
    }
    pub fn advance(&mut self, n: usize) { for _ in 0..n { self.tick(); } }
    pub fn ey_field(&self) -> JsValue { to_js(&self.ey) }
    pub fn bz_field(&self) -> JsValue { to_js(&self.bz) }
    pub fn energy(&self) -> f64 { self.ey.iter().map(|e|e*e).sum::<f64>()/2.0+self.bz.iter().map(|b|b*b).sum::<f64>()/2.0 }
    pub fn current_step(&self) -> usize { self.step }
    pub fn current_time(&self) -> f64 { self.time }
    pub fn em_components(&self) -> u64 { crate::dynamics::em::EM_COMPONENTS }
    pub fn polarization_states(&self) -> u64 { crate::dynamics::em::POLARIZATION_STATES }
    pub fn larmor_power(&self, q: f64, a: f64) -> f64 { crate::dynamics::em::larmor_power(q,a) }
    pub fn rayleigh_sigma(&self, d: f64, l: f64) -> f64 { crate::dynamics::em::rayleigh_sigma(d,l) }
    pub fn stefan_boltzmann_power(&self, t: f64) -> f64 { crate::dynamics::em::stefan_boltzmann_power(t) }
    pub fn planck_radiance(&self, l: f64, t: f64) -> f64 { crate::dynamics::em::planck_radiance(l,t) }
}

// ══════════════════════════════════════════════════════════════
// FRIEDMANN — ΛCDM cosmology
// ══════════════════════════════════════════════════════════════
#[wasm_bindgen] pub struct WasmFriedmann;
#[wasm_bindgen] impl WasmFriedmann {
    #[wasm_bindgen(constructor)] pub fn new() -> Self { WasmFriedmann }
    pub fn omega_lambda(&self) -> f64 { crate::dynamics::friedmann::omega_lambda() }
    pub fn omega_matter(&self) -> f64 { crate::dynamics::friedmann::omega_matter() }
    pub fn omega_baryon(&self) -> f64 { crate::dynamics::friedmann::omega_baryon() }
    pub fn omega_dm(&self) -> f64 { crate::dynamics::friedmann::omega_dm() }
    pub fn dm_baryon_ratio(&self) -> f64 { crate::dynamics::friedmann::dm_baryon_ratio() }
    pub fn h0_crystal(&self) -> f64 { crate::dynamics::friedmann::h0_crystal() }
    pub fn spectral_index(&self) -> f64 { crate::dynamics::friedmann::spectral_index() }
    pub fn cmb_temperature(&self) -> f64 { crate::dynamics::friedmann::cmb_temperature() }
    pub fn age_analytic(&self) -> f64 { crate::dynamics::friedmann::age_analytic() }
    pub fn hubble_norm(&self, a: f64) -> f64 { crate::dynamics::friedmann::hubble_norm(a) }
    pub fn deceleration_param(&self, a: f64) -> f64 { crate::dynamics::friedmann::deceleration_param(a) }
    pub fn comoving_distance(&self, z: f64, n: usize) -> f64 { crate::dynamics::friedmann::comoving_distance(z,n) }
    pub fn luminosity_distance(&self, z: f64, n: usize) -> f64 { crate::dynamics::friedmann::luminosity_distance(z,n) }
    pub fn acceleration_onset(&self) -> f64 { crate::dynamics::friedmann::acceleration_onset(0.001, 0.001, 100000) }
    /// Friedmann evolution [[t,a,z],...] for D3
    pub fn evolve(&self, a_init: f64, a_final: f64, dt: f64, max: usize) -> JsValue {
        let traj = crate::dynamics::friedmann::integrate_friedmann(a_init, a_final, dt, max);
        let pts: Vec<[f64;3]> = traj.iter().map(|s| [s.time, s.a, s.z]).collect();
        to_js(&pts)
    }
}

// ══════════════════════════════════════════════════════════════
// THERMO — LJ gas, MD, equipartition
// ══════════════════════════════════════════════════════════════
#[wasm_bindgen] pub struct WasmThermo;
#[wasm_bindgen] impl WasmThermo {
    #[wasm_bindgen(constructor)] pub fn new() -> Self { WasmThermo }
    pub fn gamma_monatomic(&self) -> f64 { crate::dynamics::thermo::gamma_monatomic() }
    pub fn gamma_diatomic(&self) -> f64 { crate::dynamics::thermo::gamma_diatomic() }
    pub fn carnot_efficiency(&self) -> f64 { crate::dynamics::thermo::carnot_efficiency() }
    pub fn entropy_per_tick(&self) -> f64 { crate::dynamics::thermo::entropy_per_tick() }
    pub fn ideal_gas_gamma(&self, dof: u64) -> f64 { crate::dynamics::thermo::ideal_gas_gamma(dof) }
    pub fn maxwell_speed_rms(&self, kt: f64, m: f64) -> f64 { crate::dynamics::thermo::maxwell_speed_rms(kt,m) }
    pub fn equipartition_energy(&self, dof: u64, kt: f64) -> f64 { crate::dynamics::thermo::equipartition_energy(dof,kt) }
    pub fn lj_potential(&self, eps: f64, sigma: f64, r: f64) -> f64 { crate::dynamics::thermo::lj_potential(eps,sigma,r) }
    pub fn lj_force_mag(&self, eps: f64, sigma: f64, r: f64) -> f64 { crate::dynamics::thermo::lj_force_mag(eps,sigma,r) }
}

// ══════════════════════════════════════════════════════════════
// CFD — Lattice Boltzmann D2Q9
// ══════════════════════════════════════════════════════════════
#[wasm_bindgen] pub struct WasmCFD { st: crate::dynamics::cfd::LBMState, tau: f64, fx: f64 }
#[wasm_bindgen] impl WasmCFD {
    #[wasm_bindgen(constructor)] pub fn new(nx: usize, ny: usize, tau: f64, fx: f64) -> Self {
        WasmCFD { st: crate::dynamics::cfd::lbm_init(nx, ny, 1.0), tau, fx }
    }
    pub fn tick(&mut self) { self.st = crate::dynamics::cfd::lbm_tick(self.tau, self.fx, &self.st); }
    pub fn advance(&mut self, n: usize) { self.st = crate::dynamics::cfd::lbm_evolve(self.tau, self.fx, n, &self.st); }
    pub fn total_mass(&self) -> f64 { crate::dynamics::cfd::total_mass(&self.st) }
    pub fn d2q9_velocities(&self) -> u64 { crate::dynamics::cfd::D2Q9_VELOCITIES }
    pub fn kolmogorov_spectrum(&self, k: f64, eps: f64) -> f64 { crate::dynamics::cfd::kolmogorov_spectrum(k,eps) }
    pub fn reynolds_number(&self, rho: f64, v: f64, l: f64, mu: f64) -> f64 { crate::dynamics::cfd::reynolds_number(rho,v,l,mu) }
    pub fn density_field(&self) -> JsValue { to_js(&crate::dynamics::cfd::density_field(&self.st)) }
    pub fn speed_field(&self) -> JsValue { to_js(&crate::dynamics::cfd::speed_field(&self.st)) }
}

// ══════════════════════════════════════════════════════════════
// DECAY — beta, tunneling, oscillation
// ══════════════════════════════════════════════════════════════
#[wasm_bindgen] pub struct WasmDecay;
#[wasm_bindgen] impl WasmDecay {
    #[wasm_bindgen(constructor)] pub fn new() -> Self { WasmDecay }
    pub fn sin2_theta_w(&self) -> f64 { crate::dynamics::decay::sin2_theta_w() }
    pub fn sin2_theta_12(&self) -> f64 { crate::dynamics::decay::sin2_theta_12() }
    pub fn sin2_theta_23(&self) -> f64 { crate::dynamics::decay::sin2_theta_23() }
    pub fn g_fermi(&self) -> f64 { crate::dynamics::decay::g_fermi() }
    pub fn neutron_lifetime(&self) -> f64 { crate::dynamics::decay::neutron_lifetime() }
    pub fn oscill_prob(&self, sin2_2th: f64, dm2: f64, l_e: f64) -> f64 { crate::dynamics::decay::oscill_prob(sin2_2th,dm2,l_e) }
    pub fn beta_endpoint(&self) -> f64 { crate::dynamics::decay::beta_endpoint() }
    pub fn beta_spectrum_curve(&self, n: usize) -> JsValue {
        let (t,s) = crate::dynamics::decay::beta_spectrum_curve(n);
        let pts: Vec<[f64;2]> = t.iter().zip(s.iter()).map(|(&x,&y)| [x,y]).collect();
        to_js(&pts)
    }
    pub fn fermi_golden_rule(&self, me2: f64, dos: f64) -> f64 { crate::dynamics::decay::fermi_golden_rule(me2,dos) }
}

// ══════════════════════════════════════════════════════════════
// OPTICS — Snell, Fresnel, Planck, Rayleigh
// ══════════════════════════════════════════════════════════════
#[wasm_bindgen] pub struct WasmOptics;
#[wasm_bindgen] impl WasmOptics {
    #[wasm_bindgen(constructor)] pub fn new() -> Self { WasmOptics }
    pub fn n_water(&self) -> f64 { crate::dynamics::optics::n_water() }
    pub fn n_glass(&self) -> f64 { crate::dynamics::optics::n_glass() }
    pub fn n_diamond(&self) -> f64 { crate::dynamics::optics::n_diamond() }
    pub fn snell(&self, n1: f64, n2: f64, th: f64) -> f64 { crate::dynamics::optics::snell(n1,n2,th).unwrap_or(-1.0) }
    pub fn brewster_angle(&self, n1: f64, n2: f64) -> f64 { crate::dynamics::optics::brewster_angle(n1,n2) }
    pub fn fresnel_r(&self, n1: f64, n2: f64, th: f64) -> f64 { crate::dynamics::optics::fresnel_r(n1,n2,th) }
    pub fn normal_reflectance(&self, n1: f64, n2: f64) -> f64 { crate::dynamics::optics::normal_reflectance(n1,n2) }
    pub fn rayleigh_intensity(&self, l0: f64, l: f64) -> f64 { crate::dynamics::optics::rayleigh_intensity(l0,l) }
    pub fn planck_radiance(&self, l: f64, t: f64) -> f64 { crate::dynamics::optics::planck_radiance(l,t) }
    pub fn wien_displacement(&self, t: f64) -> f64 { crate::dynamics::optics::wien_displacement(t) }
    pub fn airy_radius(&self, l: f64, ap: f64) -> f64 { crate::dynamics::optics::airy_radius(l,ap) }
    pub fn sky_blue_ratio(&self) -> f64 { crate::dynamics::optics::sky_blue_ratio() }
    /// Fresnel curves [[theta, rs, rp, R],...] for D3
    pub fn fresnel_curve(&self, n1: f64, n2: f64, n_pts: usize) -> JsValue {
        let (th,rs,rp,r) = crate::dynamics::optics::fresnel_curve(n1,n2,n_pts);
        let pts:Vec<[f64;4]>=th.iter().zip(rs.iter().zip(rp.iter().zip(r.iter()))).map(|(&t,(&s,(&p,&rv)))|[t,s,p,rv]).collect();
        to_js(&pts)
    }
}

// ══════════════════════════════════════════════════════════════
// MD — molecular dynamics, LJ, bond angles
// ══════════════════════════════════════════════════════════════
#[wasm_bindgen] pub struct WasmMD;
#[wasm_bindgen] impl WasmMD {
    #[wasm_bindgen(constructor)] pub fn new() -> Self { WasmMD }
    pub fn tetrahedral_angle(&self) -> f64 { crate::dynamics::md::tetrahedral_angle() }
    pub fn water_angle(&self) -> f64 { crate::dynamics::md::water_angle() }
    pub fn helix_per_turn(&self) -> f64 { crate::dynamics::md::helix_per_turn() }
    pub fn flory_nu(&self) -> f64 { crate::dynamics::md::flory_nu() }
    pub fn lj_potential(&self, r: f64) -> f64 { crate::dynamics::md::lj_potential(r) }
    pub fn lj_dvdr(&self, r: f64) -> f64 { crate::dynamics::md::lj_dvdr(r) }
    pub fn coulomb_potential(&self, q1: f64, q2: f64, r: f64) -> f64 { crate::dynamics::md::coulomb_potential(q1,q2,r) }
    pub fn coulomb_force(&self, q1: f64, q2: f64, r: f64) -> f64 { crate::dynamics::md::coulomb_force(q1,q2,r) }
    /// LJ + force curves [[r, V, F],...] for D3
    pub fn lj_curves(&self, rmin: f64, rmax: f64, n: usize) -> JsValue {
        let (r,v,f) = crate::dynamics::md::lj_curves(rmin, rmax, n);
        let pts: Vec<[f64;3]> = r.iter().zip(v.iter().zip(f.iter())).map(|(&ri,(&vi,&fi))| [ri,vi,fi]).collect();
        to_js(&pts)
    }
    /// 2-body MD vibration [[x1,x2],...] for D3
    pub fn md2_evolve(&self, dt: f64, n: usize) -> JsValue {
        let st = crate::dynamics::md::MD2::new(1.0, 0.0, 1.12, 0.0);
        let (x1, x2) = crate::dynamics::md::md2_evolve(dt, n, &st);
        let pts: Vec<[f64;2]> = x1.iter().zip(x2.iter()).map(|(&a,&b)| [a,b]).collect();
        to_js(&pts)
    }
}

// ══════════════════════════════════════════════════════════════
// CONDENSED — Ising, BCS, phase transitions
// ══════════════════════════════════════════════════════════════
#[wasm_bindgen] pub struct WasmCondensed;
#[wasm_bindgen] impl WasmCondensed {
    #[wasm_bindgen(constructor)] pub fn new() -> Self { WasmCondensed }
    pub fn onsager_tc(&self) -> f64 { crate::dynamics::condensed::onsager_tc() }
    pub fn bcs_ratio(&self) -> f64 { crate::dynamics::condensed::bcs_ratio() }
    pub fn ising_magnetization(&self, t: f64) -> f64 { crate::dynamics::condensed::ising_magnetization(t) }
    pub fn ising_z_square(&self) -> u64 { crate::dynamics::condensed::ISING_Z_SQUARE }
    pub fn ising_z_cubic(&self) -> u64 { crate::dynamics::condensed::ISING_Z_CUBIC }
    /// Ising MC run: returns [[sweep, magnetization],...] for D3
    pub fn ising_run(&self, n: usize, n_sweeps: usize, inv_t: f64, sample: usize) -> JsValue {
        let mut lat = crate::dynamics::condensed::Lattice::new(n, 1);
        let mut seed = 42u64;
        let (mag, _e) = crate::dynamics::condensed::ising_run(&mut lat, n_sweeps, inv_t, &mut seed, sample);
        let pts: Vec<[f64;2]> = mag.iter().enumerate().map(|(i,&m)| [i as f64 * sample as f64, m]).collect();
        to_js(&pts)
    }
}

// ══════════════════════════════════════════════════════════════
// PLASMA — MHD, Alfvén, Debye
// ══════════════════════════════════════════════════════════════
#[wasm_bindgen] pub struct WasmPlasma;
#[wasm_bindgen] impl WasmPlasma {
    #[wasm_bindgen(constructor)] pub fn new() -> Self { WasmPlasma }
    pub fn mhd_states(&self) -> u64 { crate::dynamics::plasma::MHD_STATES }
    pub fn wave_types(&self) -> u64 { crate::dynamics::plasma::WAVE_TYPES }
    pub fn propagating_modes(&self) -> u64 { crate::dynamics::plasma::PROPAGATING_MODES }
    pub fn alfven_speed(&self, b: f64, rho: f64) -> f64 { crate::dynamics::plasma::alfven_speed(b,rho) }
    pub fn plasma_beta(&self, p: f64, b: f64) -> f64 { crate::dynamics::plasma::plasma_beta(p,b) }
    pub fn debye_length(&self, kt: f64, n: f64, q: f64) -> f64 { crate::dynamics::plasma::debye_length(kt,n,q) }
    pub fn cyclotron_frequency(&self, q: f64, b: f64, m: f64) -> f64 { crate::dynamics::plasma::cyclotron_frequency(q,b,m) }
    pub fn larmor_radius(&self, m: f64, v: f64, q: f64, b: f64) -> f64 { crate::dynamics::plasma::larmor_radius(m,v,q,b) }
    pub fn mhd_energy(&self) -> f64 {
        let st = crate::dynamics::plasma::mhd_pulse(100, 0.5, 0.1);
        crate::dynamics::plasma::mhd_energy(&st)
    }
}

// ══════════════════════════════════════════════════════════════
// QFT — cross-sections, running couplings
// ══════════════════════════════════════════════════════════════
#[wasm_bindgen] pub struct WasmQFT;
#[wasm_bindgen] impl WasmQFT {
    #[wasm_bindgen(constructor)] pub fn new() -> Self { WasmQFT }
    pub fn spacetime_dim(&self) -> u64 { crate::dynamics::qft::SPACETIME_DIM }
    pub fn lorentz_gen(&self) -> u64 { crate::dynamics::qft::LORENTZ_GEN }
    pub fn dirac_gammas(&self) -> u64 { crate::dynamics::qft::DIRAC_GAMMAS }
    pub fn photon_pol(&self) -> u64 { crate::dynamics::qft::PHOTON_POL }
    pub fn gluon_colours(&self) -> u64 { crate::dynamics::qft::GLUON_COLOURS }
    pub fn qcd_beta0(&self) -> u64 { crate::dynamics::qft::QCD_BETA0 }
    pub fn alpha_inv(&self) -> f64 { crate::dynamics::qft::alpha_inv() }
    pub fn alpha_s_mz(&self) -> f64 { crate::dynamics::qft::alpha_s_mz() }
    pub fn thomson_cs(&self) -> f64 { crate::dynamics::qft::thomson_cs() }
    pub fn pair_threshold(&self, m: f64) -> f64 { crate::dynamics::qft::pair_threshold(m) }
    pub fn sigma_ee_mumu(&self, s: f64) -> f64 { crate::dynamics::qft::sigma_ee_mumu(s) }
    /// e+e- → μ+μ- cross-section curve [[√s, σ],...] for D3
    pub fn sigma_curve(&self, smin: f64, smax: f64, n: usize) -> JsValue {
        let (s,sig) = crate::dynamics::qft::sigma_curve(smin,smax,n);
        let pts: Vec<[f64;2]> = s.iter().zip(sig.iter()).map(|(&x,&y)| [x,y]).collect();
        to_js(&pts)
    }
    /// α_s running [[Q, α_s],...] for D3
    pub fn alpha_s_curve(&self, qmin: f64, qmax: f64, lambda: f64, n: usize) -> JsValue {
        let (q,a) = crate::dynamics::qft::alpha_s_curve(qmin,qmax,lambda,n);
        let pts: Vec<[f64;2]> = q.iter().zip(a.iter()).map(|(&x,&y)| [x,y]).collect();
        to_js(&pts)
    }
}

// ══════════════════════════════════════════════════════════════
// RIGID — Euler equations, gyroscope, inertia
// ══════════════════════════════════════════════════════════════
#[wasm_bindgen] pub struct WasmRigid;
#[wasm_bindgen] impl WasmRigid {
    #[wasm_bindgen(constructor)] pub fn new() -> Self { WasmRigid }
    pub fn quat_components(&self) -> u64 { crate::dynamics::rigid::QUAT_COMPONENTS }
    pub fn inertia_indep(&self) -> u64 { crate::dynamics::rigid::INERTIA_INDEP }
    pub fn rigid_dof(&self) -> u64 { crate::dynamics::rigid::RIGID_DOF }
    pub fn i_sphere(& self, m: f64, r: f64) -> f64 { crate::dynamics::rigid::i_sphere(m,r) }
    pub fn i_rod(&self, m: f64, l: f64) -> f64 { crate::dynamics::rigid::i_rod(m,l) }
    pub fn i_disk(&self, m: f64, r: f64) -> f64 { crate::dynamics::rigid::i_disk(m,r) }
    pub fn i_shell(&self, m: f64, r: f64) -> f64 { crate::dynamics::rigid::i_shell(m,r) }
    pub fn i_sphere_factor(&self) -> f64 { crate::dynamics::rigid::i_sphere_factor() }
    pub fn i_shell_factor(&self) -> f64 { crate::dynamics::rigid::i_shell_factor() }
    /// Euler tumbling [[wx,wy,wz],...] for D3
    pub fn tumbling(&self, ix: f64, iy: f64, iz: f64, wx: f64, wy: f64, wz: f64, dt: f64, n: usize) -> JsValue {
        let rb0 = crate::dynamics::rigid::RigidBody::new((ix,iy,iz),(wx,wy,wz));
        let (oxs,oys,ozs) = crate::dynamics::rigid::rigid_evolve(dt, n, &rb0);
        let pts: Vec<[f64;3]> = oxs.iter().zip(oys.iter().zip(ozs.iter())).map(|(&x,(&y,&z))| [x,y,z]).collect();
        to_js(&pts)
    }
}

// ══════════════════════════════════════════════════════════════
// MONAD — S=W∘U time evolution
// ══════════════════════════════════════════════════════════════
#[derive(Serialize)] struct MonadSnap { tick:u64, singlet:f64, weak:f64, colour:f64, mixed:f64, entropy:f64, weight:f64 }
#[wasm_bindgen] pub struct WasmMonad { state: crate::monad::AlgebraState }
#[wasm_bindgen] impl WasmMonad {
    #[wasm_bindgen(constructor)] pub fn new() -> Self { WasmMonad { state: crate::monad::AlgebraState::new() } }
    pub fn tick(&mut self) { crate::monad::Monad::tick(&mut self.state); }
    pub fn advance(&mut self, n: u64) { crate::monad::Monad::evolve(&mut self.state, n); }
    pub fn at_tick(&mut self, t: u64) { self.state = crate::monad::AlgebraState::at_tick(t); }
    pub fn snapshot(&self) -> JsValue { to_js(&MonadSnap { tick:self.state.tick, singlet:self.state.amplitudes[0],
        weak:self.state.amplitudes[1], colour:self.state.amplitudes[2], mixed:self.state.amplitudes[3],
        entropy:self.state.entropy(), weight:self.state.total_weight() }) }
    pub fn amplitudes(&self) -> JsValue { to_js(&self.state.amplitudes) }
    pub fn current_tick(&self) -> u64 { self.state.tick }
    pub fn entropy(&self) -> f64 { self.state.entropy() }
    pub fn hologron_potential(&self, l: f64) -> f64 { crate::monad::hologron_potential(l) }
    pub fn history(&self, n: u64) -> JsValue {
        let s:Vec<MonadSnap>=(0..=n).map(|t|{let st=crate::monad::AlgebraState::at_tick(t);
            MonadSnap{tick:t,singlet:st.amplitudes[0],weak:st.amplitudes[1],colour:st.amplitudes[2],
            mixed:st.amplitudes[3],entropy:st.entropy(),weight:st.total_weight()}}).collect();
        to_js(&s)
    }
}

// ══════════════════════════════════════════════════════════════
// NBODY — galaxies, solar system, figure-8
// ══════════════════════════════════════════════════════════════
#[derive(Serialize)] struct JsBody { px:f64,py:f64,pz:f64,vx:f64,vy:f64,vz:f64,m:f64 }
impl From<&crate::dynamics::nbody::Body> for JsBody {
    fn from(b:&crate::dynamics::nbody::Body)->Self{JsBody{px:b.px,py:b.py,pz:b.pz,vx:b.vx,vy:b.vy,vz:b.vz,m:b.m}}
}
fn bodies_js(b:&[crate::dynamics::nbody::Body])->JsValue{to_js(&b.iter().map(JsBody::from).collect::<Vec<_>>())}

#[wasm_bindgen] pub struct WasmNBody { bodies: Vec<crate::dynamics::nbody::Body>, eps:f64, dt:f64, step:usize }
#[wasm_bindgen] impl WasmNBody {
    #[wasm_bindgen(constructor)] pub fn new(dt:f64,eps:f64)->Self{WasmNBody{bodies:Vec::new(),eps,dt,step:0}}
    pub fn add_body(&mut self,px:f64,py:f64,pz:f64,vx:f64,vy:f64,vz:f64,m:f64){
        self.bodies.push(crate::dynamics::nbody::Body::new(px,py,pz,vx,vy,vz,m));
    }
    pub fn add_galaxy(&mut self,n:usize,tm:f64,rs:f64,cx:f64,cy:f64,cz:f64,bvx:f64,bvy:f64,bvz:f64){
        let mut g=crate::dynamics::nbody::plummer_sphere(n,tm,rs);
        for b in &mut g{b.px+=cx;b.py+=cy;b.pz+=cz;b.vx+=bvx;b.vy+=bvy;b.vz+=bvz;}
        self.bodies.extend(g);
    }
    pub fn load_figure_eight(&mut self){self.bodies=crate::dynamics::nbody::three_body_figure_eight();}
    pub fn load_solar_system(&mut self){self.bodies=crate::dynamics::nbody::solar_system_inner();}
    pub fn tick(&mut self){self.bodies=crate::dynamics::nbody::nbody_tick_direct(self.dt,self.eps,&self.bodies);self.step+=1;}
    pub fn advance(&mut self,n:usize){for _ in 0..n{self.tick()}}
    pub fn bodies(&self)->JsValue{bodies_js(&self.bodies)}
    pub fn positions_2d(&self)->JsValue{to_js(&self.bodies.iter().map(|b|[b.px,b.py]).collect::<Vec<[f64;2]>>())}
    pub fn positions_2d_mass(&self)->JsValue{to_js(&self.bodies.iter().map(|b|[b.px,b.py,b.m]).collect::<Vec<[f64;3]>>())}
    pub fn n_bodies(&self)->usize{self.bodies.len()}
    pub fn current_step(&self)->usize{self.step}
    pub fn kinetic_energy(&self)->f64{crate::dynamics::nbody::kinetic_energy(&self.bodies)}
    pub fn potential_energy(&self)->f64{crate::dynamics::nbody::potential_energy(self.eps,&self.bodies)}
    pub fn total_energy(&self)->f64{crate::dynamics::nbody::total_energy(self.eps,&self.bodies)}
    pub fn octree_children(&self)->u64{crate::dynamics::nbody::OCTREE_CHILDREN}
}

// ══════════════════════════════════════════════════════════════
// CRYSTAL_DUMP — one call, everything for D3
// ══════════════════════════════════════════════════════════════
#[derive(Serialize)] struct CrystalDump {
    n_w:u64,n_c:u64,chi:u64,beta0:u64,sigma_d:u64,tower_d:u64,
    shell_capacities:[u64;4], noble_gases:[u64;4],
    sp3_deg:f64,sp2_deg:f64,water_deg:f64,
    hartree_ev:f64,bohr_radius:f64,eps_vdw:f64,kt_300:f64,
    magic_numbers:[u64;7],iron_peak:u64,binding_curve:Vec<(u32,f64)>,
    le_nr_profile:Vec<(f64,f64)>,le_rel_profile:Vec<(f64,f64)>,
    dna_bases:u64,amino_acids:u64,total_codons:u64,
    helix_per_turn:f64,flory_nu:f64,kleiber_exp:f64,
    steane:[u64;3],mera_bond:u64,mera_depth:u64,
    bell_entropy:f64,mera_entropy:f64,
    lj_scan:Vec<[f64;4]>,
}
#[wasm_bindgen]
pub fn crystal_dump() -> JsValue {
    let lj:Vec<[f64;4]>=(0..300).map(|i|{let r=0.95+i as f64*0.01;
        [r,crate::dynamics::arcade::lj_exact(r),crate::dynamics::arcade::lj_arcade(r),crate::dynamics::arcade::lj_wca(r)]}).collect();
    to_js(&CrystalDump {
        n_w:crate::atoms::N_W, n_c:crate::atoms::N_C, chi:crate::atoms::CHI,
        beta0:crate::atoms::BETA0, sigma_d:crate::atoms::SIGMA_D, tower_d:crate::atoms::TOWER_D,
        shell_capacities:[crate::dynamics::chem::S_CAPACITY,crate::dynamics::chem::P_CAPACITY,
            crate::dynamics::chem::D_CAPACITY,crate::dynamics::chem::F_CAPACITY],
        noble_gases:crate::dynamics::chem::noble_gases(),
        sp3_deg:crate::dynamics::chem::sp3_angle_deg(),sp2_deg:crate::dynamics::chem::sp2_angle_deg(),
        water_deg:crate::dynamics::chem::water_angle_deg(),
        hartree_ev:crate::dynamics::chem::hartree_ev(),bohr_radius:crate::dynamics::chem::bohr_radius(),
        eps_vdw:crate::dynamics::chem::eps_vdw(),kt_300:crate::dynamics::chem::kt_300(),
        magic_numbers:crate::dynamics::nuclear::magic_numbers(),iron_peak:crate::dynamics::nuclear::IRON_PEAK_A,
        binding_curve:crate::dynamics::nuclear::binding_curve(250),
        le_nr_profile:crate::dynamics::astro::lane_emden_profile(1.5),
        le_rel_profile:crate::dynamics::astro::lane_emden_profile(3.0),
        dna_bases:crate::dynamics::bio::DNA_BASES, amino_acids:crate::dynamics::bio::AMINO_ACIDS,
        total_codons:crate::dynamics::bio::TOTAL_CODONS,
        helix_per_turn:crate::dynamics::bio::helix_per_turn(),flory_nu:crate::dynamics::bio::flory_nu(),
        kleiber_exp:crate::dynamics::bio::kleiber_exp(),
        steane:[crate::dynamics::qinfo::STEANE_N,crate::dynamics::qinfo::STEANE_K,crate::dynamics::qinfo::STEANE_D],
        mera_bond:crate::dynamics::qinfo::MERA_BOND,mera_depth:crate::dynamics::qinfo::MERA_DEPTH,
        bell_entropy:crate::dynamics::qinfo::bell_entropy(),mera_entropy:crate::dynamics::qinfo::mera_link_entropy(),
        lj_scan:lj,
    })
}
