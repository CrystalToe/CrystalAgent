#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Condensed — BCS Superconductivity: 2Δ/(kT_c) = N_w·π/e^γ"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); cm = toe.condensed()
fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle(f"Crystal Condensed — BCS Superconductivity\n2Δ/(kT_c) = N_w·π/e^γ = {cm.bcs_ratio():.4f}",
             fontsize=13, fontweight='bold')

nv = np.linspace(0.1, 1.0, 200)
gaps = [cm.bcs_gap(x) for x in nv]
axes[0].plot(nv, gaps, 'b-', linewidth=2)
axes[0].set_xlabel('N(0)V (coupling)'); axes[0].set_ylabel('Δ / (ℏω_D)')
axes[0].set_title('BCS Gap vs Coupling'); axes[0].grid(True, alpha=0.3)

# Temperature dependence (approximate)
t_arr = np.linspace(0, 1.5, 200)
delta_t = [cm.bcs_ratio()/2 * np.sqrt(max(0, 1-(t/1.0)**2)) if t < 1.0 else 0 for t in t_arr]
axes[1].plot(t_arr, delta_t, 'r-', linewidth=2)
axes[1].axvline(1.0, color='k', linestyle='--', label='T_c')
axes[1].set_xlabel('T / T_c'); axes[1].set_ylabel('Δ(T) / (kT_c)')
axes[1].set_title('Gap vs Temperature'); axes[1].legend(); axes[1].grid(True, alpha=0.3)

axes[2].axis('off')
for i, l in enumerate([f"BCS gap ratio = {cm.bcs_ratio():.4f}", f"  = N_w·π/e^γ = 2π/e^γ",
    f"  N_w = {cm.n_w()} (prefactor)", f"  γ = 0.5772 (Euler-Mascheroni)", "",
    f"Δ(0) = N_w·ℏω_D·exp(−1/(N(0)V))", f"  N_w = 2 (Cooper pair = 2 electrons)", "",
    f"Experimental: 2Δ/(kT_c) ≈ 3.53"]):
    axes[2].text(0.05, 0.95-i*0.1, l, transform=axes[2].transAxes, fontsize=11, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('condensed_bcs.png', dpi=150, bbox_inches='tight'); plt.show()