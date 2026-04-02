#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal QInfo — Heyting Algebra & Uncertainty Principle from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt
import matplotlib.patches as FancyBboxPatch

toe = ct.Toe(); qi = toe.qinfo()

fig, ax = plt.subplots(figsize=(10, 9))
fig.suptitle("Heyting Algebra — Uncertainty from gcd(N_w, N_c) = 1",
             fontsize=14, fontweight='bold')

# Draw the lattice: 1 at top, 1/2 and 1/3 in middle, 1/6 at bottom, 0 below
nodes = {
    '1 (singlet)':  (0.5, 0.85),
    '1/2 (weak)':   (0.25, 0.55),
    '1/3 (colour)': (0.75, 0.55),
    '1/6 (mixed)':  (0.5, 0.25),
    '0 (false)':    (0.5, 0.05),
}
colors = {
    '1 (singlet)':  '#2ecc71',
    '1/2 (weak)':   '#3498db',
    '1/3 (colour)': '#e74c3c',
    '1/6 (mixed)':  '#9b59b6',
    '0 (false)':    '#7f8c8d',
}
traces = {
    '1 (singlet)':  '1/1',
    '1/2 (weak)':   '1/N_w',
    '1/3 (colour)': '1/N_c',
    '1/6 (mixed)':  '1/χ',
    '0 (false)':    '0',
}

# Draw edges
edges = [
    ('1 (singlet)', '1/2 (weak)'),
    ('1 (singlet)', '1/3 (colour)'),
    ('1/2 (weak)', '1/6 (mixed)'),
    ('1/3 (colour)', '1/6 (mixed)'),
    ('1/6 (mixed)', '0 (false)'),
]
for n1, n2 in edges:
    x1, y1 = nodes[n1]
    x2, y2 = nodes[n2]
    ax.plot([x1, x2], [y1, y2], 'k-', linewidth=2, zorder=1)

# Draw nodes
for name, (x, y) in nodes.items():
    color = colors[name]
    circle = plt.Circle((x, y), 0.06, color=color, ec='black', linewidth=2, zorder=2)
    ax.add_patch(circle)
    ax.text(x, y, traces[name], ha='center', va='center', fontsize=11,
            fontweight='bold', color='white', zorder=3)
    ax.text(x + 0.09, y, name.split('(')[1].rstrip(')'),
            fontsize=10, va='center', fontstyle='italic')

# Annotations
ax.annotate('meet(1/N_w, 1/N_c) = 1/χ\n← UNCERTAINTY PRINCIPLE',
            xy=(0.5, 0.25), xytext=(0.78, 0.15),
            fontsize=11, fontweight='bold', color='#9b59b6',
            arrowprops=dict(arrowstyle='->', color='#9b59b6', lw=2))

ax.annotate('join(1/N_w, 1/N_c) = 1\n← COMPLEMENTARITY',
            xy=(0.5, 0.85), xytext=(0.78, 0.90),
            fontsize=11, fontweight='bold', color='#2ecc71',
            arrowprops=dict(arrowstyle='->', color='#2ecc71', lw=2))

ax.text(0.5, 0.42, 'INCOMPARABLE\n(coprime: gcd = 1)',
        ha='center', fontsize=10, fontstyle='italic', color='gray')

ax.set_xlim(0, 1); ax.set_ylim(-0.05, 1.0)
ax.set_aspect('equal')
ax.axis('off')

plt.tight_layout()
plt.savefig('qinfo_heyting.png', dpi=150, bbox_inches='tight'); plt.show()