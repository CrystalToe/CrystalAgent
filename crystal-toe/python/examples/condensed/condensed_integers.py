#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Condensed — Every Integer from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); cm = toe.condensed()
fig, ax = plt.subplots(figsize=(10, 8))
fig.suptitle(f"Crystal Condensed — Every Integer from (N_w, N_c) = ({cm.n_w()}, {cm.n_c()})", fontsize=14, fontweight='bold')
ax.axis('off')
rows = [
    ("z (square)",    "4",     "N_w²"),
    ("z (cubic)",     "6",     "χ"),
    ("Ising states",  "2",     "N_w"),
    ("T_c numerator", "2",     "N_w"),
    ("β_crit",        "1/8",   "1/N_w³"),
    ("E_ground/site", "−2",    "−N_w"),
    ("BCS prefactor", "2",     "N_w"),
    ("BCS ratio",     f"{cm.bcs_ratio():.3f}", "N_w·π/e^γ"),
    ("Onsager T_c",   f"{cm.onsager_tc():.4f}", "N_w/ln(1+√N_w)"),
    ("Cooper pair",   "2",     "N_w electrons"),
]
for i, (name, val, origin) in enumerate(rows):
    y = 0.95 - i * 0.085
    ax.text(0.02, y, name, fontsize=11, fontfamily='monospace', va='top', transform=ax.transAxes)
    ax.text(0.30, y, val, fontsize=11, fontfamily='monospace', va='top', fontweight='bold', color='crimson', transform=ax.transAxes)
    ax.text(0.50, y, f'= {origin}', fontsize=10, fontfamily='monospace', va='top', transform=ax.transAxes)
plt.savefig('condensed_integers.png', dpi=150, bbox_inches='tight'); plt.show()