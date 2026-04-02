#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Rigid — Moments of Inertia: every factor from (2,3)"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); rg = toe.rigid()
fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle("Crystal Rigid — Moments of Inertia\nEvery prefactor from (N_w, N_c) = (2, 3)",
             fontsize=13, fontweight='bold')

shapes = ['Sphere', 'Shell', 'Disk', 'Rod']
factors = [rg.i_sphere_factor(), rg.i_shell_factor(), rg.i_disk_factor(), rg.i_rod_factor()]
labels = ['2/5=N_w/(χ−1)', '2/3=N_w/N_c', '1/2=1/N_w', '1/12=1/(2χ)']
colors = ['royalblue', 'coral', 'green', 'orange']
axes[0].barh(shapes, factors, color=colors)
for i, (f, lb) in enumerate(zip(factors, labels)):
    axes[0].text(f+0.02, i, f'{f:.4f} = {lb}', va='center', fontsize=10)
axes[0].set_xlabel('I / (MR² or ML²)'); axes[0].set_title('Inertia Factors')
axes[0].grid(True, alpha=0.3, axis='x')

# I vs R for sphere
R = np.linspace(0.1, 2.0, 100)
I_sp = [rg.i_sphere(1.0, r) for r in R]
I_sh = [rg.i_shell(1.0, r) for r in R]
I_dk = [rg.i_disk(1.0, r) for r in R]
axes[1].plot(R, I_sp, 'b-', linewidth=2, label='Sphere')
axes[1].plot(R, I_sh, 'r-', linewidth=2, label='Shell')
axes[1].plot(R, I_dk, 'g-', linewidth=2, label='Disk')
axes[1].set_xlabel('R'); axes[1].set_ylabel('I (M=1)')
axes[1].set_title('Moment of Inertia vs Radius'); axes[1].legend(); axes[1].grid(True, alpha=0.3)

axes[2].axis('off')
for i, l in enumerate([f"I_sphere = 2/5 MR² = N_w/(χ−1) MR²",
    f"  Same as Flory exponent ν = 2/5!", "",
    f"I_rod = 1/12 ML² = 1/(2χ) ML²",
    f"I_disk = 1/2 MR² = 1/N_w MR²",
    f"I_shell = 2/3 MR² = N_w/N_c MR²", "",
    f"Every fraction from (2,3)!"]):
    axes[2].text(0.05, 0.95-i*0.11, l, transform=axes[2].transAxes, fontsize=11, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('rigid_inertia.png', dpi=150, bbox_inches='tight'); plt.show()