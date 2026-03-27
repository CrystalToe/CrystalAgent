# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""
112 — Solar Panel Efficiency
Crystal source: Carnot 5/6, Stefan-Boltzmann 120

analysis bridge: Thermodynamics ↔ Representation theory
  World: heat engine / gauge field partition function
  Actor: photon absorption / boson propagator
  Choice: Carnot efficiency bound (universal thermodynamic limit)
  Act: power output / free energy
  Type: T2 (shared structure — partition function IS the Boltzmann weight)
  Structure: S8 (information/entropy) + S7 (optimisation)

Carnot efficiency = (χ-1)/χ = 5/6 ≈ 0.833
Stefan-Boltzmann prefactor: 2π⁵/15 = 120 × (π⁵/900)
Crystal: 120 = N_w × N_c × (gauss + β₀) = 2 × 3 × 20

The Carnot bound is NOT about specific engines. It's about the structure
of the state space. In crystal language: the maximum extractable work
from a thermal gradient is (χ-1)/χ of the input heat, because χ=6
is the number of independent sectors that can carry entropy.
AGPL-3.0
"""
import math
from crystal_constants import (N_c, N_w, chi, beta_0, gauss, stefan_bolt,
                                carnot_ideal, PI)

# === CRYSTAL THERMODYNAMIC INVARIANTS ===
assert carnot_ideal == (chi - 1) / chi  # 5/6
assert stefan_bolt == N_w * N_c * (gauss + beta_0)  # 120

# Stefan-Boltzmann constant σ = 2π⁵k⁴/(15h³c²)
# The factor 2π⁵/15 = π⁵ × 2/15
# Crystal: 2/15 relates to sector structure
# The full factor 2π⁵/15 ≈ 129.29... but the INTEGER part 120 is crystal
sigma_sb = 5.670374419e-8  # W/m²/K⁴ (SI)

# === SOLAR FLUX AT MARS ===
T_sun = 5778.0          # K (solar effective temperature)
R_sun = 6.957e8         # m (solar radius)
AU = 1.496e11           # m
mars_distance = 1.524   # AU (average)

# Solar flux at Mars (inverse-square, N_c=3)
solar_flux_earth = sigma_sb * T_sun**4 * (R_sun / AU)**2  # W/m² at Earth
# Should be ≈ 1361 W/m² (solar constant)
solar_flux_mars = solar_flux_earth / mars_distance**2

# === PHOTOVOLTAIC EFFICIENCY ===
# Shockley-Queisser limit for single-junction solar cell
# Theoretical maximum ≈ 33.7% for AM1.5 spectrum
# This limit comes from detailed balance (Carnot-like bound)

# Crystal Carnot bound: η_Carnot = (T_hot - T_cold) / T_hot
# For solar cell: T_hot = T_sun, T_cold = T_cell
T_cell = 300.0  # K (cell operating temperature on Mars, estimated)
eta_carnot = 1 - T_cell / T_sun
# Carnot ≈ 0.948 (much higher than Shockley-Queisser)

# The gap between Carnot and Shockley-Queisser is due to:
# 1) Bandgap mismatch (entropy of photon-electron conversion)
# 2) Radiative recombination (detailed balance)
# Crystal: the (χ-1)/χ ratio gives the IDEAL upper bound
# The actual limit is further reduced by quantum efficiency factors

# Practical Mars solar panel
eta_practical = 0.30    # 30% (high-efficiency multi-junction)
panel_area = 10.0       # m²
power_output = solar_flux_mars * panel_area * eta_practical

# === STEFAN-BOLTZMANN DECOMPOSITION ===
# σ = 2π⁵k_B⁴ / (15 h³ c²)
# The 120 = 2 × 3 × 20 appears in the numerator of the coefficient
# when expressed in natural units where the sector structure is manifest.
# 
# Decomposition: 120 = N_w × N_c × (gauss + β₀)
#   N_w = 2: two polarization states of the photon
#   N_c = 3: spatial integration dimensions
#   gauss + β₀ = 13 + 7 = 20: effective degrees of freedom

print("=" * 60)
print("112 — Solar Panel Efficiency at Mars")
print("=" * 60)
print(f"Crystal invariants:")
print(f"  Carnot ideal: (χ-1)/χ = {chi-1}/{chi} = {carnot_ideal:.6f}")
print(f"  Stefan-Boltzmann 120 = {N_w}×{N_c}×({gauss}+{beta_0})")
print()
print(f"Solar flux:")
print(f"  At Earth: {solar_flux_earth:.0f} W/m²")
print(f"  At Mars ({mars_distance:.3f} AU): {solar_flux_mars:.0f} W/m²")
print()
print(f"Efficiency bounds:")
print(f"  Carnot (T_sun→T_cell): {eta_carnot:.3f}")
print(f"  Crystal Carnot (χ):    {carnot_ideal:.6f}")
print(f"  Practical panel:       {eta_practical:.2f}")
print()
print(f"Power output: {power_output:.1f} W from {panel_area:.0f} m² panel")
print()
print("analysis bridge: T2 S8+S7 — thermodynamic partition function")
print("  shared between heat engines and QFT free energy.")
print("No new observables. Application of Carnot 5/6, SB 120.")
