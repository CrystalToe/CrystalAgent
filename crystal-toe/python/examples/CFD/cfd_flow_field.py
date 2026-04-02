#!/usr/bin/env python3
"""Crystal CFD — LBM Flow Field Visualization"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); cfd = toe.cfd()
nx, ny = 30, 15
rho_field, speed_field = cfd.simulate(nx, ny, 0.7, 5e-5, 3000)

rho = np.array(rho_field).reshape(nx, ny)
speed = np.array(speed_field).reshape(nx, ny)

fig, axes = plt.subplots(1, 2, figsize=(14, 5))
fig.suptitle(f"Crystal CFD — LBM Flow Field ({nx}×{ny})\nD2Q9 = {cfd.d2q9_velocities()} = N_c²", fontsize=13, fontweight='bold')

im1 = axes[0].imshow(rho.T, origin='lower', cmap='viridis', aspect='auto')
plt.colorbar(im1, ax=axes[0]); axes[0].set_title('Density Field'); axes[0].set_xlabel('x'); axes[0].set_ylabel('y')

im2 = axes[1].imshow(speed.T, origin='lower', cmap='hot', aspect='auto')
plt.colorbar(im2, ax=axes[1]); axes[1].set_title('Speed Field |u|'); axes[1].set_xlabel('x'); axes[1].set_ylabel('y')

plt.tight_layout(); plt.savefig('cfd_flow_field.png', dpi=150, bbox_inches='tight'); plt.show()
