#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Chem — Arrhenius Kinetics & Noble Gases from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt
import numpy as np

toe = ct.Toe(); ch = toe.chem()

fig, axes = plt.subplots(1, 2, figsize=(14, 7))
fig.suptitle("Crystal Chemistry — Arrhenius & Noble Gases from (2,3)",
             fontsize=14, fontweight='bold')

# ── Left: Arrhenius rate vs barrier height ──
ax = axes[0]
ea_range = np.linspace(0.001, 1.0, 200)
kt_bio = ch.kt_300()

rates = [ch.arrhenius(ea, kt_bio) for ea in ea_range]
ax.semilogy(ea_range, rates, 'b-', linewidth=2.5, label=f'k(E_a) at T=300K')

# Mark key energies
markers = [
    (ch.eps_vdw(), 'ε_vdW = α·E_H/N_c²', '#2ecc71'),
    (ch.e_hbond(), 'E_hbond = α·E_H',     '#e74c3c'),
    (kt_bio,       'kT(300K)',              '#f39c12'),
]
for ea_mark, label, color in markers:
    rate_mark = ch.arrhenius(ea_mark, kt_bio)
    ax.plot(ea_mark, rate_mark, 'o', color=color, markersize=10, zorder=5)
    ax.annotate(f'{label}\n{ea_mark:.4f} eV',
                xy=(ea_mark, rate_mark),
                xytext=(ea_mark + 0.08, rate_mark * 3),
                fontsize=8, color=color, fontweight='bold',
                arrowprops=dict(arrowstyle='->', color=color, lw=1.5))

ax.set_xlabel('Activation energy E_a (eV)', fontsize=11)
ax.set_ylabel('Relative rate exp(−E_a/kT)', fontsize=11)
ax.set_title('Arrhenius: Thermal Activation at T=300K')
ax.legend(fontsize=10)
ax.set_ylim(1e-18, 2)
ax.grid(True, alpha=0.3)

# ── Right: Noble gas Z values ──
ax = axes[1]
gases = ch.noble_gases()
names = ['He', 'Ne', 'Ar', 'Kr']
formulas = ['N_w', 'N_w(χ−1)', 'N_w·N_c²', 'Σ_d']
colors = ['#e74c3c', '#3498db', '#2ecc71', '#9b59b6']

bars = ax.bar(names, gases, color=colors, edgecolor='black', linewidth=1.2, width=0.6)
for bar, z, form in zip(bars, gases, formulas):
    ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.8,
            f'Z={z}\n= {form}', ha='center', fontsize=10, fontweight='bold')

# Overlay the cumulative shell filling curve
cum = ch.cumulative_shells(7)
# Map cumulative to approximate noble gas positions
ax.axhline(y=ch.neutral_ph(), color='purple', linewidth=1.5, linestyle='--',
           label=f'pH = β₀ = {ch.neutral_ph()}', alpha=0.6)

ax.set_ylabel('Atomic number Z', fontsize=11)
ax.set_title('Noble Gas Closures — All from (2,3)')
ax.legend(fontsize=10)
ax.set_ylim(0, 42)

# Add self-test summary at bottom
passes, total, msgs = ch.self_test()
fig.text(0.5, 0.01,
         f'Self-test: {passes}/{total} PASS — {ch.observable_count()} observables from (2,3)',
         ha='center', fontsize=11, fontweight='bold',
         color='green' if passes == total else 'red')

plt.tight_layout(rect=[0, 0.03, 1, 0.95])
plt.savefig('chem_arrhenius.png', dpi=150, bbox_inches='tight'); plt.show()