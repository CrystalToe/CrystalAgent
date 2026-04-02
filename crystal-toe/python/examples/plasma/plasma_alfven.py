#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Plasma — Alfvén Wave Propagation: FDTD staggered leapfrog"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); pl = toe.plasma()
vys, bys, ens = pl.simulate_alfven(200, 0.5, 400, 50, False)

fig, axes = plt.subplots(2, 2, figsize=(14, 10))
fig.suptitle(f"Crystal Plasma — Alfvén Wave FDTD\nMHD states = {pl.mhd_states()} = d_colour = N_w³, wave types = {pl.wave_types()} = N_c",
             fontsize=13, fontweight='bold')

x = np.linspace(0, 1, len(vys[0]))
for i in [0, len(vys)//3, 2*len(vys)//3, -1]:
    axes[0][0].plot(x, vys[i], linewidth=1, label=f'snap {i}', alpha=0.8)
axes[0][0].set_title('v_y (velocity perturbation)'); axes[0][0].legend(fontsize=8); axes[0][0].grid(True, alpha=0.3)

for i in [0, len(bys)//3, 2*len(bys)//3, -1]:
    axes[0][1].plot(x, bys[i], linewidth=1, alpha=0.8)
axes[0][1].set_title('B_y (magnetic perturbation)'); axes[0][1].grid(True, alpha=0.3)

e0 = ens[0]; e_dev = [abs(e-e0)/(abs(e0)+1e-20) for e in ens]
axes[1][0].semilogy(range(len(ens)), [d+1e-20 for d in e_dev], 'purple', linewidth=1)
axes[1][0].set_title(f'Energy Conservation (max={max(e_dev):.2e})'); axes[1][0].grid(True, alpha=0.3)

axes[1][1].axis('off')
for i, l in enumerate([f"MHD states = {pl.mhd_states()} = N_w³ = d_colour",
    f"Wave types = {pl.wave_types()} = N_c (slow/Alfvén/fast)",
    f"Prop modes = {pl.propagating_modes()} = χ (3×2 dirs)",
    f"Non-prop = {pl.non_propagating()} = N_w (entropy+divB)",
    f"v_A = B/√ρ (Alfvén speed)", "",
    f"FDTD = staggered leapfrog", f"Same W∘U as Yee EM"]):
    axes[1][1].text(0.05, 0.95-i*0.11, l, transform=axes[1][1].transAxes, fontsize=11, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('plasma_alfven.png', dpi=150, bbox_inches='tight'); plt.show()