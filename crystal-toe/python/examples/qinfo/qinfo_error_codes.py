#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal QInfo — Error Correction Codes from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import numpy as np

toe = ct.Toe(); qi = toe.qinfo()

fig, axes = plt.subplots(1, 2, figsize=(14, 7))
fig.suptitle("Quantum Error Correction — Code Parameters from (2,3)",
             fontsize=14, fontweight='bold')

# ── Left: Steane code [[7,1,3]] ──
ax = axes[0]
ax.set_xlim(-1.5, 1.5); ax.set_ylim(-1.5, 1.5)
ax.set_aspect('equal')
ax.set_title(f'Steane Code [[{qi.steane_n()}, 1, {qi.steane_d()}]]\n'
             f'= [[β₀, d₁, N_c]]', fontsize=12, fontweight='bold')

# Draw 7 qubits in a circle
angles = np.linspace(0, 2*np.pi, qi.steane_n(), endpoint=False)
colors = ['#e74c3c'] * 1 + ['#3498db'] * 6  # 1 logical, 6 ancilla
for i, (a, c) in enumerate(zip(angles, colors)):
    x, y = np.cos(a), np.sin(a)
    circle = plt.Circle((x, y), 0.15, color=c, ec='black', linewidth=2)
    ax.add_patch(circle)
    label = 'L' if i == 0 else f'P{i}'
    ax.text(x, y, label, ha='center', va='center', fontsize=9, fontweight='bold', color='white')

ax.text(0, -0.1, f'β₀ = {qi.steane_n()} = N_w^N_c − 1\n'
        f'distance = {qi.steane_d()} = N_c\n'
        f'corrects {qi.steane_corrects()} error',
        ha='center', fontsize=10, fontweight='bold',
        bbox=dict(boxstyle='round', facecolor='lightyellow', alpha=0.9))
ax.set_xticks([]); ax.set_yticks([])

# ── Right: Code comparison ──
ax = axes[1]
codes = ['Steane', 'Shor', 'Repetition']
physical = [qi.steane_n(), qi.shor_n(), qi.n_c()]
distance = [qi.steane_d(), qi.steane_d(), qi.n_c()]  # Shor also distance 3
traces = [f'β₀ = {qi.steane_n()}', f'N_c² = {qi.shor_n()}', f'N_c = {qi.n_c()}']
colors = ['#e74c3c', '#3498db', '#2ecc71']

x = np.arange(len(codes))
bars = ax.bar(x, physical, color=colors, edgecolor='black', linewidth=1.2, width=0.5)
for bar, n, trace in zip(bars, physical, traces):
    ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.2,
            f'n={n}\n= {trace}', ha='center', fontsize=10, fontweight='bold')
ax.set_xticks(x)
ax.set_xticklabels(codes, fontsize=11)
ax.set_ylabel('Physical qubits', fontsize=11)
ax.set_title('Code Parameters — All from (2,3)')
ax.set_ylim(0, 12)

# Shor = CFD cross-link
ax.text(0.95, 0.05, f'Note: Shor {qi.shor_n()} = N_c² = D2Q9\n(same as CFD lattice!)',
        transform=ax.transAxes, fontsize=9, fontstyle='italic', ha='right',
        bbox=dict(boxstyle='round', facecolor='lightyellow'))

plt.tight_layout()
plt.savefig('qinfo_error_codes.png', dpi=150, bbox_inches='tight'); plt.show()