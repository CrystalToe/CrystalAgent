#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Friedmann — Density Parameters: Ω(a) evolution"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); fr = toe.friedmann()
a_vals = np.logspace(-3, 0.2, 500)
om_m = [fr.omega_matter()/a**3 / fr.hubble_norm(a)**2 for a in a_vals]
om_r = [fr.omega_rad()/a**4 / fr.hubble_norm(a)**2 for a in a_vals]
om_l = [fr.omega_lambda() / fr.hubble_norm(a)**2 for a in a_vals]

fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle("Crystal Friedmann — Density Evolution\nAll from (N_w, N_c) = (2, 3)", fontsize=13, fontweight='bold')

axes[0].fill_between(a_vals, 0, om_r, alpha=0.5, label=f'Radiation (1/a^{fr.n_c()+1})', color='orange')
axes[0].fill_between(a_vals, om_r, np.array(om_r)+np.array(om_m), alpha=0.5, label=f'Matter (1/a^{fr.n_c()})', color='blue')
axes[0].fill_between(a_vals, np.array(om_r)+np.array(om_m), 1, alpha=0.5, label='Λ (const)', color='purple')
axes[0].set_xscale('log'); axes[0].set_xlabel('a'); axes[0].set_ylabel('Ω(a)')
axes[0].set_title('Era Transitions'); axes[0].legend(fontsize=9); axes[0].grid(True, alpha=0.3)

# Pie chart today
axes[1].pie([fr.omega_lambda(), fr.omega_dm(), fr.omega_baryon(), fr.omega_rad()],
    labels=[f'Λ: {fr.omega_lambda():.3f}', f'DM: {fr.omega_dm():.3f}', f'Baryon: {fr.omega_baryon():.3f}', f'Rad: {fr.omega_rad():.1e}'],
    colors=['purple','navy','royalblue','orange'], autopct='%1.1f%%')
axes[1].set_title('Energy Budget Today')

axes[2].axis('off')
for i, l in enumerate([f"Ω_Λ = gauss/(gauss+χ) = 13/19 = {fr.omega_lambda():.4f}",
    f"Ω_m = χ/(gauss+χ) = 6/19 = {fr.omega_matter():.4f}",
    f"Ω_b = {fr.omega_baryon():.4f}", f"DM/b = 12π/β₀ = {fr.dm_baryon_ratio():.3f}",
    f"Flat: Ω_total = {fr.omega_lambda()+fr.omega_matter()+fr.omega_rad():.4f}",
    "", f"Planck (2018):", f"  Ω_Λ = 0.6847", f"  Ω_m = 0.3153", f"  DM/b = 5.36"]):
    axes[2].text(0.05, 0.95-i*0.09, l, transform=axes[2].transAxes, fontsize=11, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('friedmann_densities.png', dpi=150, bbox_inches='tight'); plt.show()