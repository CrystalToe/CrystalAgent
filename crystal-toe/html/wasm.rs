// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// wasm.rs — WebAssembly bindings for crystal_toe
//
// Build:  wasm-pack build --target web --features wasm
// Use:    import init, { WasmToe, WasmChem, ... } from './crystal_toe.js';

use wasm_bindgen::prelude::*;
use serde::Serialize;

// ═══════════════════════════════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════════════════════════════

fn to_js<T: Serialize>(val: &T) -> JsValue {
    serde_wasm_bindgen::to_value(val).unwrap_or(JsValue::NULL)
}

// ═══════════════════════════════════════════════════════════════
// TOE — Central object
// ═══════════════════════════════════════════════════════════════

#[wasm_bindgen]
pub struct WasmToe {
    inner: crate::toe::Toe,
}

#[wasm_bindgen]
impl WasmToe {
    #[wasm_bindgen(constructor)]
    pub fn new(vev: Option<f64>) -> Self {
        WasmToe {
            inner: match vev {
                Some(v) => crate::toe::Toe::with_vev(v),
                None => crate::toe::Toe::new(),
            },
        }
    }
    pub fn to_pdg(&self) -> WasmToe {
        WasmToe { inner: self.inner.to_pdg() }
    }

    // Constants
    pub fn n_w(&self) -> u64 { crate::atoms::N_W }
    pub fn n_c(&self) -> u64 { crate::atoms::N_C }
    pub fn chi(&self) -> u64 { crate::atoms::CHI }
    pub fn beta0(&self) -> u64 { crate::atoms::BETA0 }
    pub fn sigma_d(&self) -> u64 { crate::atoms::SIGMA_D }
    pub fn tower_d(&self) -> u64 { crate::atoms::TOWER_D }
    pub fn d_colour(&self) -> u64 { crate::atoms::D_COLOUR }
    pub fn gauss(&self) -> u64 { crate::atoms::GAUSS }

    // Physics
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

// ═══════════════════════════════════════════════════════════════
// CHEM — Orbitals, angles, energy scales
// ═══════════════════════════════════════════════════════════════

#[wasm_bindgen]
pub struct WasmChem;

#[wasm_bindgen]
impl WasmChem {
    #[wasm_bindgen(constructor)]
    pub fn new() -> Self { WasmChem }

    // Orbital capacities
    pub fn s_capacity(&self) -> u64 { crate::dynamics::chem::S_CAPACITY }
    pub fn p_capacity(&self) -> u64 { crate::dynamics::chem::P_CAPACITY }
    pub fn d_capacity(&self) -> u64 { crate::dynamics::chem::D_CAPACITY }
    pub fn f_capacity(&self) -> u64 { crate::dynamics::chem::F_CAPACITY }
    pub fn subshell_capacity(&self, l: u64) -> u64 { crate::dynamics::chem::subshell_capacity(l) }
    pub fn shell_capacity(&self, n: u64) -> u64 { crate::dynamics::chem::shell_capacity(n) }

    // Angles (degrees)
    pub fn sp3_angle_deg(&self) -> f64 { crate::dynamics::chem::sp3_angle_deg() }
    pub fn sp2_angle_deg(&self) -> f64 { crate::dynamics::chem::sp2_angle_deg() }
    pub fn water_angle_deg(&self) -> f64 { crate::dynamics::chem::water_angle_deg() }

    // Energy
    pub fn alpha_em(&self) -> f64 { crate::dynamics::chem::alpha_em() }
    pub fn hartree_ev(&self) -> f64 { crate::dynamics::chem::hartree_ev() }
    pub fn bohr_radius(&self) -> f64 { crate::dynamics::chem::bohr_radius() }
    pub fn eps_vdw(&self) -> f64 { crate::dynamics::chem::eps_vdw() }
    pub fn e_hbond(&self) -> f64 { crate::dynamics::chem::e_hbond() }
    pub fn kt_300(&self) -> f64 { crate::dynamics::chem::kt_300() }
    pub fn vdw_kt_ratio(&self) -> f64 { crate::dynamics::chem::vdw_kt_ratio() }
    pub fn arrhenius(&self, ea: f64, kt: f64) -> f64 { crate::dynamics::chem::arrhenius(ea, kt) }

