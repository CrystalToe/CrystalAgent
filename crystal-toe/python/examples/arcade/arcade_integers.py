#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Arcade — Every Integer Dashboard"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); arc = toe.arcade()
fig, ax = plt.subplots(figsize=(10, 9))
fig.suptitle(f"Crystal Arcade — Every Approximation from (N_w, N_c) = ({arc.n_w()}, {arc.n_c()})",
             fontsize=14, fontweight='bold')
ax.axis('off')
rows = [
    ("LJ cutoff",       f"{arc.lj_cutoff()}σ",      "N_c"),
    ("Barnes-Hut θ",    f"1/{arc.bh_theta_den()}",   "1/N_w"),
    ("Octree children", str(arc.octree_children()),   "d_colour = N_w³"),
    ("WCA cutoff",      f"{arc.wca_cutoff():.4f}σ",  "N_w^(1/χ) = 2^(1/6)"),
    ("Euler order",     str(arc.euler_order()),       "d₁"),
    ("Verlet order",    str(arc.verlet_order()),      "N_w"),
    ("Fixed-point",     f"{arc.fixed_bits()}.{arc.fixed_bits()}", "N_w⁴.N_w⁴"),
    ("Spatial hash",    f"{arc.hash_cells()}/dim",    "N_c"),
    ("LOD levels",      str(arc.lod_levels()),        "N_c (exact/fast/arcade)"),
    ("Mean-field T_c",  str(arc.mf_tc()),             "N_w² (vs exact 2.269)"),
    ("Newton iter",     str(arc.newton_iter()),        "N_w"),
    ("Fast α⁻¹",       str(arc.fast_alpha_inv()),    "⌊(D+1)π + ln β₀⌋"),
]
for i, (name, val, origin) in enumerate(rows):
    y = 0.95 - i * 0.073
    ax.text(0.02, y, name, fontsize=10.5, fontfamily='monospace', va='top', transform=ax.transAxes)
    ax.text(0.28, y, val, fontsize=10.5, fontfamily='monospace', va='top',
            fontweight='bold', color='crimson', transform=ax.transAxes)
    ax.text(0.48, y, f'= {origin}', fontsize=9.5, fontfamily='monospace',
            va='top', transform=ax.transAxes)
plt.savefig('arcade_integers.png', dpi=150, bbox_inches='tight'); plt.show()