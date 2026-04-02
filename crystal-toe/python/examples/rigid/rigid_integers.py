#!/usr/bin/env python3
"""Crystal Rigid — Every Integer from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); rg = toe.rigid()
fig, ax = plt.subplots(figsize=(10, 8))
fig.suptitle(f"Crystal Rigid — Every Integer from (N_w, N_c) = ({rg.n_w()}, {rg.n_c()})", fontsize=14, fontweight='bold')
ax.axis('off')
rows = [
    ("Quaternion",     "4",    "N_w²"),
    ("Inertia tensor", "6",    "χ (symmetric 3×3)"),
    ("Rigid DOF",      "6",    "χ (3 trans + 3 rot)"),
    ("Rotation matrix","9",    "N_c²"),
    ("Euler angles",   "3",    "N_c"),
    ("Rotation axes",  "3",    "N_c"),
    ("I_sphere",       "2/5",  "N_w/(χ−1) = Flory!"),
    ("I_rod",          "1/12", "1/(2χ)"),
    ("I_disk",         "1/2",  "1/N_w"),
    ("I_shell",        "2/3",  "N_w/N_c"),
    ("Lorentz gen",    "6",    "d(d−1)/2 for d=N_w²"),
]
for i, (name, val, origin) in enumerate(rows):
    y = 0.95 - i * 0.08
    ax.text(0.02, y, name, fontsize=11, fontfamily='monospace', va='top', transform=ax.transAxes)
    ax.text(0.30, y, val, fontsize=11, fontfamily='monospace', va='top', fontweight='bold', color='crimson', transform=ax.transAxes)
    ax.text(0.45, y, f'= {origin}', fontsize=10, fontfamily='monospace', va='top', transform=ax.transAxes)
plt.savefig('rigid_integers.png', dpi=150, bbox_inches='tight'); plt.show()
