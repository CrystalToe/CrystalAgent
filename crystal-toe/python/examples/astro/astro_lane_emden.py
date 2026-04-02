#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Astro — Lane-Emden Stellar Profiles"""
import crystal_toe as ct
import matplotlib.pyplot as plt
import numpy as np

toe = ct.Toe(); ast = toe.astro()

fig, axes = plt.subplots(1, 2, figsize=(14, 6))
fig.suptitle("Lane-Emden Stellar Structure — Polytropic Indices from (2,3)",
             fontsize=14, fontweight='bold')

# ── Left: θ(ξ) profiles for several n ──
ax = axes[0]
indices = [
    (1.0,   'n=1 (isothermal)',  '#3498db'),
    (1.5,   'n=3/2=N_c/N_w (WD)', '#e74c3c'),
    (3.0,   'n=3=N_c (Chandra)',  '#2ecc71'),
]
for n, label, color in indices:
    profile = ast.lane_emden_profile(n)
    xi = [p[0] for p in profile]
    theta = [p[1] for p in profile]
    ax.plot(xi, theta, color=color, linewidth=2.5, label=label)

ax.set_xlabel('ξ (dimensionless radius)', fontsize=11)
ax.set_ylabel('θ (dimensionless density^(1/n))', fontsize=11)
ax.set_title('Lane-Emden Profiles θ(ξ)')
ax.legend(fontsize=10)
ax.set_xlim(0, 10)
ax.set_ylim(-0.05, 1.05)
ax.grid(True, alpha=0.3)

# ── Right: Surface ξ₁ and mass factor vs n ──
ax = axes[1]
n_range = np.linspace(0.5, 4.5, 40)
xi1_vals = []
mass_vals = []
for n in n_range:
    xi1, mass = ast.lane_emden(n)
    xi1_vals.append(xi1)
    mass_vals.append(mass)

ax.plot(n_range, xi1_vals, 'b-', linewidth=2.5, label='ξ₁ (surface)')
ax.plot(n_range, mass_vals, 'r--', linewidth=2.5, label='−ξ₁²θ\'(ξ₁) (mass)')

# Mark Crystal indices
for n, label, color in [(1.5, 'N_c/N_w', '#e74c3c'), (3.0, 'N_c', '#2ecc71')]:
    xi1, mass = ast.lane_emden(n)
    ax.plot(n, xi1, 'o', color=color, markersize=10, zorder=5)
    ax.annotate(f'{label}\nξ₁={xi1:.2f}', xy=(n, xi1),
                xytext=(n+0.3, xi1+0.8), fontsize=9, fontweight='bold',
                arrowprops=dict(arrowstyle='->', color=color))

ax.set_xlabel('Polytropic index n', fontsize=11)
ax.set_ylabel('Value', fontsize=11)
ax.set_title('Lane-Emden Surface & Mass vs n')
ax.legend(fontsize=10)
ax.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('astro_lane_emden.png', dpi=150, bbox_inches='tight'); plt.show()