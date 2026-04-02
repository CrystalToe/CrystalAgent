#!/usr/bin/env python3
"""Crystal Decay — Phase Space Dimensions: 3N−4 = N_c·N−(N_c+1)"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); dc = toe.decay()
n_final = list(range(2, 10))
dims = [dc.phase_space_dim(n) for n in n_final]

fig, axes = plt.subplots(1, 2, figsize=(14, 6))
fig.suptitle("Crystal Decay — Phase Space Dimensions\ndim = N_c·N − (N_c+1) = 3N − 4", fontsize=13, fontweight='bold')

axes[0].bar([str(n) for n in n_final], dims, color='royalblue')
for n, d in zip(n_final, dims):
    axes[0].text(n_final.index(n), d+0.3, str(d), ha='center', fontsize=10, fontweight='bold')
axes[0].set_xlabel('N (final-state particles)'); axes[0].set_ylabel('Phase space dim')
axes[0].set_title('dim = 3N − 4'); axes[0].grid(True, alpha=0.3, axis='y')

axes[1].axis('off')
for i, l in enumerate([f"N=2: dim = {dc.phase_space_dim(2)} (2-body)",
    f"N=3: dim = {dc.phase_space_dim(3)} = χ−1 (3-body)",
    f"N=4: dim = {dc.phase_space_dim(4)} = d_colour (4-body)", "",
    f"dim = N_c·N − (N_c+1)", f"    = {dc.n_c()}·N − {dc.n_c()+1}", "",
    f"N_c = {dc.n_c()} spatial dimensions", f"N_c+1 = {dc.n_c()+1} conservation laws",
    f"(energy + {dc.n_c()} momentum)"]):
    axes[1].text(0.05, 0.95-i*0.09, l, transform=axes[1].transAxes, fontsize=12, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('decay_phase_space.png', dpi=150, bbox_inches='tight'); plt.show()