    // Noble gases
    pub fn noble_gases(&self) -> JsValue { to_js(&crate::dynamics::chem::noble_gases()) }
    pub fn neutral_ph(&self) -> u64 { crate::dynamics::chem::NEUTRAL_PH }
    pub fn dielectric_protein(&self) -> u64 { crate::dynamics::chem::DIELECTRIC_PROTEIN }
    pub fn period_lengths(&self) -> JsValue { to_js(&crate::dynamics::chem::period_lengths()) }

    // Self-test
    pub fn self_test(&self) -> JsValue {
        let (pass, total, msgs) = crate::dynamics::chem::self_test();
        to_js(&SelfTestResult { pass, total, msgs })
    }
}

// ═══════════════════════════════════════════════════════════════
// NUCLEAR — Magic numbers, SEMF, binding curve
// ═══════════════════════════════════════════════════════════════

#[wasm_bindgen]
pub struct WasmNuclear;

#[wasm_bindgen]
impl WasmNuclear {
    #[wasm_bindgen(constructor)]
    pub fn new() -> Self { WasmNuclear }

    pub fn magic_numbers(&self) -> JsValue { to_js(&crate::dynamics::nuclear::magic_numbers()) }
    pub fn iron_peak(&self) -> u64 { crate::dynamics::nuclear::IRON_PEAK_A }
    pub fn isospin_states(&self) -> u64 { crate::dynamics::nuclear::ISOSPIN_STATES }
    pub fn alpha_particle(&self) -> u64 { crate::dynamics::nuclear::ALPHA_PARTICLE }
    pub fn deuteron_a(&self) -> u64 { crate::dynamics::nuclear::DEUTERON_A }

    pub fn binding_energy(&self, a: u32, z: u32) -> f64 { crate::dynamics::nuclear::binding_energy(a, z) }
    pub fn binding_per_nucleon(&self, a: u32, z: u32) -> f64 { crate::dynamics::nuclear::binding_per_nucleon(a, z) }
    pub fn optimal_z(&self, a: u32) -> u32 { crate::dynamics::nuclear::optimal_z(a) }
    pub fn nuclear_radius(&self, a: u32) -> f64 { crate::dynamics::nuclear::nuclear_radius(a) }

    /// Returns [[a, b_per_a], ...] for D3 plotting.
    pub fn binding_curve(&self, max_a: u32) -> JsValue {
        let curve = crate::dynamics::nuclear::binding_curve(max_a);
        to_js(&curve)
    }

    pub fn self_test(&self) -> JsValue {
        let (pass, total, msgs) = crate::dynamics::nuclear::self_test();
        to_js(&SelfTestResult { pass, total, msgs })
    }
}

// ═══════════════════════════════════════════════════════════════
// ASTRO — Lane-Emden, scaling laws
// ═══════════════════════════════════════════════════════════════

#[wasm_bindgen]
pub struct WasmAstro;

#[wasm_bindgen]
impl WasmAstro {
    #[wasm_bindgen(constructor)]
    pub fn new() -> Self { WasmAstro }

    pub fn schwarz(&self) -> u64 { crate::dynamics::astro::SCHWARZ }
    pub fn hawking(&self) -> u64 { crate::dynamics::astro::HAWKING }
    pub fn sb_denom(&self) -> u64 { crate::dynamics::astro::SB_DENOM }
    pub fn eddington(&self) -> u64 { crate::dynamics::astro::EDDINGTON }
    pub fn virial(&self) -> u64 { crate::dynamics::astro::VIRIAL }

    pub fn lane_emden(&self, n: f64) -> JsValue { to_js(&crate::dynamics::astro::lane_emden(n)) }

    /// Returns [[xi, theta], ...] for D3 line plot.
    pub fn lane_emden_profile(&self, n: f64) -> JsValue {
        to_js(&crate::dynamics::astro::lane_emden_profile(n))
    }

    pub fn ms_luminosity(&self, m: f64) -> f64 { crate::dynamics::astro::ms_luminosity(m) }
    pub fn ms_lifetime(&self, m: f64) -> f64 { crate::dynamics::astro::ms_lifetime(m) }
    pub fn schwarzschild_radius(&self, m: f64) -> f64 { crate::dynamics::astro::schwarzschild_radius(m) }
    pub fn hawking_temperature(&self, m: f64) -> f64 { crate::dynamics::astro::hawking_temperature(m) }

