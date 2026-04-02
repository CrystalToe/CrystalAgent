#!/usr/bin/env python3
"""Crystal Optics — Rayleigh: I ∝ λ^(−N_w²) = λ⁻⁴"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); op = toe.optics()
lam = np.linspace(380, 750, 200)
intensity = [op.rayleigh_intensity(550.0, l) for l in lam]

fig, axes = plt.subplots(1, 2, figsize=(14, 6))
fig.suptitle(f"Crystal Optics — Rayleigh Scattering\nI ∝ λ^(−{op.rayleigh_lambda_exp()}) = λ^(−N_w²), σ ∝ d^{op.rayleigh_size_exp()} = d^χ",
             fontsize=13, fontweight='bold')

colors = plt.cm.jet(np.linspace(0, 1, len(lam)))
for i in range(len(lam)-1):
    axes[0].fill_between([lam[i], lam[i+1]], [intensity[i], intensity[i+1]], color=colors[i], alpha=0.8)
axes[0].set_xlabel('Wavelength (nm)'); axes[0].set_ylabel('Relative Scattering')
axes[0].set_title(f'Sky Blue: (700/450)^{op.rayleigh_lambda_exp()} = {op.sky_blue_ratio():.1f}×')
axes[0].grid(True, alpha=0.3)

axes[1].axis('off')
for i, l in enumerate([f"Rayleigh: I ∝ λ^(−{op.rayleigh_lambda_exp()}) = λ^(−N_w²)",
    f"Cross-section: σ ∝ d^{op.rayleigh_size_exp()} = d^χ",
    f"Blue/Red = ({700}/{450})^{op.rayleigh_lambda_exp()} = {op.sky_blue_ratio():.2f}×", "",
    f"N_w² = {op.rayleigh_lambda_exp()} appears in:", f"  Rayleigh scattering λ⁻⁴",
    f"  Stefan-Boltzmann T⁴", f"  Light bending 4GM/b", f"  Bekenstein S = A/4G"]):
    axes[1].text(0.05, 0.95-i*0.1, l, transform=axes[1].transAxes, fontsize=12, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('optics_rayleigh.png', dpi=150, bbox_inches='tight'); plt.show()
