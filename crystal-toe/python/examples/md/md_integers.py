#!/usr/bin/env python3
"""Crystal MD — Every Integer from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); md = toe.md()
fig, ax = plt.subplots(figsize=(10, 9))
fig.suptitle(f"Crystal MD — Every Integer from (N_w, N_c) = ({md.n_w()}, {md.n_c()})", fontsize=14, fontweight='bold')
ax.axis('off')
rows = [
    ("LJ attractive",   "6",     "χ"),
    ("LJ repulsive",    "12",    "2χ"),
    ("LJ pot coeff",    "4",     "N_w²"),
    ("LJ force coeff",  "24",    "d_mixed"),
    ("sp3 angle",       "109.5°","acos(−1/N_c)"),
    ("Water angle",     "104.5°","acos(−1/N_w²)"),
    ("Helix res/turn",  "3.6",   "N_c²N_w/(χ−1) = 18/5"),
    ("Flory ν",         "2/5",   "N_w/(χ−1)"),
    ("DNA bases",       "4",     "N_w²"),
    ("Codons",          "64",    "(N_w²)^N_c = 4³"),
    ("Amino acids",     "20",    "N_w²(χ−1)"),
    ("H-bonds A-T",     "2",     "N_w"),
    ("H-bonds G-C",     "3",     "N_c"),
    ("bp/turn",         "10",    "N_w(χ−1)"),
    ("Coulomb exp",     "2",     "N_c − 1"),
]
for i, (name, val, origin) in enumerate(rows):
    y = 0.96 - i * 0.062
    ax.text(0.02, y, name, fontsize=10, fontfamily='monospace', va='top', transform=ax.transAxes)
    ax.text(0.30, y, val, fontsize=10, fontfamily='monospace', va='top', fontweight='bold', color='crimson', transform=ax.transAxes)
    ax.text(0.45, y, f'= {origin}', fontsize=9.5, fontfamily='monospace', va='top', transform=ax.transAxes)
plt.savefig('md_integers.png', dpi=150, bbox_inches='tight'); plt.show()