    pub fn self_test(&self) -> JsValue {
        let (pass, total, msgs) = crate::dynamics::astro::self_test();
        to_js(&SelfTestResult { pass, total, msgs })
    }
}

// ═══════════════════════════════════════════════════════════════
// QINFO — Error correction, Heyting, entanglement
// ═══════════════════════════════════════════════════════════════

#[wasm_bindgen]
pub struct WasmQInfo;

#[wasm_bindgen]
impl WasmQInfo {
    #[wasm_bindgen(constructor)]
    pub fn new() -> Self { WasmQInfo }

    pub fn qubit_states(&self) -> u64 { crate::dynamics::qinfo::QUBIT_STATES }
    pub fn pauli_matrices(&self) -> u64 { crate::dynamics::qinfo::PAULI_MATRICES }
    pub fn bell_states(&self) -> u64 { crate::dynamics::qinfo::BELL_STATES }
    pub fn steane_n(&self) -> u64 { crate::dynamics::qinfo::STEANE_N }
    pub fn steane_d(&self) -> u64 { crate::dynamics::qinfo::STEANE_D }
    pub fn shor_n(&self) -> u64 { crate::dynamics::qinfo::SHOR_N }
    pub fn toffoli(&self) -> u64 { crate::dynamics::qinfo::TOFFOLI }
    pub fn mera_bond(&self) -> u64 { crate::dynamics::qinfo::MERA_BOND }
    pub fn mera_depth(&self) -> u64 { crate::dynamics::qinfo::MERA_DEPTH }
    pub fn bell_entropy(&self) -> f64 { crate::dynamics::qinfo::bell_entropy() }
    pub fn mera_link_entropy(&self) -> f64 { crate::dynamics::qinfo::mera_link_entropy() }
    pub fn hamming_check(&self) -> bool { crate::dynamics::qinfo::hamming_check() }
    pub fn coprimality_check(&self) -> bool { crate::dynamics::qinfo::coprimality_check() }

    pub fn self_test(&self) -> JsValue {
        let (pass, total, msgs) = crate::dynamics::qinfo::self_test();
        to_js(&SelfTestResult { pass, total, msgs })
    }
}

// ═══════════════════════════════════════════════════════════════
// BIO — Genetic code, allometric scaling
// ═══════════════════════════════════════════════════════════════

#[wasm_bindgen]
pub struct WasmBio;

#[wasm_bindgen]
impl WasmBio {
    #[wasm_bindgen(constructor)]
    pub fn new() -> Self { WasmBio }

    pub fn dna_bases(&self) -> u64 { crate::dynamics::bio::DNA_BASES }
    pub fn codon_len(&self) -> u64 { crate::dynamics::bio::CODON_LEN }
    pub fn total_codons(&self) -> u64 { crate::dynamics::bio::TOTAL_CODONS }
    pub fn amino_acids(&self) -> u64 { crate::dynamics::bio::AMINO_ACIDS }
    pub fn stop_codons(&self) -> u64 { crate::dynamics::bio::STOP_CODONS }
    pub fn bp_per_turn(&self) -> u64 { crate::dynamics::bio::BP_PER_TURN }
    pub fn helix_per_turn(&self) -> f64 { crate::dynamics::bio::helix_per_turn() }
    pub fn flory_nu(&self) -> f64 { crate::dynamics::bio::flory_nu() }
    pub fn kleiber_exp(&self) -> f64 { crate::dynamics::bio::kleiber_exp() }
    pub fn codon_redundancy(&self) -> f64 { crate::dynamics::bio::codon_redundancy() }

    pub fn kleiber(&self, m: f64) -> f64 { crate::dynamics::bio::kleiber(m) }
    pub fn heart_rate(&self, m: f64) -> f64 { crate::dynamics::bio::heart_rate(m) }
    pub fn lifespan(&self, m: f64) -> f64 { crate::dynamics::bio::lifespan(m) }

    pub fn self_test(&self) -> JsValue {
        let (pass, total, msgs) = crate::dynamics::bio::self_test();
        to_js(&SelfTestResult { pass, total, msgs })
    }
}

// ═══════════════════════════════════════════════════════════════
// ARCADE — Approximation layers, LJ, integrators
// ═══════════════════════════════════════════════════════════════

#[wasm_bindgen]
pub struct WasmArcade;

#[wasm_bindgen]
impl WasmArcade {
    #[wasm_bindgen(constructor)]
    pub fn new() -> Self { WasmArcade }

