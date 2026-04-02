#!/usr/bin/env python3
"""Crystal GW — Frequency Evolution and ISCO Cutoff"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); gw = toe.gw()
fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle(f"Crystal GW — Frequency Evolution\nISCO cutoff at f = 1/(χ^(3/2)πM), χ = {gw.chi()}", fontsize=13, fontweight='bold')

masses = [20, 40, 60, 80, 100]
for M in masses:
    f_isco = gw.isco_frequency(float(M))
    axes[0].bar(str(M), f_isco, color='royalblue', alpha=0.7)
axes[0].set_xlabel('Total Mass (M☉)'); axes[0].set_ylabel('f_ISCO'); axes[0].set_title('ISCO Frequency vs Mass'); axes[0].grid(True, alpha=0.3, axis='y')

m1, m2 = 30.0, 30.0; mc = gw.chirp_mass(m1, m2)
f_vals = np.logspace(-4, -1, 200)
dfdt = [gw.chirp_rate(mc, f) for f in f_vals]
axes[1].loglog(f_vals, dfdt, 'purple', linewidth=2)
axes[1].set_xlabel('f_GW'); axes[1].set_ylabel('df/dt'); axes[1].set_title('Chirp Rate (df/dt ∝ f^(11/3))'); axes[1].grid(True, alpha=0.3)

ttm = [gw.time_to_merger(mc, f) for f in f_vals]
axes[2].loglog(f_vals, ttm, 'darkred', linewidth=2)
axes[2].set_xlabel('f_GW'); axes[2].set_ylabel('Time to Merger'); axes[2].set_title('Merger Countdown'); axes[2].grid(True, alpha=0.3)
plt.tight_layout(); plt.savefig('gw_frequency.png', dpi=150, bbox_inches='tight'); plt.show()
