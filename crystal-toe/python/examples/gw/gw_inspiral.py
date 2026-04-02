#!/usr/bin/env python3
"""Crystal GW — Binary Black Hole Inspiral Waveform"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe()
gw = toe.gw()
m1, m2 = 30.0, 30.0
mc = gw.chirp_mass(m1, m2)
f_isco = gw.isco_frequency(m1+m2)
print(f"Chirp mass: {mc:.2f}, Peters: {gw.peters_coefficient():.1f} = 32/5 = N_w^5/(chi-1)")

times, freqs, hp, hx = gw.inspiral_waveform(m1, m2, 1e6, 0.3, f_isco/50, 0.5)

fig, axes = plt.subplots(2, 2, figsize=(16, 10))
fig.suptitle(f"Crystal GW — BBH Inspiral ({m1:.0f}+{m2:.0f} M☉)\n"
             f"Toe(v={toe.vev():.0f} MeV) → gw() | Peters=32/5, chirp=5/3", fontsize=13, fontweight='bold')
axes[0][0].plot(times, hp, 'b-', linewidth=0.3); axes[0][0].set_title('h₊'); axes[0][0].grid(True, alpha=0.3)
axes[0][1].plot(times, hx, 'r-', linewidth=0.3); axes[0][1].set_title('h×'); axes[0][1].grid(True, alpha=0.3)
axes[1][0].plot(times, freqs, 'purple', linewidth=1); axes[1][0].set_title('Frequency Chirp'); axes[1][0].grid(True, alpha=0.3)
axes[1][1].axis('off')
for i, l in enumerate([f"Peters = 32/5 = N_w⁵/(χ−1)", f"Chirp = 5/3 = (χ−1)/N_c",
    f"Polarizations = {gw.gw_polarizations()} = N_c−1", f"Amplitude = {gw.amplitude_factor()} = N_w²",
    f"ISCO = {gw.chi()} GM = χ", "", "Every coefficient from (2,3)."]):
    axes[1][1].text(0.05, 0.95-i*0.12, l, transform=axes[1][1].transAxes, fontsize=12, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('gw_inspiral.png', dpi=150, bbox_inches='tight'); plt.show()
