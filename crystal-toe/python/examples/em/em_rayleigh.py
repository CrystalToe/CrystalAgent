#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal EM — Why the Sky is Blue: Rayleigh σ ∝ 1/λ^(N_w²) = 1/λ⁴"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); em = toe.em()
lam = np.linspace(380, 750, 200)  # visible spectrum nm
sigma = [em.rayleigh_sigma(100e-9, l*1e-9) for l in lam]
sigma = np.array(sigma) / max(sigma)

fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle(f"Crystal EM — Why the Sky is Blue\nσ ∝ d^χ/λ^(N_w²) = d⁶/λ⁴", fontsize=13, fontweight='bold')

colors = plt.cm.jet(np.linspace(0, 1, len(lam)))
for i in range(len(lam)-1):
    axes[0].fill_between([lam[i], lam[i+1]], [sigma[i], sigma[i+1]], color=colors[i], alpha=0.8)
axes[0].set_xlabel('Wavelength (nm)'); axes[0].set_ylabel('Relative σ'); axes[0].set_title('Rayleigh Scattering'); axes[0].grid(True, alpha=0.3)

ratio = em.sky_blue_ratio(450e-9, 700e-9)
axes[1].bar(['Blue (450nm)','Red (700nm)'], [ratio, 1.0], color=['royalblue','red'])
axes[1].set_ylabel('Relative scattering'); axes[1].set_title(f'Blue/Red = (700/450)^{em.rayleigh_wave_exp()} = {ratio:.1f}×')

axes[2].axis('off')
for i, l in enumerate([f"σ ∝ d^{em.rayleigh_size_exp()}/λ^{em.rayleigh_wave_exp()}",
    f"Size exp = χ = {em.rayleigh_size_exp()}", f"Wave exp = N_w² = {em.rayleigh_wave_exp()}",
    f"Blue/Red = {ratio:.1f}×", "", f"Same N_w²=4 as:", f"  Stefan-Boltzmann T⁴",
    f"  Bekenstein S=A/4G", f"  Light bending 4GM/b"]):
    axes[2].text(0.05, 0.95-i*0.1, l, transform=axes[2].transAxes, fontsize=12, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('em_rayleigh.png', dpi=150, bbox_inches='tight'); plt.show()