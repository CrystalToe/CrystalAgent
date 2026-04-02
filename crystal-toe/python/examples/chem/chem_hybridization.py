#!/usr/bin/env python3
"""Crystal Chem — Hybridization Angles from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt
import numpy as np

toe = ct.Toe(); ch = toe.chem()

fig, axes = plt.subplots(2, 2, figsize=(12, 10), subplot_kw={'projection': 'polar'})
fig.suptitle("Crystal Hybridization — Every Bond Angle from (2,3)", fontsize=14, fontweight='bold')

angles_data = [
    ("sp3 — Tetrahedral",  ch.sp3_angle_deg(), "arccos(−1/N_c)", '#e74c3c', 4),
    ("sp2 — Trigonal",     ch.sp2_angle_deg(), "2π/N_c",         '#3498db', 3),
    ("sp — Linear",        180.0,               "π",              '#2ecc71', 2),
    ("Water — Bent",       ch.water_angle_deg(),"arccos(−1/N_w²)",'#f39c12', 2),
]

for ax, (title, angle_deg, formula, color, n_bonds) in zip(axes.flat, angles_data):
    angle_rad = np.radians(angle_deg)

    # Draw bonds as thick lines from center
    for i in range(n_bonds):
        if n_bonds == 4:
            # project tetrahedral onto 2D: 0, 109.47, 219, 328.5
            theta = np.radians(i * angle_deg)
        elif n_bonds == 3:
            theta = np.radians(i * angle_deg)
        else:
            theta = np.radians(90 - angle_deg/2 + i * angle_deg)
        ax.plot([theta, theta], [0, 0.8], color=color, linewidth=4, solid_capstyle='round')
        ax.plot(theta, 0.85, 'o', color=color, markersize=10)

    # Draw the angle arc between first two bonds
    if n_bonds >= 2:
        if n_bonds == 4:
            t1, t2 = 0, np.radians(angle_deg)
        elif n_bonds == 3:
            t1, t2 = 0, np.radians(angle_deg)
        else:
            t1 = np.radians(90 - angle_deg/2)
            t2 = np.radians(90 + angle_deg/2)
        arc = np.linspace(t1, t2, 50)
        ax.plot(arc, [0.35]*50, color='black', linewidth=2, linestyle='--')

    ax.set_title(f"{title}\n{angle_deg:.2f}° = {formula}", fontsize=11, fontweight='bold', pad=15)
    ax.set_ylim(0, 1.1)
    ax.set_rticks([])
    ax.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('chem_hybridization.png', dpi=150, bbox_inches='tight'); plt.show()
