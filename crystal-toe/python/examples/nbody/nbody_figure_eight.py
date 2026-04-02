#!/usr/bin/env python3
"""
Crystal N-Body — Three-Body Figure-Eight
==========================================
Chenciner-Montgomery periodic solution.
Three equal masses trace a figure-8.
Lagrange points = χ−1 = 5. Phase space = 3 × χ = 18.
"""

import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe()
nb = toe.nbody()

bodies = nb.three_body_figure_eight()
eps = 0.001
dt = 0.001
n_steps = 8000  # ~1.2 periods

snaps = nb.evolve_direct(dt, eps, n_steps, bodies)

fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle("Crystal N-Body — Three-Body Figure-Eight\n"
             f"Toe(v={toe.vev():.0f} MeV) → nbody() | 3 bodies, χ−1=5 Lagrange points",
             fontsize=13, fontweight='bold')

colors = ['#e41a1c', '#377eb8', '#4daf4a']
for i in range(3):
    x = [s[i][0] for s in snaps]
    y = [s[i][1] for s in snaps]
    axes[0].plot(x, y, color=colors[i], linewidth=0.8, label=f'Body {i+1}')
    axes[0].plot(x[0], y[0], 'o', color=colors[i], markersize=8)

axes[0].set_aspect('equal'); axes[0].legend()
axes[0].set_title('Figure-Eight Orbit'); axes[0].grid(True, alpha=0.3)
axes[0].set_xlabel('x'); axes[0].set_ylabel('y')

time = np.arange(len(snaps)) * dt
energies = [nb.total_energy(eps, s) for s in snaps]
e0 = energies[0]
axes[1].plot(time, np.array(energies), 'purple', linewidth=0.5)
axes[1].set_xlabel('Time'); axes[1].set_ylabel('Total Energy')
axes[1].set_title(f'Energy (dev={np.abs((energies[-1]-e0)/e0):.2e})')
axes[1].grid(True, alpha=0.3)

for i in range(3):
    r = [np.sqrt(s[i][0]**2 + s[i][1]**2) for s in snaps]
    axes[2].plot(time, r, color=colors[i], linewidth=0.5, label=f'Body {i+1}')
axes[2].set_xlabel('Time'); axes[2].set_ylabel('|r|')
axes[2].set_title('Distance from Origin'); axes[2].legend()
axes[2].grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('nbody_figure_eight.png', dpi=150, bbox_inches='tight')
plt.show()
