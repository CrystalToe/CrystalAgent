#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Decay — Muon Decay: G_F² = 192π³/(τ_μ·m_μ⁵)"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); dc = toe.decay()
gf = dc.g_fermi()
print(f"G_F = {gf:.6e} GeV⁻² (PDG: 1.1664e-5)")
print(f"Beta constant = {dc.beta_factor()} = d_mixed × d_colour = 24 × 8")

# Decay rate vs energy for different particles
energies = np.linspace(0.01, 2.0, 200)
rates = [dc.beta_decay_rate(gf, E) for E in energies]

fig, axes = plt.subplots(1, 2, figsize=(14, 6))
fig.suptitle(f"Crystal Decay — Muon Decay & Fermi Constant\nG_F² = {dc.beta_factor()}π³/(τ_μ·m_μ⁵) where {dc.beta_factor()} = d_mixed×d_colour", fontsize=13, fontweight='bold')

axes[0].semilogy(energies, rates, 'b-', linewidth=2)
axes[0].set_xlabel('Energy (GeV)'); axes[0].set_ylabel('Decay Rate')
axes[0].set_title('β Decay Rate ∝ E⁵/(192π³)'); axes[0].grid(True, alpha=0.3)

axes[1].axis('off')
for i, l in enumerate([f"Muon decay: μ⁻ → e⁻ + ν̄_e + ν_μ",
    f"Γ = G_F²·m_μ⁵ / ({dc.beta_factor()}π³)", f"",
    f"G_F = {gf:.4e} GeV⁻²", f"G_F(PDG) = 1.1664×10⁻⁵ GeV⁻²",
    f"", f"{dc.beta_factor()} = d_mixed × d_colour",
    f"    = {dc.chi()*dc.n_w()*dc.n_w()} × {dc.n_w()**3}",
    f"    = (N_w³·N_c) × (N_w³)", f"    = 24 × 8"]):
    axes[1].text(0.05, 0.95-i*0.09, l, transform=axes[1].transAxes, fontsize=12, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('decay_muon.png', dpi=150, bbox_inches='tight'); plt.show()