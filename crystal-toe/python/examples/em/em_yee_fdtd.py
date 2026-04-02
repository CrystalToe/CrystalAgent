#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal EM — Yee FDTD: Gaussian pulse propagation at c = χ/χ = 1"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); em = toe.em()
print(f"EM components: {em.em_components()} = χ, Maxwell: {em.maxwell_equations()} = N_c+1")

ey_snaps, energies = em.simulate_pulse(300, 0.3, 0.04, 1.0, 0.5, 400, 50)

fig, axes = plt.subplots(2, 2, figsize=(16, 10))
fig.suptitle(f"Crystal EM — Yee FDTD\nToe(v={toe.vev():.0f} MeV) → em() | "
             f"{em.em_components()} components = χ, c = χ/χ = 1", fontsize=13, fontweight='bold')
x = np.linspace(0, 1, len(ey_snaps[0]))
for i, idx in enumerate([0, len(ey_snaps)//3, 2*len(ey_snaps)//3, -1]):
    axes[0][0].plot(x, ey_snaps[idx], linewidth=1, label=f'snap {idx}', alpha=0.8)
axes[0][0].set_title('E_y Propagation'); axes[0][0].legend(fontsize=8); axes[0][0].grid(True, alpha=0.3)

axes[0][1].plot(range(len(energies)), energies, 'purple', linewidth=2)
axes[0][1].set_title(f'Energy Conservation (dev={(energies[-1]-energies[0])/energies[0]:.2e})')
axes[0][1].grid(True, alpha=0.3)

# Waterfall plot
for i, ey in enumerate(ey_snaps):
    axes[1][0].plot(x, np.array(ey) + i*0.3, 'b-', linewidth=0.5, alpha=0.7)
axes[1][0].set_title('Waterfall (E_y + offset)'); axes[1][0].grid(True, alpha=0.3)

axes[1][1].axis('off')
for i, l in enumerate([f"Components = χ = {em.em_components()}", f"Maxwell = N_c+1 = {em.maxwell_equations()}",
    f"Polarizations = N_c−1 = {em.polarization_states()}", f"c = χ/χ = 1 (Lieb-Robinson)",
    f"Yee = monad W∘U on EM sector", f"CFL: dt/dx ≤ 1", "", "All from (2,3)."]):
    axes[1][1].text(0.05, 0.95-i*0.11, l, transform=axes[1][1].transAxes, fontsize=12, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('em_yee_fdtd.png', dpi=150, bbox_inches='tight'); plt.show()