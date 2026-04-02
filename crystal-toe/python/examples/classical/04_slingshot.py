#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""
Crystal Classical Dynamics — Example 4: Lunar Gravity Slingshot
================================================================
N-body simulation: spacecraft in Earth-Moon system.
Demonstrates gravity assist — free energy from orbital mechanics.
All force computation from crystal leapfrog.
"""

import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe()
cl = toe.classical()

# Constants (km, s)
GM_EARTH = 3.986004418e5
GM_MOON  = 4.9028e3
R_EARTH  = 6371.0
MOON_DIST = 384400.0

print("=== Lunar Gravity Slingshot ===")
print(f"  Earth GM: {GM_EARTH:.3e} km³/s²")
print(f"  Moon  GM: {GM_MOON:.3e} km³/s²")
print(f"  Moon distance: {MOON_DIST:.0f} km")

# === Multiple slingshot trajectories with different launch angles ===
fig, axes = plt.subplots(2, 2, figsize=(16, 14))
fig.suptitle("Crystal Classical Dynamics — Lunar Gravity Slingshot\n"
             "N-body: Earth + Moon, symplectic leapfrog from crystal monad",
             fontsize=14, fontweight='bold')

launch_speeds = [10.8, 10.9, 11.0, 11.1]  # km/s — near escape velocity
v_esc = cl.escape_velocity(GM_EARTH, R_EARTH + 500)
print(f"  Escape velocity at 500 km: {v_esc:.3f} km/s")

for idx, v_launch in enumerate(launch_speeds):
    ax = axes[idx // 2][idx % 2]

    # Launch from 500 km altitude, mostly prograde with slight Moon-ward component
    px, py, pz = R_EARTH + 500, 0.0, 0.0
    vx, vy, vz = 0.0, v_launch, 0.3

    dt = 100.0   # 100 second steps
    n_steps = 60000  # ~70 days

    xs, ys, zs = cl.slingshot(
        GM_EARTH, GM_MOON, MOON_DIST, 0.0, 0.0,
        px, py, pz, vx, vy, vz, dt, n_steps
    )

    # Compute initial and final specific energy
    e0 = cl.orbital_energy(GM_EARTH, px, py, pz, vx, vy, vz)
    ef = cl.orbital_energy(GM_EARTH, xs[-1], ys[-1], zs[-1],
                           (xs[-1]-xs[-2])/dt, (ys[-1]-ys[-2])/dt, (zs[-1]-zs[-2])/dt)

    # Plot
    ax.plot(np.array(xs)/R_EARTH, np.array(ys)/R_EARTH, 'b-', linewidth=0.3, alpha=0.7)

    # Earth
    theta = np.linspace(0, 2*np.pi, 100)
    ax.plot(np.cos(theta), np.sin(theta), 'g-', linewidth=2)
    ax.fill(np.cos(theta), np.sin(theta), color='green', alpha=0.3)

    # Moon position
    ax.plot(MOON_DIST/R_EARTH, 0, 'ko', markersize=6, label='Moon')

    # Moon orbit circle
    ax.plot(MOON_DIST/R_EARTH * np.cos(theta), MOON_DIST/R_EARTH * np.sin(theta),
            'k--', linewidth=0.5, alpha=0.3)

    # Start/end markers
    ax.plot(xs[0]/R_EARTH, ys[0]/R_EARTH, 'go', markersize=8, label='Launch')
    ax.plot(xs[-1]/R_EARTH, ys[-1]/R_EARTH, 'r*', markersize=10, label='Final')

    bound = MOON_DIST * 1.5 / R_EARTH
    ax.set_xlim(-bound, bound)
    ax.set_ylim(-bound, bound)
    ax.set_aspect('equal')
    ax.set_xlabel('x / R⊕')
    ax.set_ylabel('y / R⊕')
    ax.set_title(f'v₀ = {v_launch} km/s   E₀={e0:.1f}  Ef={ef:.1f} km²/s²')
    ax.legend(loc='upper right', fontsize=8)
    ax.grid(True, alpha=0.2)

plt.tight_layout()
plt.savefig('crystal_classical_04_slingshot.png', dpi=150, bbox_inches='tight')
plt.show()
print("\nSaved: crystal_classical_04_slingshot.png")