    pub fn lj_cutoff(&self) -> u64 { crate::dynamics::arcade::LJ_CUTOFF }
    pub fn octree_children(&self) -> u64 { crate::dynamics::arcade::OCTREE_CHILDREN }
    pub fn fixed_bits(&self) -> u64 { crate::dynamics::arcade::FIXED_BITS }
    pub fn lod_levels(&self) -> u64 { crate::dynamics::arcade::LOD_LEVELS }
    pub fn fast_alpha_inv(&self) -> u64 { crate::dynamics::arcade::FAST_ALPHA_INV }
    pub fn wca_cutoff(&self) -> f64 { crate::dynamics::arcade::wca_cutoff() }
    pub fn bh_theta(&self) -> f64 { crate::dynamics::arcade::bh_theta() }
    pub fn mean_field_error(&self) -> f64 { crate::dynamics::arcade::mean_field_error() }
    pub fn verify_alpha_inv(&self) -> bool { crate::dynamics::arcade::verify_alpha_inv() }

    pub fn lj_exact(&self, r: f64) -> f64 { crate::dynamics::arcade::lj_exact(r) }
    pub fn lj_arcade(&self, r: f64) -> f64 { crate::dynamics::arcade::lj_arcade(r) }
    pub fn lj_wca(&self, r: f64) -> f64 { crate::dynamics::arcade::lj_wca(r) }

    /// Returns [[r, V_exact, V_arcade, V_wca], ...] for D3 multi-line plot.
    pub fn lj_scan(&self, r_min: f64, r_max: f64, n_points: usize) -> JsValue {
        let dr = (r_max - r_min) / n_points as f64;
        let data: Vec<[f64; 4]> = (0..n_points).map(|i| {
            let r = r_min + i as f64 * dr;
            [r, crate::dynamics::arcade::lj_exact(r),
             crate::dynamics::arcade::lj_arcade(r),
             crate::dynamics::arcade::lj_wca(r)]
        }).collect();
        to_js(&data)
    }

    pub fn self_test(&self) -> JsValue {
        let (pass, total, msgs) = crate::dynamics::arcade::self_test();
        to_js(&SelfTestResult { pass, total, msgs })
    }
}

// ═══════════════════════════════════════════════════════════════
// EM — Yee FDTD photon propagation (classical Schrödinger-like)
// ═══════════════════════════════════════════════════════════════

#[wasm_bindgen]
pub struct WasmEM {
    ey: Vec<f64>,
    bz: Vec<f64>,
    time: f64,
    courant: f64,
    n_grid: usize,
    step: usize,
}

#[wasm_bindgen]
impl WasmEM {
    /// Create 1D EM field with Gaussian pulse.
    #[wasm_bindgen(constructor)]
    pub fn new(n_grid: usize, center: f64, width: f64, amp: f64, courant: f64) -> Self {
        let st = crate::dynamics::em::gaussian_pulse(n_grid, center, width, amp);
        WasmEM { ey: st.ey, bz: st.bz, time: 0.0, courant, n_grid, step: 0 }
    }

    /// Advance one Yee tick (W∘U split: B kick, E drift).
    pub fn tick(&mut self) {
        let n = self.ey.len();
        // W: dB/dt = −dE/dx
        let bz: Vec<f64> = self.bz.iter().enumerate().map(|(i, &b)| {
            b - self.courant * (self.ey[i + 1] - self.ey[i])
        }).collect();
        // U: dE/dt = dB/dx (PEC boundaries)
        let mut ey = vec![0.0; n];
        for i in 1..n - 1 {
            ey[i] = self.ey[i] - self.courant * (bz[i] - bz[i - 1]);
        }
        self.ey = ey;
        self.bz = bz;
        self.time += self.courant;
        self.step += 1;
    }

    pub fn advance(&mut self, n: usize) { for _ in 0..n { self.tick(); } }

    /// Get E_y field as array for D3/Canvas.
    pub fn ey_field(&self) -> JsValue { to_js(&self.ey) }
    /// Get B_z field as array.
    pub fn bz_field(&self) -> JsValue { to_js(&self.bz) }

    /// Total EM energy: (E² + B²)/2.
    pub fn energy(&self) -> f64 {
        let ee: f64 = self.ey.iter().map(|e| e * e).sum::<f64>() / 2.0;
        let be: f64 = self.bz.iter().map(|b| b * b).sum::<f64>() / 2.0;
        ee + be
    }

