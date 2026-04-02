#!/usr/bin/env python3
"""Crystal Decay — Neutron Beta Spectrum: Γ = G_F²E⁵/(192π³)"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); dc = toe.decay()
t_arr, spec = dc.beta_spectrum_curve(500)

fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle(f"Crystal Decay — Neutron Beta Spectrum\n192 = d_mixed×d_colour, G_F from muon via 192π³", fontsize=13, fontweight='bold')
axes[0].plot(t_arr, spec, 'b-', linewidth=2); axes[0].fill_between(t_arr, 0, spec, alpha=0.2)
axes[0].axvline(dc.beta_endpoint(), color='r', linestyle='--', label=f'Endpoint = {dc.beta_endpoint():.3f} MeV')
axes[0].set_xlabel('T_e (MeV)'); axes[0].set_ylabel('dΓ/dT'); axes[0].set_title('Beta Spectrum Shape')
axes[0].legend(); axes[0].grid(True, alpha=0.3)

print(f"G_F = {dc.g_fermi():.6e} GeV⁻² (PDG: 1.1664e-5)")
print(f"τ_n = {dc.neutron_lifetime():.1f} s (exp: ~878 s)")
print(f"Endpoint = {dc.beta_endpoint():.3f} MeV")

# Kurie plot: √(dΓ/(pEF)) should be linear
axes[1].plot(t_arr, [np.sqrt(s+1e-30) for s in spec], 'purple', linewidth=2)
axes[1].set_xlabel('T_e (MeV)'); axes[1].set_ylabel('√(dΓ/dT)'); axes[1].set_title('Kurie Plot')
axes[1].grid(True, alpha=0.3)

axes[2].axis('off')
for i, l in enumerate([f"β constant = {dc.beta_factor()} = d_mixed×d_colour",
    f"G_F = {dc.g_fermi():.4e} GeV⁻²", f"τ_n = {dc.neutron_lifetime():.1f} s",
    f"Endpoint = {dc.beta_endpoint():.3f} MeV", "",
    f"Γ = G_F²m_e⁵(1+3λ²)fV_ud²/(2π³)", f"192 appears in denominator",
    f"192 = 24 × 8 = d_mixed × d_colour"]):
    axes[2].text(0.05, 0.95-i*0.11, l, transform=axes[2].transAxes, fontsize=11, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('decay_beta.png', dpi=150, bbox_inches='tight'); plt.show()
