#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal CFD — Every Integer from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); cfd = toe.cfd()
fig, ax = plt.subplots(figsize=(10, 8))
fig.suptitle(f"Crystal CFD — Every Integer from (N_w, N_c) = ({cfd.n_w()}, {cfd.n_c()})", fontsize=14, fontweight='bold')
ax.axis('off')
rows = [
    ("D2Q9 velocities", "9",    "N_c²"),
    ("Kolmogorov",       "−5/3", "−(χ−1)/N_c"),
    ("Stokes drag",      "24",   "d_mixed = N_w³·N_c"),
    ("Blasius",          "1/4",  "1/N_w²"),
    ("Von Karman κ",     "2/5",  "N_w/(χ−1)"),
    ("w_rest",           "4/9",  "N_w²/N_c²"),
    ("w_cardinal",       "1/9",  "1/N_c²"),
    ("w_diagonal",       "1/36", "1/Σ_d"),
    ("c_s²",             "1/3",  "1/N_c"),
    ("Stokes force",     "6πμrv","χ·π·μ·r·v"),
    ("Reynolds",         "ρvL/μ","dimensionless"),
]
for i, (name, val, origin) in enumerate(rows):
    y = 0.95 - i * 0.08
    ax.text(0.02, y, name, fontsize=11, fontfamily='monospace', va='top', transform=ax.transAxes)
    ax.text(0.35, y, val, fontsize=11, fontfamily='monospace', va='top', fontweight='bold', color='crimson', transform=ax.transAxes)
    ax.text(0.50, y, f'= {origin}', fontsize=10, fontfamily='monospace', va='top', transform=ax.transAxes)
plt.savefig('cfd_integers.png', dpi=150, bbox_inches='tight'); plt.show()