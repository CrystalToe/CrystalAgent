#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Thermo — LJ 6-12 Potential: χ and 2χ"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); th = toe.thermo()
r = np.linspace(0.9, 3.0, 500)
v = [th.lj_potential(1.0, 1.0, ri) for ri in r]
f = [th.lj_force_mag(1.0, 1.0, ri) for ri in r]

fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle(f"Crystal Thermo — Lennard-Jones 6-12\nV = 4ε[(σ/r)^{th.lj_repel()} − (σ/r)^{th.lj_attract()}] "
             f"where {th.lj_attract()}=χ, {th.lj_repel()}=2χ, F prefactor {th.lj_force_prefactor()}=d_mixed",
             fontsize=13, fontweight='bold')
axes[0].plot(r, v, 'b-', linewidth=2); axes[0].axhline(0, color='k', linewidth=0.5)
axes[0].axhline(-1, color='r', linestyle='--', alpha=0.5, label='−ε')
axes[0].set_ylim(-1.5, 3); axes[0].set_xlabel('r/σ'); axes[0].set_ylabel('V/ε')
axes[0].set_title('LJ Potential'); axes[0].legend(); axes[0].grid(True, alpha=0.3)

axes[1].plot(r, f, 'r-', linewidth=2); axes[1].axhline(0, color='k', linewidth=0.5)
axes[1].set_xlabel('r/σ'); axes[1].set_ylabel('F'); axes[1].set_title(f'LJ Force (prefactor {th.lj_force_prefactor()} = d_mixed)')
axes[1].set_ylim(-3, 5); axes[1].grid(True, alpha=0.3)

axes[2].axis('off')
for i, l in enumerate([f"Attractive: (σ/r)^{th.lj_attract()} = (σ/r)^χ", f"Repulsive: (σ/r)^{th.lj_repel()} = (σ/r)^(2χ)",
    f"Force: {th.lj_force_prefactor()}ε/r = d_mixed·ε/r", f"r_min = 2^(1/χ) σ = {2**(1/6):.4f} σ",
    f"V(σ) = 0, V(r_min) = −ε", "", f"γ_mono = {th.gamma_monatomic():.4f} = (χ−1)/N_c = 5/3",
    f"γ_di = {th.gamma_diatomic():.4f} = β₀/(χ−1) = 7/5", f"Carnot = {th.carnot_efficiency():.4f} = (χ−1)/χ = 5/6"]):
    axes[2].text(0.05, 0.95-i*0.1, l, transform=axes[2].transAxes, fontsize=11, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('thermo_lj.png', dpi=150, bbox_inches='tight'); plt.show()