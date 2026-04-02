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
