#!/usr/bin/env python3
"""Crystal Friedmann — Comoving & Luminosity Distances"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); fr = toe.friedmann()
z_vals = np.linspace(0.01, 3.0, 100)
d_c = [fr.comoving_distance(z, 10000) for z in z_vals]
d_l = [fr.luminosity_distance(z, 10000) for z in z_vals]

fig, axes = plt.subplots(1, 2, figsize=(14, 6))
fig.suptitle("Crystal Friedmann — Cosmic Distances", fontsize=13, fontweight='bold')

axes[0].plot(z_vals, d_c, 'b-', linewidth=2, label='Comoving d_C')
axes[0].plot(z_vals, d_l, 'r-', linewidth=2, label='Luminosity d_L')
axes[0].set_xlabel('Redshift z'); axes[0].set_ylabel('Distance (c/H₀)')
axes[0].set_title('Distance-Redshift'); axes[0].legend(); axes[0].grid(True, alpha=0.3)

# Hubble diagram (magnitude vs z)
mu = [5*np.log10(dl*3000) + 25 if dl > 0 else 0 for dl in d_l]  # distance modulus
axes[1].plot(z_vals, mu, 'purple', linewidth=2)
axes[1].set_xlabel('Redshift z'); axes[1].set_ylabel('Distance modulus μ')
axes[1].set_title('Hubble Diagram (Type Ia SNe)'); axes[1].grid(True, alpha=0.3)
plt.tight_layout(); plt.savefig('friedmann_distances.png', dpi=150, bbox_inches='tight'); plt.show()
