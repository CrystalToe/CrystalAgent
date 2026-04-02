#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Friedmann — Cosmic Expansion: a(t) from Big Bang to today"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); fr = toe.friedmann()
a_arr, t_arr, z_arr = fr.integrate(0.001, 1.5, 1e-4, 500000)

fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle(f"Crystal Friedmann — Cosmic Expansion\nΩ_Λ={fr.omega_lambda():.4f}=gauss/(gauss+χ)=13/19, "
             f"Ω_m={fr.omega_matter():.4f}=χ/(gauss+χ)=6/19", fontsize=13, fontweight='bold')

axes[0].plot(t_arr, a_arr, 'b-', linewidth=2)
axes[0].set_xlabel('t × H₀'); axes[0].set_ylabel('a(t)'); axes[0].set_title('Scale Factor')
axes[0].axhline(1.0, color='r', linestyle='--', alpha=0.5, label='a=1 (today)')
axes[0].legend(); axes[0].grid(True, alpha=0.3)

axes[1].plot(a_arr, [fr.hubble_norm(a) for a in a_arr], 'purple', linewidth=2)
axes[1].set_xlabel('a'); axes[1].set_ylabel('H(a)/H₀'); axes[1].set_title('Hubble Parameter')
axes[1].set_yscale('log'); axes[1].grid(True, alpha=0.3)

axes[2].plot(a_arr, [fr.deceleration_param(a) for a in a_arr], 'red', linewidth=2)
axes[2].axhline(0, color='k', linewidth=0.5)
z_acc = fr.acceleration_onset()
axes[2].axvline(1/(1+z_acc), color='green', linestyle='--', label=f'q=0 at z={z_acc:.2f}')
axes[2].set_xlabel('a'); axes[2].set_ylabel('q(a)'); axes[2].set_title('Deceleration → Acceleration')
axes[2].legend(); axes[2].grid(True, alpha=0.3)
plt.tight_layout(); plt.savefig('friedmann_expansion.png', dpi=150, bbox_inches='tight'); plt.show()