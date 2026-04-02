#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Rigid — Asymmetric Top: intermediate axis instability"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); rg = toe.rigid()
# Spin around intermediate axis (unstable!)
ens_int, lms_int, _ = rg.simulate(1.0, 2.0, 3.0, 0.01, 1.0, 0.01, 0.001, 30000)
# Spin around max axis (stable)
ens_max, lms_max, _ = rg.simulate(1.0, 2.0, 3.0, 0.01, 0.01, 1.0, 0.001, 30000)
# Spin around min axis (stable)
ens_min, lms_min, _ = rg.simulate(1.0, 2.0, 3.0, 1.0, 0.01, 0.01, 0.001, 30000)

fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle("Crystal Rigid — Intermediate Axis Theorem\nAsymmetric top: rotation around I_mid is unstable", fontsize=13, fontweight='bold')

t = np.arange(len(ens_min)) * 0.001
axes[0].plot(t, ens_min, 'b-', linewidth=0.5); axes[0].set_title('Min axis (stable)'); axes[0].grid(True, alpha=0.3)
axes[1].plot(t, ens_int, 'r-', linewidth=0.5); axes[1].set_title('Intermediate axis (UNSTABLE)'); axes[1].grid(True, alpha=0.3)
axes[2].plot(t, ens_max, 'g-', linewidth=0.5); axes[2].set_title('Max axis (stable)'); axes[2].grid(True, alpha=0.3)
for ax in axes: ax.set_xlabel('Time'); ax.set_ylabel('KE')
plt.tight_layout(); plt.savefig('rigid_asymmetric.png', dpi=150, bbox_inches='tight'); plt.show()