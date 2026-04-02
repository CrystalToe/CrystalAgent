#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Astro — Black Holes: Schwarzschild & Hawking from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt
import numpy as np

toe = ct.Toe(); ast = toe.astro()

fig, axes = plt.subplots(1, 2, figsize=(14, 6))
fig.suptitle(f"Black Holes — r_s = {ast.schwarz()}GM/c², T_H ∝ 1/({ast.hawking_factor()}πM)",
             fontsize=14, fontweight='bold')

m_range = np.logspace(-1, 2, 200)  # 0.1 to 100 solar masses

# ── Left: Schwarzschild radius ──
ax = axes[0]
rs = [ast.schwarzschild_radius(m) for m in m_range]
ax.loglog(m_range, rs, 'b-', linewidth=2.5)
ax.set_xlabel('M / M☉', fontsize=11)
ax.set_ylabel('r_s (relative units)', fontsize=11)
ax.set_title(f'Schwarzschild: r_s = N_w·GM/c² (N_w={ast.schwarz()})')
ax.grid(True, alpha=0.3, which='both')
ax.text(0.05, 0.9, f'r_s ∝ M\nfactor = N_w = {ast.schwarz()}',
        transform=ax.transAxes, fontsize=11, fontweight='bold',
        bbox=dict(boxstyle='round', facecolor='lightyellow'))

# ── Right: Hawking temperature ──
ax = axes[1]
th = [ast.hawking_temperature(m) for m in m_range]
ax.loglog(m_range, th, 'r-', linewidth=2.5)
ax.set_xlabel('M / M☉', fontsize=11)
ax.set_ylabel('T_H (relative units)', fontsize=11)
ax.set_title(f'Hawking: T ∝ 1/(d_colour·π·M) (d_colour={ast.hawking_factor()}=N_w³)')
ax.grid(True, alpha=0.3, which='both')
ax.text(0.05, 0.9, f'T_H ∝ 1/M\nfactor = {ast.hawking_factor()} = N_w³\n'
        f'Hawking×Eddington = {ast.hawking_eddington_product()} = N_w⁵',
        transform=ax.transAxes, fontsize=10, fontweight='bold',
        bbox=dict(boxstyle='round', facecolor='lightyellow'))

plt.tight_layout()
plt.savefig('astro_black_holes.png', dpi=150, bbox_inches='tight'); plt.show()