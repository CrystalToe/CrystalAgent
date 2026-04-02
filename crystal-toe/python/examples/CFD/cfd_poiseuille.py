#!/usr/bin/env python3
"""Crystal CFD — Poiseuille Channel Flow: LBM D2Q9 = N_c²"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); cfd = toe.cfd()
ny = 20; tau = 0.8; fx = 1e-6
num, ana = cfd.poiseuille(4, ny, tau, fx, 8000)

fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle(f"Crystal CFD — Poiseuille Flow (LBM D2Q9)\nToe(v={toe.vev():.0f} MeV) → cfd() | "
             f"D2Q9 = {cfd.d2q9_velocities()} = N_c², c_s² = 1/N_c", fontsize=13, fontweight='bold')
y = np.arange(ny)
axes[0].plot(num, y, 'bo-', markersize=4, label='LBM')
axes[0].plot(ana, y, 'r--', linewidth=2, label='Analytical')
axes[0].set_xlabel('u_x'); axes[0].set_ylabel('y'); axes[0].set_title('Velocity Profile')
axes[0].legend(); axes[0].grid(True, alpha=0.3)

err = [abs(n-a)/(abs(a)+1e-20) if abs(a) > 1e-15 else 0 for n,a in zip(num, ana)]
axes[1].plot(err, y, 'purple', linewidth=2)
axes[1].set_xlabel('Relative Error'); axes[1].set_ylabel('y'); axes[1].set_title('Error vs Analytical')
axes[1].grid(True, alpha=0.3)

axes[2].axis('off')
for i, l in enumerate([f"D2Q9 = {cfd.d2q9_velocities()} = N_c² = {cfd.n_c()}²",
    f"c_s² = 1/N_c = 1/{cfd.n_c()}", f"w_rest = N_w²/N_c² = 4/9",
    f"w_card = 1/N_c² = 1/9", f"w_diag = 1/Σ_d = 1/36",
    f"ν = c_s²(τ−½) = (τ−½)/N_c", "", f"Collision = W (BGK)", f"Streaming = U (propagate)",
    f"Tick = W∘U = crystal monad"]):
    axes[2].text(0.05, 0.95-i*0.09, l, transform=axes[2].transAxes, fontsize=11, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('cfd_poiseuille.png', dpi=150, bbox_inches='tight'); plt.show()
