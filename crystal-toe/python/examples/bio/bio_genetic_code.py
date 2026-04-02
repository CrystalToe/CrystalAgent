#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Bio — Genetic Code from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt
import numpy as np

toe = ct.Toe(); bio = toe.bio()

fig, axes = plt.subplots(1, 2, figsize=(14, 7))
fig.suptitle("Genetic Code — Every Number from (2,3)", fontsize=14, fontweight='bold')

# ── Left: Code structure breakdown ──
ax = axes[0]
labels = ['DNA bases\nN_w²', 'Codon len\nN_c', 'Total codons\n(N_w²)^N_c',
          'Amino acids\nN_w²(χ−1)', 'Stop codons\nN_c', 'Sense codons\n64−3']
values = [bio.dna_bases(), bio.codon_len(), bio.codons(),
          bio.amino_acids(), bio.stop_codons(), bio.sense_codons()]
colors = ['#e74c3c', '#3498db', '#9b59b6', '#2ecc71', '#e67e22', '#1abc9c']

bars = ax.bar(range(len(labels)), values, color=colors, edgecolor='black', linewidth=1.2)
for bar, v in zip(bars, values):
    ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 1,
            str(v), ha='center', fontsize=12, fontweight='bold')
ax.set_xticks(range(len(labels)))
ax.set_xticklabels(labels, fontsize=8)
ax.set_ylabel('Count', fontsize=11)
ax.set_title('Genetic Code Numbers')
ax.set_ylim(0, 72)

# ── Right: Redundancy ──
ax = axes[1]
# Pie chart: 61 sense codons for 20 amino acids + 3 stops
sizes = [bio.amino_acids(), bio.sense_codons() - bio.amino_acids(), bio.stop_codons()]
labels_pie = [f'{bio.amino_acids()} amino acids\n= N_w²(χ−1)',
              f'{bio.sense_codons()-bio.amino_acids()} redundant\ncodons',
              f'{bio.stop_codons()} stop\n= N_c']
colors_pie = ['#2ecc71', '#3498db', '#e74c3c']
wedges, texts, autotexts = ax.pie(sizes, labels=labels_pie, colors=colors_pie,
                                   autopct='%1.0f%%', startangle=90,
                                   textprops={'fontsize': 10})
ax.set_title(f'Codon Usage: redundancy = {bio.codon_redundancy():.2f} ≈ N_c')

plt.tight_layout()
plt.savefig('bio_genetic_code.png', dpi=150, bbox_inches='tight'); plt.show()