#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""
Crystal Classical Dynamics — Example 3: Hohmann Transfer Earth→Mars
====================================================================
Minimum-energy transfer between circular orbits.
Vis-viva equation: v = √(GM(2/r - 1/a)) — every coefficient from (2,3).
"""

import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe()
cl = toe.classical()

# Solar system constants (km, s)
MU_SUN   = 1.327124e11   # km³/s²
R_EARTH  = 1.496e8       # km (1 AU)
R_MARS   = 2.279e8       # km (1.524 AU)
R_JUPITER = 7.785e8      # km (5.2 AU)

# === HOHMANN: Earth → Mars ===
dv1, dv2, t_transfer = cl.hohmann_transfer(MU_SUN, R_EARTH, R_MARS)
print("=== Hohmann Transfer: Earth → Mars ===")
print(f"  ΔV₁ (departure): {dv1:.3f} km/s")
print(f"  ΔV₂ (arrival):   {dv2:.3f} km/s")
print(f"  ΔV total:         {abs(dv1)+abs(dv2):.3f} km/s")
print(f"  Transfer time:    {t_transfer/86400:.1f} days")

# === SIMULATE THE TRANSFER ===
# Start in Earth orbit, apply ΔV₁
v_earth = cl.vis_viva(MU_SUN, R_EARTH, R_EARTH)  # circular
v_depart = cl.vis_viva(MU_SUN, R_EARTH, (R_EARTH + R_MARS) / 2)  # transfer ellipse

# Simulate transfer orbit
px, py, pz = R_EARTH, 0.0, 0.0
vx, vy, vz = 0.0, v_depart, 0.0
dt = 3600.0  # 1 hour steps
n_steps = int(t_transfer / dt) + 500

xs, ys, zs, _, _, _ = cl.kepler_orbit(MU_SUN, px, py, pz, vx, vy, vz, dt, n_steps)

# Simulate Earth and Mars orbits for reference
t_earth_period = cl.kepler_period(R_EARTH, MU_SUN)
t_mars_period = cl.kepler_period(R_MARS, MU_SUN)

earth_state = cl.satellite_circular(MU_SUN, R_EARTH)
ex, ey, ez, _, _, _ = cl.kepler_orbit(MU_SUN, *earth_state[0], dt, n_steps)

mars_state = cl.satellite_circular(MU_SUN, R_MARS)
mx, my, mz, _, _, _ = cl.kepler_orbit(MU_SUN, *mars_state[0], dt, n_steps)

# === COMPARE: Hohmann vs Bi-elliptic for Earth → Jupiter ===
dv_h1, dv_h2, t_h = cl.hohmann_transfer(MU_SUN, R_EARTH, R_JUPITER)
dv_b1, dv_b2, dv_b3, t_b = cl.bielliptic_transfer(MU_SUN, R_EARTH, R_JUPITER, 2*R_JUPITER)

print(f"\n=== Comparison: Earth → Jupiter ===")
print(f"  Hohmann:     ΔV = {abs(dv_h1)+abs(dv_h2):.3f} km/s, time = {t_h/86400:.0f} days")
print(f"  Bi-elliptic: ΔV = {abs(dv_b1)+abs(dv_b2)+abs(dv_b3):.3f} km/s, time = {t_b/86400:.0f} days")

# === PLOT ===
fig, axes = plt.subplots(1, 2, figsize=(18, 8))
fig.suptitle("Crystal Classical Dynamics — Hohmann Transfer Earth → Mars\n"
             "vis-viva: v = √(GM(2/r − 1/a)) — every coefficient from (2,3)",
             fontsize=14, fontweight='bold')

# Left: Transfer orbit
ax = axes[0]
au = 1.496e8
ax.plot(np.array(ex)/au, np.array(ey)/au, 'b-', linewidth=0.5, alpha=0.5, label='Earth orbit')
ax.plot(np.array(mx)/au, np.array(my)/au, 'r-', linewidth=0.5, alpha=0.5, label='Mars orbit')

# Transfer arc (only up to arrival)
n_transfer = int(t_transfer / dt)
ax.plot(np.array(xs[:n_transfer])/au, np.array(ys[:n_transfer])/au,
        'gold', linewidth=3, label=f'Transfer ({t_transfer/86400:.0f} days)')

ax.plot(0, 0, 'yo', markersize=15, zorder=5)  # Sun
ax.plot(xs[0]/au, ys[0]/au, 'bo', markersize=8, zorder=5, label='Departure')
ax.plot(xs[n_transfer]/au, ys[n_transfer]/au, 'ro', markersize=8, zorder=5, label='Arrival')

ax.set_aspect('equal')
ax.set_xlabel('x (AU)', fontsize=12)
ax.set_ylabel('y (AU)', fontsize=12)
ax.set_title('Hohmann Transfer Orbit')
ax.legend(loc='lower left', fontsize=10)
ax.grid(True, alpha=0.3)

# Right: ΔV comparison bar chart
ax2 = axes[1]
scenarios = ['Earth→Mars\n(Hohmann)', 'Earth→Jupiter\n(Hohmann)', 'Earth→Jupiter\n(Bi-elliptic)']
dvs = [abs(dv1)+abs(dv2), abs(dv_h1)+abs(dv_h2), abs(dv_b1)+abs(dv_b2)+abs(dv_b3)]
times = [t_transfer/86400, t_h/86400, t_b/86400]
bars = ax2.bar(scenarios, dvs, color=['gold', 'coral', 'skyblue'], edgecolor='black')
ax2.set_ylabel('Total ΔV (km/s)', fontsize=12)
ax2.set_title('Transfer ΔV Comparison')
for bar, t in zip(bars, times):
    ax2.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.2,
             f'{t:.0f} days', ha='center', fontsize=10)

# Escape velocity reference
v_esc = cl.escape_velocity(MU_SUN, R_EARTH)
ax2.axhline(y=v_esc, color='red', linestyle='--', alpha=0.5, label=f'v_esc = {v_esc:.1f} km/s')
ax2.legend()
ax2.grid(True, alpha=0.3, axis='y')

plt.tight_layout()
plt.savefig('crystal_classical_03_hohmann.png', dpi=150, bbox_inches='tight')
plt.show()
print("\nSaved: crystal_classical_03_hohmann.png")