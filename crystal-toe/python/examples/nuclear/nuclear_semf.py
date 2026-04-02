#!/usr/bin/env python3
"""Crystal Nuclear — SEMF Term Decomposition"""
import crystal_toe as ct
import matplotlib.pyplot as plt
import numpy as np

toe = ct.Toe(); nuc = toe.nuclear()
nw, nc = float(nuc.n_w()), float(nuc.n_c())

fig, ax = plt.subplots(figsize=(12, 7))
fig.suptitle("SEMF Decomposition — Each Term Uses Crystal Exponents",
             fontsize=13, fontweight='bold')

a_range = np.arange(10, 251)
# Compute each SEMF term along the valley of stability
vol, surf, coul, asym, pair_arr = [], [], [], [], []
for a in a_range:
    af = float(a)
    z = float(nuc.optimal_z(int(a)))
    vol.append(15.8 * af / af)  # per nucleon
    surf.append(18.3 * af**(nw/nc) / af)
    coul.append(0.714 * z*(z-1) / af**(1/nc) / af)
    asym.append(23.2 * (af - nw*z)**2 / af / af)
    dp = 12.0 if a % 2 == 0 else 0.0
    pair_arr.append(dp / af**(1/nw) / af)

ax.fill_between(a_range, 0, vol, alpha=0.3, color='#2ecc71', label=f'Volume: a_V (constant)')
ax.plot(a_range, surf, 'r-', linewidth=2, label=f'Surface: A^(N_w/N_c−1)')
ax.plot(a_range, coul, 'b-', linewidth=2, label=f'Coulomb: Z²/A^(1+1/N_c)')
ax.plot(a_range, asym, 'm-', linewidth=2, label=f'Asymmetry: (A−N_w·Z)²/A²')

# Net B/A
ba = [nuc.binding_per_nucleon(int(a), nuc.optimal_z(int(a))) for a in a_range]
ax.plot(a_range, ba, 'k-', linewidth=3, label='Net B/A')

ax.axvline(x=56, color='green', linewidth=1.5, linestyle='--', alpha=0.6, label='Fe-56 = d_colour·β₀')
ax.set_xlabel('Mass number A', fontsize=12)
ax.set_ylabel('Energy per nucleon (MeV)', fontsize=12)
ax.legend(fontsize=10, loc='right')
ax.set_ylim(0, 17)
ax.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('nuclear_semf.png', dpi=150, bbox_inches='tight'); plt.show()
