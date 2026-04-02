#!/usr/bin/env python3
"""Crystal Decay — Neutrino Oscillations: sin²(2θ₂₃) = 120/121"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); dc = toe.decay()
l_over_e = np.linspace(0, 2000, 1000)
p_atm = [dc.oscill_prob(dc.sin2_2theta_23(), 2.5e-3, le) for le in l_over_e]
p_sol = [dc.oscill_prob(4*dc.sin2_theta_12()*(1-dc.sin2_theta_12()), 7.5e-5, le) for le in l_over_e]

fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle(f"Crystal Decay — Neutrino Oscillations\nsin²(2θ₂₃) = 120/121 = 4·(χ/(2χ−1))·((χ−1)/(2χ−1))", fontsize=13, fontweight='bold')

axes[0].plot(l_over_e, p_atm, 'b-', linewidth=1, label='Atmospheric (Δm²₃₂)')
axes[0].plot(l_over_e, p_sol, 'r-', linewidth=1, label='Solar (Δm²₂₁)')
axes[0].set_xlabel('L/E (km/GeV)'); axes[0].set_ylabel('P(ν_μ→ν_τ)')
axes[0].set_title('Oscillation Probability'); axes[0].legend(); axes[0].grid(True, alpha=0.3)

# Baseline scan for T2K-like
baselines = np.linspace(100, 1000, 200)
p_base = [dc.oscill_prob(dc.sin2_2theta_23(), 2.5e-3, L/0.6) for L in baselines]
axes[1].plot(baselines, p_base, 'purple', linewidth=2)
axes[1].axvline(295, color='green', linestyle='--', label='T2K (295 km)')
axes[1].set_xlabel('Baseline L (km)'); axes[1].set_ylabel('P (E=0.6 GeV)')
axes[1].set_title('Baseline Scan'); axes[1].legend(); axes[1].grid(True, alpha=0.3)

axes[2].axis('off')
for i, l in enumerate([f"sin²θ₂₃ = χ/(2χ−1) = 6/11 = {dc.sin2_theta_23():.4f}",
    f"sin²(2θ₂₃) = 120/121 = {dc.sin2_2theta_23():.6f}",
    f"sin²θ₁₂ = N_c/π² = 3/π² = {dc.sin2_theta_12():.4f}",
    f"sin²θ_W = N_c/gauss = 3/13 = {dc.sin2_theta_w():.4f}",
    "", f"PDG values:", f"  θ₂₃: 0.545  (crystal: {dc.sin2_theta_23():.4f})",
    f"  θ₁₂: 0.307  (crystal: {dc.sin2_theta_12():.4f})",
    f"  θ_W: 0.231  (crystal: {dc.sin2_theta_w():.4f})"]):
    axes[2].text(0.05, 0.95-i*0.1, l, transform=axes[2].transAxes, fontsize=11, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('decay_oscillations.png', dpi=150, bbox_inches='tight'); plt.show()
