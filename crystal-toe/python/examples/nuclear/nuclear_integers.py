#!/usr/bin/env python3
"""Crystal Nuclear — Every Integer Dashboard"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); nuc = toe.nuclear()
fig, ax = plt.subplots(figsize=(10, 10))
fig.suptitle(f"Crystal Nuclear — Every Coefficient from (N_w, N_c) = ({nuc.n_w()}, {nuc.n_c()})",
             fontsize=14, fontweight='bold')
ax.axis('off')

magic = nuc.magic_numbers()
labels = nuc.magic_labels()
rows = []
for m, l in zip(magic, labels):
    rows.append((f"Magic {m}", str(m), l))
rows += [
    ("Surface exp",      "2/3",  "N_w/N_c"),
    ("Coulomb exp",      "1/3",  "1/N_c"),
    ("Coulomb prefactor","3/5",  "N_c/(χ−1)"),
    ("Pairing exp",      "1/2",  "1/N_w"),
    ("Asymmetry factor", str(nuc.asymmetry_factor()), "N_w"),
    ("Isospin states",   str(nuc.isospin_states()),   "N_w"),
    ("Deuteron A",       str(nuc.deuteron_a()),        "N_w"),
    ("Alpha A",          str(nuc.alpha_particle()),    "N_w²"),
    ("Iron peak A",      str(nuc.iron_peak()),         "d_colour·β₀"),
    ("B(He-4) Crystal",  f"{nuc.he4_binding_crystal()} MeV", "N_w²·β₀"),
]
for i, (name, val, origin) in enumerate(rows):
    y = 0.97 - i * 0.05
    ax.text(0.02, y, name, fontsize=10, fontfamily='monospace', va='top', transform=ax.transAxes)
    ax.text(0.32, y, val, fontsize=10, fontfamily='monospace', va='top',
            fontweight='bold', color='crimson', transform=ax.transAxes)
    ax.text(0.50, y, f'= {origin}', fontsize=9, fontfamily='monospace',
            va='top', transform=ax.transAxes)
plt.savefig('nuclear_integers.png', dpi=150, bbox_inches='tight'); plt.show()
