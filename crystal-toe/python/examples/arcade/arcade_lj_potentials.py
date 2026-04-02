#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Arcade — LJ Potential: Exact vs Arcade vs WCA"""
import crystal_toe as ct
import matplotlib.pyplot as plt
import numpy as np

toe = ct.Toe(); arc = toe.arcade()

fig, ax = plt.subplots(figsize=(12, 7))
fig.suptitle("Lennard-Jones Approximations — Cutoffs from (2,3)",
             fontsize=14, fontweight='bold')

r = np.linspace(0.95, 4.0, 500)

# Compute potentials
v_exact = [arc.lj_exact(ri) for ri in r]
v_arcade = [arc.lj_arcade(ri) for ri in r]
v_wca = [arc.lj_wca(ri) for ri in r]

ax.plot(r, v_exact, 'b-', linewidth=2.5, label='LJ exact: 4ε[(σ/r)¹²−(σ/r)⁶]')
ax.plot(r, v_arcade, 'r--', linewidth=2.5, label=f'Arcade: cut at N_c={arc.lj_cutoff()}σ, shifted')
ax.plot(r, v_wca, 'g:', linewidth=2.5, label=f'WCA: cut at N_w^(1/χ)={arc.wca_cutoff():.3f}σ')

# Mark cutoffs
ax.axvline(x=arc.lj_cutoff(), color='red', linewidth=1, linestyle=':', alpha=0.5)
ax.axvline(x=arc.wca_cutoff(), color='green', linewidth=1, linestyle=':', alpha=0.5)

# Mark minimum
ax.plot(arc.wca_cutoff(), arc.lj_exact(arc.wca_cutoff()), 'ko', markersize=8, zorder=5)
ax.annotate(f'r_min = N_w^(1/χ) = {arc.wca_cutoff():.3f}',
            xy=(arc.wca_cutoff(), arc.lj_exact(arc.wca_cutoff())),
            xytext=(1.5, -1.5), fontsize=10, fontweight='bold',
            arrowprops=dict(arrowstyle='->', color='black'))

ax.axhline(y=0, color='gray', linewidth=0.5)
ax.set_xlabel('r / σ', fontsize=12)
ax.set_ylabel('V(r) / ε', fontsize=12)
ax.set_ylim(-1.5, 2.0)
ax.legend(fontsize=10)
ax.grid(True, alpha=0.3)

# Cutoff error annotation
ax.text(0.98, 0.95, f'Cutoff error: {arc.lj_cutoff_error():.4f}\n(< 1% beyond N_c·σ)',
        transform=ax.transAxes, fontsize=10, ha='right', va='top',
        bbox=dict(boxstyle='round', facecolor='lightyellow'))

plt.tight_layout()
plt.savefig('arcade_lj_potentials.png', dpi=150, bbox_inches='tight'); plt.show()