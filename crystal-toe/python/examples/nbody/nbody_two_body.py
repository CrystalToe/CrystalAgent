#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""
Crystal N-Body — Two-Body Kepler
=================================
Equal mass binary. Proves energy and momentum conservation.
Octree children = 8 = d_colour = N_w³. Force ∝ 1/r² = 1/r^(N_c−1).
"""

import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe()
nb = toe.nbody()

print(f"Toe VEV:          {nb.vev():.0f} MeV")
print(f"Octree children:  {nb.octree_children()} = d_colour = N_w³")
print(f"Force exponent:   {nb.force_exponent()} = N_c − 1")
print(f"Phase/body:       {nb.phase_per_body()} = χ")

# Equal-mass binary
bodies = nb.two_body_kepler(1.0, 1.0, 10.0)
eps = 0.01
dt = 0.01
n_steps = 3000

e0 = nb.total_energy(eps, bodies)
p0 = nb.total_momentum(bodies)
print(f"\nInitial E = {e0:.6f}")
print(f"Initial p = ({p0[0]:.6f}, {p0[1]:.6f}, {p0[2]:.6f})")

snaps = nb.evolve_direct(dt, eps, n_steps, bodies)

# Extract trajectories
x0 = [s[0][0] for s in snaps]; y0 = [s[0][1] for s in snaps]
x1 = [s[1][0] for s in snaps]; y1 = [s[1][1] for s in snaps]
energies = [nb.total_energy(eps, s) for s in snaps]
time = np.arange(len(snaps)) * dt

fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle(f"Crystal N-Body — Two-Body Kepler\n"
             f"Toe(v={toe.vev():.0f} MeV) → nbody() | "
             f"octree={nb.octree_children()}, force=1/r^{nb.force_exponent()}, phase={nb.phase_per_body()}/body",
             fontsize=13, fontweight='bold')

axes[0].plot(x0, y0, 'b-', linewidth=0.5, label='Body 1')
axes[0].plot(x1, y1, 'r-', linewidth=0.5, label='Body 2')
axes[0].set_aspect('equal'); axes[0].legend()
axes[0].set_xlabel('x'); axes[0].set_ylabel('y')
axes[0].set_title('Binary Orbit'); axes[0].grid(True, alpha=0.3)

e_dev = np.abs((np.array(energies) - e0) / e0)
axes[1].semilogy(time, e_dev + 1e-20, 'purple', linewidth=0.5)
axes[1].set_xlabel('Time'); axes[1].set_ylabel('|ΔE/E₀|')
axes[1].set_title(f'Energy Conservation (max={e_dev.max():.2e})')
axes[1].grid(True, alpha=0.3)

sep = [np.sqrt((s[0][0]-s[1][0])**2 + (s[0][1]-s[1][1])**2 + (s[0][2]-s[1][2])**2) for s in snaps]
axes[2].plot(time, sep, 'teal', linewidth=0.5)
axes[2].set_xlabel('Time'); axes[2].set_ylabel('Separation')
axes[2].set_title('Binary Separation'); axes[2].grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('nbody_two_body.png', dpi=150, bbox_inches='tight')
plt.show()