    pub fn current_step(&self) -> usize { self.step }
    pub fn current_time(&self) -> f64 { self.time }
    pub fn grid_size(&self) -> usize { self.n_grid }

    /// Crystal constants from EM module.
    pub fn em_components(&self) -> u64 { crate::dynamics::em::EM_COMPONENTS }
    pub fn polarization_states(&self) -> u64 { crate::dynamics::em::POLARIZATION_STATES }
}

// ═══════════════════════════════════════════════════════════════
// MONAD — Crystal time evolution S = W∘U
// ═══════════════════════════════════════════════════════════════

#[derive(Serialize)]
struct MonadSnapshot {
    tick: u64,
    singlet: f64,
    weak: f64,
    colour: f64,
    mixed: f64,
    entropy: f64,
    total_weight: f64,
}

#[wasm_bindgen]
pub struct WasmMonad {
    state: crate::monad::AlgebraState,
}

#[wasm_bindgen]
impl WasmMonad {
    #[wasm_bindgen(constructor)]
    pub fn new() -> Self {
        WasmMonad { state: crate::monad::AlgebraState::new() }
    }

    /// One tick of S = W∘U.
    pub fn tick(&mut self) {
        crate::monad::Monad::tick(&mut self.state);
    }

    /// Advance n ticks.
    pub fn advance(&mut self, n: u64) {
        crate::monad::Monad::evolve(&mut self.state, n);
    }

    /// Jump to exact tick t (direct computation, no iteration).
    pub fn at_tick(&mut self, t: u64) {
        self.state = crate::monad::AlgebraState::at_tick(t);
    }

    /// Current snapshot as {tick, singlet, weak, colour, mixed, entropy, total_weight}.
    pub fn snapshot(&self) -> JsValue {
        to_js(&MonadSnapshot {
            tick: self.state.tick,
            singlet: self.state.amplitudes[0],
            weak: self.state.amplitudes[1],
            colour: self.state.amplitudes[2],
            mixed: self.state.amplitudes[3],
            entropy: self.state.entropy(),
            total_weight: self.state.total_weight(),
        })
    }

    /// Sector amplitudes as [singlet, weak, colour, mixed].
    pub fn amplitudes(&self) -> JsValue { to_js(&self.state.amplitudes) }
    pub fn current_tick(&self) -> u64 { self.state.tick }
    pub fn entropy(&self) -> f64 { self.state.entropy() }
    pub fn total_weight(&self) -> f64 { self.state.total_weight() }

    /// Eigenvalues: [1, 1/N_w, 1/N_c, 1/χ] = [1, 0.5, 0.333, 0.167].
    pub fn eigenvalues(&self) -> JsValue {
        to_js(&crate::quantum::sector_eigenvalues())
    }

    /// Sector dimensions: [1, 3, 8, 24].
    pub fn sector_dims(&self) -> JsValue {
        to_js(&crate::atoms::SECTOR_DIMS)
    }

    /// Hologron potential V(L) = −L^(−2Δ_weak).
    pub fn hologron_potential(&self, l: f64) -> f64 {
        crate::monad::hologron_potential(l)
    }

    /// Generate full evolution history: [{tick, singlet, weak, colour, mixed, entropy}, ...].
    pub fn history(&self, n_ticks: u64) -> JsValue {
        let snaps: Vec<MonadSnapshot> = (0..=n_ticks).map(|t| {
            let st = crate::monad::AlgebraState::at_tick(t);
            MonadSnapshot {
                tick: t,
                singlet: st.amplitudes[0],
                weak: st.amplitudes[1],
                colour: st.amplitudes[2],
                mixed: st.amplitudes[3],
                entropy: st.entropy(),
                total_weight: st.total_weight(),
            }
        }).collect();
        to_js(&snaps)
    }
}

// ═══════════════════════════════════════════════════════════════
// NBODY — Galaxy collisions, solar systems, figure-8
// ═══════════════════════════════════════════════════════════════

#[derive(Serialize)]
struct JsBody {
    px: f64, py: f64, pz: f64,
    vx: f64, vy: f64, vz: f64,
    m: f64,
}

impl From<&crate::dynamics::nbody::Body> for JsBody {
    fn from(b: &crate::dynamics::nbody::Body) -> Self {
        JsBody { px: b.px, py: b.py, pz: b.pz, vx: b.vx, vy: b.vy, vz: b.vz, m: b.m }
    }
}

fn bodies_to_js(bodies: &[crate::dynamics::nbody::Body]) -> JsValue {
    let jb: Vec<JsBody> = bodies.iter().map(JsBody::from).collect();
    to_js(&jb)
}

#[wasm_bindgen]
pub struct WasmNBody {
    bodies: Vec<crate::dynamics::nbody::Body>,
    eps: f64,
    dt: f64,
    step: usize,
}

#[wasm_bindgen]
impl WasmNBody {
    /// Create empty simulation. Set dt and softening.
    #[wasm_bindgen(constructor)]
    pub fn new(dt: f64, eps: f64) -> Self {
        WasmNBody { bodies: Vec::new(), eps, dt, step: 0 }
    }

