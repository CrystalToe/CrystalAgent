#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Condensed — Phase Transition: M(T) with β=1/8=1/N_w³"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); cm = toe.condensed()
tc = cm.onsager_tc()

# MC at several temperatures
temps = np.linspace(0.5, 4.0, 20)
mc_mags = []
for T in temps:
    mags, _ = cm.ising_simulate(12, 1.0/T, 1500, 50)
    mc_mags.append(np.mean([abs(m) for m in mags[-20:]]))

fig, axes = plt.subplots(1, 2, figsize=(14, 6))
fig.suptitle(f"Crystal Condensed — Ising Phase Transition\n|M| ~ (1−T/T_c)^β, β = 1/N_w³ = {cm.critical_beta():.4f}",
             fontsize=13, fontweight='bold')

T_mf = np.linspace(0.1, tc-0.01, 200)
M_mf = [cm.ising_magnetization(T) for T in T_mf]
axes[0].plot(T_mf, M_mf, 'b-', linewidth=2, label=f'β = 1/N_w³ = 1/8')
axes[0].scatter(temps, mc_mags, c='red', s=30, zorder=5, label='MC (12×12)')
axes[0].axvline(tc, color='green', linestyle='--', label=f'T_c = {tc:.3f}')
axes[0].set_xlabel('T'); axes[0].set_ylabel('|M|')
axes[0].set_title('Magnetization vs Temperature'); axes[0].legend(); axes[0].grid(True, alpha=0.3)

axes[1].axis('off')
for i, l in enumerate([f"Onsager T_c = N_w/ln(1+√N_w) = {tc:.6f}",
    f"Critical β = 1/N_w³ = 1/{cm.n_w()**3} = {cm.critical_beta()}", "",
    f"z = {cm.ising_z_square()} neighbours (square)",
    f"z = {cm.ising_z_cubic()} neighbours (cubic = χ)", "",
    f"|M| ~ (1 − T/T_c)^(1/8) near T_c", f"Exact 2D Ising (Onsager 1944)"]):
    axes[1].text(0.05, 0.95-i*0.11, l, transform=axes[1].transAxes, fontsize=12, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('condensed_phase.png', dpi=150, bbox_inches='tight'); plt.show()