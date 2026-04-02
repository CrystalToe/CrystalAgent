#!/usr/bin/env python3
"""Crystal MD — Polymer Scaling: Flory ν = N_w/(χ−1) = 2/5"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); md = toe.md()
N = np.logspace(1, 4, 100)
nu = md.flory_nu()
R_flory = N**nu

fig, axes = plt.subplots(1, 2, figsize=(14, 6))
fig.suptitle(f"Crystal MD — Polymer Scaling\nR ~ N^ν, Flory ν = N_w/(χ−1) = {md.flory_nu():.1f}", fontsize=13, fontweight='bold')

axes[0].loglog(N, R_flory, 'b-', linewidth=2, label=f'ν = {nu} (good solvent)')
axes[0].loglog(N, N**0.5, 'r--', linewidth=1, label='ν = 1/2 (ideal)')
axes[0].loglog(N, N**(1/3), 'g--', linewidth=1, label='ν = 1/3 (collapsed)')
axes[0].set_xlabel('Chain length N'); axes[0].set_ylabel('End-to-end R')
axes[0].set_title('Polymer Scaling Laws'); axes[0].legend(); axes[0].grid(True, alpha=0.3)

axes[1].axis('off')
for i, l in enumerate([f"Flory exponent ν = N_w/(χ−1) = 2/5 = 0.4",
    f"  Good solvent (real polymer in water)", "",
    f"ν = 1/2 = 1/N_w: ideal chain (theta solvent)",
    f"ν = 1/N_c: collapsed globule", "",
    f"R ~ N^ν, N = # monomers", f"Same 2/5 as von Karman κ in turbulence!"]):
    axes[1].text(0.05, 0.95-i*0.11, l, transform=axes[1].transAxes, fontsize=12, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('md_polymer.png', dpi=150, bbox_inches='tight'); plt.show()
