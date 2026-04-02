#!/usr/bin/env python3
"""Crystal Optics — Fresnel Reflectance: n_water=4/3=C_F, n_glass=3/2=N_c/N_w"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); op = toe.optics()
fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle(f"Crystal Optics — Fresnel Reflectance\nn_water={op.n_water():.4f}=C_F=(N_c²−1)/(2N_c), n_glass={op.n_glass():.4f}=N_c/N_w",
             fontsize=13, fontweight='bold')

for n2, name, color in [(op.n_water(),'Water','blue'), (op.n_glass(),'Glass','green'), (op.n_diamond(),'Diamond','red')]:
    angles, rs, rp, r = op.fresnel_curve(1.0, n2, 200)
    axes[0].plot(angles, rs, color=color, linewidth=1.5, linestyle='--', alpha=0.7)
    axes[0].plot(angles, rp, color=color, linewidth=1.5, linestyle=':', alpha=0.7)
    axes[0].plot(angles, r, color=color, linewidth=2, label=f'{name} (n={n2:.2f})')
axes[0].set_xlabel('Angle (°)'); axes[0].set_ylabel('Reflectance')
axes[0].set_title('Fresnel Reflectance'); axes[0].legend(); axes[0].grid(True, alpha=0.3)

# Brewster angles
materials = [('Water',op.n_water()), ('Glass',op.n_glass()), ('Diamond',op.n_diamond())]
brewster = [np.degrees(op.brewster_angle(1.0, n)) for _,n in materials]
axes[1].barh([m for m,_ in materials], brewster, color=['blue','green','red'])
axes[1].set_xlabel('Brewster Angle (°)'); axes[1].set_title('Brewster Angles (Rp = 0)')
axes[1].grid(True, alpha=0.3, axis='x')

axes[2].axis('off')
for i, l in enumerate([f"n_water = C_F = (N_c²−1)/(2N_c) = 4/3 = {op.n_water():.4f}",
    f"n_glass = N_c/N_w = 3/2 = {op.n_glass():.4f}",
    f"n_diamond = gauss/(χ−1) = 13/5 = {op.n_diamond():.4f}", "",
    f"Normal R(glass) = {op.normal_reflectance(1.0, op.n_glass())*100:.1f}%",
    f"Normal R(diamond) = {op.normal_reflectance(1.0, op.n_diamond())*100:.1f}%", "",
    f"C_F is the Casimir factor of SU(N_c)", f"The SAME fraction governs QCD and water!"]):
    axes[2].text(0.05, 0.95-i*0.1, l, transform=axes[2].transAxes, fontsize=11, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('optics_fresnel.png', dpi=150, bbox_inches='tight'); plt.show()
