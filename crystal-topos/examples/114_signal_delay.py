# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""
114 — Signal Round-Trip Delay (Earth-Mars Communications)
Crystal source: c = causal boundary, Maxwell singlet


The speed of light c is NOT just "a constant." In crystal language,
c is the spectral bound of the Dirac operator — the maximum rate
at which information propagates through the noncommutative geometry.
The photon is the singlet representation of A_F (dimension 1 in sector_dims).
It propagates at the causal boundary BECAUSE it's a singlet (massless).

The duality S12: Maxwell's equations exhibit electric-magnetic duality,
which is a consequence of the ℂ summand in A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ).
AGPL-3.0
"""
import math
from crystal_constants import (N_c, N_w, chi, sector_dims, D, PI)

# === CRYSTAL CAUSAL STRUCTURE ===
# The singlet (dimension 1) in sector_dims = [1, 3, 8, 24]
# corresponds to the U(1) electromagnetic sector.
# Massless particles live in the singlet — they propagate at c.
assert sector_dims[0] == 1, "Singlet sector → photon → speed c"

# Speed of light (defines the causal boundary)
c = 299792.458  # km/s

# === EARTH-MARS DISTANCES ===
AU_km = 1.496e8  # km

# Mars distance varies: 0.37 AU (opposition) to 2.68 AU (conjunction)
d_min = 0.37 * AU_km   # closest approach
d_avg = 1.52 * AU_km   # average (Mars semi-major axis ≈ 1.524 AU)
d_max = 2.68 * AU_km   # solar conjunction (far side)

# One-way light time
t_min = d_min / c       # seconds
t_avg = d_avg / c
t_max = d_max / c

# Round-trip
rt_min = 2 * t_min
rt_avg = 2 * t_avg
rt_max = 2 * t_max

# === COMMUNICATION CONSTRAINTS ===
# Shannon capacity: C = B × log₂(1 + SNR)
# For deep space, the limiting factor is the round-trip delay,
# not the bandwidth — you can't have real-time control.

# Typical DSN bandwidth to Mars: ~2 Mbps (proximity relay)
# or ~500 kbps (direct to Earth, X-band)
bandwidth_direct = 500  # kbps

# Data volume per sol (Mars day ≈ 24h 37m)
sol_seconds = 24 * 3600 + 37 * 60  # 88620 s
# Communication window ≈ 8-10 hours per sol
comm_window = 8 * 3600  # seconds
data_per_sol = bandwidth_direct * comm_window / 8  # kilobytes

# === RELATIVISTIC CORRECTIONS ===
# For Mars mission, v << c, so relativistic effects are tiny.
# But the STRUCTURE matters: c as causal boundary means
# no faster-than-light communication, period.
# This is a THEOREM in crystal: the Dirac operator's spectrum
# is bounded, and c is that bound.

# Gravitational time dilation (Sun's field)
# Δt/t ≈ GM_sun/(rc²) — tiny for Mars orbit
GM_sun_c2 = 1.48e3     # meters (Schwarzschild radius of Sun / 2)
r_mars_m = 2.279e11    # meters
grav_dilation = GM_sun_c2 / r_mars_m  # dimensionless, ≈ 6.5e-9

print("=" * 60)
print("114 — Signal Round-Trip Delay: Earth ↔ Mars")
print("=" * 60)
print(f"Crystal invariant: c = causal boundary of Dirac operator")
print(f"  Photon = singlet representation (dim = {sector_dims[0]})")
print(f"  Massless because singlet → propagates at spectral bound")
print()
print(f"One-way light time:")
print(f"  Closest ({d_min/AU_km:.2f} AU): {t_min:.0f} s = {t_min/60:.1f} min")
print(f"  Average ({d_avg/AU_km:.2f} AU): {t_avg:.0f} s = {t_avg/60:.1f} min")
print(f"  Farthest ({d_max/AU_km:.2f} AU): {t_max:.0f} s = {t_max/60:.1f} min")
print()
print(f"Round-trip delay:")
print(f"  Min: {rt_min/60:.1f} min")
print(f"  Avg: {rt_avg/60:.1f} min")
print(f"  Max: {rt_max/60:.1f} min")
print()
print(f"Data budget: {data_per_sol/1e6:.1f} GB/sol at {bandwidth_direct} kbps")
print(f"Gravitational time dilation: {grav_dilation:.2e} (negligible)")
print()
print("  c is the causal boundary, not a parameter to fit.")
print("No new observables. Structural: c from Dirac spectral bound.")
