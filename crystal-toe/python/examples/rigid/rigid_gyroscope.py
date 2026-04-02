#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Rigid — Gyroscope: symmetric top precession"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); rg = toe.rigid()
# Symmetric top (I_x = I_y ≠ I_z)
ens, lms, qns = rg.simulate(2.0, 2.0, 1.0, 0.1, 0.1, 5.0, 0.001, 30000)

fig, axes = plt.subplots(1, 2, figsize=(14, 6))
fig.suptitle("Crystal Rigid — Symmetric Top Precession\nI_x=I_y=2, I_z=1, ω_z=5 (fast spin)", fontsize=13, fontweight='bold')

t = np.arange(len(ens)) * 0.001
axes[0].plot(t, ens, 'b-', linewidth=0.5)
axes[0].set_title('Energy (conserved)'); axes[0].set_xlabel('Time'); axes[0].grid(True, alpha=0.3)

axes[1].plot(t, lms, 'r-', linewidth=0.5)
axes[1].set_title('|L| (conserved)'); axes[1].set_xlabel('Time'); axes[1].grid(True, alpha=0.3)
plt.tight_layout(); plt.savefig('rigid_gyroscope.png', dpi=150, bbox_inches='tight'); plt.show()