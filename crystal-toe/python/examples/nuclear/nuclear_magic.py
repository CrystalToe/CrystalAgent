#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Nuclear — Magic Numbers from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt
import numpy as np

toe = ct.Toe(); nuc = toe.nuclear()

fig, ax = plt.subplots(figsize=(12, 7))
fig.suptitle("Nuclear Magic Numbers — All 7 from (2,3)", fontsize=14, fontweight='bold')

magic = nuc.magic_numbers()
labels = nuc.magic_labels()
names = [f'{m}' for m in magic]
colors = plt.cm.viridis(np.linspace(0.2, 0.9, 7))

bars = ax.bar(range(7), magic, color=colors, edgecolor='black', linewidth=1.2, width=0.7)
for i, (bar, m, lbl) in enumerate(zip(bars, magic, labels)):
    ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 2,
            f'{m}\n= {lbl}', ha='center', fontsize=9, fontweight='bold')

ax.set_xticks(range(7))
ax.set_xticklabels([f'M{i+1}' for i in range(7)])
ax.set_ylabel('Nucleon number', fontsize=12)
ax.set_xlabel('Magic number index', fontsize=12)
ax.set_ylim(0, 145)

# Annotate physical nuclei
annotations = [
    (0, 'He-4 core\n2p + 2n'),
    (1, 'O-16\nclosure'),
    (3, 'Ni-56 / Ca-48'),
    (5, 'Pb-208\nprotons'),
    (6, 'Pb-208\nneutrons'),
]
for idx, text in annotations:
    ax.annotate(text, xy=(idx, magic[idx]),
                xytext=(idx + 0.4, magic[idx] + 8),
                fontsize=8, fontstyle='italic',
                arrowprops=dict(arrowstyle='->', color='gray'))

plt.tight_layout()
plt.savefig('nuclear_magic.png', dpi=150, bbox_inches='tight'); plt.show()