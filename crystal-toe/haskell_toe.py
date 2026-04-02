#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later
# haskell_toe.py — COMPLETE: atoms + physics + ALL 21 dynamics

import subprocess
from pathlib import Path

class HaskellToe:
    def __init__(self, binary=None):
        if binary is None:
            for c in [Path.cwd()/"crystal_oracle", Path(__file__).parent/"crystal_oracle"]:
                if c.exists() and c.is_file():
                    binary = str(c.resolve()); break
        if binary is None:
            raise FileNotFoundError("crystal_oracle not found. ghc -O2 CrystalOracle.hs -o crystal_oracle")
        self._binary = binary; self._values = {}; self._run()

    def _run(self):
        r = subprocess.run([self._binary], capture_output=True, text=True, timeout=10)
        if r.returncode != 0: raise RuntimeError(f"Haskell oracle failed: {r.stderr}")
        for line in r.stdout.strip().splitlines():
            if "=" not in line: continue
            k, v = line.split("=", 1); k = k.strip()
            if v.startswith("["):
                self._values[k] = [int(x) for x in v.strip("[]").split(",")]
            else:
                try: self._values[k] = int(v)
                except ValueError:
                    try: self._values[k] = float(v)
                    except ValueError: self._values[k] = v

    def get(self, key): return self._values[key]
    @property
    def all_values(self): return dict(self._values)

    # ── Atoms ──────────────────────────────────────────
    @property
    def chi(self): return self._values["chi"]
    @property
    def beta0(self): return self._values["beta0"]
    @property
    def d1(self): return self._values["d1"]
    @property
    def d2(self): return self._values["d2"]
    @property
    def d3(self): return self._values["d3"]
    @property
    def d4(self): return self._values["d4"]
    @property
    def sigma_d(self): return self._values["sigma_d"]
    @property
    def sigma_d2(self): return self._values["sigma_d2"]
    @property
    def gauss(self): return self._values["gauss"]
    @property
    def tower_d(self): return self._values["tower_d"]
    @property
    def d_colour(self): return self._values["d_colour"]
    @property
    def d_mixed(self): return self._values["d_mixed"]
    @property
    def shared_core(self): return self._values["shared_core"]
    @property
    def fermat3(self): return self._values["fermat3"]
    @property
    def kappa(self): return self._values["kappa"]

    # ── VEV ────────────────────────────────────────────
    @property
    def vev_crystal(self): return self._values["vev_crystal"]
    @property
    def conversion_factor(self): return self._values["conversion_factor"]
    @property
    def vev_pdg(self): return self._values["vev_pdg"]

    # ── Couplings ──────────────────────────────────────
    @property
    def alpha_inv(self): return self._values["alpha_inv"]
    @property
    def alpha(self): return self._values["alpha"]
    @property
    def sin2_theta_w(self): return self._values["sin2_theta_w"]
    @property
    def cos2_theta_w(self): return self._values["cos2_theta_w"]

    # ── Masses Crystal ─────────────────────────────────
    @property
    def proton_mass(self): return self._values["proton_mass"]
    @property
    def neutron_mass(self): return self._values["neutron_mass"]
    @property
    def electron_mass(self): return self._values["electron_mass"]
    @property
    def muon_mass(self): return self._values["muon_mass"]
    @property
    def tau_mass(self): return self._values["tau_mass"]
    @property
    def pion_mass(self): return self._values["pion_mass"]
    @property
    def kaon_mass(self): return self._values["kaon_mass"]
    @property
    def rho_mass(self): return self._values["rho_mass"]
    @property
    def delta_mass(self): return self._values["delta_mass"]
    @property
    def top_mass(self): return self._values["top_mass"]
    @property
    def z_mass(self): return self._values["z_mass"]
    @property
    def w_mass(self): return self._values["w_mass"]
    @property
    def higgs_mass(self): return self._values["higgs_mass"]
    @property
    def lambda_qcd(self): return self._values["lambda_qcd"]
    @property
    def f_pi(self): return self._values["f_pi"]
    @property
    def up_mass(self): return self._values["up_mass"]
    @property
    def down_mass(self): return self._values["down_mass"]
    @property
    def strange_mass(self): return self._values["strange_mass"]
    @property
    def charm_mass(self): return self._values["charm_mass"]
    @property
    def bottom_mass(self): return self._values["bottom_mass"]

    # ── Masses PDG ─────────────────────────────────────
    @property
    def proton_mass_pdg(self): return self._values["proton_mass_pdg"]
    @property
    def electron_mass_pdg(self): return self._values["electron_mass_pdg"]
    @property
    def z_mass_pdg(self): return self._values["z_mass_pdg"]
    @property
    def top_mass_pdg(self): return self._values["top_mass_pdg"]

    # ── Dimensionless ──────────────────────────────────
    @property
    def mp_me_ratio(self): return self._values["mp_me_ratio"]
    @property
    def mu_e_ratio(self): return self._values["mu_e_ratio"]
    @property
    def tau_mu_ratio(self): return self._values["tau_mu_ratio"]

    # ── Cosmo ──────────────────────────────────────────
    @property
    def omega_lambda(self): return self._values["omega_lambda"]
    @property
    def omega_cdm(self): return self._values["omega_cdm"]
    @property
    def omega_b(self): return self._values["omega_b"]
    @property
    def omega_m(self): return self._values["omega_m"]
    @property
    def h0(self): return self._values["h0"]
    @property
    def spectral_index(self): return self._values["spectral_index"]

    # ── Mixing ─────────────────────────────────────────
    @property
    def sin_cabibbo(self): return self._values["sin_cabibbo"]
    @property
    def v_us(self): return self._values["v_us"]
    @property
    def v_cb(self): return self._values["v_cb"]
    @property
    def v_ub(self): return self._values["v_ub"]
    @property
    def jarlskog(self): return self._values["jarlskog"]
    @property
    def sin2_theta12(self): return self._values["sin2_theta12"]
    @property
    def sin2_theta23(self): return self._values["sin2_theta23"]
    @property
    def sin2_theta13(self): return self._values["sin2_theta13"]

    # ── CODATA ─────────────────────────────────────────
    @property
    def proton_radius(self): return self._values["proton_radius"]

    # ══════════════════════════════════════════════════
    # DYNAMICS — ALL 21 MODULES
    # ══════════════════════════════════════════════════

    # Classical
    @property
    def dyn_spatial_dim(self): return self._values["dyn_spatial_dim"]
    @property
    def dyn_phase_space(self): return self._values["dyn_phase_space"]
    @property
    def dyn_force_exp(self): return self._values["dyn_force_exp"]

    # GR
    @property
    def dyn_isco(self): return self._values["dyn_isco"]
    @property
    def dyn_precession(self): return self._values["dyn_precession"]
    @property
    def dyn_bending(self): return self._values["dyn_bending"]
    @property
    def dyn_photon_sphere(self): return self._values["dyn_photon_sphere"]
    @property
    def dyn_schwarz(self): return self._values["dyn_schwarz"]

    # GW
    @property
    def dyn_peters(self): return self._values["dyn_peters"]
    @property
    def dyn_chirp_exp(self): return self._values["dyn_chirp_exp"]
    @property
    def dyn_gw_pol(self): return self._values["dyn_gw_pol"]

    # EM
    @property
    def dyn_em_comp(self): return self._values["dyn_em_comp"]
    @property
    def dyn_maxwell(self): return self._values["dyn_maxwell"]
    @property
    def dyn_em_pol(self): return self._values["dyn_em_pol"]
    @property
    def dyn_larmor(self): return self._values["dyn_larmor"]

    # Friedmann
    @property
    def dyn_friedmann_flat(self): return self._values["dyn_friedmann_flat"]

    # NBody
    @property
    def dyn_octree(self): return self._values["dyn_octree"]
    @property
    def dyn_bh_theta(self): return self._values["dyn_bh_theta"]

    # Thermo
    @property
    def dyn_lj_attract(self): return self._values["dyn_lj_attract"]
    @property
    def dyn_lj_repel(self): return self._values["dyn_lj_repel"]
    @property
    def dyn_gamma_mono(self): return self._values["dyn_gamma_mono"]

    # CFD
    @property
    def dyn_d2q9(self): return self._values["dyn_d2q9"]
    @property
    def dyn_stokes(self): return self._values["dyn_stokes"]
    @property
    def dyn_kolmogorov(self): return self._values["dyn_kolmogorov"]

    # Decay
    @property
    def dyn_beta_factor(self): return self._values["dyn_beta_factor"]

    # Optics
    @property
    def dyn_n_water(self): return self._values["dyn_n_water"]
    @property
    def dyn_n_glass(self): return self._values["dyn_n_glass"]
    @property
    def dyn_n_diamond(self): return self._values["dyn_n_diamond"]
    @property
    def dyn_rayleigh(self): return self._values["dyn_rayleigh"]
    @property
    def dyn_planck(self): return self._values["dyn_planck"]

    # MD
    @property
    def dyn_sp3(self): return self._values["dyn_sp3"]
    @property
    def dyn_water_angle(self): return self._values["dyn_water_angle"]
    @property
    def dyn_helix(self): return self._values["dyn_helix"]
    @property
    def dyn_flory(self): return self._values["dyn_flory"]
    @property
    def dyn_amino(self): return self._values["dyn_amino"]
    @property
    def dyn_dna(self): return self._values["dyn_dna"]

    # Condensed
    @property
    def dyn_ising_z(self): return self._values["dyn_ising_z"]
    @property
    def dyn_onsager(self): return self._values["dyn_onsager"]
    @property
    def dyn_bcs(self): return self._values["dyn_bcs"]

    # Plasma
    @property
    def dyn_mhd(self): return self._values["dyn_mhd"]
    @property
    def dyn_wave_types(self): return self._values["dyn_wave_types"]
    @property
    def dyn_prop_modes(self): return self._values["dyn_prop_modes"]

    # QFT
    @property
    def dyn_spacetime(self): return self._values["dyn_spacetime"]
    @property
    def dyn_lorentz(self): return self._values["dyn_lorentz"]
    @property
    def dyn_dirac(self): return self._values["dyn_dirac"]
    @property
    def dyn_gluons(self): return self._values["dyn_gluons"]
    @property
    def dyn_one_loop(self): return self._values["dyn_one_loop"]
    @property
    def dyn_thomson(self): return self._values["dyn_thomson"]
    @property
    def dyn_sigma10(self): return self._values["dyn_sigma10"]

    # Rigid
    @property
    def dyn_quat(self): return self._values["dyn_quat"]
    @property
    def dyn_inertia(self): return self._values["dyn_inertia"]
    @property
    def dyn_i_sphere(self): return self._values["dyn_i_sphere"]
    @property
    def dyn_i_rod(self): return self._values["dyn_i_rod"]
    @property
    def dyn_i_shell(self): return self._values["dyn_i_shell"]

    # Chem
    @property
    def dyn_s_cap(self): return self._values["dyn_s_cap"]
    @property
    def dyn_p_cap(self): return self._values["dyn_p_cap"]
    @property
    def dyn_d_cap(self): return self._values["dyn_d_cap"]
    @property
    def dyn_f_cap(self): return self._values["dyn_f_cap"]
    @property
    def dyn_noble_kr(self): return self._values["dyn_noble_kr"]
    @property
    def dyn_ph(self): return self._values["dyn_ph"]

    # Nuclear
    @property
    def dyn_magic(self): return self._values["dyn_magic"]
    @property
    def dyn_iron(self): return self._values["dyn_iron"]

    # Astro
    @property
    def dyn_poly_nr(self): return self._values["dyn_poly_nr"]
    @property
    def dyn_poly_rel(self): return self._values["dyn_poly_rel"]
    @property
    def dyn_hawking(self): return self._values["dyn_hawking"]
    @property
    def dyn_sb(self): return self._values["dyn_sb"]
    @property
    def dyn_eddington(self): return self._values["dyn_eddington"]
    @property
    def dyn_le_15_xi(self): return self._values["dyn_le_15_xi"]
    @property
    def dyn_le_15_mass(self): return self._values["dyn_le_15_mass"]
    @property
    def dyn_le_30_xi(self): return self._values["dyn_le_30_xi"]
    @property
    def dyn_le_30_mass(self): return self._values["dyn_le_30_mass"]

    # QInfo
    @property
    def dyn_qubit(self): return self._values["dyn_qubit"]
    @property
    def dyn_pauli(self): return self._values["dyn_pauli"]
    @property
    def dyn_bell(self): return self._values["dyn_bell"]
    @property
    def dyn_steane_n(self): return self._values["dyn_steane_n"]
    @property
    def dyn_steane_k(self): return self._values["dyn_steane_k"]
    @property
    def dyn_steane_d(self): return self._values["dyn_steane_d"]
    @property
    def dyn_shor(self): return self._values["dyn_shor"]
    @property
    def dyn_mera_bond(self): return self._values["dyn_mera_bond"]
    @property
    def dyn_mera_depth(self): return self._values["dyn_mera_depth"]

    # Bio
    @property
    def dyn_codons(self): return self._values["dyn_codons"]
    @property
    def dyn_stops(self): return self._values["dyn_stops"]
    @property
    def dyn_hbond_at(self): return self._values["dyn_hbond_at"]
    @property
    def dyn_hbond_gc(self): return self._values["dyn_hbond_gc"]
    @property
    def dyn_bp_turn(self): return self._values["dyn_bp_turn"]
    @property
    def dyn_lipid(self): return self._values["dyn_lipid"]
    @property
    def dyn_kleiber(self): return self._values["dyn_kleiber"]
    @property
    def dyn_surface(self): return self._values["dyn_surface"]
    @property
    def dyn_heart(self): return self._values["dyn_heart"]

    # Arcade
    @property
    def dyn_lj_cut(self): return self._values["dyn_lj_cut"]
    @property
    def dyn_fixed_bits(self): return self._values["dyn_fixed_bits"]
    @property
    def dyn_lod(self): return self._values["dyn_lod"]
    @property
    def dyn_wca(self): return self._values["dyn_wca"]
    @property
    def dyn_fast_alpha(self): return self._values["dyn_fast_alpha"]

    def __repr__(self):
        return f"HaskellToe({len(self._values)} values from {self._binary})"
