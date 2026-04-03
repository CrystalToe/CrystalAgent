/* tslint:disable */
/* eslint-disable */

export class WasmArcade {
    free(): void;
    [Symbol.dispose](): void;
    bh_theta(): number;
    euler_step(x: number, v: number, dt: number): number;
    fast_alpha_inv(): bigint;
    fast_inv_sqrt(x: number): number;
    fixed_bits(): bigint;
    fixed_resolution(): number;
    fixed_round_trip(x: number): number;
    lj_arcade(r: number): number;
    lj_cutoff(): bigint;
    lj_exact(r: number): number;
    lj_scan(r_min: number, r_max: number, n: number): any;
    lj_wca(r: number): number;
    lod_levels(): bigint;
    mean_field_error(): number;
    constructor();
    octree_children(): bigint;
    onsager_tc(): number;
    self_test(): any;
    verify_alpha_inv(): boolean;
    verlet_step(x: number, v: number, a: number, dt: number): number;
    wca_cutoff(): number;
}

export class WasmAstro {
    free(): void;
    [Symbol.dispose](): void;
    eddington(): bigint;
    hawking(): bigint;
    hawking_eddington_product(): bigint;
    hawking_temperature(m: number): number;
    lane_emden(n: number): any;
    lane_emden_nr(): any;
    lane_emden_profile(n: number): any;
    lane_emden_rel(): any;
    ms_exponent_identity(): boolean;
    ms_lifetime(m: number): number;
    ms_luminosity(m: number): number;
    constructor();
    sb_denom(): bigint;
    schwarz(): bigint;
    schwarzschild_radius(m: number): number;
    self_test(): any;
    virial(): bigint;
}

export class WasmBio {
    free(): void;
    [Symbol.dispose](): void;
    amino_acids(): bigint;
    bp_per_turn(): bigint;
    codon_len(): bigint;
    codon_redundancy(): number;
    constant_heartbeats(): boolean;
    dna_bases(): bigint;
    flory_nu(): number;
    heart_rate(m: number): number;
    heart_rate_exp(): number;
    helix_per_turn(): number;
    kleiber(m: number): number;
    kleiber_exp(): number;
    lifespan(m: number): number;
    lipid_layers(): bigint;
    constructor();
    self_test(): any;
    sense_codons(): bigint;
    stop_codons(): bigint;
    surface_exp(): number;
    total_codons(): bigint;
}

export class WasmCFD {
    free(): void;
    [Symbol.dispose](): void;
    advance(n: number): void;
    d2q9_velocities(): bigint;
    density_field(): any;
    kolmogorov_spectrum(k: number, eps: number): number;
    constructor(nx: number, ny: number, tau: number, fx: number);
    reynolds_number(rho: number, v: number, l: number, mu: number): number;
    speed_field(): any;
    tick(): void;
    total_mass(): number;
}

export class WasmChem {
    free(): void;
    [Symbol.dispose](): void;
    alpha_em(): number;
    arrhenius(ea: number, kt: number): number;
    arrhenius_bio(ea: number): number;
    bohr_radius(): number;
    d_capacity(): bigint;
    dielectric_protein(): bigint;
    e_hbond(): number;
    eps_vdw(): number;
    f_capacity(): bigint;
    hartree_ev(): number;
    kt_300(): number;
    neutral_ph(): bigint;
    constructor();
    noble_gases(): any;
    p_capacity(): bigint;
    period_lengths(): any;
    rydberg_ev(): number;
    s_capacity(): bigint;
    self_test(): any;
    shell_capacity(n: bigint): bigint;
    sp2_angle_deg(): number;
    sp3_angle_deg(): number;
    subshell_capacity(l: bigint): bigint;
    vdw_kt_ratio(): number;
    water_angle_deg(): number;
}

export class WasmClassical {
    free(): void;
    [Symbol.dispose](): void;
    escape_velocity(gm: number, r: number): number;
    force_exponent(): bigint;
    hohmann_transfer(gm: number, r1: number, r2: number): any;
    /**
     * Evolve circular orbit and return [[x,y],...] for D3
     */
    kepler_orbit(gm: number, r: number, dt: number, n: number): any;
    kepler_period(a: number, gm: number): number;
    constructor();
    phase_space_dim(): bigint;
    /**
     * Slingshot trajectory [[x,y,speed],...]
     */
    slingshot_traj(gm_star: number, gm_planet: number, r_planet: number, r_ship: number, v_ship: number, dt: number, n: number): any;
    spatial_dim(): bigint;
    vis_viva(gm: number, r: number, a: number): number;
}

export class WasmCondensed {
    free(): void;
    [Symbol.dispose](): void;
    bcs_ratio(): number;
    ising_magnetization(t: number): number;
    /**
     * Ising MC run: returns [[sweep, magnetization],...] for D3
     */
    ising_run(n: number, n_sweeps: number, inv_t: number, sample: number): any;
    ising_z_cubic(): bigint;
    ising_z_square(): bigint;
    constructor();
    onsager_tc(): number;
}

export class WasmDecay {
    free(): void;
    [Symbol.dispose](): void;
    beta_endpoint(): number;
    beta_spectrum_curve(n: number): any;
    fermi_golden_rule(me2: number, dos: number): number;
    g_fermi(): number;
    neutron_lifetime(): number;
    constructor();
    oscill_prob(sin2_2th: number, dm2: number, l_e: number): number;
    sin2_theta_12(): number;
    sin2_theta_23(): number;
    sin2_theta_w(): number;
}