    /// Add a single body.
    pub fn add_body(&mut self, px: f64, py: f64, pz: f64,
                    vx: f64, vy: f64, vz: f64, m: f64) {
        self.bodies.push(crate::dynamics::nbody::Body::new(px, py, pz, vx, vy, vz, m));
    }

    /// Generate a Plummer sphere galaxy and add it at (cx,cy,cz) with bulk velocity (vx,vy,vz).
    pub fn add_galaxy(&mut self, n: usize, total_m: f64, r_scale: f64,
                      cx: f64, cy: f64, cz: f64,
                      bvx: f64, bvy: f64, bvz: f64) {
        let mut galaxy = crate::dynamics::nbody::plummer_sphere(n, total_m, r_scale);
        for b in &mut galaxy {
            b.px += cx; b.py += cy; b.pz += cz;
            b.vx += bvx; b.vy += bvy; b.vz += bvz;
        }
        self.bodies.extend(galaxy);
    }

    /// Load the figure-eight 3-body solution.
    pub fn load_figure_eight(&mut self) {
        self.bodies = crate::dynamics::nbody::three_body_figure_eight();
    }

    /// Load inner solar system.
    pub fn load_solar_system(&mut self) {
        self.bodies = crate::dynamics::nbody::solar_system_inner();
    }

    /// Advance one timestep (direct O(N²) integration).
    pub fn tick(&mut self) {
        self.bodies = crate::dynamics::nbody::nbody_tick_direct(self.dt, self.eps, &self.bodies);
        self.step += 1;
    }

    /// Advance n timesteps.
    pub fn advance(&mut self, n: usize) {
        for _ in 0..n {
            self.tick();
        }
    }

    /// Get current bodies as [{px,py,pz,vx,vy,vz,m}, ...].
    pub fn bodies(&self) -> JsValue { bodies_to_js(&self.bodies) }

    /// Get just [x, y] positions for fast 2D rendering. Returns [[x,y], ...].
    pub fn positions_2d(&self) -> JsValue {
        let pts: Vec<[f64; 2]> = self.bodies.iter().map(|b| [b.px, b.py]).collect();
        to_js(&pts)
    }

    /// Get [x, y, m] for sized scatter plots.
    pub fn positions_2d_mass(&self) -> JsValue {
        let pts: Vec<[f64; 3]> = self.bodies.iter().map(|b| [b.px, b.py, b.m]).collect();
        to_js(&pts)
    }

    pub fn n_bodies(&self) -> usize { self.bodies.len() }
    pub fn current_step(&self) -> usize { self.step }
    pub fn kinetic_energy(&self) -> f64 { crate::dynamics::nbody::kinetic_energy(&self.bodies) }
    pub fn potential_energy(&self) -> f64 { crate::dynamics::nbody::potential_energy(self.eps, &self.bodies) }
    pub fn total_energy(&self) -> f64 { crate::dynamics::nbody::total_energy(self.eps, &self.bodies) }

    /// Crystal constants used by nbody.
    pub fn octree_children(&self) -> u64 { crate::dynamics::nbody::OCTREE_CHILDREN }
    pub fn force_exponent(&self) -> u64 { crate::dynamics::nbody::FORCE_EXPONENT }
    pub fn phase_per_body(&self) -> u64 { crate::dynamics::nbody::PHASE_PER_BODY }
}

// ═══════════════════════════════════════════════════════════════
// SHARED TYPES
// ═══════════════════════════════════════════════════════════════

#[derive(Serialize)]
struct SelfTestResult {
    pass: usize,
    total: usize,
    msgs: Vec<String>,
}

// ═══════════════════════════════════════════════════════════════
// BULK DATA EXPORT — one call, all constants for D3
// ═══════════════════════════════════════════════════════════════

#[derive(Serialize)]
struct CrystalDump {
    // Atoms
    n_w: u64, n_c: u64, chi: u64, beta0: u64, sigma_d: u64, tower_d: u64,

