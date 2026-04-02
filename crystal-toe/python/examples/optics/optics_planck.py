#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Optics — Planck Radiation: B(λ) ∝ λ^(−5) = λ^(−(χ−1))"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); op = toe.optics()
temps = [3000.0, 4000.0, 5000.0, 5778.0, 7000.0]
lam_nm, spectra = op.planck_curves(temps, 500)

fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle(f"Crystal Optics — Planck Radiation\nB(λ,T) ∝ λ^(−{op.planck_lambda_exp()}) = λ^(−(χ−1)), Wien: λ_max·T = const",
             fontsize=13, fontweight='bold')

for i, T in enumerate(temps):
    s = np.array(spectra[i]); s /= max(s) if max(s) > 0 else 1
    axes[0].plot(lam_nm, s, linewidth=1.5, label=f'{T:.0f} K')
    lmax = op.wien_displacement(T) * 1e9
    axes[0].axvline(lmax, color=f'C{i}', linestyle=':', alpha=0.3)
axes[0].set_xlabel('λ (nm)'); axes[0].set_ylabel('B (normalized)')
axes[0].set_title(f'Planck Spectra (exp = χ−1 = {op.planck_lambda_exp()})'); axes[0].legend(fontsize=9)
axes[0].set_xlim(0, 2500); axes[0].grid(True, alpha=0.3)

T_arr = np.linspace(2000, 10000, 200)
lmax = [op.wien_displacement(T)*1e9 for T in T_arr]
axes[1].plot(T_arr, lmax, 'red', linewidth=2); axes[1].set_xlabel('T (K)'); axes[1].set_ylabel('λ_max (nm)')
axes[1].set_title('Wien Displacement'); axes[1].grid(True, alpha=0.3)

axes[2].axis('off')
for i, l in enumerate([f"Planck exp = χ−1 = {op.planck_lambda_exp()}", f"Wien: λ_max·T = 2898 μm·K",
    f"Sun (5778 K): λ_max = {op.wien_displacement(5778)*1e9:.0f} nm", "",
    f"Same exponent family:", f"  Rayleigh λ^(−{op.rayleigh_lambda_exp()}) = λ^(−N_w²)",
    f"  Planck λ^(−{op.planck_lambda_exp()}) = λ^(−(χ−1))",
    f"  Stefan T^{op.rayleigh_lambda_exp()} = T^(N_w²)"]):
    axes[2].text(0.05, 0.95-i*0.11, l, transform=axes[2].transAxes, fontsize=11, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('optics_planck.png', dpi=150, bbox_inches='tight'); plt.show()