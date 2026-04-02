#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Thermo — Adiabatic Indices γ from (2,3)"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); th = toe.thermo()
fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle("Crystal Thermo — Adiabatic Index γ = (f+2)/f\nAll DOF from (N_w, N_c) = (2, 3)", fontsize=13, fontweight='bold')

dofs = [3, 5, 6, 7]; labels = ['Mono (N_c)', 'Di (χ−1)', 'χ', 'β₀']
gammas = [(f+2)/f for f in dofs]
colors = ['royalblue','red','green','orange']
axes[0].bar(labels, gammas, color=colors); axes[0].set_ylabel('γ'); axes[0].set_title('γ = (f+2)/f'); axes[0].grid(True, alpha=0.3, axis='y')

# Maxwell-Boltzmann speed distributions at different T
v = np.linspace(0, 5, 300)
for T, c in [(0.5,'blue'),(1.0,'green'),(2.0,'red')]:
    vrms = th.maxwell_speed_rms(T, 1.0)
    # f(v) ∝ v² exp(-v²/(2T)) in 3D
    fv = v**2 * np.exp(-v**2 / (2*T))
    fv /= fv.max()
    axes[1].plot(v, fv, color=c, linewidth=2, label=f'T={T}, v_rms={vrms:.2f}')
axes[1].set_xlabel('Speed'); axes[1].set_ylabel('f(v)'); axes[1].set_title(f'Maxwell (N_c={th.n_c()} dimensions)')
axes[1].legend(); axes[1].grid(True, alpha=0.3)

axes[2].axis('off')
for i, l in enumerate([f"DOF mono = N_c = {th.dof_mono()}", f"DOF di = χ−1 = {th.dof_di()}",
    f"γ_mono = (χ−1)/N_c = {th.gamma_monatomic():.4f} = 5/3",
    f"γ_di = β₀/(χ−1) = {th.gamma_diatomic():.4f} = 7/5",
    f"Carnot = (χ−1)/χ = {th.carnot_efficiency():.4f} = 5/6",
    f"S/tick = ln(χ) = {th.entropy_per_tick():.4f} = ln(6)",
    f"v_rms = √(N_c·kT/m)", f"E = f·kT/N_w = f·kT/2", "",
    f"Kolmogorov 5/3 = (χ−1)/N_c = γ_mono!", f"Same fraction in GW chirp!"]):
    axes[2].text(0.05, 0.95-i*0.085, l, transform=axes[2].transAxes, fontsize=11, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('thermo_gamma.png', dpi=150, bbox_inches='tight'); plt.show()