    // Chem
    shell_capacities: [u64; 4],
    noble_gases: [u64; 4],
    sp3_deg: f64, sp2_deg: f64, water_deg: f64,
    hartree_ev: f64, bohr_radius: f64, eps_vdw: f64, kt_300: f64,

    // Nuclear
    magic_numbers: [u64; 7],
    iron_peak: u64,
    binding_curve: Vec<(u32, f64)>,

    // Astro
    le_nr_profile: Vec<(f64, f64)>,
    le_rel_profile: Vec<(f64, f64)>,

    // Bio
    dna_bases: u64, amino_acids: u64, total_codons: u64,
    helix_per_turn: f64, flory_nu: f64, kleiber_exp: f64,

    // QInfo
    steane: [u64; 3],
    mera_bond: u64, mera_depth: u64,
    bell_entropy: f64, mera_entropy: f64,

    // Arcade
    lj_scan: Vec<[f64; 4]>,
}

/// Dump everything D3 needs in one call — avoids hundreds of tiny WASM calls.
#[wasm_bindgen]
pub fn crystal_dump() -> JsValue {
    let chem = crate::dynamics::chem::self_test();
    let _ = chem; // just to prove it compiles

    let lj: Vec<[f64; 4]> = (0..300).map(|i| {
        let r = 0.95 + i as f64 * 0.01;
        [r, crate::dynamics::arcade::lj_exact(r),
         crate::dynamics::arcade::lj_arcade(r),
         crate::dynamics::arcade::lj_wca(r)]
    }).collect();

    let dump = CrystalDump {
        n_w: crate::atoms::N_W,
        n_c: crate::atoms::N_C,
        chi: crate::atoms::CHI,
        beta0: crate::atoms::BETA0,
        sigma_d: crate::atoms::SIGMA_D,
        tower_d: crate::atoms::TOWER_D,

        shell_capacities: [
            crate::dynamics::chem::S_CAPACITY,
            crate::dynamics::chem::P_CAPACITY,
            crate::dynamics::chem::D_CAPACITY,
            crate::dynamics::chem::F_CAPACITY,
        ],
        noble_gases: crate::dynamics::chem::noble_gases(),
        sp3_deg: crate::dynamics::chem::sp3_angle_deg(),
        sp2_deg: crate::dynamics::chem::sp2_angle_deg(),
        water_deg: crate::dynamics::chem::water_angle_deg(),
        hartree_ev: crate::dynamics::chem::hartree_ev(),
        bohr_radius: crate::dynamics::chem::bohr_radius(),
        eps_vdw: crate::dynamics::chem::eps_vdw(),
        kt_300: crate::dynamics::chem::kt_300(),

        magic_numbers: crate::dynamics::nuclear::magic_numbers(),
        iron_peak: crate::dynamics::nuclear::IRON_PEAK_A,
        binding_curve: crate::dynamics::nuclear::binding_curve(250),

        le_nr_profile: crate::dynamics::astro::lane_emden_profile(1.5),
        le_rel_profile: crate::dynamics::astro::lane_emden_profile(3.0),

        dna_bases: crate::dynamics::bio::DNA_BASES,
        amino_acids: crate::dynamics::bio::AMINO_ACIDS,
        total_codons: crate::dynamics::bio::TOTAL_CODONS,
        helix_per_turn: crate::dynamics::bio::helix_per_turn(),
        flory_nu: crate::dynamics::bio::flory_nu(),
        kleiber_exp: crate::dynamics::bio::kleiber_exp(),

        steane: [crate::dynamics::qinfo::STEANE_N, crate::dynamics::qinfo::STEANE_K, crate::dynamics::qinfo::STEANE_D],
        mera_bond: crate::dynamics::qinfo::MERA_BOND,
        mera_depth: crate::dynamics::qinfo::MERA_DEPTH,
        bell_entropy: crate::dynamics::qinfo::bell_entropy(),
        mera_entropy: crate::dynamics::qinfo::mera_link_entropy(),

        lj_scan: lj,
    };
    to_js(&dump)
}
