#!/usr/bin/env python3
"""Crystal QFT — e⁺e⁻→μ⁺μ⁻: σ = N_w²πα²/(N_c·s)"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); qf = toe.qft()
ss, sigmas = qf.sigma_curve(2.0, 200.0, 500)

fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle(f"Crystal QFT — e⁺e⁻ → μ⁺μ⁻\nσ = {qf.spacetime_dim()}πα²/({qf.n_c()}s) where {qf.spacetime_dim()}=N_w², {qf.n_c()}=N_c",
             fontsize=13, fontweight='bold')
axes[0].loglog(ss, sigmas, 'b-', linewidth=2)
axes[0].set_xlabel('√s (GeV)'); axes[0].set_ylabel('σ (nb)')
axes[0].set_title('QED Cross-Section (∝ 1/s)'); axes[0].grid(True, alpha=0.3)

axes[1].plot(ss, [s**2 * sig for s, sig in zip(ss, sigmas)], 'r-', linewidth=2)
axes[1].set_xlabel('√s (GeV)'); axes[1].set_ylabel('s·σ (nb·GeV²)')
axes[1].set_title('s·σ = const (point-like)'); axes[1].grid(True, alpha=0.3)

axes[2].axis('off')
for i, l in enumerate([f"σ = N_w²πα²/(N_c·s) × ℏ²c²", f"  N_w² = {qf.spacetime_dim()} (spacetime)",
    f"  N_c = {qf.n_c()} (colour)", f"  α⁻¹ = {qf.alpha_inv():.3f} = (D+1)π + ln(β₀)",
    f"", f"Thomson σ_T = (d_colour/N_c)πr_e²",
    f"  = (8/3)πr_e² = {qf.thomson_cs():.4e} barn", "",
    f"Pair threshold = N_w·m = 2m"]):
    axes[2].text(0.05, 0.95-i*0.1, l, transform=axes[2].transAxes, fontsize=11, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('qft_cross_section.png', dpi=150, bbox_inches='tight'); plt.show()