export class WasmEM {
    free(): void;
    [Symbol.dispose](): void;
    advance(n: number): void;
    bz_field(): any;
    current_step(): number;
    current_time(): number;
    em_components(): bigint;
    energy(): number;
    ey_field(): any;
    larmor_power(q: number, a: number): number;
    constructor(n_grid: number, center: number, width: number, amp: number, courant: number);
    planck_radiance(l: number, t: number): number;
    polarization_states(): bigint;
    rayleigh_sigma(d: number, l: number): number;
    stefan_boltzmann_power(t: number): number;
    tick(): void;
}

export class WasmFriedmann {
    free(): void;
    [Symbol.dispose](): void;
    acceleration_onset(): number;
    age_analytic(): number;
    cmb_temperature(): number;
    comoving_distance(z: number, n: number): number;
    deceleration_param(a: number): number;
    dm_baryon_ratio(): number;
    /**
     * Friedmann evolution [[t,a,z],...] for D3
     */
    evolve(a_init: number, a_final: number, dt: number, max: number): any;
    h0_crystal(): number;
    hubble_norm(a: number): number;
    luminosity_distance(z: number, n: number): number;
    constructor();
    omega_baryon(): number;
    omega_dm(): number;
    omega_lambda(): number;
    omega_matter(): number;
    spectral_index(): number;
}

export class WasmGR {
    free(): void;
    [Symbol.dispose](): void;
    bending_factor(): bigint;
    /**
     * Geodesic orbit [[r,phi],...] for D3 polar plot
     */
    geodesic(rs: number, ang_l: number, energy: number, dtau: number, n: number): any;
    gravitational_redshift(rs: number, r: number): number;
    isco_energy(): number;
    isco_factor(): bigint;
    isco_radius(gm: number): number;
    light_bending_analytic(rs: number, b: number): number;
    constructor();
    photon_sphere(): bigint;
    precession_analytic(rs: number, a: number, e: number): number;
    precession_factor(): bigint;
    schwarz_factor(): bigint;
    schwarzschild_r(gm: number): number;
    shapiro_delay(gm: number, r1: number, r2: number, b: number): number;
    spacetime_dim(): bigint;
    v_eff_massive(rs: number, l: number, r: number): number;
    v_eff_photon(rs: number, l: number, r: number): number;
    /**
     * Effective potential curve [[r, V_eff],...] for D3
     */
    veff_curve(rs: number, l: number, r_min: number, r_max: number, n: number): any;
}

export class WasmGW {
    free(): void;
    [Symbol.dispose](): void;
    chirp_mass(m1: number, m2: number): number;
    gw_frequency(m: number, a: number): number;
    gw_power(mu: number, m: number, a: number): number;
    /**
     * Binary inspiral [[t,a,freq],...] for D3
     */
    inspiral(m1: number, m2: number, a0: number, dt: number): any;
    isco_frequency(m: number): number;
    constructor();
    peters_coefficient(): number;
    polarizations(): bigint;
    quadrupole_order(): bigint;
    time_to_merger(mc: number, f: number): number;
    /**
     * Inspiral waveform [[t,h+,h×,freq],...] for D3
     */
    waveform(m1: number, m2: number, dist: number, iota: number, f0: number, dt: number): any;
}

export class WasmMD {
    free(): void;
    [Symbol.dispose](): void;
    coulomb_force(q1: number, q2: number, r: number): number;
    coulomb_potential(q1: number, q2: number, r: number): number;
    flory_nu(): number;
    helix_per_turn(): number;
    /**
     * LJ + force curves [[r, V, F],...] for D3
     */
    lj_curves(rmin: number, rmax: number, n: number): any;
    lj_dvdr(r: number): number;
    lj_potential(r: number): number;
    /**
     * 2-body MD vibration [[x1,x2],...] for D3
     */
    md2_evolve(dt: number, n: number): any;
    constructor();
    tetrahedral_angle(): number;
    water_angle(): number;
}

export class WasmMonad {
    free(): void;
    [Symbol.dispose](): void;
    advance(n: bigint): void;
    amplitudes(): any;
    at_tick(t: bigint): void;
    current_tick(): bigint;
    entropy(): number;
    history(n: bigint): any;
    hologron_potential(l: number): number;
    constructor();
    snapshot(): any;
    tick(): void;
}

export class WasmNBody {
    free(): void;
    [Symbol.dispose](): void;
    add_body(px: number, py: number, pz: number, vx: number, vy: number, vz: number, m: number): void;
    add_galaxy(n: number, tm: number, rs: number, cx: number, cy: number, cz: number, bvx: number, bvy: number, bvz: number): void;
    advance(n: number): void;
    bodies(): any;
    current_step(): number;
    kinetic_energy(): number;
    load_figure_eight(): void;
    load_solar_system(): void;
    n_bodies(): number;
    constructor(dt: number, eps: number);
    octree_children(): bigint;
    positions_2d(): any;
    positions_2d_mass(): any;
    potential_energy(): number;
    tick(): void;
    total_energy(): number;
}

