#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Thermo — Every Integer Dashboard"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); th = toe.thermo()
fig, ax = plt.subplots(figsize=(10, 8))
fig.suptitle(f"Crystal Thermo — Every Coefficient from (N_w, N_c) = ({th.n_w()}, {th.n_c()})", fontsize=14, fontweight='bold')
ax.axis('off')
rows = [
    ("LJ attractive",  str(th.lj_attract()),       "χ = N_w × N_c"),
    ("LJ repulsive",   str(th.lj_repel()),         "2χ"),
    ("LJ force",       str(th.lj_force_prefactor()),"d_mixed = N_w³ × N_c"),
    ("DOF mono",       str(th.dof_mono()),          "N_c"),
    ("DOF diatomic",   str(th.dof_di()),            "χ − 1"),
    ("γ monatomic",    "5/3",                       "(χ−1)/N_c"),
    ("γ diatomic",     "7/5",                       "β₀/(χ−1)"),
    ("Carnot η",       "5/6",                       "(χ−1)/χ"),
    ("Entropy/tick",   "ln(6)",                     "ln(χ)"),
    ("Stokes drag",    "24",                        "d_mixed"),
    ("r_min/σ",       f"{2**(1/6):.4f}",           "N_w^(1/χ)"),
    ("Kolmogorov",     "5/3",                       "(χ−1)/N_c = γ_mono"),
]
for i, (name, val, origin) in enumerate(rows):
    y = 0.95 - i * 0.075
    ax.text(0.02, y, name, fontsize=11, fontfamily='monospace', va='top', transform=ax.transAxes)
    ax.text(0.30, y, val, fontsize=11, fontfamily='monospace', va='top', fontweight='bold', color='crimson', transform=ax.transAxes)
    ax.text(0.45, y, f'= {origin}', fontsize=10, fontfamily='monospace', va='top', transform=ax.transAxes)
plt.savefig('thermo_integers.png', dpi=150, bbox_inches='tight'); plt.show()