# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""
113 — RTG Power (Pu-238 Decay)
Crystal source: Nuclear binding, τ_n = D²/N_w = 882

analysis bridge: Nuclear physics ↔ Power engineering
  World: nuclear decay / spectral action
  Actor: Pu-238 nucleus / Dirac operator
  Choice: decay channel selection (α vs β vs γ)
  Act: heat generation / eigenvalue
  Type: T1 (nuclear physics solves power engineering problem)
  Structure: S4 (oscillation/decay) + S2 (conserved quantity)

The neutron lifetime τ_n relates to D²/N_w = 42²/2 = 882 seconds.
PDG value: τ_n = 878.4 ± 0.5 s (bottle) or 887.7 ± 2.2 s (beam).
Crystal: 882 s sits between the two measurements (neutron lifetime puzzle).

Nuclear binding energies involve the strong force (β₀=7)
and Coulomb repulsion (α), both crystal invariants.
AGPL-3.0
"""
import math
from crystal_constants import (N_c, N_w, D, beta_0, chi, gauss,
                                tau_n_ratio, C_F, PI)

# === CRYSTAL NUCLEAR INVARIANTS ===
tau_n_crystal = tau_n_ratio  # D²/N_w = 882 seconds
assert tau_n_crystal == D**2 / N_w == 882

# PDG values for comparison
tau_n_bottle = 878.4  # seconds (bottle method)
tau_n_beam = 887.7    # seconds (beam method)
# Crystal prediction 882 sits between them — the "neutron lifetime puzzle"

# === PU-238 PROPERTIES ===
# Pu-238 decays by α emission: Pu-238 → U-234 + He-4
half_life_pu238 = 87.7  # years
decay_energy = 5.593    # MeV (α particle kinetic energy)
thermal_power_per_kg = 0.558  # W/g = 558 W/kg (thermal)

# Decay constant
lambda_decay = math.log(2) / (half_life_pu238 * 365.25 * 24 * 3600)  # per second

# === RTG DESIGN (Multi-Mission RTG, MMRTG-class) ===
pu238_mass = 4.8  # kg (MMRTG uses ~4.8 kg Pu-238)
thermal_power_initial = pu238_mass * 1000 * thermal_power_per_kg  # W

# Thermoelectric conversion efficiency
# Carnot bound: η < (T_hot - T_cold) / T_hot
T_hot_rtg = 1273.0   # K (GPHS module hot shoe)
T_cold_rtg = 473.0   # K (cold shoe)
eta_carnot_rtg = 1 - T_cold_rtg / T_hot_rtg

# Crystal Carnot: (χ-1)/χ = 5/6 is the IDEAL bound
# Actual thermoelectric: η ≈ 6-7% (far from Carnot due to ZT limitations)
eta_thermoelectric = 0.065
electric_power_initial = thermal_power_initial * eta_thermoelectric

# Power after Mars mission duration (3 years)
mission_years = 3.0
mission_seconds = mission_years * 365.25 * 24 * 3600
thermal_power_after = thermal_power_initial * math.exp(-lambda_decay * mission_seconds)
electric_power_after = thermal_power_after * eta_thermoelectric

# === NUCLEAR BINDING CRYSTAL CONNECTION ===
# α decay occurs when: Q = M_parent - M_daughter - M_alpha > 0
# The binding energy per nucleon B/A involves:
#   - Volume term ∝ A (strong force, β₀=7 scale)
#   - Surface term ∝ A^(2/3) (geometry, N_c=3)
#   - Coulomb term ∝ Z²/A^(1/3) (electromagnetic, α)
#   - Asymmetry term ∝ (N-Z)²/A (isospin, N_w=2)
#   - Pairing term (spin-statistics, N_w=2 Pauli structure)
#
# Every term traces to crystal invariants:
#   β₀ → strong scale, N_c → surface geometry,
#   α → Coulomb, N_w → isospin + pairing

print("=" * 60)
print("113 — RTG Power: Pu-238 for Mars Mission")
print("=" * 60)
print(f"Crystal invariants:")
print(f"  τ_n = D²/N_w = {D}²/{N_w} = {tau_n_crystal} s")
print(f"  PDG bottle: {tau_n_bottle} s | beam: {tau_n_beam} s")
print(f"  Crystal sits between (neutron lifetime puzzle)")
print(f"  β₀ = {beta_0} (strong force running)")
print(f"  C_F = {C_F:.4f} (QCD vertex)")
print()
print(f"Pu-238 RTG ({pu238_mass} kg):")
print(f"  Initial thermal: {thermal_power_initial:.0f} W")
print(f"  Thermoelectric η: {eta_thermoelectric*100:.1f}%")
print(f"  Carnot bound:     {eta_carnot_rtg*100:.1f}%")
print(f"  Initial electric: {electric_power_initial:.1f} W")
print(f"  After {mission_years:.0f} years:  {electric_power_after:.1f} W")
print()
print("analysis bridge: T1 S4+S2 — nuclear decay physics → power engineering")
print("  Binding energy terms trace to β₀, N_c, α, N_w from A_F.")
print("No new observables. Application of τ_n, β₀, C_F, α.")
