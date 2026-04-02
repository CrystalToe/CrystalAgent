#!/usr/bin/env python3
"""Crystal QFT — Phase Space: Φ₂ = 1/(8π) = 1/(d_colour·π)"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); qf = toe.qft()
fig, axes = plt.subplots(1, 2, figsize=(14, 6))
fig.suptitle("Crystal QFT — Phase Space & Thresholds", fontsize=13, fontweight='bold')

masses = {'e': 0.511e-3, 'μ': 0.1057, 'τ': 1.777, 'c': 1.27, 'b': 4.18, 't': 173.0}
thresholds = {k: qf.pair_threshold(m) for k, m in masses.items()}
axes[0].barh(list(thresholds.keys()), list(thresholds.values()), color='royalblue')
axes[0].set_xlabel('√s threshold (GeV)'); axes[0].set_title(f'Pair Threshold = N_w·m = 2m')
axes[0].set_xscale('log'); axes[0].grid(True, alpha=0.3, axis='x')

n_final = list(range(2, 10))
dims = [qf.n_c()*n - (qf.n_c()+1) for n in n_final]
axes[1].bar([str(n) for n in n_final], dims, color='coral')
axes[1].set_xlabel('Final-state particles'); axes[1].set_ylabel('Phase space dim')
axes[1].set_title(f'dim = N_c·n − (N_c+1) = 3n−4'); axes[1].grid(True, alpha=0.3, axis='y')
plt.tight_layout(); plt.savefig('qft_phase_space.png', dpi=150, bbox_inches='tight'); plt.show()
