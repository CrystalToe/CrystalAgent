#!/usr/bin/env python3
"""Crystal Friedmann — Every Integer from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); fr = toe.friedmann()
fig, ax = plt.subplots(figsize=(10, 8))
fig.suptitle(f"Crystal Friedmann — Every Integer from (N_w, N_c) = ({fr.n_w()}, {fr.n_c()})", fontsize=14, fontweight='bold')
ax.axis('off')
rows = [
    ("Ω_Λ numerator",   "13", "gauss = N_c² + N_w²"),
    ("Ω_Λ denominator",  "19", "gauss + χ"),
    ("Ω_m numerator",    "6",  "χ = N_w × N_c"),
    ("100θ* denominator","96", "N_w(D+χ) = 2×48"),
    ("T_CMB",            "19/7","(gauss+χ)/β₀"),
    ("Age",              "97/7","(gauss·β₀+χ)/β₀"),
    ("A_s",              "21",  "N_c × β₀"),
    ("Matter exp",       "3",   "N_c (in 1/a³)"),
    ("Radiation exp",    "4",   "N_c+1 (in 1/a⁴)"),
    ("w_DE",             "−1",  "Landauer"),
    ("DM/b factor",      "12π/7","N_w²N_cπ/β₀"),
    ("H₀ factor",        "42/43","D/(Σ_d+β₀)"),
]
for i, (name, val, origin) in enumerate(rows):
    y = 0.95 - i * 0.075
    ax.text(0.02, y, name, fontsize=11, fontfamily='monospace', va='top', transform=ax.transAxes)
    ax.text(0.38, y, val, fontsize=11, fontfamily='monospace', va='top', fontweight='bold', color='crimson', transform=ax.transAxes)
    ax.text(0.52, y, f'= {origin}', fontsize=10, fontfamily='monospace', va='top', transform=ax.transAxes)
plt.savefig('friedmann_integers.png', dpi=150, bbox_inches='tight'); plt.show()
