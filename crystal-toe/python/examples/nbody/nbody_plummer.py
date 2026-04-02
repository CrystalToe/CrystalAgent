#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""
Crystal N-Body — Plummer Sphere
================================
Self-gravitating cluster of N bodies in virial equilibrium.
Watch it evolve under its own gravity.
"""

import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe()
nb = toe.nbody()

N = 30
bodies = nb.plummer_sphere(N, 100.0, 5.0)
eps = 0.1
dt = 0.02
n_steps = 200

print(f"Plummer sphere: N={N}, M_total=100, r_scale=5")
e0 = nb.total_energy(eps, bodies)
print(f"Initial E = {e0:.4f}")

snaps = nb.evolve_direct(dt, eps, n_steps, bodies)

fig, axes = plt.subplots(2, 3, figsize=(18, 12))
fig.suptitle(f"Crystal N-Body — Plummer Sphere (N={N})\n"
             f"Toe(v={toe.vev():.0f} MeV) → nbody() | self-gravitating cluster",
             fontsize=14, fontweight='bold')

# Snapshots at different times
for idx, (step_i, title) in enumerate([(0, 't = 0'), (n_steps//3, 't = T/3'),
                                        (2*n_steps//3, 't = 2T/3'), (n_steps, 't = T')]):
    ax = axes[idx // 2][idx % 2]
    s = snaps[step_i]
    xs = [b[0] for b in s]; ys = [b[1] for b in s]
    ms = [b[6] for b in s]
    ax.scatter(xs, ys, s=[m*20 for m in ms], c='royalblue', alpha=0.7, edgecolors='navy')
    ax.set_xlim(-15, 15); ax.set_ylim(-15, 15)
    ax.set_aspect('equal')
    ax.set_title(title); ax.grid(True, alpha=0.3)
    ax.set_xlabel('x'); ax.set_ylabel('y')

# Energy conservation
ax_e = axes[1][0]
energies = [nb.total_energy(eps, s) for s in snaps[::5]]
time = np.arange(len(energies)) * dt * 5
ax_e.plot(time, energies, 'purple', linewidth=1)
ax_e.set_xlabel('Time'); ax_e.set_ylabel('Total Energy')
ax_e.set_title('Energy Conservation'); ax_e.grid(True, alpha=0.3)

# All trajectories
ax_t = axes[1][1]
for i in range(min(N, 15)):
    x = [s[i][0] for s in snaps[::3]]
    y = [s[i][1] for s in snaps[::3]]
    ax_t.plot(x, y, linewidth=0.3, alpha=0.6)
ax_t.set_xlim(-15, 15); ax_t.set_ylim(-15, 15)
ax_t.set_aspect('equal')
ax_t.set_title('Trajectories (first 15 bodies)'); ax_t.grid(True, alpha=0.3)

# Hidden extra subplot for text
ax_txt = axes[1][2] if len(axes[1]) > 2 else None
if ax_txt is None:
    ax_txt = axes[0][2]
ax_txt.axis('off')

plt.tight_layout()
plt.savefig('nbody_plummer.png', dpi=150, bbox_inches='tight')
plt.show()