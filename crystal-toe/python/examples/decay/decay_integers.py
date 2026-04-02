#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Decay — Every Integer from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); dc = toe.decay()
fig, ax = plt.subplots(figsize=(10, 8))
fig.suptitle(f"Crystal Decay — Every Integer from (N_w, N_c) = ({dc.n_w()}, {dc.n_c()})", fontsize=14, fontweight='bold')
ax.axis('off')
rows = [
    ("β constant",    "192",     "d_mixed × d_colour = 24×8"),
    ("sin²θ_W",       "3/13",    "N_c / gauss"),
    ("sin²θ₁₂",       "3/π²",    "N_c / π²"),
    ("sin²θ₂₃",       "6/11",    "χ / (2χ−1)"),
    ("sin²(2θ₂₃)",    "120/121", "4·(6/11)·(5/11)"),
    ("Phase(N=2)",     "2",       "N_c·2 − (N_c+1)"),
    ("Phase(N=3)",     "5",       "χ−1"),
    ("Phase(N=4)",     "8",       "d_colour"),
    ("Fermi 2π",       "2π",      "N_w·π"),
    ("w_DE",           "−1",      "Landauer"),
    ("G_F extraction", "192π³",   "d_mixed·d_colour·π³"),
]
for i, (name, val, origin) in enumerate(rows):
    y = 0.95 - i * 0.08
    ax.text(0.02, y, name, fontsize=11, fontfamily='monospace', va='top', transform=ax.transAxes)
    ax.text(0.28, y, val, fontsize=11, fontfamily='monospace', va='top', fontweight='bold', color='crimson', transform=ax.transAxes)
    ax.text(0.45, y, f'= {origin}', fontsize=10, fontfamily='monospace', va='top', transform=ax.transAxes)
plt.savefig('decay_integers.png', dpi=150, bbox_inches='tight'); plt.show()