#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""
Crystal Classical Dynamics — Example 1: LEO Satellite
=====================================================
Toe() is the root. VEV derived from M_Pl. Everything flows down.
toe.classical() inherits VEV, masses, couplings.
"""

import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.gridspec import GridSpec

# ═══ THE ONE SEED ═══
toe = ct.Toe()                    # M_Pl × 35/(43×36×2⁵⁰) = 245.17 GeV
# toe = ct.Toe(246220.0)          # opt-in PDG for gap analysis

# ═══ DERIVED — everything from VEV ═══
print(f"VEV:          {toe.vev():.2f} MeV (crystal derived from M_Pl)")
print(f"Proton:       {toe.proton_mass():.2f} MeV")
print(f"Electron:     {toe.electron_mass():.4f} MeV")
print(f"α⁻¹:          {toe.alpha_inv():.3f}")
print(f"N_w={toe.n_w()}, N_c={toe.n_c()}, χ={toe.chi()}")

# ═══ CLASSICAL DYNAMICS FROM THE TOE ═══
cl = toe.classical()              # child — inherits everything
print(f"\nClassical VEV: {cl.vev():.2f} MeV (same as parent Toe)")
print(f"Classical m_p: {cl.proton_mass():.2f} MeV (inherited)")
print(f"Spatial dim:   {cl.spatial_dim()} = N_c")
print(f"Phase space:   {cl.phase_space_dim()} = χ")
print(f"Force:         1/r^{cl.force_exponent()} (N_c − 1 = 2)")

# ═══ SETUP: LEO satellite 400 km above Earth ═══
GM_EARTH = 3.986004418e5  # km³/s²
R_EARTH  = 6371.0
R_LEO    = R_EARTH + 400.0

state, v_circ, period = cl.satellite_circular(GM_EARTH, R_LEO)
px, py, pz, vx, vy, vz = state
print(f"\nCircular velocity: {v_circ:.4f} km/s")
print(f"Orbital period:    {period:.1f} s = {period/60:.1f} min")

# ═══ SIMULATE: 5 full orbits ═══
dt = 1.0
n_orbits = 5
n_steps = int(n_orbits * period / dt)
xs, ys, zs, _, _, _ = cl.kepler_orbit(GM_EARTH, px, py, pz, vx, vy, vz, dt, n_steps)
time = np.array(cl.time_array(dt, n_steps)) / period

# Conservation traces
energy = cl.kepler_energy_trace(GM_EARTH, px, py, pz, vx, vy, vz, dt, n_steps)
ang_mom = cl.kepler_angular_momentum_trace(px, py, pz, vx, vy, vz, dt, n_steps, GM_EARTH)
radii = cl.kepler_radius_trace(GM_EARTH, px, py, pz, vx, vy, vz, dt, n_steps)
speed = cl.kepler_speed_trace(GM_EARTH, px, py, pz, vx, vy, vz, dt, n_steps)

E0 = energy[0]
L0 = ang_mom[0]
energy_dev = np.abs((np.array(energy) - E0) / E0)
angmom_dev = np.abs((np.array(ang_mom) - L0) / L0)

print(f"\nMax energy deviation: {energy_dev.max():.2e}")
print(f"Max L deviation:      {angmom_dev.max():.2e}")

# ═══ PLOT ═══
fig = plt.figure(figsize=(16, 12))
fig.suptitle("Crystal Classical Dynamics — LEO Satellite\n"
             f"Toe(v={toe.vev():.0f} MeV) → classical() → orbit\n"
             f"All from (N_w, N_c) = ({cl.n_w()}, {cl.n_c()})",
             fontsize=14, fontweight='bold')
gs = GridSpec(3, 2, figure=fig, hspace=0.35, wspace=0.3)

# 1. Orbit
ax1 = fig.add_subplot(gs[0, 0])
ax1.plot(np.array(xs)/R_EARTH, np.array(ys)/R_EARTH, 'b-', linewidth=0.3, alpha=0.8)
theta = np.linspace(0, 2*np.pi, 100)
ax1.plot(np.cos(theta), np.sin(theta), 'g-', linewidth=2, label='Earth')
ax1.set_aspect('equal')
ax1.set_xlabel('x / R⊕'); ax1.set_ylabel('y / R⊕')
ax1.set_title(f'Orbit ({n_orbits} revolutions)')
ax1.legend(); ax1.grid(True, alpha=0.3)

# 2. Altitude
ax2 = fig.add_subplot(gs[0, 1])
ax2.plot(time, np.array(radii) - R_EARTH, 'r-', linewidth=0.5)
ax2.set_xlabel('Time (periods)'); ax2.set_ylabel('Altitude (km)')
ax2.set_title('Altitude vs Time'); ax2.grid(True, alpha=0.3)

# 3. Energy conservation
ax3 = fig.add_subplot(gs[1, 0])
ax3.semilogy(time, energy_dev + 1e-20, 'purple', linewidth=0.5)
ax3.set_xlabel('Time (periods)'); ax3.set_ylabel('|ΔE/E₀|')
ax3.set_title(f'Energy Conservation (max = {energy_dev.max():.2e})')
ax3.grid(True, alpha=0.3)

# 4. Angular momentum conservation
ax4 = fig.add_subplot(gs[1, 1])
ax4.semilogy(time, angmom_dev + 1e-20, 'orange', linewidth=0.5)
ax4.set_xlabel('Time (periods)'); ax4.set_ylabel('|ΔL/L₀|')
ax4.set_title(f'L Conservation (max = {angmom_dev.max():.2e})')
ax4.grid(True, alpha=0.3)

# 5. Speed
ax5 = fig.add_subplot(gs[2, 0])
ax5.plot(time, speed, 'teal', linewidth=0.5)
ax5.set_xlabel('Time (periods)'); ax5.set_ylabel('Speed (km/s)')
ax5.set_title('Orbital Speed'); ax5.grid(True, alpha=0.3)

# 6. Crystal identity box
ax6 = fig.add_subplot(gs[2, 1])
ax6.axis('off')
lines = [
    f"Toe(v={toe.vev():.0f} MeV)  ← crystal derived",
    f"  .classical()           ← child dynamics",
    f"",
    f"N_w = {cl.n_w()},  N_c = {cl.n_c()},  χ = {cl.chi()}",
    f"Spatial dim  = N_c = {cl.spatial_dim()}",
    f"Phase space  = χ = {cl.phase_space_dim()}",
    f"Force        ∝ 1/r^{cl.force_exponent()} (N_c−1)",
    f"Kepler       T² ∝ a^{cl.n_c()} (N_c)",
    f"Lagrange pts = χ−1 = {cl.chi()-1}",
    f"",
    f"Leapfrog = monad S = W∘U∘W",
    f"One seed. Everything derived.",
]
for i, line in enumerate(lines):
    weight = 'bold' if 'Toe(' in line or 'One seed' in line else 'normal'
    ax6.text(0.05, 0.95 - i*0.08, line, transform=ax6.transAxes,
             fontsize=11, fontfamily='monospace', fontweight=weight, va='top')

plt.savefig('crystal_classical_01_leo.png', dpi=150, bbox_inches='tight')
plt.show()
print("\nSaved: crystal_classical_01_leo.png")