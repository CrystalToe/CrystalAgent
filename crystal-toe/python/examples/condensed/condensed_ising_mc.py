#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Condensed — Ising Monte Carlo: z=N_w²=4, T_c=N_w/ln(1+√N_w)"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); cm = toe.condensed()
tc = cm.onsager_tc()
print(f"Onsager T_c = {tc:.6f} = N_w/ln(1+√N_w)")

temps = [1.0, 1.5, 2.0, tc, 3.0, 4.0, 5.0]
fig, axes = plt.subplots(2, 2, figsize=(14, 10))
fig.suptitle(f"Crystal Condensed — 2D Ising Monte Carlo\nz = {cm.ising_z_square()} = N_w², T_c = {tc:.4f} = N_w/ln(1+√N_w)",
             fontsize=13, fontweight='bold')

# Magnetization vs sweeps at different T
for T in [1.0, tc, 5.0]:
    mags, _ = cm.ising_simulate(16, 1.0/T, 2000, 10)
    label = f'T={T:.2f}' + (' (T_c)' if abs(T-tc) < 0.01 else '')
    axes[0][0].plot(range(len(mags)), [abs(m) for m in mags], linewidth=0.8, label=label)
axes[0][0].set_xlabel('Sample'); axes[0][0].set_ylabel('|M|')
axes[0][0].set_title('Magnetization Evolution'); axes[0][0].legend(); axes[0][0].grid(True, alpha=0.3)

# M(T) curve
T_arr = np.linspace(0.5, 4.0, 100)
M_mf = [cm.ising_magnetization(T) for T in T_arr]
axes[0][1].plot(T_arr, M_mf, 'b-', linewidth=2, label='Mean-field')
axes[0][1].axvline(tc, color='r', linestyle='--', label=f'T_c = {tc:.3f}')
axes[0][1].set_xlabel('T'); axes[0][1].set_ylabel('|M|')
axes[0][1].set_title('Order Parameter'); axes[0][1].legend(); axes[0][1].grid(True, alpha=0.3)

# Energy vs sweeps
for T in [1.0, tc, 5.0]:
    _, ens = cm.ising_simulate(16, 1.0/T, 2000, 10)
    axes[1][0].plot(range(len(ens)), ens, linewidth=0.8, label=f'T={T:.2f}')
axes[1][0].set_xlabel('Sample'); axes[1][0].set_ylabel('E')
axes[1][0].set_title('Energy Evolution'); axes[1][0].legend(); axes[1][0].grid(True, alpha=0.3)

axes[1][1].axis('off')
for i, l in enumerate([f"z_square = N_w² = {cm.ising_z_square()}", f"z_cubic = χ = {cm.ising_z_cubic()}",
    f"Ising states = N_w = {cm.ising_states()}", f"T_c = N_w/ln(1+√N_w) = {tc:.6f}",
    f"β_crit = 1/N_w³ = {cm.critical_beta():.4f}", f"E_ground/site = −N_w = −2", "",
    f"Metropolis = crystal monad on lattice"]):
    axes[1][1].text(0.05, 0.95-i*0.11, l, transform=axes[1][1].transAxes, fontsize=11, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('condensed_ising.png', dpi=150, bbox_inches='tight'); plt.show()