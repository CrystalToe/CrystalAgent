#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal QInfo — Entanglement Entropy from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt
import numpy as np

toe = ct.Toe(); qi = toe.qinfo()

fig, axes = plt.subplots(1, 2, figsize=(14, 6))
fig.suptitle("Entanglement Entropy — All from (2,3)", fontsize=14, fontweight='bold')

# ── Left: S = ln(d) for different subsystem dimensions ──
ax = axes[0]
d_range = np.arange(2, 20)
entropies = np.log(d_range)
ax.plot(d_range, entropies, 'b-', linewidth=2, label='S = ln(d)')

# Mark Crystal dimensions
marks = [
    (qi.n_w(),   'N_w',    qi.bell_entropy(),       '#e74c3c'),
    (qi.n_c(),   'N_c',    np.log(qi.n_c()),        '#3498db'),
    (qi.chi(),   'χ',      qi.mera_link_entropy(),  '#2ecc71'),
]
for d, label, s, color in marks:
    ax.plot(d, s, 'o', color=color, markersize=12, zorder=5)
    ax.annotate(f'd={d} ({label})\nS={s:.3f}', xy=(d, s),
                xytext=(d + 1.2, s - 0.15), fontsize=10, fontweight='bold',
                color=color, arrowprops=dict(arrowstyle='->', color=color))

ax.set_xlabel('Subsystem dimension d', fontsize=11)
ax.set_ylabel('Entanglement entropy S (nats)', fontsize=11)
ax.set_title('Maximal Entanglement: S = ln(d)')
ax.legend(fontsize=11)
ax.grid(True, alpha=0.3)

# ── Right: Entropy decomposition ──
ax = axes[1]
ln2 = qi.bell_entropy()
ln3 = np.log(3)
ln6 = qi.mera_link_entropy()

bars = ax.bar(['ln(N_w)\n= ln(2)', 'ln(N_c)\n= ln(3)', 'ln(χ)\n= ln(6)'],
              [ln2, ln3, ln6],
              color=['#e74c3c', '#3498db', '#2ecc71'],
              edgecolor='black', linewidth=1.2, width=0.5)

for bar, v in zip(bars, [ln2, ln3, ln6]):
    ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.03,
            f'{v:.4f}', ha='center', fontsize=11, fontweight='bold')

# Show sum
ax.annotate(f'ln(χ) = ln(N_w) + ln(N_c)\n{ln6:.4f} = {ln2:.4f} + {ln3:.4f}',
            xy=(2, ln6), xytext=(1.5, ln6 + 0.25),
            fontsize=10, fontweight='bold',
            bbox=dict(boxstyle='round', facecolor='lightyellow'))

ax.set_ylabel('Entropy (nats)', fontsize=11)
ax.set_title('Entropy Factorization: ln(χ) = ln(N_w) + ln(N_c)')
ax.set_ylim(0, 2.2)

plt.tight_layout()
plt.savefig('qinfo_entropy.png', dpi=150, bbox_inches='tight'); plt.show()