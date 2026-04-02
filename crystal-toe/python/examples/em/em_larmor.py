#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal EM — Larmor Radiation: P = (N_c−1)/N_c × q²a² = (2/3)q²a²"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); em = toe.em()
accel = np.linspace(0.1, 10, 200)
power = [em.larmor_power(1.0, a) for a in accel]

fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle(f"Crystal EM — Larmor Radiation\nP = (N_c−1)/N_c × q²a² = (2/3)q²a²", fontsize=13, fontweight='bold')

axes[0].plot(accel, power, 'orange', linewidth=2); axes[0].plot(accel, 2/3*accel**2, 'k--', linewidth=1, label='(2/3)a²')
axes[0].set_xlabel('Acceleration'); axes[0].set_ylabel('Power'); axes[0].set_title('Larmor Power (q=1)'); axes[0].legend(); axes[0].grid(True, alpha=0.3)

charges = np.linspace(0.1, 5, 200)
power_q = [em.larmor_power(q, 1.0) for q in charges]
axes[1].plot(charges, power_q, 'red', linewidth=2); axes[1].plot(charges, 2/3*charges**2, 'k--', linewidth=1)
axes[1].set_xlabel('Charge q'); axes[1].set_ylabel('Power'); axes[1].set_title('Larmor Power (a=1)'); axes[1].grid(True, alpha=0.3)

r_vals = np.linspace(0.5, 10, 200)
force = [em.coulomb_force(1.0, 1.0, r) for r in r_vals]
axes[2].plot(r_vals, force, 'blue', linewidth=2); axes[2].set_xlabel('r'); axes[2].set_ylabel('F')
axes[2].set_title(f'Coulomb 1/r^(N_c−1) = 1/r²'); axes[2].grid(True, alpha=0.3)
plt.tight_layout(); plt.savefig('em_larmor.png', dpi=150, bbox_inches='tight'); plt.show()