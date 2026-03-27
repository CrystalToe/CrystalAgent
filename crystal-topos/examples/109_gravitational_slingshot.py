# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""
109 — Gravitational Slingshot (Three-Body)
Crystal source: Three-body solvable manifold (10D), chaotic complement (8D)
Phase space decomposition: 18 = 10 + 8

  Choice: phase space decomposition into solvable + chaotic sectors

The three-body problem has 18 phase space dimensions (3 bodies × 3 positions × 2).
Crystal decomposes this as 10 (solvable, integrable) + 8 (chaotic, non-integrable).
10 = gauss - N_c = 13 - 3
8  = N_c² - 1 (adjoint representation of SU(3))

The solvable sector gives the restricted three-body problem (Lagrange points).
The chaotic sector is the SU(3) adjoint — same dimension as gluon field space.
AGPL-3.0
"""
import math
from crystal_constants import (N_c, N_w, chi, gauss, solvable_dim, chaotic_dim,
                                phase_18, lagrange_pts, PI)

# === THREE-BODY PHASE SPACE ===
n_bodies = N_c          # 3 bodies (Sun, planet, spacecraft)
pos_dims = N_c          # 3 spatial dimensions
# Full phase space: n_bodies × pos_dims × 2 (position + momentum)
# But center of mass removes 2*pos_dims = 6 DOF
# Remaining: 3*3*2 - 6 = 12... that's the reduced problem

# Crystal decomposition uses the FULL constraint space = 18
# 18 = 3 bodies × 3 dims × 2 (pos+vel) = 18
# This decomposes as:
#   Solvable sector: 10 dimensions (restricted 3-body, Euler/Lagrange solutions)
#   Chaotic sector:  8 dimensions (residual chaos, no closed-form)

assert solvable_dim == 10, "Solvable sector = gauss - N_c = 10"
assert chaotic_dim == 8, "Chaotic sector = N_c² - 1 = 8 (adjoint of SU(3))"
assert phase_18 == 18, "Total phase decomposition = 18"
assert phase_18 == solvable_dim + chaotic_dim

# === SLINGSHOT MECHANICS ===
# In the solvable sector (restricted 3-body), energy and Jacobi integral are conserved
# The 5 Lagrange points live in this sector (χ-1 = 5)
assert lagrange_pts == 5

# Slingshot: spacecraft approaches planet in planet's rest frame,
# deflects, gains energy in Sun's frame.
# Maximum energy gain occurs at closest approach (periapsis)

# Example: Earth gravity assist for Mars mission
mu_earth = 3.986e5      # km³/s² (Earth gravitational parameter)
r_earth_radius = 6371.0  # km
min_altitude = 300.0     # km (minimum flyby altitude)
r_periapsis = r_earth_radius + min_altitude

v_earth_orbital = 29.78  # km/s (Earth orbital velocity)
v_inf = 3.0              # km/s (hyperbolic excess velocity, typical)

# Hyperbolic deflection angle (from vis-viva in N_c=3)
# δ = 2 * arcsin(1 / e) where e = 1 + r_p * v_inf² / μ
e_hyp = 1 + r_periapsis * v_inf**2 / mu_earth
delta = 2 * math.asin(1 / e_hyp)

# Velocity gain in Sun's frame
dv_slingshot = 2 * v_inf * math.sin(delta / 2)

# === CRYSTAL STRUCTURAL CONTENT ===
# The 10+8 decomposition is the SAME decomposition that appears in:
# - QCD: 8 gluons (adjoint of SU(3)) vs 10-dim baryon decuplet
# - Geometry: 10 independent components of Riemann tensor in 4D minus
#   8 constraints from Bianchi identity
# This is the shared structure: the decomposition 18 = 10 + 8 is shared
# across celestial mechanics, QCD, and differential geometry.

print("=" * 60)
print("109 — Gravitational Slingshot (Three-Body Decomposition)")
print("=" * 60)
print(f"Crystal: phase space 18 = {solvable_dim} (solvable) + {chaotic_dim} (chaotic)")
print(f"  Solvable: gauss - N_c = {gauss} - {N_c} = {solvable_dim}")
print(f"  Chaotic:  N_c² - 1 = {N_c}² - 1 = {chaotic_dim} (SU(3) adjoint)")
print(f"  Lagrange points: {lagrange_pts} (in solvable sector)")
print()
print(f"Slingshot parameters:")
print(f"  Hyperbolic excess: {v_inf} km/s")
print(f"  Eccentricity: {e_hyp:.4f}")
print(f"  Deflection angle: {math.degrees(delta):.1f}°")
print(f"  Velocity gain: {dv_slingshot:.3f} km/s")
print()
print("  across celestial mechanics, QCD, and Riemannian geometry")
print("No new observables. Application of existing 10+8 decomposition.")
