#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal QFT — Every Integer from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); qf = toe.qft()
fig, ax = plt.subplots(figsize=(10, 8))
fig.suptitle(f"Crystal QFT — Every Integer from (N_w, N_c) = ({qf.n_w()}, {qf.n_c()})", fontsize=14, fontweight='bold')
ax.axis('off')
rows = [
    ("Spacetime",    "4",  "N_w²"), ("Lorentz",  "6",  "χ"),
    ("Dirac",        "4",  "N_w²"), ("Spinor",   "2",  "N_w"),
    ("Photon pol",   "2",  "N_c−1"), ("Gluons",  "8",  "d₃ = N_c²−1"),
    ("β₀",          "7",  "(11N_c−2χ)/3"), ("1-loop", "16", "N_w⁴"),
    ("Propagator",   "2",  "N_c−1"), ("Thomson", "8/3", "d_colour/N_c"),
    ("Pair",         "2m", "N_w·m"), ("Φ₂",     "1/(8π)", "1/(d_colour·π)"),
]
for i, (name, val, origin) in enumerate(rows):
    y = 0.95 - i * 0.075
    ax.text(0.02, y, name, fontsize=11, fontfamily='monospace', va='top', transform=ax.transAxes)
    ax.text(0.25, y, val, fontsize=11, fontfamily='monospace', va='top', fontweight='bold', color='crimson', transform=ax.transAxes)
    ax.text(0.40, y, f'= {origin}', fontsize=10, fontfamily='monospace', va='top', transform=ax.transAxes)
plt.savefig('qft_integers.png', dpi=150, bbox_inches='tight'); plt.show()