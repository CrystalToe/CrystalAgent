#!/usr/bin/env python3
"""Crystal Plasma — Every Integer from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); pl = toe.plasma()
fig, ax = plt.subplots(figsize=(10, 8))
fig.suptitle(f"Crystal Plasma — Every Integer from (N_w, N_c) = ({pl.n_w()}, {pl.n_c()})", fontsize=14, fontweight='bold')
ax.axis('off')
rows = [
    ("MHD state vars",   "8",  "d_colour = N_w³"),
    ("Wave types",        "3",  "N_c (slow/Alfvén/fast)"),
    ("Propagating modes", "6",  "χ = 2 × N_c"),
    ("Non-propagating",   "2",  "N_w (entropy + divB)"),
    ("Total modes",       "8",  "χ + N_w = d_colour"),
    ("Mag pressure",      "B²/2","B²/(N_w·μ₀)"),
    ("Plasma beta",       "2p/B²","N_w·μ₀·p/B²"),
    ("EM components",     "6",  "χ (from EM module)"),
    ("CFD D2Q9",          "9",  "N_c² (from CFD module)"),
    ("MHD = EM + CFD",    "8",  "d_colour = N_w³"),
]
for i, (name, val, origin) in enumerate(rows):
    y = 0.95 - i * 0.085
    ax.text(0.02, y, name, fontsize=11, fontfamily='monospace', va='top', transform=ax.transAxes)
    ax.text(0.35, y, val, fontsize=11, fontfamily='monospace', va='top', fontweight='bold', color='crimson', transform=ax.transAxes)
    ax.text(0.50, y, f'= {origin}', fontsize=10, fontfamily='monospace', va='top', transform=ax.transAxes)
plt.savefig('plasma_integers.png', dpi=150, bbox_inches='tight'); plt.show()
