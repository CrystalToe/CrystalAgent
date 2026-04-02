#!/usr/bin/env python3
"""Crystal Nuclear — Binding Energy Curve from SEMF"""
import crystal_toe as ct
import matplotlib.pyplot as plt
import numpy as np

toe = ct.Toe(); nuc = toe.nuclear()

fig, ax = plt.subplots(figsize=(12, 7))
fig.suptitle("Nuclear Binding Energy per Nucleon — SEMF with Crystal Exponents",
             fontsize=13, fontweight='bold')

# Get binding curve
curve = nuc.binding_curve(250)
a_vals = [c[0] for c in curve]
ba_vals = [c[1] for c in curve]
ax.plot(a_vals, ba_vals, 'b-', linewidth=1.5, label='SEMF B/A')

# Mark key nuclei
key_nuclei = [
    (4,   2,  'He-4',  '#e74c3c'),
    (12,  6,  'C-12',  '#e67e22'),
    (16,  8,  'O-16',  '#f1c40f'),
    (56,  26, 'Fe-56', '#2ecc71'),
    (208, 82, 'Pb-208','#3498db'),
    (238, 92, 'U-238', '#9b59b6'),
]
for a, z, name, color in key_nuclei:
    ba = nuc.binding_per_nucleon(a, z)
    ax.plot(a, ba, 'o', color=color, markersize=10, zorder=5)
    ax.annotate(f'{name}\nB/A={ba:.2f}', xy=(a, ba),
                xytext=(a + 8, ba + 0.3),
                fontsize=9, fontweight='bold', color=color,
                arrowprops=dict(arrowstyle='->', color=color))

# Mark iron peak
peak_a, peak_ba = nuc.peak_nucleus(250)
ax.axvline(x=peak_a, color='green', linewidth=1, linestyle=':', alpha=0.5)
ax.axhline(y=peak_ba, color='green', linewidth=1, linestyle=':', alpha=0.5)

# Annotate Crystal exponents
ax.text(0.98, 0.05,
        f'Crystal SEMF exponents:\n'
        f'  Surface: A^({nuc.surface_exp()[0]}/{nuc.surface_exp()[1]}) = A^(N_w/N_c)\n'
        f'  Coulomb: A^(-{nuc.coulomb_exp()[0]}/{nuc.coulomb_exp()[1]}) = A^(-1/N_c)\n'
        f'  Pairing: A^(-{nuc.pairing_exp()[0]}/{nuc.pairing_exp()[1]}) = A^(-1/N_w)\n'
        f'  Fe peak: A={nuc.iron_peak()} = d_colour·β₀',
        transform=ax.transAxes, fontsize=9, fontfamily='monospace',
        ha='right', va='bottom',
        bbox=dict(boxstyle='round', facecolor='lightyellow', alpha=0.8))

ax.set_xlabel('Mass number A', fontsize=12)
ax.set_ylabel('B/A (MeV)', fontsize=12)
ax.set_ylim(0, 9.5)
ax.legend(fontsize=11)
ax.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('nuclear_binding.png', dpi=150, bbox_inches='tight'); plt.show()
