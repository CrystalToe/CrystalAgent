#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal CFD — Kolmogorov Turbulence Spectrum: E(k) ∝ k^(−5/3)"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); cfd = toe.cfd()
k = np.logspace(-2, 2, 500)
E = [cfd.kolmogorov_spectrum(ki, 1.0) for ki in k]

fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle("Crystal CFD — Kolmogorov Energy Spectrum\nE(k) ∝ ε^(2/3) k^(−5/3) where 5/3 = (χ−1)/N_c", fontsize=13, fontweight='bold')
axes[0].loglog(k, E, 'b-', linewidth=2)
axes[0].loglog(k, k**(-5/3)*E[0]*k[0]**(5/3), 'r--', linewidth=1, alpha=0.5, label='k^(−5/3)')
axes[0].set_xlabel('Wavenumber k'); axes[0].set_ylabel('E(k)'); axes[0].set_title('Energy Spectrum')
axes[0].legend(); axes[0].grid(True, alpha=0.3)

# Different dissipation rates
for eps_val, c in [(0.1,'blue'),(1.0,'green'),(10.0,'red')]:
    E = [cfd.kolmogorov_spectrum(ki, eps_val) for ki in k]
    axes[1].loglog(k, E, color=c, linewidth=2, label=f'ε={eps_val}')
axes[1].set_xlabel('k'); axes[1].set_ylabel('E(k)'); axes[1].set_title('Varying Dissipation ε')
axes[1].legend(); axes[1].grid(True, alpha=0.3)

axes[2].axis('off')
for i, l in enumerate([f"Kolmogorov −5/3 = −(χ−1)/N_c",
    f"  Same as:", f"    γ_mono = 5/3 (ideal gas)",
    f"    GW chirp = 5/3", f"    All = (χ−1)/N_c = ({cfd.chi()}-1)/{cfd.n_c()}",
    f"", f"Von Karman κ = N_w/(χ−1) = {cfd.von_karman():.2f}",
    f"Blasius δ ∝ Re^(−1/N_w²) = Re^(−{cfd.blasius_exponent():.2f})",
    f"Stokes drag = {cfd.stokes_drag()} = d_mixed"]):
    axes[2].text(0.05, 0.95-i*0.1, l, transform=axes[2].transAxes, fontsize=11, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('cfd_kolmogorov.png', dpi=150, bbox_inches='tight'); plt.show()