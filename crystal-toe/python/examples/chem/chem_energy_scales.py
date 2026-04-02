#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Chem — Energy Scales from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt
import numpy as np

toe = ct.Toe(); ch = toe.chem()

fig, axes = plt.subplots(1, 2, figsize=(14, 7))
fig.suptitle("Crystal Chemistry — Energy & Length Scales from α = 1/((D+1)π + ln β₀)",
             fontsize=13, fontweight='bold')

# ── Left: Energy scale ladder ──
ax = axes[0]
energies = {
    f'Hartree E_H = α²m_ec²':           ch.hartree_ev(),
    f'Rydberg Ry = E_H/N_w':            ch.rydberg_ev(),
    f'H-bond = α·E_H':                  ch.e_hbond(),
    f'kT(300K)':                         ch.kt_300(),
    f'ε_vdW = α·E_H/N_c²':             ch.eps_vdw(),
}
names = list(energies.keys())
vals = list(energies.values())
colors = ['#e74c3c', '#c0392b', '#3498db', '#2ecc71', '#27ae60']
y_pos = np.arange(len(names))

bars = ax.barh(y_pos, vals, color=colors, edgecolor='black', linewidth=0.8, height=0.6)
for bar, v in zip(bars, vals):
    ax.text(bar.get_width() + 0.3, bar.get_y() + bar.get_height()/2,
            f'{v:.4f} eV', va='center', fontsize=10, fontweight='bold')
ax.set_yticks(y_pos)
ax.set_yticklabels(names, fontsize=9)
ax.set_xlabel('Energy (eV)')
ax.set_title('Energy Scale Ladder')
ax.set_xlim(0, max(vals) * 1.4)

# ── Right: Thermal-VdW coincidence ──
ax = axes[1]
temps = np.linspace(100, 600, 200)
kt_vals = 8.617333e-5 * temps  # kT in eV

eps = ch.eps_vdw()
ax.axhline(y=eps, color='#e74c3c', linewidth=2.5, linestyle='--',
           label=f'ε_vdW = α·E_H/N_c² = {eps:.4f} eV')
ax.plot(temps, kt_vals, color='#3498db', linewidth=2.5,
        label='kT(T)')
ax.axvline(x=300, color='#7f8c8d', linewidth=1, linestyle=':')
ax.plot(300, ch.kt_300(), 'ko', markersize=10, zorder=5)
ax.annotate(f'300 K: kT = {ch.kt_300():.4f} eV\nratio = {ch.vdw_kt_ratio():.2f}',
            xy=(300, ch.kt_300()), xytext=(380, ch.kt_300() + 0.008),
            fontsize=10, fontweight='bold',
            arrowprops=dict(arrowstyle='->', color='black'))

ax.set_xlabel('Temperature (K)')
ax.set_ylabel('Energy (eV)')
ax.set_title('Crystal Prediction: ε_vdW ≈ kT at Biological T')
ax.legend(fontsize=10)
ax.set_ylim(0, 0.06)

plt.tight_layout()
plt.savefig('chem_energy_scales.png', dpi=150, bbox_inches='tight'); plt.show()