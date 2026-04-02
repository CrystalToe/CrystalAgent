#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Thermo — 2D Lattice MD: Watch Crystal Melt"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); th = toe.thermo()
lattice = th.make_lattice_2d(4, 4, 1.3, 0.1)
eps, sigma, cutoff = 1.0, 1.0, 3.5
print(f"Lattice: {len(lattice)} particles, T_init={th.temperature(lattice):.4f}")

snaps = th.simulate(0.001, eps, sigma, cutoff, 2000, 200, lattice)

fig, axes = plt.subplots(2, 3, figsize=(18, 10))
fig.suptitle(f"Crystal Thermo — 2D Lattice MD\nLJ {th.lj_attract()}-{th.lj_repel()}, Verlet W∘U∘W", fontsize=13, fontweight='bold')
for idx in range(min(6, len(snaps))):
    ax = axes[idx//3][idx%3]
    s = snaps[idx]
    xs = [p[0] for p in s]; ys = [p[1] for p in s]
    ax.scatter(xs, ys, s=50, c='royalblue', edgecolors='navy')
    ax.set_xlim(-2, 7); ax.set_ylim(-2, 7); ax.set_aspect('equal')
    ax.set_title(f'Snapshot {idx}'); ax.grid(True, alpha=0.3)
plt.tight_layout(); plt.savefig('thermo_lattice.png', dpi=150, bbox_inches='tight'); plt.show()