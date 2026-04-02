#!/usr/bin/env python3
"""Crystal Chem — Orbital Shell Filling from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import numpy as np

toe = ct.Toe(); ch = toe.chem()

fig, axes = plt.subplots(1, 2, figsize=(14, 7))
fig.suptitle("Crystal Orbital Structure — All Capacities from (2,3)", fontsize=14, fontweight='bold')

# ── Left: Subshell capacities bar chart ──
ax = axes[0]
labels = ['s (l=0)', 'p (l=1)', 'd (l=2)', 'f (l=3)']
caps = [ch.subshell_capacity(l) for l in range(4)]
formulas = ['N_w', 'χ', 'N_w(χ−1)', 'N_w·β₀']
colors = ['#e74c3c', '#3498db', '#2ecc71', '#f39c12']
bars = ax.bar(labels, caps, color=colors, edgecolor='black', linewidth=1.2)
for bar, cap, form in zip(bars, caps, formulas):
    ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.3,
            f'{cap} = {form}', ha='center', fontsize=10, fontweight='bold')
ax.set_ylabel('Electron capacity N_w(2l+1)')
ax.set_title('Subshell Capacities')
ax.set_ylim(0, 17)

# ── Right: Shell capacity N_w·n² ──
ax = axes[1]
ns = np.arange(1, 6)
shell_caps = [ch.shell_capacity(int(n)) for n in ns]
ax.bar(ns, shell_caps, color='#9b59b6', edgecolor='black', linewidth=1.2)
# Overlay the N_w·n² curve
n_cont = np.linspace(0.5, 5.5, 100)
ax.plot(n_cont, ch.n_w() * n_cont**2, 'r--', linewidth=2, label='N_w·n²')
for n, sc in zip(ns, shell_caps):
    ax.text(n, sc + 1, str(sc), ha='center', fontsize=11, fontweight='bold')
ax.set_xlabel('Principal quantum number n')
ax.set_ylabel('Shell capacity 2n²')
ax.set_title('Shell Filling: N_w·n²')
ax.legend(fontsize=11)
ax.set_ylim(0, 55)

plt.tight_layout()
plt.savefig('chem_orbitals.png', dpi=150, bbox_inches='tight'); plt.show()
