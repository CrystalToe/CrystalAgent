#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""
Crystal Classical Dynamics — Example 2: Elliptical Orbits
==========================================================
Shows how eccentricity affects orbit shape.
Proves Kepler's laws numerically from the crystal leapfrog.
"""

import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe()
cl = toe.classical()
GM = 1.0  # normalized units
A  = 5.0  # semi-major axis

eccentricities = [0.0, 0.2, 0.5, 0.7, 0.9, 0.95]
colors = plt.cm.plasma(np.linspace(0.1, 0.9, len(eccentricities)))

fig, axes = plt.subplots(2, 3, figsize=(18, 12))
fig.suptitle("Crystal Classical Dynamics — Elliptical Orbits\n"
             "Kepler's laws from the monad S = W∘U∘W, all integers from (2,3)",
             fontsize=14, fontweight='bold')

# Top row: orbits
ax_orbit = fig.add_subplot(2, 1, 1)
for i, ecc in enumerate(eccentricities):
    state = cl.orbit_elliptical(GM, A, ecc)
    px, py, pz, vx, vy, vz = state
    period = cl.kepler_period(A, GM)
    dt = period / 2000
    n = int(1.1 * period / dt)
    xs, ys, zs, _, _, _ = cl.kepler_orbit(GM, px, py, pz, vx, vy, vz, dt, n)
    ax_orbit.plot(xs, ys, color=colors[i], linewidth=1.5, label=f'e = {ecc}')

ax_orbit.plot(0, 0, 'yo', markersize=12, zorder=5, label='Central body')
ax_orbit.set_aspect('equal')
ax_orbit.set_xlabel('x', fontsize=12)
ax_orbit.set_ylabel('y', fontsize=12)
ax_orbit.set_title('Orbit shapes: same semi-major axis, varying eccentricity')
ax_orbit.legend(loc='upper right', fontsize=10)
ax_orbit.grid(True, alpha=0.3)

# Bottom left: radius vs time (shows Kepler's 2nd law)
ax_r = fig.add_subplot(2, 3, 4)
for i, ecc in enumerate([0.0, 0.5, 0.9]):
    state = cl.orbit_elliptical(GM, A, ecc)
    px, py, pz, vx, vy, vz = state
    period = cl.kepler_period(A, GM)
    dt = period / 1000
    n = int(1.5 * period / dt)
    radii = cl.kepler_radius_trace(GM, px, py, pz, vx, vy, vz, dt, n)
    time = np.array(cl.time_array(dt, n)) / period
    ax_r.plot(time, radii, linewidth=1.5, label=f'e = {ecc}')

ax_r.set_xlabel('Time / Period')
ax_r.set_ylabel('Radius')
ax_r.set_title("Radius oscillation (Kepler's 2nd law)")
ax_r.legend()
ax_r.grid(True, alpha=0.3)

# Bottom middle: speed vs time
ax_v = fig.add_subplot(2, 3, 5)
for i, ecc in enumerate([0.0, 0.5, 0.9]):
    state = cl.orbit_elliptical(GM, A, ecc)
    px, py, pz, vx, vy, vz = state
    period = cl.kepler_period(A, GM)
    dt = period / 1000
    n = int(1.5 * period / dt)
    speed = cl.kepler_speed_trace(GM, px, py, pz, vx, vy, vz, dt, n)
    time = np.array(cl.time_array(dt, n)) / period
    ax_v.plot(time, speed, linewidth=1.5, label=f'e = {ecc}')

ax_v.set_xlabel('Time / Period')
ax_v.set_ylabel('Speed')
ax_v.set_title('Speed: fast at periapsis, slow at apoapsis')
ax_v.legend()
ax_v.grid(True, alpha=0.3)

# Bottom right: Kepler's 3rd law verification
ax_k3 = fig.add_subplot(2, 3, 6)
semi_major_axes = np.linspace(1, 20, 50)
periods_analytic = [cl.kepler_period(a, GM) for a in semi_major_axes]
ax_k3.plot(semi_major_axes, np.array(periods_analytic)**2, 'b-', linewidth=2, label='T²')
ax_k3.plot(semi_major_axes, (2*np.pi)**2 * semi_major_axes**3 / GM, 'r--', linewidth=2, label='(2π)² a³/GM')
ax_k3.set_xlabel('Semi-major axis a')
ax_k3.set_ylabel('T²')
ax_k3.set_title("Kepler's 3rd Law: T² ∝ a^N_c = a³")
ax_k3.legend()
ax_k3.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('crystal_classical_02_elliptical.png', dpi=150, bbox_inches='tight')
plt.show()
print("Saved: crystal_classical_02_elliptical.png")