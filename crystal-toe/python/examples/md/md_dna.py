#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal MD — DNA & Protein: bases=N_w²=4, amino acids=N_w²(χ−1)=20"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); md = toe.md()
fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle("Crystal MD — Molecular Biology from (2,3)\nDNA bases = N_w² = 4, amino acids = N_w²(χ−1) = 20", fontsize=13, fontweight='bold')

# DNA bases bar
bases = ['A-T', 'T-A', 'G-C', 'C-G']
hbonds = [md.hbond_at(), md.hbond_at(), md.hbond_gc(), md.hbond_gc()]
colors = ['blue','blue','red','red']
axes[0].bar(bases, hbonds, color=colors, alpha=0.7, edgecolor='black')
axes[0].set_ylabel('H-bonds'); axes[0].set_title(f'H-bonds: A-T={md.hbond_at()}=N_w, G-C={md.hbond_gc()}=N_c')
axes[0].grid(True, alpha=0.3, axis='y')

# Helix diagram
import numpy as np
t = np.linspace(0, 4*np.pi, 500)
r = md.helix_per_turn()
axes[1].plot(np.cos(t), t/(2*np.pi)*r, 'b-', linewidth=2)
axes[1].plot(np.cos(t+np.pi), t/(2*np.pi)*r, 'r-', linewidth=2)
for i in range(int(t[-1]/(2*np.pi)*r)):
    axes[1].axhline(i, color='gray', linewidth=0.3, alpha=0.3)
axes[1].set_xlabel('x'); axes[1].set_ylabel('Residue #')
axes[1].set_title(f'α-helix: {md.helix_per_turn():.1f} residues/turn'); axes[1].grid(True, alpha=0.3)

axes[2].axis('off')
for i, l in enumerate([f"DNA bases = N_w² = {md.dna_bases()}",
    f"Codons = (N_w²)^N_c = {md.codons()}", f"Amino acids = N_w²(χ−1) = {md.amino_acids()}",
    f"H-bonds A-T = N_w = {md.hbond_at()}", f"H-bonds G-C = N_c = {md.hbond_gc()}",
    f"bp/turn = N_w(χ−1) = {md.bp_per_turn()}", "",
    f"α-helix = N_c²N_w/(χ−1) = {md.helix_per_turn():.1f}",
    f"Flory ν = N_w/(χ−1) = {md.flory_nu():.1f}", "",
    f"20 amino acids = 4 bases × 5 DOF"]):
    axes[2].text(0.05, 0.95-i*0.085, l, transform=axes[2].transAxes, fontsize=11, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('md_dna.png', dpi=150, bbox_inches='tight'); plt.show()