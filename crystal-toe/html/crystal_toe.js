/* @ts-self-types="./crystal_toe.d.ts" */

export class WasmArcade {
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmArcadeFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmarcade_free(ptr, 0);
    }
    /**
     * @returns {number}
     */
    bh_theta() {
        const ret = wasm.wasmarcade_bh_theta(this.__wbg_ptr);
        return ret;
    }
    /**
     * @param {number} x
     * @param {number} v
     * @param {number} dt
     * @returns {number}
     */
    euler_step(x, v, dt) {
        const ret = wasm.wasmarcade_euler_step(this.__wbg_ptr, x, v, dt);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    fast_alpha_inv() {
        const ret = wasm.wasmarcade_fast_alpha_inv(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @param {number} x
     * @returns {number}
     */
    fast_inv_sqrt(x) {
        const ret = wasm.wasmarcade_fast_inv_sqrt(this.__wbg_ptr, x);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    fixed_bits() {
        const ret = wasm.wasmarcade_fixed_bits(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {number}
     */
    fixed_resolution() {
        const ret = wasm.wasmarcade_fixed_resolution(this.__wbg_ptr);
        return ret;
    }
    /**
     * @param {number} x
     * @returns {number}
     */
    fixed_round_trip(x) {
        const ret = wasm.wasmarcade_fixed_round_trip(this.__wbg_ptr, x);
        return ret;
    }
    /**
     * @param {number} r
     * @returns {number}
     */
    lj_arcade(r) {
        const ret = wasm.wasmarcade_lj_arcade(this.__wbg_ptr, r);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    lj_cutoff() {
        const ret = wasm.wasmarcade_lj_cutoff(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @param {number} r
     * @returns {number}
     */
    lj_exact(r) {
        const ret = wasm.wasmarcade_lj_exact(this.__wbg_ptr, r);
        return ret;
    }
    /**
     * @param {number} r_min
     * @param {number} r_max
     * @param {number} n
     * @returns {any}
     */
    lj_scan(r_min, r_max, n) {
        const ret = wasm.wasmarcade_lj_scan(this.__wbg_ptr, r_min, r_max, n);
        return ret;
    }
    /**
     * @param {number} r
     * @returns {number}
     */
    lj_wca(r) {
        const ret = wasm.wasmarcade_lj_wca(this.__wbg_ptr, r);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    lod_levels() {
        const ret = wasm.wasmarcade_lod_levels(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {number}
     */
    mean_field_error() {
        const ret = wasm.wasmarcade_mean_field_error(this.__wbg_ptr);
        return ret;
    }
    constructor() {
        const ret = wasm.wasmarcade_new();
        this.__wbg_ptr = ret >>> 0;
        WasmArcadeFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
    /**
     * @returns {bigint}
     */
    octree_children() {
        const ret = wasm.wasmarcade_octree_children(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {number}
     */
    onsager_tc() {
        const ret = wasm.wasmarcade_onsager_tc(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {any}
     */
    self_test() {
        const ret = wasm.wasmarcade_self_test(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {boolean}
     */
    verify_alpha_inv() {
        const ret = wasm.wasmarcade_verify_alpha_inv(this.__wbg_ptr);
        return ret !== 0;
    }
    /**
     * @param {number} x
     * @param {number} v
     * @param {number} a
     * @param {number} dt
     * @returns {number}
     */
    verlet_step(x, v, a, dt) {
        const ret = wasm.wasmarcade_verlet_step(this.__wbg_ptr, x, v, a, dt);
        return ret;
    }
    /**
     * @returns {number}
     */
    wca_cutoff() {
        const ret = wasm.wasmarcade_wca_cutoff(this.__wbg_ptr);
        return ret;
    }
}
if (Symbol.dispose) WasmArcade.prototype[Symbol.dispose] = WasmArcade.prototype.free;

export class WasmAstro {
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmAstroFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmastro_free(ptr, 0);
    }
    /**
     * @returns {bigint}
     */
    eddington() {
        const ret = wasm.wasmastro_eddington(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    hawking() {
        const ret = wasm.wasmastro_hawking(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    hawking_eddington_product() {
        const ret = wasm.wasmastro_hawking_eddington_product(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @param {number} m
     * @returns {number}
     */
    hawking_temperature(m) {
        const ret = wasm.wasmastro_hawking_temperature(this.__wbg_ptr, m);
        return ret;
    }
    /**
     * @param {number} n
     * @returns {any}
     */
    lane_emden(n) {
        const ret = wasm.wasmastro_lane_emden(this.__wbg_ptr, n);
        return ret;
    }
    /**
     * @returns {any}
     */
    lane_emden_nr() {
        const ret = wasm.wasmastro_lane_emden_nr(this.__wbg_ptr);
        return ret;
    }
    /**
     * @param {number} n
     * @returns {any}
     */
    lane_emden_profile(n) {
        const ret = wasm.wasmastro_lane_emden_profile(this.__wbg_ptr, n);
        return ret;
    }
    /**
     * @returns {any}
     */
    lane_emden_rel() {
        const ret = wasm.wasmastro_lane_emden_rel(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {boolean}
     */
    ms_exponent_identity() {
        const ret = wasm.wasmastro_ms_exponent_identity(this.__wbg_ptr);
        return ret !== 0;
    }
    /**
     * @param {number} m
     * @returns {number}
     */
    ms_lifetime(m) {
        const ret = wasm.wasmastro_ms_lifetime(this.__wbg_ptr, m);
        return ret;
    }
    /**
     * @param {number} m
     * @returns {number}
     */
    ms_luminosity(m) {
        const ret = wasm.wasmastro_ms_luminosity(this.__wbg_ptr, m);
        return ret;
    }
    constructor() {
        const ret = wasm.wasmastro_new();
        this.__wbg_ptr = ret >>> 0;
        WasmAstroFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
    /**
     * @returns {bigint}
     */
    sb_denom() {
        const ret = wasm.wasmastro_sb_denom(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    schwarz() {
        const ret = wasm.wasmastro_schwarz(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @param {number} m
     * @returns {number}
     */
    schwarzschild_radius(m) {
        const ret = wasm.wasmastro_schwarzschild_radius(this.__wbg_ptr, m);
        return ret;
    }
    /**
     * @returns {any}
     */
    self_test() {
        const ret = wasm.wasmastro_self_test(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    virial() {
        const ret = wasm.wasmastro_virial(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
}
if (Symbol.dispose) WasmAstro.prototype[Symbol.dispose] = WasmAstro.prototype.free;

export class WasmBio {
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmBioFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmbio_free(ptr, 0);
    }
    /**
     * @returns {bigint}
     */
    amino_acids() {
        const ret = wasm.wasmbio_amino_acids(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    bp_per_turn() {
        const ret = wasm.wasmbio_bp_per_turn(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    codon_len() {
        const ret = wasm.wasmbio_codon_len(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {number}
     */
    codon_redundancy() {
        const ret = wasm.wasmbio_codon_redundancy(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {boolean}
     */
    constant_heartbeats() {
        const ret = wasm.wasmbio_constant_heartbeats(this.__wbg_ptr);
        return ret !== 0;
    }
    /**
     * @returns {bigint}
     */
    dna_bases() {
        const ret = wasm.wasmbio_dna_bases(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {number}
     */
    flory_nu() {
        const ret = wasm.wasmbio_flory_nu(this.__wbg_ptr);
        return ret;
    }
    /**
     * @param {number} m
     * @returns {number}
     */
    heart_rate(m) {
        const ret = wasm.wasmbio_heart_rate(this.__wbg_ptr, m);
        return ret;
    }
    /**
     * @returns {number}
     */
    heart_rate_exp() {
        const ret = wasm.wasmbio_heart_rate_exp(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    helix_per_turn() {
        const ret = wasm.wasmbio_helix_per_turn(this.__wbg_ptr);
        return ret;
    }
    /**
     * @param {number} m
     * @returns {number}
     */
    kleiber(m) {
        const ret = wasm.wasmbio_kleiber(this.__wbg_ptr, m);
        return ret;
    }
    /**
     * @returns {number}
     */
    kleiber_exp() {
        const ret = wasm.wasmbio_kleiber_exp(this.__wbg_ptr);
        return ret;
    }
    /**
     * @param {number} m
     * @returns {number}
     */
    lifespan(m) {
        const ret = wasm.wasmbio_lifespan(this.__wbg_ptr, m);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    lipid_layers() {
        const ret = wasm.wasmbio_lipid_layers(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    constructor() {
        const ret = wasm.wasmbio_new();
        this.__wbg_ptr = ret >>> 0;
        WasmBioFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
    /**
     * @returns {any}
     */
    self_test() {
        const ret = wasm.wasmbio_self_test(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    sense_codons() {
        const ret = wasm.wasmbio_sense_codons(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    stop_codons() {
        const ret = wasm.wasmbio_stop_codons(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {number}
     */
    surface_exp() {
        const ret = wasm.wasmbio_surface_exp(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    total_codons() {
        const ret = wasm.wasmbio_total_codons(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
}
if (Symbol.dispose) WasmBio.prototype[Symbol.dispose] = WasmBio.prototype.free;

export class WasmCFD {
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmCFDFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmcfd_free(ptr, 0);
    }
    /**
     * @param {number} n
     */
    advance(n) {
        wasm.wasmcfd_advance(this.__wbg_ptr, n);
    }
    /**
     * @returns {bigint}
     */
    d2q9_velocities() {
        const ret = wasm.wasmcfd_d2q9_velocities(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {any}
     */
    density_field() {
        const ret = wasm.wasmcfd_density_field(this.__wbg_ptr);
        return ret;
    }
    /**
     * @param {number} k
     * @param {number} eps
     * @returns {number}
     */
    kolmogorov_spectrum(k, eps) {
        const ret = wasm.wasmcfd_kolmogorov_spectrum(this.__wbg_ptr, k, eps);
        return ret;
    }
    /**
     * @param {number} nx
     * @param {number} ny
     * @param {number} tau
     * @param {number} fx
     */
    constructor(nx, ny, tau, fx) {
        const ret = wasm.wasmcfd_new(nx, ny, tau, fx);
        this.__wbg_ptr = ret >>> 0;
        WasmCFDFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
    /**
     * @param {number} rho
     * @param {number} v
     * @param {number} l
     * @param {number} mu
     * @returns {number}
     */
    reynolds_number(rho, v, l, mu) {
        const ret = wasm.wasmcfd_reynolds_number(this.__wbg_ptr, rho, v, l, mu);
        return ret;
    }
    /**
     * @returns {any}
     */
    speed_field() {
        const ret = wasm.wasmcfd_speed_field(this.__wbg_ptr);
        return ret;
    }
    tick() {
        wasm.wasmcfd_tick(this.__wbg_ptr);
    }
    /**
     * @returns {number}
     */
    total_mass() {
        const ret = wasm.wasmcfd_total_mass(this.__wbg_ptr);
        return ret;
    }
}
if (Symbol.dispose) WasmCFD.prototype[Symbol.dispose] = WasmCFD.prototype.free;

export class WasmChem {
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmChemFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmchem_free(ptr, 0);
    }
    /**
     * @returns {number}
     */
    alpha_em() {
        const ret = wasm.wasmchem_alpha_em(this.__wbg_ptr);
        return ret;
    }
    /**
     * @param {number} ea
     * @param {number} kt
     * @returns {number}
     */
    arrhenius(ea, kt) {
        const ret = wasm.wasmchem_arrhenius(this.__wbg_ptr, ea, kt);
        return ret;
    }
    /**
     * @param {number} ea
     * @returns {number}
     */
    arrhenius_bio(ea) {
        const ret = wasm.wasmchem_arrhenius_bio(this.__wbg_ptr, ea);
        return ret;
    }
    /**
     * @returns {number}
     */
    bohr_radius() {
        const ret = wasm.wasmchem_bohr_radius(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    d_capacity() {
        const ret = wasm.wasmchem_d_capacity(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    dielectric_protein() {
        const ret = wasm.wasmchem_dielectric_protein(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {number}
     */
    e_hbond() {
        const ret = wasm.wasmchem_e_hbond(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    eps_vdw() {
        const ret = wasm.wasmchem_eps_vdw(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    f_capacity() {
        const ret = wasm.wasmchem_f_capacity(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {number}
     */
    hartree_ev() {
        const ret = wasm.wasmchem_hartree_ev(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    kt_300() {
        const ret = wasm.wasmchem_kt_300(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    neutral_ph() {
        const ret = wasm.wasmchem_neutral_ph(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    constructor() {
        const ret = wasm.wasmchem_new();
        this.__wbg_ptr = ret >>> 0;
        WasmChemFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
    /**
     * @returns {any}
     */
    noble_gases() {
        const ret = wasm.wasmchem_noble_gases(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    p_capacity() {
        const ret = wasm.wasmchem_p_capacity(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {any}
     */
    period_lengths() {
        const ret = wasm.wasmchem_period_lengths(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    rydberg_ev() {
        const ret = wasm.wasmchem_rydberg_ev(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    s_capacity() {
        const ret = wasm.wasmchem_s_capacity(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {any}
     */
    self_test() {
        const ret = wasm.wasmchem_self_test(this.__wbg_ptr);
        return ret;
    }
    /**
     * @param {bigint} n
     * @returns {bigint}
     */
    shell_capacity(n) {
        const ret = wasm.wasmchem_shell_capacity(this.__wbg_ptr, n);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {number}
     */
    sp2_angle_deg() {
        const ret = wasm.wasmchem_sp2_angle_deg(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    sp3_angle_deg() {
        const ret = wasm.wasmchem_sp3_angle_deg(this.__wbg_ptr);
        return ret;
    }
    /**
     * @param {bigint} l
     * @returns {bigint}
     */
    subshell_capacity(l) {
        const ret = wasm.wasmchem_subshell_capacity(this.__wbg_ptr, l);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {number}
     */
    vdw_kt_ratio() {
        const ret = wasm.wasmchem_vdw_kt_ratio(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    water_angle_deg() {
        const ret = wasm.wasmchem_water_angle_deg(this.__wbg_ptr);
        return ret;
    }
}
if (Symbol.dispose) WasmChem.prototype[Symbol.dispose] = WasmChem.prototype.free;

export class WasmClassical {
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmClassicalFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmclassical_free(ptr, 0);
    }
    /**
     * @param {number} gm
     * @param {number} r
     * @returns {number}
     */
    escape_velocity(gm, r) {
        const ret = wasm.wasmclassical_escape_velocity(this.__wbg_ptr, gm, r);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    force_exponent() {
        const ret = wasm.wasmclassical_force_exponent(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @param {number} gm
     * @param {number} r1
     * @param {number} r2
     * @returns {any}
     */
    hohmann_transfer(gm, r1, r2) {
        const ret = wasm.wasmclassical_hohmann_transfer(this.__wbg_ptr, gm, r1, r2);
        return ret;
    }
    /**
     * Evolve circular orbit and return [[x,y],...] for D3
     * @param {number} gm
     * @param {number} r
     * @param {number} dt
     * @param {number} n
     * @returns {any}
     */
    kepler_orbit(gm, r, dt, n) {
        const ret = wasm.wasmclassical_kepler_orbit(this.__wbg_ptr, gm, r, dt, n);
        return ret;
    }
    /**
     * @param {number} a
     * @param {number} gm
     * @returns {number}
     */
    kepler_period(a, gm) {
        const ret = wasm.wasmclassical_kepler_period(this.__wbg_ptr, a, gm);
        return ret;
    }
    constructor() {
        const ret = wasm.wasmclassical_new();
        this.__wbg_ptr = ret >>> 0;
        WasmClassicalFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
    /**
     * @returns {bigint}
     */
    phase_space_dim() {
        const ret = wasm.wasmclassical_phase_space_dim(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * Slingshot trajectory [[x,y,speed],...]
     * @param {number} gm_star
     * @param {number} gm_planet
     * @param {number} r_planet
     * @param {number} r_ship
     * @param {number} v_ship
     * @param {number} dt
     * @param {number} n
     * @returns {any}
     */
    slingshot_traj(gm_star, gm_planet, r_planet, r_ship, v_ship, dt, n) {
        const ret = wasm.wasmclassical_slingshot_traj(this.__wbg_ptr, gm_star, gm_planet, r_planet, r_ship, v_ship, dt, n);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    spatial_dim() {
        const ret = wasm.wasmclassical_spatial_dim(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @param {number} gm
     * @param {number} r
     * @param {number} a
     * @returns {number}
     */
    vis_viva(gm, r, a) {
        const ret = wasm.wasmclassical_vis_viva(this.__wbg_ptr, gm, r, a);
        return ret;
    }
}
if (Symbol.dispose) WasmClassical.prototype[Symbol.dispose] = WasmClassical.prototype.free;

export class WasmCondensed {
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmCondensedFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmcondensed_free(ptr, 0);
    }
    /**
     * @returns {number}
     */
    bcs_ratio() {
        const ret = wasm.wasmcondensed_bcs_ratio(this.__wbg_ptr);
        return ret;
    }
    /**
     * @param {number} t
     * @returns {number}
     */
    ising_magnetization(t) {
        const ret = wasm.wasmcondensed_ising_magnetization(this.__wbg_ptr, t);
        return ret;
    }
    /**
     * Ising MC run: returns [[sweep, magnetization],...] for D3
     * @param {number} n
     * @param {number} n_sweeps
     * @param {number} inv_t
     * @param {number} sample
     * @returns {any}
     */
    ising_run(n, n_sweeps, inv_t, sample) {
        const ret = wasm.wasmcondensed_ising_run(this.__wbg_ptr, n, n_sweeps, inv_t, sample);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    ising_z_cubic() {
        const ret = wasm.wasmcondensed_ising_z_cubic(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    ising_z_square() {
        const ret = wasm.wasmcondensed_ising_z_square(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    constructor() {
        const ret = wasm.wasmcondensed_new();
        this.__wbg_ptr = ret >>> 0;
        WasmCondensedFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
    /**
     * @returns {number}
     */
    onsager_tc() {
        const ret = wasm.wasmcondensed_onsager_tc(this.__wbg_ptr);
        return ret;
    }
}
if (Symbol.dispose) WasmCondensed.prototype[Symbol.dispose] = WasmCondensed.prototype.free;

export class WasmDecay {
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmDecayFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmdecay_free(ptr, 0);
    }
    /**
     * @returns {number}
     */
    beta_endpoint() {
        const ret = wasm.wasmdecay_beta_endpoint(this.__wbg_ptr);
        return ret;
    }
    /**
     * @param {number} n
     * @returns {any}
     */
    beta_spectrum_curve(n) {
        const ret = wasm.wasmdecay_beta_spectrum_curve(this.__wbg_ptr, n);
        return ret;
    }
    /**
     * @param {number} me2
     * @param {number} dos
     * @returns {number}
     */
    fermi_golden_rule(me2, dos) {
        const ret = wasm.wasmdecay_fermi_golden_rule(this.__wbg_ptr, me2, dos);
        return ret;
    }
    /**
     * @returns {number}
     */
    g_fermi() {
        const ret = wasm.wasmdecay_g_fermi(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    neutron_lifetime() {
        const ret = wasm.wasmdecay_neutron_lifetime(this.__wbg_ptr);
        return ret;
    }
    constructor() {
        const ret = wasm.wasmdecay_new();
        this.__wbg_ptr = ret >>> 0;
        WasmDecayFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
    /**
     * @param {number} sin2_2th
     * @param {number} dm2
     * @param {number} l_e
     * @returns {number}
     */
    oscill_prob(sin2_2th, dm2, l_e) {
        const ret = wasm.wasmdecay_oscill_prob(this.__wbg_ptr, sin2_2th, dm2, l_e);
        return ret;
    }
    /**
     * @returns {number}
     */
    sin2_theta_12() {
        const ret = wasm.wasmdecay_sin2_theta_12(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    sin2_theta_23() {
        const ret = wasm.wasmdecay_sin2_theta_23(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    sin2_theta_w() {
        const ret = wasm.wasmdecay_sin2_theta_w(this.__wbg_ptr);
        return ret;
    }
}
if (Symbol.dispose) WasmDecay.prototype[Symbol.dispose] = WasmDecay.prototype.free;

export class WasmEM {
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmEMFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmem_free(ptr, 0);
    }
    /**
     * @param {number} n
     */
    advance(n) {
        wasm.wasmem_advance(this.__wbg_ptr, n);
    }
    /**
     * @returns {any}
     */
    bz_field() {
        const ret = wasm.wasmem_bz_field(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    current_step() {
        const ret = wasm.wasmem_current_step(this.__wbg_ptr);
        return ret >>> 0;
    }
    /**
     * @returns {number}
     */
    current_time() {
        const ret = wasm.wasmem_current_time(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    em_components() {
        const ret = wasm.wasmem_em_components(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {number}
     */
    energy() {
        const ret = wasm.wasmem_energy(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {any}
     */
    ey_field() {
        const ret = wasm.wasmem_ey_field(this.__wbg_ptr);
        return ret;
    }
    /**
     * @param {number} q
     * @param {number} a
     * @returns {number}
     */
    larmor_power(q, a) {
        const ret = wasm.wasmem_larmor_power(this.__wbg_ptr, q, a);
        return ret;
    }
    /**
     * @param {number} n_grid
     * @param {number} center
     * @param {number} width
     * @param {number} amp
     * @param {number} courant
     */
    constructor(n_grid, center, width, amp, courant) {
        const ret = wasm.wasmem_new(n_grid, center, width, amp, courant);
        this.__wbg_ptr = ret >>> 0;
        WasmEMFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
    /**
     * @param {number} l
     * @param {number} t
     * @returns {number}
     */
    planck_radiance(l, t) {
        const ret = wasm.wasmem_planck_radiance(this.__wbg_ptr, l, t);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    polarization_states() {
        const ret = wasm.wasmem_polarization_states(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @param {number} d
     * @param {number} l
     * @returns {number}
     */
    rayleigh_sigma(d, l) {
        const ret = wasm.wasmem_rayleigh_sigma(this.__wbg_ptr, d, l);
        return ret;
    }
    /**
     * @param {number} t
     * @returns {number}
     */
    stefan_boltzmann_power(t) {
        const ret = wasm.wasmem_stefan_boltzmann_power(this.__wbg_ptr, t);
        return ret;
    }
    tick() {
        wasm.wasmem_tick(this.__wbg_ptr);
    }
}
if (Symbol.dispose) WasmEM.prototype[Symbol.dispose] = WasmEM.prototype.free;

export class WasmFriedmann {
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmFriedmannFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmfriedmann_free(ptr, 0);
    }
    /**
     * @returns {number}
     */
    acceleration_onset() {
        const ret = wasm.wasmfriedmann_acceleration_onset(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    age_analytic() {
        const ret = wasm.wasmfriedmann_age_analytic(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    cmb_temperature() {
        const ret = wasm.wasmfriedmann_cmb_temperature(this.__wbg_ptr);
        return ret;
    }
    /**
     * @param {number} z
     * @param {number} n
     * @returns {number}
     */
    comoving_distance(z, n) {
        const ret = wasm.wasmfriedmann_comoving_distance(this.__wbg_ptr, z, n);
        return ret;
    }
    /**
     * @param {number} a
     * @returns {number}
     */
    deceleration_param(a) {
        const ret = wasm.wasmfriedmann_deceleration_param(this.__wbg_ptr, a);
        return ret;
    }
    /**
     * @returns {number}
     */
    dm_baryon_ratio() {
        const ret = wasm.wasmfriedmann_dm_baryon_ratio(this.__wbg_ptr);
        return ret;
    }
    /**
     * Friedmann evolution [[t,a,z],...] for D3
     * @param {number} a_init
     * @param {number} a_final
     * @param {number} dt
     * @param {number} max
     * @returns {any}
     */
    evolve(a_init, a_final, dt, max) {
        const ret = wasm.wasmfriedmann_evolve(this.__wbg_ptr, a_init, a_final, dt, max);
        return ret;
    }
    /**
     * @returns {number}
     */
    h0_crystal() {
        const ret = wasm.wasmfriedmann_h0_crystal(this.__wbg_ptr);
        return ret;
    }
    /**
     * @param {number} a
     * @returns {number}
     */
    hubble_norm(a) {
        const ret = wasm.wasmfriedmann_hubble_norm(this.__wbg_ptr, a);
        return ret;
    }
    /**
     * @param {number} z
     * @param {number} n
     * @returns {number}
     */
    luminosity_distance(z, n) {
        const ret = wasm.wasmfriedmann_luminosity_distance(this.__wbg_ptr, z, n);
        return ret;
    }
    constructor() {
        const ret = wasm.wasmfriedmann_new();
        this.__wbg_ptr = ret >>> 0;
        WasmFriedmannFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
    /**
     * @returns {number}
     */
    omega_baryon() {
        const ret = wasm.wasmfriedmann_omega_baryon(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    omega_dm() {
        const ret = wasm.wasmfriedmann_omega_dm(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    omega_lambda() {
        const ret = wasm.wasmfriedmann_omega_lambda(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    omega_matter() {
        const ret = wasm.wasmfriedmann_omega_matter(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    spectral_index() {
        const ret = wasm.wasmfriedmann_spectral_index(this.__wbg_ptr);
        return ret;
    }
}
if (Symbol.dispose) WasmFriedmann.prototype[Symbol.dispose] = WasmFriedmann.prototype.free;

export class WasmGR {
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmGRFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmgr_free(ptr, 0);
    }
    /**
     * @returns {bigint}
     */
    bending_factor() {
        const ret = wasm.wasmgr_bending_factor(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * Geodesic orbit [[r,phi],...] for D3 polar plot
     * @param {number} rs
     * @param {number} ang_l
     * @param {number} energy
     * @param {number} dtau
     * @param {number} n
     * @returns {any}
     */
    geodesic(rs, ang_l, energy, dtau, n) {
        const ret = wasm.wasmgr_geodesic(this.__wbg_ptr, rs, ang_l, energy, dtau, n);
        return ret;
    }
    /**
     * @param {number} rs
     * @param {number} r
     * @returns {number}
     */
    gravitational_redshift(rs, r) {
        const ret = wasm.wasmgr_gravitational_redshift(this.__wbg_ptr, rs, r);
        return ret;
    }
    /**
     * @returns {number}
     */
    isco_energy() {
        const ret = wasm.wasmgr_isco_energy(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    isco_factor() {
        const ret = wasm.wasmgr_isco_factor(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @param {number} gm
     * @returns {number}
     */
    isco_radius(gm) {
        const ret = wasm.wasmgr_isco_radius(this.__wbg_ptr, gm);
        return ret;
    }
    /**
     * @param {number} rs
     * @param {number} b
     * @returns {number}
     */
    light_bending_analytic(rs, b) {
        const ret = wasm.wasmgr_light_bending_analytic(this.__wbg_ptr, rs, b);
        return ret;
    }
    constructor() {
        const ret = wasm.wasmgr_new();
        this.__wbg_ptr = ret >>> 0;
        WasmGRFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
    /**
     * @returns {bigint}
     */
    photon_sphere() {
        const ret = wasm.wasmgr_photon_sphere(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @param {number} rs
     * @param {number} a
     * @param {number} e
     * @returns {number}
     */
    precession_analytic(rs, a, e) {
        const ret = wasm.wasmgr_precession_analytic(this.__wbg_ptr, rs, a, e);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    precession_factor() {
        const ret = wasm.wasmgr_precession_factor(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    schwarz_factor() {
        const ret = wasm.wasmgr_schwarz_factor(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @param {number} gm
     * @returns {number}
     */
    schwarzschild_r(gm) {
        const ret = wasm.wasmgr_schwarzschild_r(this.__wbg_ptr, gm);
        return ret;
    }
    /**
     * @param {number} gm
     * @param {number} r1
     * @param {number} r2
     * @param {number} b
     * @returns {number}
     */
    shapiro_delay(gm, r1, r2, b) {
        const ret = wasm.wasmgr_shapiro_delay(this.__wbg_ptr, gm, r1, r2, b);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    spacetime_dim() {
        const ret = wasm.wasmgr_spacetime_dim(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @param {number} rs
     * @param {number} l
     * @param {number} r
     * @returns {number}
     */
    v_eff_massive(rs, l, r) {
        const ret = wasm.wasmgr_v_eff_massive(this.__wbg_ptr, rs, l, r);
        return ret;
    }
    /**
     * @param {number} rs
     * @param {number} l
     * @param {number} r
     * @returns {number}
     */
    v_eff_photon(rs, l, r) {
        const ret = wasm.wasmgr_v_eff_photon(this.__wbg_ptr, rs, l, r);
        return ret;
    }
    /**
     * Effective potential curve [[r, V_eff],...] for D3
     * @param {number} rs
     * @param {number} l
     * @param {number} r_min
     * @param {number} r_max
     * @param {number} n
     * @returns {any}
     */
    veff_curve(rs, l, r_min, r_max, n) {
        const ret = wasm.wasmgr_veff_curve(this.__wbg_ptr, rs, l, r_min, r_max, n);
        return ret;
    }
}
if (Symbol.dispose) WasmGR.prototype[Symbol.dispose] = WasmGR.prototype.free;

export class WasmGW {
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmGWFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmgw_free(ptr, 0);
    }
    /**
     * @param {number} m1
     * @param {number} m2
     * @returns {number}
     */
    chirp_mass(m1, m2) {
        const ret = wasm.wasmgw_chirp_mass(this.__wbg_ptr, m1, m2);
        return ret;
    }
    /**
     * @param {number} m
     * @param {number} a
     * @returns {number}
     */
    gw_frequency(m, a) {
        const ret = wasm.wasmgw_gw_frequency(this.__wbg_ptr, m, a);
        return ret;
    }
    /**
     * @param {number} mu
     * @param {number} m
     * @param {number} a
     * @returns {number}
     */
    gw_power(mu, m, a) {
        const ret = wasm.wasmgw_gw_power(this.__wbg_ptr, mu, m, a);
        return ret;
    }
    /**
     * Binary inspiral [[t,a,freq],...] for D3
     * @param {number} m1
     * @param {number} m2
     * @param {number} a0
     * @param {number} dt
     * @returns {any}
     */
    inspiral(m1, m2, a0, dt) {
        const ret = wasm.wasmgw_inspiral(this.__wbg_ptr, m1, m2, a0, dt);
        return ret;
    }
    /**
     * @param {number} m
     * @returns {number}
     */
    isco_frequency(m) {
        const ret = wasm.wasmgw_isco_frequency(this.__wbg_ptr, m);
        return ret;
    }
    constructor() {
        const ret = wasm.wasmgw_new();
        this.__wbg_ptr = ret >>> 0;
        WasmGWFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
    /**
     * @returns {number}
     */
    peters_coefficient() {
        const ret = wasm.wasmgw_peters_coefficient(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    polarizations() {
        const ret = wasm.wasmgw_polarizations(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    quadrupole_order() {
        const ret = wasm.wasmgw_quadrupole_order(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @param {number} mc
     * @param {number} f
     * @returns {number}
     */
    time_to_merger(mc, f) {
        const ret = wasm.wasmgw_time_to_merger(this.__wbg_ptr, mc, f);
        return ret;
    }
    /**
     * Inspiral waveform [[t,h+,h×,freq],...] for D3
     * @param {number} m1
     * @param {number} m2
     * @param {number} dist
     * @param {number} iota
     * @param {number} f0
     * @param {number} dt
     * @returns {any}
     */
    waveform(m1, m2, dist, iota, f0, dt) {
        const ret = wasm.wasmgw_waveform(this.__wbg_ptr, m1, m2, dist, iota, f0, dt);
        return ret;
    }
}
if (Symbol.dispose) WasmGW.prototype[Symbol.dispose] = WasmGW.prototype.free;

export class WasmMD {
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmMDFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmmd_free(ptr, 0);
    }
    /**
     * @param {number} q1
     * @param {number} q2
     * @param {number} r
     * @returns {number}
     */
    coulomb_force(q1, q2, r) {
        const ret = wasm.wasmmd_coulomb_force(this.__wbg_ptr, q1, q2, r);
        return ret;
    }
    /**
     * @param {number} q1
     * @param {number} q2
     * @param {number} r
     * @returns {number}
     */
    coulomb_potential(q1, q2, r) {
        const ret = wasm.wasmmd_coulomb_potential(this.__wbg_ptr, q1, q2, r);
        return ret;
    }
    /**
     * @returns {number}
     */
    flory_nu() {
        const ret = wasm.wasmmd_flory_nu(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    helix_per_turn() {
        const ret = wasm.wasmmd_helix_per_turn(this.__wbg_ptr);
        return ret;
    }
    /**
     * LJ + force curves [[r, V, F],...] for D3
     * @param {number} rmin
     * @param {number} rmax
     * @param {number} n
     * @returns {any}
     */
    lj_curves(rmin, rmax, n) {
        const ret = wasm.wasmmd_lj_curves(this.__wbg_ptr, rmin, rmax, n);
        return ret;
    }
    /**
     * @param {number} r
     * @returns {number}
     */
    lj_dvdr(r) {
        const ret = wasm.wasmmd_lj_dvdr(this.__wbg_ptr, r);
        return ret;
    }
    /**
     * @param {number} r
     * @returns {number}
     */
    lj_potential(r) {
        const ret = wasm.wasmmd_lj_potential(this.__wbg_ptr, r);
        return ret;
    }
    /**
     * 2-body MD vibration [[x1,x2],...] for D3
     * @param {number} dt
     * @param {number} n
     * @returns {any}
     */
    md2_evolve(dt, n) {
        const ret = wasm.wasmmd_md2_evolve(this.__wbg_ptr, dt, n);
        return ret;
    }
    constructor() {
        const ret = wasm.wasmmd_new();
        this.__wbg_ptr = ret >>> 0;
        WasmMDFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
    /**
     * @returns {number}
     */
    tetrahedral_angle() {
        const ret = wasm.wasmmd_tetrahedral_angle(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    water_angle() {
        const ret = wasm.wasmmd_water_angle(this.__wbg_ptr);
        return ret;
    }
}
if (Symbol.dispose) WasmMD.prototype[Symbol.dispose] = WasmMD.prototype.free;

export class WasmMonad {
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmMonadFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmmonad_free(ptr, 0);
    }
    /**
     * @param {bigint} n
     */
    advance(n) {
        wasm.wasmmonad_advance(this.__wbg_ptr, n);
    }
    /**
     * @returns {any}
     */
    amplitudes() {
        const ret = wasm.wasmmonad_amplitudes(this.__wbg_ptr);
        return ret;
    }
    /**
     * @param {bigint} t
     */
    at_tick(t) {
        wasm.wasmmonad_at_tick(this.__wbg_ptr, t);
    }
    /**
     * @returns {bigint}
     */
    current_tick() {
        const ret = wasm.wasmmonad_current_tick(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {number}
     */
    entropy() {
        const ret = wasm.wasmmonad_entropy(this.__wbg_ptr);
        return ret;
    }
    /**
     * @param {bigint} n
     * @returns {any}
     */
    history(n) {
        const ret = wasm.wasmmonad_history(this.__wbg_ptr, n);
        return ret;
    }
    /**
     * @param {number} l
     * @returns {number}
     */
    hologron_potential(l) {
        const ret = wasm.wasmmonad_hologron_potential(this.__wbg_ptr, l);
        return ret;
    }
    constructor() {
        const ret = wasm.wasmmonad_new();
        this.__wbg_ptr = ret >>> 0;
        WasmMonadFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
    /**
     * @returns {any}
     */
    snapshot() {
        const ret = wasm.wasmmonad_snapshot(this.__wbg_ptr);
        return ret;
    }
    tick() {
        wasm.wasmmonad_tick(this.__wbg_ptr);
    }
}
if (Symbol.dispose) WasmMonad.prototype[Symbol.dispose] = WasmMonad.prototype.free;

export class WasmNBody {
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmNBodyFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmnbody_free(ptr, 0);
    }
    /**
     * @param {number} px
     * @param {number} py
     * @param {number} pz
     * @param {number} vx
     * @param {number} vy
     * @param {number} vz
     * @param {number} m
     */
    add_body(px, py, pz, vx, vy, vz, m) {
        wasm.wasmnbody_add_body(this.__wbg_ptr, px, py, pz, vx, vy, vz, m);
    }
    /**
     * @param {number} n
     * @param {number} tm
     * @param {number} rs
     * @param {number} cx
     * @param {number} cy
     * @param {number} cz
     * @param {number} bvx
     * @param {number} bvy
     * @param {number} bvz
     */
    add_galaxy(n, tm, rs, cx, cy, cz, bvx, bvy, bvz) {
        wasm.wasmnbody_add_galaxy(this.__wbg_ptr, n, tm, rs, cx, cy, cz, bvx, bvy, bvz);
    }
    /**
     * @param {number} n
     */
    advance(n) {
        wasm.wasmnbody_advance(this.__wbg_ptr, n);
    }
    /**
     * @returns {any}
     */
    bodies() {
        const ret = wasm.wasmnbody_bodies(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    current_step() {
        const ret = wasm.wasmnbody_current_step(this.__wbg_ptr);
        return ret >>> 0;
    }
    /**
     * @returns {number}
     */
    kinetic_energy() {
        const ret = wasm.wasmnbody_kinetic_energy(this.__wbg_ptr);
        return ret;
    }
    load_figure_eight() {
        wasm.wasmnbody_load_figure_eight(this.__wbg_ptr);
    }
    load_solar_system() {
        wasm.wasmnbody_load_solar_system(this.__wbg_ptr);
    }
    /**
     * @returns {number}
     */
    n_bodies() {
        const ret = wasm.wasmnbody_n_bodies(this.__wbg_ptr);
        return ret >>> 0;
    }
    /**
     * @param {number} dt
     * @param {number} eps
     */
    constructor(dt, eps) {
        const ret = wasm.wasmnbody_new(dt, eps);
        this.__wbg_ptr = ret >>> 0;
        WasmNBodyFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
    /**
     * @returns {bigint}
     */
    octree_children() {
        const ret = wasm.wasmnbody_octree_children(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {any}
     */
    positions_2d() {
        const ret = wasm.wasmnbody_positions_2d(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {any}
     */
    positions_2d_mass() {
        const ret = wasm.wasmnbody_positions_2d_mass(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    potential_energy() {
        const ret = wasm.wasmnbody_potential_energy(this.__wbg_ptr);
        return ret;
    }
    tick() {
        wasm.wasmnbody_tick(this.__wbg_ptr);
    }
    /**
     * @returns {number}
     */
    total_energy() {
        const ret = wasm.wasmnbody_total_energy(this.__wbg_ptr);
        return ret;
    }
}
if (Symbol.dispose) WasmNBody.prototype[Symbol.dispose] = WasmNBody.prototype.free;

export class WasmNuclear {
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmNuclearFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmnuclear_free(ptr, 0);
    }
    /**
     * @returns {bigint}
     */
    alpha_particle() {
        const ret = wasm.wasmnuclear_alpha_particle(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @param {number} max_a
     * @returns {any}
     */
    binding_curve(max_a) {
        const ret = wasm.wasmnuclear_binding_curve(this.__wbg_ptr, max_a);
        return ret;
    }
    /**
     * @param {number} a
     * @param {number} z
     * @returns {number}
     */
    binding_energy(a, z) {
        const ret = wasm.wasmnuclear_binding_energy(this.__wbg_ptr, a, z);
        return ret;
    }
    /**
     * @param {number} a
     * @param {number} z
     * @returns {number}
     */
    binding_per_nucleon(a, z) {
        const ret = wasm.wasmnuclear_binding_per_nucleon(this.__wbg_ptr, a, z);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    deuteron_a() {
        const ret = wasm.wasmnuclear_deuteron_a(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    iron_peak() {
        const ret = wasm.wasmnuclear_iron_peak(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    isospin_states() {
        const ret = wasm.wasmnuclear_isospin_states(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {any}
     */
    magic_numbers() {
        const ret = wasm.wasmnuclear_magic_numbers(this.__wbg_ptr);
        return ret;
    }
    constructor() {
        const ret = wasm.wasmnuclear_new();
        this.__wbg_ptr = ret >>> 0;
        WasmNuclearFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
    /**
     * @param {number} a
     * @returns {number}
     */
    nuclear_radius(a) {
        const ret = wasm.wasmnuclear_nuclear_radius(this.__wbg_ptr, a);
        return ret;
    }
    /**
     * @param {number} a
     * @returns {number}
     */
    nuclear_volume(a) {
        const ret = wasm.wasmnuclear_nuclear_volume(this.__wbg_ptr, a);
        return ret;
    }
    /**
     * @param {number} a
     * @returns {number}
     */
    optimal_z(a) {
        const ret = wasm.wasmnuclear_optimal_z(this.__wbg_ptr, a);
        return ret >>> 0;
    }
    /**
     * @param {number} max_a
     * @returns {any}
     */
    peak_nucleus(max_a) {
        const ret = wasm.wasmnuclear_peak_nucleus(this.__wbg_ptr, max_a);
        return ret;
    }
    /**
     * @returns {any}
     */
    self_test() {
        const ret = wasm.wasmnuclear_self_test(this.__wbg_ptr);
        return ret;
    }
}
if (Symbol.dispose) WasmNuclear.prototype[Symbol.dispose] = WasmNuclear.prototype.free;

export class WasmOptics {
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmOpticsFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmoptics_free(ptr, 0);
    }
    /**
     * @param {number} l
     * @param {number} ap
     * @returns {number}
     */
    airy_radius(l, ap) {
        const ret = wasm.wasmoptics_airy_radius(this.__wbg_ptr, l, ap);
        return ret;
    }
    /**
     * @param {number} n1
     * @param {number} n2
     * @returns {number}
     */
    brewster_angle(n1, n2) {
        const ret = wasm.wasmoptics_brewster_angle(this.__wbg_ptr, n1, n2);
        return ret;
    }
    /**
     * Fresnel curves [[theta, rs, rp, R],...] for D3
     * @param {number} n1
     * @param {number} n2
     * @param {number} n_pts
     * @returns {any}
     */
    fresnel_curve(n1, n2, n_pts) {
        const ret = wasm.wasmoptics_fresnel_curve(this.__wbg_ptr, n1, n2, n_pts);
        return ret;
    }
    /**
     * @param {number} n1
     * @param {number} n2
     * @param {number} th
     * @returns {number}
     */
    fresnel_r(n1, n2, th) {
        const ret = wasm.wasmoptics_fresnel_r(this.__wbg_ptr, n1, n2, th);
        return ret;
    }
    /**
     * @returns {number}
     */
    n_diamond() {
        const ret = wasm.wasmoptics_n_diamond(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    n_glass() {
        const ret = wasm.wasmoptics_n_glass(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    n_water() {
        const ret = wasm.wasmoptics_n_water(this.__wbg_ptr);
        return ret;
    }
    constructor() {
        const ret = wasm.wasmoptics_new();
        this.__wbg_ptr = ret >>> 0;
        WasmOpticsFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
    /**
     * @param {number} n1
     * @param {number} n2
     * @returns {number}
     */
    normal_reflectance(n1, n2) {
        const ret = wasm.wasmoptics_normal_reflectance(this.__wbg_ptr, n1, n2);
        return ret;
    }
    /**
     * @param {number} l
     * @param {number} t
     * @returns {number}
     */
    planck_radiance(l, t) {
        const ret = wasm.wasmoptics_planck_radiance(this.__wbg_ptr, l, t);
        return ret;
    }
    /**
     * @param {number} l0
     * @param {number} l
     * @returns {number}
     */
    rayleigh_intensity(l0, l) {
        const ret = wasm.wasmoptics_rayleigh_intensity(this.__wbg_ptr, l0, l);
        return ret;
    }
    /**
     * @returns {number}
     */
    sky_blue_ratio() {
        const ret = wasm.wasmoptics_sky_blue_ratio(this.__wbg_ptr);
        return ret;
    }
    /**
     * @param {number} n1
     * @param {number} n2
     * @param {number} th
     * @returns {number}
     */
    snell(n1, n2, th) {
        const ret = wasm.wasmoptics_snell(this.__wbg_ptr, n1, n2, th);
        return ret;
    }
    /**
     * @param {number} t
     * @returns {number}
     */
    wien_displacement(t) {
        const ret = wasm.wasmoptics_wien_displacement(this.__wbg_ptr, t);
        return ret;
    }
}
if (Symbol.dispose) WasmOptics.prototype[Symbol.dispose] = WasmOptics.prototype.free;

export class WasmPlasma {
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmPlasmaFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmplasma_free(ptr, 0);
    }
    /**
     * @param {number} b
     * @param {number} rho
     * @returns {number}
     */
    alfven_speed(b, rho) {
        const ret = wasm.wasmplasma_alfven_speed(this.__wbg_ptr, b, rho);
        return ret;
    }
    /**
     * @param {number} q
     * @param {number} b
     * @param {number} m
     * @returns {number}
     */
    cyclotron_frequency(q, b, m) {
        const ret = wasm.wasmplasma_cyclotron_frequency(this.__wbg_ptr, q, b, m);
        return ret;
    }
    /**
     * @param {number} kt
     * @param {number} n
     * @param {number} q
     * @returns {number}
     */
    debye_length(kt, n, q) {
        const ret = wasm.wasmplasma_debye_length(this.__wbg_ptr, kt, n, q);
        return ret;
    }
    /**
     * @param {number} m
     * @param {number} v
     * @param {number} q
     * @param {number} b
     * @returns {number}
     */
    larmor_radius(m, v, q, b) {
        const ret = wasm.wasmplasma_larmor_radius(this.__wbg_ptr, m, v, q, b);
        return ret;
    }
    /**
     * @returns {number}
     */
    mhd_energy() {
        const ret = wasm.wasmplasma_mhd_energy(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    mhd_states() {
        const ret = wasm.wasmplasma_mhd_states(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    constructor() {
        const ret = wasm.wasmplasma_new();
        this.__wbg_ptr = ret >>> 0;
        WasmPlasmaFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
    /**
     * @param {number} p
     * @param {number} b
     * @returns {number}
     */
    plasma_beta(p, b) {
        const ret = wasm.wasmplasma_plasma_beta(this.__wbg_ptr, p, b);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    propagating_modes() {
        const ret = wasm.wasmplasma_propagating_modes(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    wave_types() {
        const ret = wasm.wasmplasma_wave_types(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
}
if (Symbol.dispose) WasmPlasma.prototype[Symbol.dispose] = WasmPlasma.prototype.free;

export class WasmQFT {
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmQFTFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmqft_free(ptr, 0);
    }
    /**
     * @returns {number}
     */
    alpha_inv() {
        const ret = wasm.wasmqft_alpha_inv(this.__wbg_ptr);
        return ret;
    }
    /**
     * α_s running [[Q, α_s],...] for D3
     * @param {number} qmin
     * @param {number} qmax
     * @param {number} lambda
     * @param {number} n
     * @returns {any}
     */
    alpha_s_curve(qmin, qmax, lambda, n) {
        const ret = wasm.wasmqft_alpha_s_curve(this.__wbg_ptr, qmin, qmax, lambda, n);
        return ret;
    }
    /**
     * @returns {number}
     */
    alpha_s_mz() {
        const ret = wasm.wasmqft_alpha_s_mz(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    dirac_gammas() {
        const ret = wasm.wasmqft_dirac_gammas(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    gluon_colours() {
        const ret = wasm.wasmqft_gluon_colours(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    lorentz_gen() {
        const ret = wasm.wasmqft_lorentz_gen(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    constructor() {
        const ret = wasm.wasmqft_new();
        this.__wbg_ptr = ret >>> 0;
        WasmQFTFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
    /**
     * @param {number} m
     * @returns {number}
     */
    pair_threshold(m) {
        const ret = wasm.wasmqft_pair_threshold(this.__wbg_ptr, m);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    photon_pol() {
        const ret = wasm.wasmqft_photon_pol(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    qcd_beta0() {
        const ret = wasm.wasmqft_qcd_beta0(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * e+e- → μ+μ- cross-section curve [[√s, σ],...] for D3
     * @param {number} smin
     * @param {number} smax
     * @param {number} n
     * @returns {any}
     */
    sigma_curve(smin, smax, n) {
        const ret = wasm.wasmqft_sigma_curve(this.__wbg_ptr, smin, smax, n);
        return ret;
    }
    /**
     * @param {number} s
     * @returns {number}
     */
    sigma_ee_mumu(s) {
        const ret = wasm.wasmqft_sigma_ee_mumu(this.__wbg_ptr, s);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    spacetime_dim() {
        const ret = wasm.wasmqft_spacetime_dim(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {number}
     */
    thomson_cs() {
        const ret = wasm.wasmqft_thomson_cs(this.__wbg_ptr);
        return ret;
    }
}
if (Symbol.dispose) WasmQFT.prototype[Symbol.dispose] = WasmQFT.prototype.free;

export class WasmQInfo {
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmQInfoFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmqinfo_free(ptr, 0);
    }
    /**
     * @returns {number}
     */
    bell_entropy() {
        const ret = wasm.wasmqinfo_bell_entropy(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    bell_states() {
        const ret = wasm.wasmqinfo_bell_states(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {boolean}
     */
    coprimality_check() {
        const ret = wasm.wasmqinfo_coprimality_check(this.__wbg_ptr);
        return ret !== 0;
    }
    /**
     * @returns {boolean}
     */
    hamming_check() {
        const ret = wasm.wasmqinfo_hamming_check(this.__wbg_ptr);
        return ret !== 0;
    }
    /**
     * @param {number} a
     * @param {number} b
     * @returns {number}
     */
    heyting_join(a, b) {
        const ret = wasm.wasmqinfo_heyting_join(this.__wbg_ptr, a, b);
        return ret;
    }
    /**
     * @param {number} a
     * @param {number} b
     * @returns {number}
     */
    heyting_meet(a, b) {
        const ret = wasm.wasmqinfo_heyting_meet(this.__wbg_ptr, a, b);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    mera_bond() {
        const ret = wasm.wasmqinfo_mera_bond(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    mera_depth() {
        const ret = wasm.wasmqinfo_mera_depth(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {number}
     */
    mera_link_entropy() {
        const ret = wasm.wasmqinfo_mera_link_entropy(this.__wbg_ptr);
        return ret;
    }
    constructor() {
        const ret = wasm.wasmqinfo_new();
        this.__wbg_ptr = ret >>> 0;
        WasmQInfoFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
    /**
     * @returns {bigint}
     */
    pauli_group() {
        const ret = wasm.wasmqinfo_pauli_group(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    pauli_matrices() {
        const ret = wasm.wasmqinfo_pauli_matrices(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    qubit_states() {
        const ret = wasm.wasmqinfo_qubit_states(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {any}
     */
    self_test() {
        const ret = wasm.wasmqinfo_self_test(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    shor_n() {
        const ret = wasm.wasmqinfo_shor_n(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    steane_corrects() {
        const ret = wasm.wasmqinfo_steane_corrects(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    steane_d() {
        const ret = wasm.wasmqinfo_steane_d(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    steane_n() {
        const ret = wasm.wasmqinfo_steane_n(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    toffoli() {
        const ret = wasm.wasmqinfo_toffoli(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    tomography_min() {
        const ret = wasm.wasmqinfo_tomography_min(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
}
if (Symbol.dispose) WasmQInfo.prototype[Symbol.dispose] = WasmQInfo.prototype.free;

export class WasmRigid {
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmRigidFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmrigid_free(ptr, 0);
    }
    /**
     * @param {number} m
     * @param {number} r
     * @returns {number}
     */
    i_disk(m, r) {
        const ret = wasm.wasmrigid_i_disk(this.__wbg_ptr, m, r);
        return ret;
    }
    /**
     * @param {number} m
     * @param {number} l
     * @returns {number}
     */
    i_rod(m, l) {
        const ret = wasm.wasmrigid_i_rod(this.__wbg_ptr, m, l);
        return ret;
    }
    /**
     * @param {number} m
     * @param {number} r
     * @returns {number}
     */
    i_shell(m, r) {
        const ret = wasm.wasmrigid_i_shell(this.__wbg_ptr, m, r);
        return ret;
    }
    /**
     * @returns {number}
     */
    i_shell_factor() {
        const ret = wasm.wasmrigid_i_shell_factor(this.__wbg_ptr);
        return ret;
    }
    /**
     * @param {number} m
     * @param {number} r
     * @returns {number}
     */
    i_sphere(m, r) {
        const ret = wasm.wasmrigid_i_sphere(this.__wbg_ptr, m, r);
        return ret;
    }
    /**
     * @returns {number}
     */
    i_sphere_factor() {
        const ret = wasm.wasmrigid_i_sphere_factor(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    inertia_indep() {
        const ret = wasm.wasmrigid_inertia_indep(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    constructor() {
        const ret = wasm.wasmrigid_new();
        this.__wbg_ptr = ret >>> 0;
        WasmRigidFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
    /**
     * @returns {bigint}
     */
    quat_components() {
        const ret = wasm.wasmrigid_quat_components(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    rigid_dof() {
        const ret = wasm.wasmrigid_rigid_dof(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * Euler tumbling [[wx,wy,wz],...] for D3
     * @param {number} ix
     * @param {number} iy
     * @param {number} iz
     * @param {number} wx
     * @param {number} wy
     * @param {number} wz
     * @param {number} dt
     * @param {number} n
     * @returns {any}
     */
    tumbling(ix, iy, iz, wx, wy, wz, dt, n) {
        const ret = wasm.wasmrigid_tumbling(this.__wbg_ptr, ix, iy, iz, wx, wy, wz, dt, n);
        return ret;
    }
}
if (Symbol.dispose) WasmRigid.prototype[Symbol.dispose] = WasmRigid.prototype.free;

export class WasmThermo {
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmThermoFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmthermo_free(ptr, 0);
    }
    /**
     * @returns {number}
     */
    carnot_efficiency() {
        const ret = wasm.wasmthermo_carnot_efficiency(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    entropy_per_tick() {
        const ret = wasm.wasmthermo_entropy_per_tick(this.__wbg_ptr);
        return ret;
    }
    /**
     * @param {bigint} dof
     * @param {number} kt
     * @returns {number}
     */
    equipartition_energy(dof, kt) {
        const ret = wasm.wasmthermo_equipartition_energy(this.__wbg_ptr, dof, kt);
        return ret;
    }
    /**
     * @returns {number}
     */
    gamma_diatomic() {
        const ret = wasm.wasmthermo_gamma_diatomic(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    gamma_monatomic() {
        const ret = wasm.wasmthermo_gamma_monatomic(this.__wbg_ptr);
        return ret;
    }
    /**
     * @param {bigint} dof
     * @returns {number}
     */
    ideal_gas_gamma(dof) {
        const ret = wasm.wasmthermo_ideal_gas_gamma(this.__wbg_ptr, dof);
        return ret;
    }
    /**
     * @param {number} eps
     * @param {number} sigma
     * @param {number} r
     * @returns {number}
     */
    lj_force_mag(eps, sigma, r) {
        const ret = wasm.wasmthermo_lj_force_mag(this.__wbg_ptr, eps, sigma, r);
        return ret;
    }
    /**
     * @param {number} eps
     * @param {number} sigma
     * @param {number} r
     * @returns {number}
     */
    lj_potential(eps, sigma, r) {
        const ret = wasm.wasmthermo_lj_potential(this.__wbg_ptr, eps, sigma, r);
        return ret;
    }
    /**
     * @param {number} kt
     * @param {number} m
     * @returns {number}
     */
    maxwell_speed_rms(kt, m) {
        const ret = wasm.wasmthermo_maxwell_speed_rms(this.__wbg_ptr, kt, m);
        return ret;
    }
    constructor() {
        const ret = wasm.wasmthermo_new();
        this.__wbg_ptr = ret >>> 0;
        WasmThermoFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
}
if (Symbol.dispose) WasmThermo.prototype[Symbol.dispose] = WasmThermo.prototype.free;

export class WasmToe {
    static __wrap(ptr) {
        ptr = ptr >>> 0;
        const obj = Object.create(WasmToe.prototype);
        obj.__wbg_ptr = ptr;
        WasmToeFinalization.register(obj, obj.__wbg_ptr, obj);
        return obj;
    }
    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        WasmToeFinalization.unregister(this);
        return ptr;
    }
    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_wasmtoe_free(ptr, 0);
    }
    /**
     * @returns {number}
     */
    alpha() {
        const ret = wasm.wasmtoe_alpha(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    alpha_inv() {
        const ret = wasm.wasmtoe_alpha_inv(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    beta0() {
        const ret = wasm.wasmtoe_beta0(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    chi() {
        const ret = wasm.wasmtoe_chi(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    d_colour() {
        const ret = wasm.wasmtoe_d_colour(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {number}
     */
    electron_mass() {
        const ret = wasm.wasmtoe_electron_mass(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    gauss() {
        const ret = wasm.wasmtoe_gauss(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {number}
     */
    higgs_mass() {
        const ret = wasm.wasmtoe_higgs_mass(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    n_c() {
        const ret = wasm.wasmtoe_n_c(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {bigint}
     */
    n_w() {
        const ret = wasm.wasmtoe_n_w(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @param {number | null} [vev]
     */
    constructor(vev) {
        const ret = wasm.wasmtoe_new(!isLikeNone(vev), isLikeNone(vev) ? 0 : vev);
        this.__wbg_ptr = ret >>> 0;
        WasmToeFinalization.register(this, this.__wbg_ptr, this);
        return this;
    }
    /**
     * @returns {number}
     */
    proton_mass() {
        const ret = wasm.wasmtoe_proton_mass(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {bigint}
     */
    sigma_d() {
        const ret = wasm.wasmtoe_sigma_d(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {number}
     */
    sin2_theta_w() {
        const ret = wasm.wasmtoe_sin2_theta_w(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {WasmToe}
     */
    to_pdg() {
        const ret = wasm.wasmtoe_to_pdg(this.__wbg_ptr);
        return WasmToe.__wrap(ret);
    }
    /**
     * @returns {bigint}
     */
    tower_d() {
        const ret = wasm.wasmtoe_tower_d(this.__wbg_ptr);
        return BigInt.asUintN(64, ret);
    }
    /**
     * @returns {number}
     */
    vev() {
        const ret = wasm.wasmtoe_vev(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    w_mass() {
        const ret = wasm.wasmtoe_w_mass(this.__wbg_ptr);
        return ret;
    }
    /**
     * @returns {number}
     */
    z_mass() {
        const ret = wasm.wasmtoe_z_mass(this.__wbg_ptr);
        return ret;
    }
}
if (Symbol.dispose) WasmToe.prototype[Symbol.dispose] = WasmToe.prototype.free;

/**
 * @returns {any}
 */
export function crystal_dump() {
    const ret = wasm.crystal_dump();
    return ret;
}

function __wbg_get_imports() {
    const import0 = {
        __proto__: null,
        __wbg_Error_2e59b1b37a9a34c3: function(arg0, arg1) {
            const ret = Error(getStringFromWasm0(arg0, arg1));
            return ret;
        },
        __wbg___wbindgen_throw_81fc77679af83bc6: function(arg0, arg1) {
            throw new Error(getStringFromWasm0(arg0, arg1));
        },
        __wbg_new_4f9fafbb3909af72: function() {
            const ret = new Object();
            return ret;
        },
        __wbg_new_f3c9df4f38f3f798: function() {
            const ret = new Array();
            return ret;
        },
        __wbg_set_6be42768c690e380: function(arg0, arg1, arg2) {
            arg0[arg1] = arg2;
        },
        __wbg_set_6c60b2e8ad0e9383: function(arg0, arg1, arg2) {
            arg0[arg1 >>> 0] = arg2;
        },
        __wbindgen_cast_0000000000000001: function(arg0) {
            // Cast intrinsic for `F64 -> Externref`.
            const ret = arg0;
            return ret;
        },
        __wbindgen_cast_0000000000000002: function(arg0, arg1) {
            // Cast intrinsic for `Ref(String) -> Externref`.
            const ret = getStringFromWasm0(arg0, arg1);
            return ret;
        },
        __wbindgen_cast_0000000000000003: function(arg0) {
            // Cast intrinsic for `U64 -> Externref`.
            const ret = BigInt.asUintN(64, arg0);
            return ret;
        },
        __wbindgen_init_externref_table: function() {
            const table = wasm.__wbindgen_externrefs;
            const offset = table.grow(4);
            table.set(0, undefined);
            table.set(offset + 0, undefined);
            table.set(offset + 1, null);
            table.set(offset + 2, true);
            table.set(offset + 3, false);
        },
    };
    return {
        __proto__: null,
        "./crystal_toe_bg.js": import0,
    };
}

const WasmArcadeFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmarcade_free(ptr >>> 0, 1));
const WasmAstroFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmastro_free(ptr >>> 0, 1));
const WasmBioFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmbio_free(ptr >>> 0, 1));
const WasmCFDFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmcfd_free(ptr >>> 0, 1));
const WasmChemFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmchem_free(ptr >>> 0, 1));
const WasmClassicalFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmclassical_free(ptr >>> 0, 1));
const WasmCondensedFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmcondensed_free(ptr >>> 0, 1));
const WasmDecayFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmdecay_free(ptr >>> 0, 1));
const WasmEMFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmem_free(ptr >>> 0, 1));
const WasmFriedmannFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmfriedmann_free(ptr >>> 0, 1));
const WasmGRFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmgr_free(ptr >>> 0, 1));
const WasmGWFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmgw_free(ptr >>> 0, 1));
const WasmMDFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmmd_free(ptr >>> 0, 1));
const WasmMonadFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmmonad_free(ptr >>> 0, 1));
const WasmNBodyFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmnbody_free(ptr >>> 0, 1));
const WasmNuclearFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmnuclear_free(ptr >>> 0, 1));
const WasmOpticsFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmoptics_free(ptr >>> 0, 1));
const WasmPlasmaFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmplasma_free(ptr >>> 0, 1));
const WasmQFTFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmqft_free(ptr >>> 0, 1));
const WasmQInfoFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmqinfo_free(ptr >>> 0, 1));
const WasmRigidFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmrigid_free(ptr >>> 0, 1));
const WasmThermoFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmthermo_free(ptr >>> 0, 1));
const WasmToeFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_wasmtoe_free(ptr >>> 0, 1));

function getStringFromWasm0(ptr, len) {
    ptr = ptr >>> 0;
    return decodeText(ptr, len);
}

let cachedUint8ArrayMemory0 = null;
function getUint8ArrayMemory0() {
    if (cachedUint8ArrayMemory0 === null || cachedUint8ArrayMemory0.byteLength === 0) {
        cachedUint8ArrayMemory0 = new Uint8Array(wasm.memory.buffer);
    }
    return cachedUint8ArrayMemory0;
}

function isLikeNone(x) {
    return x === undefined || x === null;
}

let cachedTextDecoder = new TextDecoder('utf-8', { ignoreBOM: true, fatal: true });
cachedTextDecoder.decode();
const MAX_SAFARI_DECODE_BYTES = 2146435072;
let numBytesDecoded = 0;
function decodeText(ptr, len) {
    numBytesDecoded += len;
    if (numBytesDecoded >= MAX_SAFARI_DECODE_BYTES) {
        cachedTextDecoder = new TextDecoder('utf-8', { ignoreBOM: true, fatal: true });
        cachedTextDecoder.decode();
        numBytesDecoded = len;
    }
    return cachedTextDecoder.decode(getUint8ArrayMemory0().subarray(ptr, ptr + len));
}

let wasmModule, wasm;
function __wbg_finalize_init(instance, module) {
    wasm = instance.exports;
    wasmModule = module;
    cachedUint8ArrayMemory0 = null;
    wasm.__wbindgen_start();
    return wasm;
}

async function __wbg_load(module, imports) {
    if (typeof Response === 'function' && module instanceof Response) {
        if (typeof WebAssembly.instantiateStreaming === 'function') {
            try {
                return await WebAssembly.instantiateStreaming(module, imports);
            } catch (e) {
                const validResponse = module.ok && expectedResponseType(module.type);

                if (validResponse && module.headers.get('Content-Type') !== 'application/wasm') {
                    console.warn("`WebAssembly.instantiateStreaming` failed because your server does not serve Wasm with `application/wasm` MIME type. Falling back to `WebAssembly.instantiate` which is slower. Original error:\n", e);

                } else { throw e; }
            }
        }

        const bytes = await module.arrayBuffer();
        return await WebAssembly.instantiate(bytes, imports);
    } else {
        const instance = await WebAssembly.instantiate(module, imports);

        if (instance instanceof WebAssembly.Instance) {
            return { instance, module };
        } else {
            return instance;
        }
    }

    function expectedResponseType(type) {
        switch (type) {
            case 'basic': case 'cors': case 'default': return true;
        }
        return false;
    }
}

function initSync(module) {
    if (wasm !== undefined) return wasm;


    if (module !== undefined) {
        if (Object.getPrototypeOf(module) === Object.prototype) {
            ({module} = module)
        } else {
            console.warn('using deprecated parameters for `initSync()`; pass a single object instead')
        }
    }

    const imports = __wbg_get_imports();
    if (!(module instanceof WebAssembly.Module)) {
        module = new WebAssembly.Module(module);
    }
    const instance = new WebAssembly.Instance(module, imports);
    return __wbg_finalize_init(instance, module);
}

async function __wbg_init(module_or_path) {
    if (wasm !== undefined) return wasm;


    if (module_or_path !== undefined) {
        if (Object.getPrototypeOf(module_or_path) === Object.prototype) {
            ({module_or_path} = module_or_path)
        } else {
            console.warn('using deprecated parameters for the initialization function; pass a single object instead')
        }
    }

    if (module_or_path === undefined) {
        module_or_path = new URL('crystal_toe_bg.wasm', import.meta.url);
    }
    const imports = __wbg_get_imports();

    if (typeof module_or_path === 'string' || (typeof Request === 'function' && module_or_path instanceof Request) || (typeof URL === 'function' && module_or_path instanceof URL)) {
        module_or_path = fetch(module_or_path);
    }

    const { instance, module } = await __wbg_load(await module_or_path, imports);

    return __wbg_finalize_init(instance, module);
}

export { initSync, __wbg_init as default };
