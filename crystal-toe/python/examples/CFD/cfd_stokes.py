#!/usr/bin/env python3
"""Crystal CFD — Stokes Drag: F = 6πμrv where 6 = χ"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); cfd = toe.cfd()
v = np.linspace(0.01, 5, 200)
F = [cfd.stokes_drag_force(1.0, 0.01, vi) for vi in v]

fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle(f"Crystal CFD — Stokes Drag & Reynolds Number\nF = χπμrv = {cfd.chi()}πμrv, Stokes coeff = {cfd.stokes_drag()} = d_mixed", fontsize=13, fontweight='bold')

axes[0].plot(v, F, 'b-', linewidth=2)
axes[0].set_xlabel('Velocity'); axes[0].set_ylabel('Drag Force'); axes[0].set_title('Stokes Drag (μ=1, r=0.01)')
axes[0].grid(True, alpha=0.3)

Re = np.logspace(-1, 6, 500)
cd_stokes = cfd.stokes_drag() / Re  # C_D = 24/Re for Stokes
axes[1].loglog(Re, cd_stokes, 'r-', linewidth=2, label=f'C_D = {cfd.stokes_drag()}/Re')
axes[1].axhline(0.44, color='green', linestyle='--', label='Newton regime (C_D≈0.44)')
axes[1].set_xlabel('Re'); axes[1].set_ylabel('C_D'); axes[1].set_title('Drag Coefficient')
axes[1].set_ylim(1e-3, 1e3); axes[1].legend(); axes[1].grid(True, alpha=0.3)

radii = np.linspace(0.001, 0.1, 200)
terminal = [vi * 1.0 / (cfd.stokes_drag() * np.pi * 1e-3 * r) for r, vi in zip(radii, [0.001]*len(radii))]
axes[2].plot(radii*1000, [cfd.stokes_drag_force(1e-3, r, 0.01) for r in radii], 'purple', linewidth=2)
axes[2].set_xlabel('Radius (mm)'); axes[2].set_ylabel('Force'); axes[2].set_title('Drag vs Particle Size')
axes[2].grid(True, alpha=0.3)
plt.tight_layout(); plt.savefig('cfd_stokes.png', dpi=150, bbox_inches='tight'); plt.show()
