#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Optics — Every Integer from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); op = toe.optics()
fig, ax = plt.subplots(figsize=(10, 8))
fig.suptitle(f"Crystal Optics — Every Integer from (N_w, N_c) = ({op.n_w()}, {op.n_c()})", fontsize=14, fontweight='bold')
ax.axis('off')
rows = [
    ("n_water",        "4/3",  "C_F = (N_c²−1)/(2N_c)"),
    ("n_glass",        "3/2",  "N_c / N_w"),
    ("n_diamond",      "13/5", "gauss / (χ−1)"),
    ("Rayleigh λ exp", "4",    "N_w²"),
    ("Rayleigh d exp", "6",    "χ"),
    ("Planck λ exp",   "5",    "χ − 1"),
    ("Brewster(glass)", f"{__import__('math').degrees(op.brewster_angle(1.0, op.n_glass())):.1f}°", "atan(N_c/N_w)"),
    ("Sky blue ratio", f"{op.sky_blue_ratio():.2f}", "(700/450)^(N_w²)"),
    ("Normal R(glass)", f"{op.normal_reflectance(1.0, op.n_glass())*100:.1f}%", "((1−n)/(1+n))²"),
    ("Wien (5778K)",   f"{op.wien_displacement(5778)*1e9:.0f} nm", "b/T"),
]
for i, (name, val, origin) in enumerate(rows):
    y = 0.95 - i * 0.085
    ax.text(0.02, y, name, fontsize=11, fontfamily='monospace', va='top', transform=ax.transAxes)
    ax.text(0.32, y, val, fontsize=11, fontfamily='monospace', va='top', fontweight='bold', color='crimson', transform=ax.transAxes)
    ax.text(0.50, y, f'= {origin}', fontsize=10, fontfamily='monospace', va='top', transform=ax.transAxes)
plt.savefig('optics_integers.png', dpi=150, bbox_inches='tight'); plt.show()