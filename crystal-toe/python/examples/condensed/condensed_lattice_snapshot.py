#!/usr/bin/env python3
"""Crystal Condensed — Ising Lattice Snapshots: ordered vs disordered"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); cm = toe.condensed()
tc = cm.onsager_tc()

fig, axes = plt.subplots(1, 3, figsize=(18, 5))
fig.suptitle(f"Crystal Condensed — Ising Lattice Snapshots (simulated)", fontsize=13, fontweight='bold')

for idx, (T, title) in enumerate([(1.0, f'T=1.0 (ordered)'), (tc, f'T=T_c={tc:.2f}'), (5.0, f'T=5.0 (disordered)')]):
    mags, _ = cm.ising_simulate(32, 1.0/T, 500, 100)
    # Create synthetic lattice visualization from magnetization
    n = 32
    np.random.seed(42)
    if T < tc:
        grid = np.sign(np.random.randn(n,n) + mags[-1]*3)
    else:
        grid = np.sign(np.random.randn(n,n))
    axes[idx].imshow(grid, cmap='coolwarm', interpolation='nearest', vmin=-1, vmax=1)
    axes[idx].set_title(f'{title}\n|M|≈{abs(mags[-1]):.2f}')
    axes[idx].axis('off')

plt.tight_layout(); plt.savefig('condensed_lattice.png', dpi=150, bbox_inches='tight'); plt.show()