export class WasmNuclear {
    free(): void;
    [Symbol.dispose](): void;
    alpha_particle(): bigint;
    binding_curve(max_a: number): any;
    binding_energy(a: number, z: number): number;
    binding_per_nucleon(a: number, z: number): number;
    deuteron_a(): bigint;
    iron_peak(): bigint;
    isospin_states(): bigint;
    magic_numbers(): any;
    constructor();
    nuclear_radius(a: number): number;
    nuclear_volume(a: number): number;
    optimal_z(a: number): number;
    peak_nucleus(max_a: number): any;
    self_test(): any;
}

export class WasmOptics {
    free(): void;
    [Symbol.dispose](): void;
    airy_radius(l: number, ap: number): number;
    brewster_angle(n1: number, n2: number): number;
    /**
     * Fresnel curves [[theta, rs, rp, R],...] for D3
     */
    fresnel_curve(n1: number, n2: number, n_pts: number): any;
    fresnel_r(n1: number, n2: number, th: number): number;
    n_diamond(): number;
    n_glass(): number;
    n_water(): number;
    constructor();
    normal_reflectance(n1: number, n2: number): number;
    planck_radiance(l: number, t: number): number;
    rayleigh_intensity(l0: number, l: number): number;
    sky_blue_ratio(): number;
    snell(n1: number, n2: number, th: number): number;
    wien_displacement(t: number): number;
}

export class WasmPlasma {
    free(): void;
    [Symbol.dispose](): void;
    alfven_speed(b: number, rho: number): number;
    cyclotron_frequency(q: number, b: number, m: number): number;
    debye_length(kt: number, n: number, q: number): number;
    larmor_radius(m: number, v: number, q: number, b: number): number;
    mhd_energy(): number;
    mhd_states(): bigint;
    constructor();
    plasma_beta(p: number, b: number): number;
    propagating_modes(): bigint;
    wave_types(): bigint;
}

export class WasmQFT {
    free(): void;
    [Symbol.dispose](): void;
    alpha_inv(): number;
    /**
     * α_s running [[Q, α_s],...] for D3
     */
    alpha_s_curve(qmin: number, qmax: number, lambda: number, n: number): any;
    alpha_s_mz(): number;
    dirac_gammas(): bigint;
    gluon_colours(): bigint;
    lorentz_gen(): bigint;
    constructor();
    pair_threshold(m: number): number;
    photon_pol(): bigint;
    qcd_beta0(): bigint;
    /**
     * e+e- → μ+μ- cross-section curve [[√s, σ],...] for D3
     */
    sigma_curve(smin: number, smax: number, n: number): any;
    sigma_ee_mumu(s: number): number;
    spacetime_dim(): bigint;
    thomson_cs(): number;
}

export class WasmQInfo {
    free(): void;
    [Symbol.dispose](): void;
    bell_entropy(): number;
    bell_states(): bigint;
    coprimality_check(): boolean;
    hamming_check(): boolean;
    heyting_join(a: number, b: number): number;
    heyting_meet(a: number, b: number): number;
    mera_bond(): bigint;
    mera_depth(): bigint;
    mera_link_entropy(): number;
    constructor();
    pauli_group(): bigint;
    pauli_matrices(): bigint;
    qubit_states(): bigint;
    self_test(): any;
    shor_n(): bigint;
    steane_corrects(): bigint;
    steane_d(): bigint;
    steane_n(): bigint;
    toffoli(): bigint;
    tomography_min(): bigint;
}

export class WasmRigid {
    free(): void;
    [Symbol.dispose](): void;
    i_disk(m: number, r: number): number;
    i_rod(m: number, l: number): number;
    i_shell(m: number, r: number): number;
    i_shell_factor(): number;
    i_sphere(m: number, r: number): number;
    i_sphere_factor(): number;
    inertia_indep(): bigint;
    constructor();
    quat_components(): bigint;
    rigid_dof(): bigint;
    /**
     * Euler tumbling [[wx,wy,wz],...] for D3
     */
    tumbling(ix: number, iy: number, iz: number, wx: number, wy: number, wz: number, dt: number, n: number): any;
}

export class WasmThermo {
    free(): void;
    [Symbol.dispose](): void;
    carnot_efficiency(): number;
    entropy_per_tick(): number;
    equipartition_energy(dof: bigint, kt: number): number;
    gamma_diatomic(): number;
    gamma_monatomic(): number;
    ideal_gas_gamma(dof: bigint): number;
    lj_force_mag(eps: number, sigma: number, r: number): number;
    lj_potential(eps: number, sigma: number, r: number): number;
    maxwell_speed_rms(kt: number, m: number): number;
    constructor();
}

export class WasmToe {
    free(): void;
    [Symbol.dispose](): void;
    alpha(): number;
    alpha_inv(): number;
    beta0(): bigint;
    chi(): bigint;
    d_colour(): bigint;
    electron_mass(): number;
    gauss(): bigint;
    higgs_mass(): number;
    n_c(): bigint;
    n_w(): bigint;
    constructor(vev?: number | null);
    proton_mass(): number;
    sigma_d(): bigint;
    sin2_theta_w(): number;
    to_pdg(): WasmToe;
    tower_d(): bigint;
    vev(): number;
    w_mass(): number;
    z_mass(): number;
}

export function crystal_dump(): any;

export type InitInput = RequestInfo | URL | Response | BufferSource | WebAssembly.Module;

