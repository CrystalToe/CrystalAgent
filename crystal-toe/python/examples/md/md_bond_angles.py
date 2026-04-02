#!/usr/bin/env python3
"""Crystal MD — Molecular Bond Angles: sp3=acos(−1/N_c), water=acos(−1/N_w²)"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); md = toe.md()
fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle("Crystal MD — Bond Angles from (2,3)\nsp3 = acos(−1/N_c) = 109.47°, water = acos(−1/N_w²) = 104.48°",
             fontsize=13, fontweight='bold')

# Draw tetrahedral angle
theta_t = np.radians(md.tetrahedral_angle_deg())
theta_w = np.radians(md.water_angle_deg())
for theta, name, ax in [(theta_t, f'sp3 = {md.tetrahedral_angle_deg():.2f}°', axes[0]),
                          (theta_w, f'Water = {md.water_angle_deg():.2f}°', axes[1])]:
    ax.plot([0, np.cos(-theta/2)], [0, np.sin(-theta/2)], 'b-', linewidth=3)
    ax.plot([0, np.cos(theta/2)], [0, np.sin(theta/2)], 'b-', linewidth=3)
    arc = np.linspace(-theta/2, theta/2, 50)
    ax.plot(0.3*np.cos(arc), 0.3*np.sin(arc), 'r-', linewidth=2)
    ax.plot(0, 0, 'ko', markersize=10)
    ax.set_aspect('equal'); ax.set_title(name); ax.grid(True, alpha=0.3)
    ax.set_xlim(-0.5, 1.2); ax.set_ylim(-0.8, 0.8)

axes[2].axis('off')
for i, l in enumerate([f"sp3 tetrahedral = acos(−1/N_c)", f"  = acos(−1/{md.n_c()}) = {md.tetrahedral_angle_deg():.2f}°",
    f"  (methane CH₄, diamond)", "",
    f"Water H-O-H = acos(−1/N_w²)", f"  = acos(−1/{md.n_w()**2}) = {md.water_angle_deg():.2f}°",
    f"  (lone pairs bend it from 109.5°)", "",
    f"Helix = {md.helix_per_turn():.1f} residues/turn",
    f"  = N_c²·N_w/(χ−1) = 18/5",
    f"Flory ν = N_w/(χ−1) = {md.flory_nu():.1f}"]):
    axes[2].text(0.05, 0.95-i*0.085, l, transform=axes[2].transAxes, fontsize=11, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('md_bond_angles.png', dpi=150, bbox_inches='tight'); plt.show()
