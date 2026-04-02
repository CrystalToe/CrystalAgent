#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal GW — Every Integer from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); gw = toe.gw()
fig, ax = plt.subplots(figsize=(10, 8))
fig.suptitle(f"Crystal GW — Every Coefficient from (N_w, N_c) = ({gw.n_w()}, {gw.n_c()})", fontsize=14, fontweight='bold')
ax.axis('off')

rows = [
    ("Peters power",    "32/5",  "N_w⁵/(χ−1)", f"{gw.peters_coefficient():.1f}"),
    ("Orbital decay",   "64/5",  "N_w⁶/(χ−1)", f"{2*gw.peters_coefficient():.1f}"),
    ("Chirp exponent",  "5/3",   "(χ−1)/N_c",   f"{gw.chirp_exponent():.4f}"),
    ("Polarizations",   "2",     "N_c − 1",      f"{gw.gw_polarizations()}"),
    ("GW doubling",     "2",     "N_w",           f"{gw.n_w()}"),
    ("Amplitude",       "4",     "N_w²",          f"{gw.amplitude_factor()}"),
    ("ISCO freq",       "1/(6^1.5 πM)", "1/(χ^(3/2) πM)", f"χ = {gw.chi()}"),
    ("Chirp mass 3/5",  "3/5",   "N_c/(χ−1)",    f"{gw.n_c()}/{gw.chi()-1}"),
    ("Chirp mass 2/5",  "2/5",   "N_w/(χ−1)",    f"{gw.n_w()}/{gw.chi()-1}"),
    ("Chirp rate",      "96/5",  "N_c·Peters",    f"{3*gw.peters_coefficient():.1f}"),
]

for i, (name, val, origin, computed) in enumerate(rows):
    y = 0.93 - i * 0.085
    ax.text(0.02, y, name, fontsize=12, fontfamily='monospace', va='top', transform=ax.transAxes)
    ax.text(0.32, y, val, fontsize=12, fontfamily='monospace', va='top', fontweight='bold', color='crimson', transform=ax.transAxes)
    ax.text(0.45, y, f"= {origin}", fontsize=11, fontfamily='monospace', va='top', transform=ax.transAxes)
    ax.text(0.75, y, f"→ {computed}", fontsize=11, fontfamily='monospace', va='top', color='navy', transform=ax.transAxes)

ax.text(0.02, 0.05, "Kolmogorov turbulence = GW chirp = 5/3. Same crystal fraction.", 
        fontsize=12, fontfamily='monospace', fontweight='bold', va='top', transform=ax.transAxes)
plt.savefig('gw_integers.png', dpi=150, bbox_inches='tight'); plt.show()