export interface InitOutput {
    readonly memory: WebAssembly.Memory;
    readonly __wbg_wasmarcade_free: (a: number, b: number) => void;
    readonly __wbg_wasmastro_free: (a: number, b: number) => void;
    readonly __wbg_wasmbio_free: (a: number, b: number) => void;
    readonly __wbg_wasmcfd_free: (a: number, b: number) => void;
    readonly __wbg_wasmchem_free: (a: number, b: number) => void;
    readonly __wbg_wasmclassical_free: (a: number, b: number) => void;
    readonly __wbg_wasmcondensed_free: (a: number, b: number) => void;
    readonly __wbg_wasmdecay_free: (a: number, b: number) => void;
    readonly __wbg_wasmem_free: (a: number, b: number) => void;
    readonly __wbg_wasmfriedmann_free: (a: number, b: number) => void;
    readonly __wbg_wasmgr_free: (a: number, b: number) => void;
    readonly __wbg_wasmgw_free: (a: number, b: number) => void;
    readonly __wbg_wasmmd_free: (a: number, b: number) => void;
    readonly __wbg_wasmmonad_free: (a: number, b: number) => void;
    readonly __wbg_wasmnbody_free: (a: number, b: number) => void;
    readonly __wbg_wasmnuclear_free: (a: number, b: number) => void;
    readonly __wbg_wasmoptics_free: (a: number, b: number) => void;
    readonly __wbg_wasmplasma_free: (a: number, b: number) => void;
    readonly __wbg_wasmqft_free: (a: number, b: number) => void;
    readonly __wbg_wasmqinfo_free: (a: number, b: number) => void;
    readonly __wbg_wasmrigid_free: (a: number, b: number) => void;
    readonly __wbg_wasmthermo_free: (a: number, b: number) => void;
    readonly __wbg_wasmtoe_free: (a: number, b: number) => void;
    readonly crystal_dump: () => any;
    readonly wasmarcade_bh_theta: (a: number) => number;
    readonly wasmarcade_euler_step: (a: number, b: number, c: number, d: number) => number;
    readonly wasmarcade_fast_alpha_inv: (a: number) => bigint;
    readonly wasmarcade_fast_inv_sqrt: (a: number, b: number) => number;
    readonly wasmarcade_fixed_bits: (a: number) => bigint;
    readonly wasmarcade_fixed_resolution: (a: number) => number;
    readonly wasmarcade_fixed_round_trip: (a: number, b: number) => number;
    readonly wasmarcade_lj_arcade: (a: number, b: number) => number;
    readonly wasmarcade_lj_cutoff: (a: number) => bigint;
    readonly wasmarcade_lj_exact: (a: number, b: number) => number;
    readonly wasmarcade_lj_scan: (a: number, b: number, c: number, d: number) => any;
    readonly wasmarcade_lj_wca: (a: number, b: number) => number;
    readonly wasmarcade_mean_field_error: (a: number) => number;
    readonly wasmarcade_octree_children: (a: number) => bigint;
    readonly wasmarcade_onsager_tc: (a: number) => number;
    readonly wasmarcade_self_test: (a: number) => any;
    readonly wasmarcade_verify_alpha_inv: (a: number) => number;
    readonly wasmarcade_verlet_step: (a: number, b: number, c: number, d: number, e: number) => number;
    readonly wasmarcade_wca_cutoff: (a: number) => number;
    readonly wasmastro_eddington: (a: number) => bigint;
    readonly wasmastro_hawking_eddington_product: (a: number) => bigint;
    readonly wasmastro_hawking_temperature: (a: number, b: number) => number;
    readonly wasmastro_lane_emden: (a: number, b: number) => any;
    readonly wasmastro_lane_emden_nr: (a: number) => any;
    readonly wasmastro_lane_emden_profile: (a: number, b: number) => any;
    readonly wasmastro_lane_emden_rel: (a: number) => any;
    readonly wasmastro_ms_lifetime: (a: number, b: number) => number;
    readonly wasmastro_ms_luminosity: (a: number, b: number) => number;
    readonly wasmastro_sb_denom: (a: number) => bigint;
    readonly wasmastro_schwarz: (a: number) => bigint;
    readonly wasmastro_schwarzschild_radius: (a: number, b: number) => number;
    readonly wasmastro_self_test: (a: number) => any;
    readonly wasmbio_amino_acids: (a: number) => bigint;
    readonly wasmbio_bp_per_turn: (a: number) => bigint;
    readonly wasmbio_codon_redundancy: (a: number) => number;
    readonly wasmbio_flory_nu: (a: number) => number;
    readonly wasmbio_heart_rate: (a: number, b: number) => number;
    readonly wasmbio_heart_rate_exp: (a: number) => number;
    readonly wasmbio_helix_per_turn: (a: number) => number;
    readonly wasmbio_kleiber: (a: number, b: number) => number;
    readonly wasmbio_kleiber_exp: (a: number) => number;
    readonly wasmbio_lifespan: (a: number, b: number) => number;
    readonly wasmbio_self_test: (a: number) => any;
    readonly wasmbio_sense_codons: (a: number) => bigint;
    readonly wasmbio_surface_exp: (a: number) => number;
    readonly wasmbio_total_codons: (a: number) => bigint;
    readonly wasmcfd_advance: (a: number, b: number) => void;
    readonly wasmcfd_d2q9_velocities: (a: number) => bigint;
    readonly wasmcfd_density_field: (a: number) => any;
    readonly wasmcfd_kolmogorov_spectrum: (a: number, b: number, c: number) => number;
    readonly wasmcfd_new: (a: number, b: number, c: number, d: number) => number;
    readonly wasmcfd_reynolds_number: (a: number, b: number, c: number, d: number, e: number) => number;
    readonly wasmcfd_speed_field: (a: number) => any;
    readonly wasmcfd_tick: (a: number) => void;
    readonly wasmcfd_total_mass: (a: number) => number;
    readonly wasmchem_alpha_em: (a: number) => number;
    readonly wasmchem_arrhenius: (a: number, b: number, c: number) => number;
    readonly wasmchem_arrhenius_bio: (a: number, b: number) => number;
    readonly wasmchem_bohr_radius: (a: number) => number;
    readonly wasmchem_e_hbond: (a: number) => number;
    readonly wasmchem_eps_vdw: (a: number) => number;
    readonly wasmchem_f_capacity: (a: number) => bigint;
    readonly wasmchem_hartree_ev: (a: number) => number;
    readonly wasmchem_kt_300: (a: number) => number;
    readonly wasmchem_neutral_ph: (a: number) => bigint;
    readonly wasmchem_noble_gases: (a: number) => any;
    readonly wasmchem_p_capacity: (a: number) => bigint;
    readonly wasmchem_period_lengths: (a: number) => any;
    readonly wasmchem_rydberg_ev: (a: number) => number;
    readonly wasmchem_self_test: (a: number) => any;
    readonly wasmchem_shell_capacity: (a: number, b: bigint) => bigint;
    readonly wasmchem_sp2_angle_deg: (a: number) => number;
    readonly wasmchem_sp3_angle_deg: (a: number) => number;
    readonly wasmchem_subshell_capacity: (a: number, b: bigint) => bigint;
    readonly wasmchem_vdw_kt_ratio: (a: number) => number;
    readonly wasmchem_water_angle_deg: (a: number) => number;
    readonly wasmclassical_escape_velocity: (a: number, b: number, c: number) => number;
    readonly wasmclassical_hohmann_transfer: (a: number, b: number, c: number, d: number) => any;
    readonly wasmclassical_kepler_orbit: (a: number, b: number, c: number, d: number, e: number) => any;
    readonly wasmclassical_kepler_period: (a: number, b: number, c: number) => number;
    readonly wasmclassical_slingshot_traj: (a: number, b: number, c: number, d: number, e: number, f: number, g: number, h: number) => any;
    readonly wasmclassical_vis_viva: (a: number, b: number, c: number, d: number) => number;
    readonly wasmcondensed_bcs_ratio: (a: number) => number;
    readonly wasmcondensed_ising_magnetization: (a: number, b: number) => number;
    readonly wasmcondensed_ising_run: (a: number, b: number, c: number, d: number, e: number) => any;
    readonly wasmdecay_beta_endpoint: (a: number) => number;
    readonly wasmdecay_beta_spectrum_curve: (a: number, b: number) => any;
    readonly wasmdecay_fermi_golden_rule: (a: number, b: number, c: number) => number;
    readonly wasmdecay_g_fermi: (a: number) => number;
    readonly wasmdecay_neutron_lifetime: (a: number) => number;
    readonly wasmdecay_oscill_prob: (a: number, b: number, c: number, d: number) => number;
    readonly wasmdecay_sin2_theta_12: (a: number) => number;
    readonly wasmdecay_sin2_theta_23: (a: number) => number;
    readonly wasmdecay_sin2_theta_w: (a: number) => number;
    readonly wasmem_advance: (a: number, b: number) => void;
    readonly wasmem_bz_field: (a: number) => any;
    readonly wasmem_current_step: (a: number) => number;
    readonly wasmem_current_time: (a: number) => number;
    readonly wasmem_energy: (a: number) => number;
    readonly wasmem_ey_field: (a: number) => any;
    readonly wasmem_larmor_power: (a: number, b: number, c: number) => number;
    readonly wasmem_new: (a: number, b: number, c: number, d: number, e: number) => number;
    readonly wasmem_planck_radiance: (a: number, b: number, c: number) => number;
    readonly wasmem_rayleigh_sigma: (a: number, b: number, c: number) => number;
    readonly wasmem_stefan_boltzmann_power: (a: number, b: number) => number;
    readonly wasmem_tick: (a: number) => void;
    readonly wasmfriedmann_acceleration_onset: (a: number) => number;
    readonly wasmfriedmann_age_analytic: (a: number) => number;
    readonly wasmfriedmann_cmb_temperature: (a: number) => number;
    readonly wasmfriedmann_comoving_distance: (a: number, b: number, c: number) => number;
    readonly wasmfriedmann_deceleration_param: (a: number, b: number) => number;
    readonly wasmfriedmann_dm_baryon_ratio: (a: number) => number;
    readonly wasmfriedmann_evolve: (a: number, b: number, c: number, d: number, e: number) => any;
    readonly wasmfriedmann_h0_crystal: (a: number) => number;
    readonly wasmfriedmann_hubble_norm: (a: number, b: number) => number;
    readonly wasmfriedmann_luminosity_distance: (a: number, b: number, c: number) => number;
    readonly wasmfriedmann_omega_baryon: (a: number) => number;
    readonly wasmfriedmann_omega_dm: (a: number) => number;
    readonly wasmfriedmann_omega_lambda: (a: number) => number;
    readonly wasmfriedmann_omega_matter: (a: number) => number;
    readonly wasmfriedmann_spectral_index: (a: number) => number;
    readonly wasmgr_geodesic: (a: number, b: number, c: number, d: number, e: number, f: number) => any;
    readonly wasmgr_gravitational_redshift: (a: number, b: number, c: number) => number;
    readonly wasmgr_isco_energy: (a: number) => number;
    readonly wasmgr_isco_radius: (a: number, b: number) => number;
    readonly wasmgr_light_bending_analytic: (a: number, b: number, c: number) => number;
    readonly wasmgr_precession_analytic: (a: number, b: number, c: number, d: number) => number;
    readonly wasmgr_shapiro_delay: (a: number, b: number, c: number, d: number, e: number) => number;
    readonly wasmgr_v_eff_massive: (a: number, b: number, c: number, d: number) => number;
    readonly wasmgr_v_eff_photon: (a: number, b: number, c: number, d: number) => number;
    readonly wasmgr_veff_curve: (a: number, b: number, c: number, d: number, e: number, f: number) => any;
    readonly wasmgw_chirp_mass: (a: number, b: number, c: number) => number;
    readonly wasmgw_gw_frequency: (a: number, b: number, c: number) => number;
    readonly wasmgw_gw_power: (a: number, b: number, c: number, d: number) => number;
    readonly wasmgw_inspiral: (a: number, b: number, c: number, d: number, e: number) => any;
    readonly wasmgw_isco_frequency: (a: number, b: number) => number;
    readonly wasmgw_peters_coefficient: (a: number) => number;
    readonly wasmgw_time_to_merger: (a: number, b: number, c: number) => number;
    readonly wasmgw_waveform: (a: number, b: number, c: number, d: number, e: number, f: number, g: number) => any;
    readonly wasmmd_coulomb_force: (a: number, b: number, c: number, d: number) => number;
    readonly wasmmd_coulomb_potential: (a: number, b: number, c: number, d: number) => number;
    readonly wasmmd_lj_curves: (a: number, b: number, c: number, d: number) => any;
    readonly wasmmd_lj_dvdr: (a: number, b: number) => number;
    readonly wasmmd_md2_evolve: (a: number, b: number, c: number) => any;
    readonly wasmmd_tetrahedral_angle: (a: number) => number;
    readonly wasmmd_water_angle: (a: number) => number;
    readonly wasmmonad_advance: (a: number, b: bigint) => void;
    readonly wasmmonad_amplitudes: (a: number) => any;
    readonly wasmmonad_at_tick: (a: number, b: bigint) => void;
    readonly wasmmonad_current_tick: (a: number) => bigint;
    readonly wasmmonad_entropy: (a: number) => number;
    readonly wasmmonad_history: (a: number, b: bigint) => any;
    readonly wasmmonad_hologron_potential: (a: number, b: number) => number;
    readonly wasmmonad_new: () => number;
    readonly wasmmonad_snapshot: (a: number) => any;
    readonly wasmmonad_tick: (a: number) => void;
    readonly wasmnbody_add_body: (a: number, b: number, c: number, d: number, e: number, f: number, g: number, h: number) => void;
    readonly wasmnbody_add_galaxy: (a: number, b: number, c: number, d: number, e: number, f: number, g: number, h: number, i: number, j: number) => void;
    readonly wasmnbody_advance: (a: number, b: number) => void;
    readonly wasmnbody_bodies: (a: number) => any;
    readonly wasmnbody_current_step: (a: number) => number;
    readonly wasmnbody_kinetic_energy: (a: number) => number;
    readonly wasmnbody_load_figure_eight: (a: number) => void;
    readonly wasmnbody_load_solar_system: (a: number) => void;
    readonly wasmnbody_n_bodies: (a: number) => number;
    readonly wasmnbody_new: (a: number, b: number) => number;
    readonly wasmnbody_positions_2d: (a: number) => any;
    readonly wasmnbody_positions_2d_mass: (a: number) => any;
    readonly wasmnbody_potential_energy: (a: number) => number;
    readonly wasmnbody_tick: (a: number) => void;
    readonly wasmnbody_total_energy: (a: number) => number;
    readonly wasmnuclear_binding_curve: (a: number, b: number) => any;
    readonly wasmnuclear_binding_energy: (a: number, b: number, c: number) => number;
    readonly wasmnuclear_binding_per_nucleon: (a: number, b: number, c: number) => number;
    readonly wasmnuclear_iron_peak: (a: number) => bigint;
    readonly wasmnuclear_magic_numbers: (a: number) => any;
    readonly wasmnuclear_nuclear_radius: (a: number, b: number) => number;
    readonly wasmnuclear_nuclear_volume: (a: number, b: number) => number;
    readonly wasmnuclear_optimal_z: (a: number, b: number) => number;
    readonly wasmnuclear_peak_nucleus: (a: number, b: number) => any;
    readonly wasmnuclear_self_test: (a: number) => any;
    readonly wasmoptics_airy_radius: (a: number, b: number, c: number) => number;
    readonly wasmoptics_brewster_angle: (a: number, b: number, c: number) => number;
    readonly wasmoptics_fresnel_curve: (a: number, b: number, c: number, d: number) => any;
    readonly wasmoptics_fresnel_r: (a: number, b: number, c: number, d: number) => number;
    readonly wasmoptics_n_diamond: (a: number) => number;
    readonly wasmoptics_n_glass: (a: number) => number;
    readonly wasmoptics_n_water: (a: number) => number;
    readonly wasmoptics_normal_reflectance: (a: number, b: number, c: number) => number;
    readonly wasmoptics_planck_radiance: (a: number, b: number, c: number) => number;
    readonly wasmoptics_rayleigh_intensity: (a: number, b: number, c: number) => number;
    readonly wasmoptics_sky_blue_ratio: (a: number) => number;
    readonly wasmoptics_snell: (a: number, b: number, c: number, d: number) => number;
    readonly wasmoptics_wien_displacement: (a: number, b: number) => number;
    readonly wasmplasma_alfven_speed: (a: number, b: number, c: number) => number;
    readonly wasmplasma_debye_length: (a: number, b: number, c: number, d: number) => number;
    readonly wasmplasma_larmor_radius: (a: number, b: number, c: number, d: number, e: number) => number;
    readonly wasmplasma_mhd_energy: (a: number) => number;
    readonly wasmplasma_plasma_beta: (a: number, b: number, c: number) => number;
    readonly wasmqft_alpha_inv: (a: number) => number;
    readonly wasmqft_alpha_s_curve: (a: number, b: number, c: number, d: number, e: number) => any;
    readonly wasmqft_alpha_s_mz: (a: number) => number;
    readonly wasmqft_sigma_curve: (a: number, b: number, c: number, d: number) => any;
    readonly wasmqft_sigma_ee_mumu: (a: number, b: number) => number;
    readonly wasmqft_thomson_cs: (a: number) => number;
    readonly wasmqinfo_bell_entropy: (a: number) => number;
    readonly wasmqinfo_coprimality_check: (a: number) => number;
    readonly wasmqinfo_hamming_check: (a: number) => number;
    readonly wasmqinfo_heyting_join: (a: number, b: number, c: number) => number;
    readonly wasmqinfo_heyting_meet: (a: number, b: number, c: number) => number;
    readonly wasmqinfo_mera_depth: (a: number) => bigint;
    readonly wasmqinfo_mera_link_entropy: (a: number) => number;
    readonly wasmqinfo_self_test: (a: number) => any;
    readonly wasmqinfo_steane_corrects: (a: number) => bigint;
    readonly wasmrigid_i_disk: (a: number, b: number, c: number) => number;
    readonly wasmrigid_i_rod: (a: number, b: number, c: number) => number;
    readonly wasmrigid_i_shell: (a: number, b: number, c: number) => number;
    readonly wasmrigid_i_sphere: (a: number, b: number, c: number) => number;
    readonly wasmrigid_tumbling: (a: number, b: number, c: number, d: number, e: number, f: number, g: number, h: number, i: number) => any;
    readonly wasmthermo_carnot_efficiency: (a: number) => number;
    readonly wasmthermo_equipartition_energy: (a: number, b: bigint, c: number) => number;
    readonly wasmthermo_gamma_diatomic: (a: number) => number;
    readonly wasmthermo_gamma_monatomic: (a: number) => number;
    readonly wasmthermo_ideal_gas_gamma: (a: number, b: bigint) => number;
    readonly wasmthermo_lj_force_mag: (a: number, b: number, c: number, d: number) => number;
    readonly wasmthermo_lj_potential: (a: number, b: number, c: number, d: number) => number;
    readonly wasmthermo_maxwell_speed_rms: (a: number, b: number, c: number) => number;
    readonly wasmtoe_electron_mass: (a: number) => number;
    readonly wasmtoe_gauss: (a: number) => bigint;
    readonly wasmtoe_higgs_mass: (a: number) => number;
    readonly wasmtoe_new: (a: number, b: number) => number;
    readonly wasmtoe_proton_mass: (a: number) => number;
    readonly wasmtoe_sigma_d: (a: number) => bigint;
    readonly wasmtoe_sin2_theta_w: (a: number) => number;
    readonly wasmtoe_to_pdg: (a: number) => number;
    readonly wasmtoe_w_mass: (a: number) => number;
    readonly wasmtoe_z_mass: (a: number) => number;
    readonly wasmarcade_new: () => number;
    readonly wasmastro_new: () => number;
    readonly wasmbio_new: () => number;
    readonly wasmchem_new: () => number;
    readonly wasmclassical_new: () => number;
    readonly wasmcondensed_new: () => number;
    readonly wasmdecay_new: () => number;
    readonly wasmfriedmann_new: () => number;
    readonly wasmgr_new: () => number;
    readonly wasmgw_new: () => number;
    readonly wasmmd_new: () => number;
    readonly wasmnuclear_new: () => number;
    readonly wasmoptics_new: () => number;
    readonly wasmplasma_new: () => number;
    readonly wasmqft_new: () => number;
    readonly wasmqinfo_new: () => number;
    readonly wasmrigid_new: () => number;
    readonly wasmthermo_new: () => number;
    readonly wasmmd_lj_potential: (a: number, b: number) => number;
    readonly wasmtoe_vev: (a: number) => number;
    readonly wasmarcade_lod_levels: (a: number) => bigint;
    readonly wasmastro_hawking: (a: number) => bigint;
    readonly wasmastro_ms_exponent_identity: (a: number) => number;
    readonly wasmastro_virial: (a: number) => bigint;
    readonly wasmbio_codon_len: (a: number) => bigint;
    readonly wasmbio_constant_heartbeats: (a: number) => number;
    readonly wasmbio_dna_bases: (a: number) => bigint;
    readonly wasmbio_lipid_layers: (a: number) => bigint;
    readonly wasmbio_stop_codons: (a: number) => bigint;
    readonly wasmchem_d_capacity: (a: number) => bigint;
    readonly wasmchem_dielectric_protein: (a: number) => bigint;
    readonly wasmchem_s_capacity: (a: number) => bigint;
    readonly wasmclassical_force_exponent: (a: number) => bigint;
    readonly wasmclassical_phase_space_dim: (a: number) => bigint;
    readonly wasmclassical_spatial_dim: (a: number) => bigint;
    readonly wasmcondensed_ising_z_cubic: (a: number) => bigint;
    readonly wasmcondensed_ising_z_square: (a: number) => bigint;
    readonly wasmcondensed_onsager_tc: (a: number) => number;
    readonly wasmem_em_components: (a: number) => bigint;
    readonly wasmem_polarization_states: (a: number) => bigint;
    readonly wasmgr_bending_factor: (a: number) => bigint;
    readonly wasmgr_isco_factor: (a: number) => bigint;
    readonly wasmgr_photon_sphere: (a: number) => bigint;
    readonly wasmgr_precession_factor: (a: number) => bigint;
    readonly wasmgr_schwarz_factor: (a: number) => bigint;
    readonly wasmgr_spacetime_dim: (a: number) => bigint;
    readonly wasmgw_polarizations: (a: number) => bigint;
    readonly wasmgw_quadrupole_order: (a: number) => bigint;
    readonly wasmmd_flory_nu: (a: number) => number;
    readonly wasmmd_helix_per_turn: (a: number) => number;
    readonly wasmnbody_octree_children: (a: number) => bigint;
    readonly wasmnuclear_alpha_particle: (a: number) => bigint;
    readonly wasmnuclear_deuteron_a: (a: number) => bigint;
    readonly wasmnuclear_isospin_states: (a: number) => bigint;
    readonly wasmplasma_mhd_states: (a: number) => bigint;
    readonly wasmplasma_propagating_modes: (a: number) => bigint;
    readonly wasmplasma_wave_types: (a: number) => bigint;
    readonly wasmqft_dirac_gammas: (a: number) => bigint;
    readonly wasmqft_gluon_colours: (a: number) => bigint;
    readonly wasmqft_lorentz_gen: (a: number) => bigint;
    readonly wasmqft_photon_pol: (a: number) => bigint;
    readonly wasmqft_qcd_beta0: (a: number) => bigint;
    readonly wasmqft_spacetime_dim: (a: number) => bigint;
    readonly wasmqinfo_bell_states: (a: number) => bigint;
    readonly wasmqinfo_mera_bond: (a: number) => bigint;
    readonly wasmqinfo_pauli_group: (a: number) => bigint;
    readonly wasmqinfo_pauli_matrices: (a: number) => bigint;
    readonly wasmqinfo_qubit_states: (a: number) => bigint;
    readonly wasmqinfo_shor_n: (a: number) => bigint;
    readonly wasmqinfo_steane_d: (a: number) => bigint;
    readonly wasmqinfo_steane_n: (a: number) => bigint;
    readonly wasmqinfo_toffoli: (a: number) => bigint;
    readonly wasmqinfo_tomography_min: (a: number) => bigint;
    readonly wasmrigid_i_shell_factor: (a: number) => number;
    readonly wasmrigid_i_sphere_factor: (a: number) => number;
    readonly wasmrigid_inertia_indep: (a: number) => bigint;
    readonly wasmrigid_quat_components: (a: number) => bigint;
    readonly wasmrigid_rigid_dof: (a: number) => bigint;
    readonly wasmthermo_entropy_per_tick: (a: number) => number;
    readonly wasmtoe_alpha: (a: number) => number;
    readonly wasmtoe_alpha_inv: (a: number) => number;
    readonly wasmtoe_beta0: (a: number) => bigint;
    readonly wasmtoe_chi: (a: number) => bigint;
    readonly wasmtoe_d_colour: (a: number) => bigint;
    readonly wasmtoe_n_c: (a: number) => bigint;
    readonly wasmtoe_n_w: (a: number) => bigint;
    readonly wasmtoe_tower_d: (a: number) => bigint;
    readonly wasmplasma_cyclotron_frequency: (a: number, b: number, c: number, d: number) => number;
    readonly wasmgr_schwarzschild_r: (a: number, b: number) => number;
    readonly wasmqft_pair_threshold: (a: number, b: number) => number;
    readonly __wbindgen_externrefs: WebAssembly.Table;
    readonly __wbindgen_start: () => void;
}

export type SyncInitInput = BufferSource | WebAssembly.Module;

/**
 * Instantiates the given `module`, which can either be bytes or
 * a precompiled `WebAssembly.Module`.
 *
 * @param {{ module: SyncInitInput }} module - Passing `SyncInitInput` directly is deprecated.
 *
 * @returns {InitOutput}
 */
export function initSync(module: { module: SyncInitInput } | SyncInitInput): InitOutput;

/**
 * If `module_or_path` is {RequestInfo} or {URL}, makes a request and
 * for everything else, calls `WebAssembly.instantiate` directly.
 *
 * @param {{ module_or_path: InitInput | Promise<InitInput> }} module_or_path - Passing `InitInput` directly is deprecated.
 *
 * @returns {Promise<InitOutput>}
 */
export default function __wbg_init (module_or_path?: { module_or_path: InitInput | Promise<InitInput> } | InitInput | Promise<InitInput>): Promise<InitOutput>;
