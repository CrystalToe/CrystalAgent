#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Bio — Protein & DNA Structure from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt
import numpy as np

toe = ct.Toe(); bio = toe.bio()

fig, axes = plt.subplots(1, 2, figsize=(14, 7))
fig.suptitle("Molecular Structure — Every Parameter from (2,3)",
             fontsize=14, fontweight='bold')

# ── Left: DNA double helix parameters ──
ax = axes[0]
ax.axis('off')
ax.set_xlim(0, 1); ax.set_ylim(0, 1)
ax.set_title('DNA Double Helix', fontsize=12, fontweight='bold')

# Draw schematic helix
t = np.linspace(0, 4*np.pi, 200)
x1 = 0.3 + 0.15 * np.sin(t)
x2 = 0.3 - 0.15 * np.sin(t)
y = np.linspace(0.1, 0.85, 200)
ax.plot(x1, y, 'b-', linewidth=3, alpha=0.7)
ax.plot(x2, y, 'r-', linewidth=3, alpha=0.7)
# H-bond rungs
for i in range(10):
    yi = 0.15 + i * 0.07
    xi1 = 0.3 + 0.15 * np.sin(yi * 4 * np.pi / 0.75)
    xi2 = 0.3 - 0.15 * np.sin(yi * 4 * np.pi / 0.75)
    ax.plot([xi1, xi2], [yi, yi], 'g-', linewidth=1.5, alpha=0.5)

# Parameters
params = [
    (f"Strands: {bio.helix_strands()} = N_w", 0.92),
    (f"BP/turn: {bio.bp_per_turn()} = N_w(χ−1)", 0.85),
    (f"H-bond A-T: {bio.hbond_at()} = N_w", 0.78),
    (f"H-bond G-C: {bio.hbond_gc()} = N_c", 0.71),
    (f"Chargaff pairs: {bio.chargaff_pairs()} = N_w", 0.64),
    (f"Bases: {bio.dna_bases()} = N_w²", 0.57),
    (f"Lipid layers: {bio.lipid_layers()} = N_w", 0.50),
]
for text, y_pos in params:
    ax.text(0.55, y_pos, text, fontsize=10, fontfamily='monospace',
            fontweight='bold', transform=ax.transAxes)

# ── Right: Protein structure numbers ──
ax = axes[1]
names = ['Helix/turn\n18/5', 'Flory ν\n2/5', 'Peptide°\n2π/N_c',
         'Ramaφ,ψ\nN_w', 'Redundancy\n≈N_c']
values = [bio.helix_per_turn(), bio.flory_nu(),
          np.degrees(2*np.pi/bio.n_c()), bio.ramachandran_angles(),
          bio.codon_redundancy()]
traces = ['N_c²·N_w/(χ−1)', 'N_w/(χ−1)', '120° = 2π/N_c',
          'N_w = 2', '61/20 ≈ 3']
colors = ['#e74c3c', '#3498db', '#2ecc71', '#f39c12', '#9b59b6']

bars = ax.bar(range(len(names)), values, color=colors, edgecolor='black', linewidth=1.2)
for bar, v, trace in zip(bars, values, traces):
    ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 2,
            f'{v:.2f}\n= {trace}', ha='center', fontsize=8, fontweight='bold')
ax.set_xticks(range(len(names)))
ax.set_xticklabels(names, fontsize=9)
ax.set_ylabel('Value', fontsize=11)
ax.set_title('Protein Structure Parameters')
ax.set_ylim(0, max(values) * 1.4)

plt.tight_layout()
plt.savefig('bio_protein.png', dpi=150, bbox_inches='tight'); plt.show()