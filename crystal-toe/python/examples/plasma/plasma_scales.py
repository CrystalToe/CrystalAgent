#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Plasma — Characteristic Scales: Debye, Larmor, cyclotron"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); pl = toe.plasma()
fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle("Crystal Plasma — Characteristic Scales", fontsize=13, fontweight='bold')

n_vals = np.logspace(10, 22, 200)
ld = [pl.debye_length(1e-3, n, 1.6e-19) for n in n_vals]
axes[0].loglog(n_vals, ld, 'b-', linewidth=2)
axes[0].set_xlabel('Density n (m⁻³)'); axes[0].set_ylabel('λ_D (m)')
axes[0].set_title('Debye Length'); axes[0].grid(True, alpha=0.3)

B_vals = np.logspace(-4, 2, 200)
wc = [pl.cyclotron_frequency(1.6e-19, b, 9.1e-31) for b in B_vals]
axes[1].loglog(B_vals, wc, 'r-', linewidth=2)
axes[1].set_xlabel('B (T)'); axes[1].set_ylabel('ω_c (rad/s)')
axes[1].set_title('Cyclotron Frequency'); axes[1].grid(True, alpha=0.3)

wp = [pl.plasma_frequency(n, 9.1e-31) for n in n_vals]
axes[2].loglog(n_vals, wp, 'green', linewidth=2)
axes[2].set_xlabel('Density n (m⁻³)'); axes[2].set_ylabel('ω_p (rad/s)')
axes[2].set_title('Plasma Frequency'); axes[2].grid(True, alpha=0.3)
plt.tight_layout(); plt.savefig('plasma_scales.png', dpi=150, bbox_inches='tight'); plt.show()