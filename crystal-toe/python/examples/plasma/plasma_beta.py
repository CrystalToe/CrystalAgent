#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Plasma — Plasma Beta & Magnetic Pressure"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); pl = toe.plasma()
B = np.linspace(0.1, 5.0, 200)
p_mag = [pl.mag_pressure(b) for b in B]

fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle(f"Crystal Plasma — Pressure Balance\np_mag = B²/(N_w·μ₀) = B²/2, β = N_w·p/B² = 2p/B²",
             fontsize=13, fontweight='bold')

axes[0].plot(B, p_mag, 'b-', linewidth=2)
axes[0].set_xlabel('B'); axes[0].set_ylabel('p_mag'); axes[0].set_title('Magnetic Pressure = B²/2')
axes[0].grid(True, alpha=0.3)

p_vals = np.logspace(-2, 2, 200)
for b_val in [0.5, 1.0, 2.0]:
    beta = [pl.plasma_beta(p, b_val) for p in p_vals]
    axes[1].loglog(p_vals, beta, linewidth=2, label=f'B={b_val}')
axes[1].axhline(1.0, color='k', linestyle='--', alpha=0.5, label='β=1')
axes[1].set_xlabel('p_gas'); axes[1].set_ylabel('β'); axes[1].set_title('Plasma Beta')
axes[1].legend(); axes[1].grid(True, alpha=0.3)

rho = np.logspace(-2, 2, 200)
va = [pl.alfven_speed(1.0, r) for r in rho]
axes[2].loglog(rho, va, 'red', linewidth=2)
axes[2].set_xlabel('ρ'); axes[2].set_ylabel('v_A'); axes[2].set_title('Alfvén Speed = B/√ρ')
axes[2].grid(True, alpha=0.3)
plt.tight_layout(); plt.savefig('plasma_beta.png', dpi=150, bbox_inches='tight'); plt.show()