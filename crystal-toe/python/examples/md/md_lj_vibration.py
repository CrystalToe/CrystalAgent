#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal MD — LJ Molecular Vibration: 2-particle Velocity Verlet"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); md = toe.md()
# Two particles near LJ equilibrium
r_eq = 2**(1/6)  # equilibrium distance
seps, ens = md.md2_evolve(0.0, 0.0, r_eq + 0.1, 0.3, 0.001, 20000)

fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle("Crystal MD — LJ Molecular Vibration\nV = N_w²[(1/r)^(2χ) − (1/r)^χ] = 4[(1/r)¹² − (1/r)⁶]",
             fontsize=13, fontweight='bold')

time = np.arange(len(seps)) * 0.001
axes[0].plot(time, seps, 'b-', linewidth=0.3)
axes[0].axhline(r_eq, color='r', linestyle='--', label=f'r_eq = 2^(1/χ) = {r_eq:.4f}')
axes[0].set_xlabel('Time'); axes[0].set_ylabel('Separation')
axes[0].set_title('Molecular Vibration'); axes[0].legend(); axes[0].grid(True, alpha=0.3)

e0 = ens[0]; e_dev = np.abs((np.array(ens)-e0)/(abs(e0)+1e-20))
axes[1].semilogy(time, e_dev+1e-20, 'purple', linewidth=0.3)
axes[1].set_xlabel('Time'); axes[1].set_ylabel('|ΔE/E₀|')
axes[1].set_title(f'Energy Conservation (max={e_dev.max():.2e})'); axes[1].grid(True, alpha=0.3)

r_arr, v_arr, f_arr = md.lj_curves(0.9, 2.5, 300)
axes[2].plot(r_arr, v_arr, 'b-', linewidth=2, label='V(r)')
axes[2].plot(r_arr, f_arr, 'r-', linewidth=2, label='F(r)')
axes[2].axhline(0, color='k', linewidth=0.5)
axes[2].set_xlabel('r/σ'); axes[2].set_ylabel('V, F'); axes[2].set_ylim(-2, 5)
axes[2].set_title('LJ Potential & Force'); axes[2].legend(); axes[2].grid(True, alpha=0.3)
plt.tight_layout(); plt.savefig('md_lj_vibration.png', dpi=150, bbox_inches='tight'); plt.show()