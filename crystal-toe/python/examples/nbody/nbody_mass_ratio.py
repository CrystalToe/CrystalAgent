#!/usr/bin/env python3
"""
Crystal N-Body — Mass Ratio Scan
==================================
How does the binary orbit change with mass ratio?
Scan from equal mass to extreme ratio.
Centre of mass stays fixed — momentum conservation proof.
"""

import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe()
nb = toe.nbody()

ratios = [1.0, 2.0, 5.0, 10.0, 50.0, 100.0]
eps = 0.01
dt = 0.01

fig, axes = plt.subplots(2, 3, figsize=(18, 12))
fig.suptitle("Crystal N-Body — Mass Ratio Scan\n"
             f"Toe(v={toe.vev():.0f} MeV) → nbody() | binary orbit vs mass ratio q = m₁/m₂",
             fontsize=14, fontweight='bold')

for idx, q in enumerate(ratios):
    ax = axes[idx // 3][idx % 3]
    m1 = q; m2 = 1.0
    bodies = nb.two_body_kepler(m1, m2, 10.0)

    # Evolve for ~2 orbits
    period_est = 2 * np.pi * np.sqrt(10.0**3 / (m1 + m2))
    n_steps = int(2.5 * period_est / dt)
    snaps = nb.evolve_direct(dt, eps, n_steps, bodies)

    x0 = [s[0][0] for s in snaps]; y0 = [s[0][1] for s in snaps]
    x1 = [s[1][0] for s in snaps]; y1 = [s[1][1] for s in snaps]

    # Centre of mass
    com_x = [(s[0][0]*m1 + s[1][0]*m2)/(m1+m2) for s in snaps]
    com_y = [(s[0][1]*m1 + s[1][1]*m2)/(m1+m2) for s in snaps]

    ax.plot(x0, y0, 'b-', linewidth=0.5, label=f'm₁={m1:.0f}')
    ax.plot(x1, y1, 'r-', linewidth=0.5, label=f'm₂={m2:.0f}')
    ax.plot(com_x[0], com_y[0], 'k+', markersize=15, markeredgewidth=2, label='CoM')

    # Verify CoM didn't move
    com_drift = np.sqrt((com_x[-1]-com_x[0])**2 + (com_y[-1]-com_y[0])**2)

    ax.set_aspect('equal')
    ax.set_title(f'q = {q:.0f}:1  (CoM drift = {com_drift:.2e})')
    ax.legend(fontsize=8, loc='upper right')
    ax.grid(True, alpha=0.3)
    ax.set_xlabel('x'); ax.set_ylabel('y')

plt.tight_layout()
plt.savefig('nbody_mass_ratio.png', dpi=150, bbox_inches='tight')
plt.show()
