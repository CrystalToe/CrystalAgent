#!/usr/bin/env python3
"""Crystal Friedmann — CMB Parameters: all from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); fr = toe.friedmann()
fig, ax = plt.subplots(figsize=(12, 8))
fig.suptitle("Crystal Friedmann — CMB & Cosmological Parameters", fontsize=14, fontweight='bold')
ax.axis('off')
rows = [
    ("Ω_Λ",        f"{fr.omega_lambda():.4f}", "gauss/(gauss+χ) = 13/19",    "0.6847"),
    ("Ω_m",        f"{fr.omega_matter():.4f}", "χ/(gauss+χ) = 6/19",         "0.3153"),
    ("Ω_b",        f"{fr.omega_baryon():.4f}", "Ω_m·β₀/(β₀+12π)",            "0.0493"),
    ("DM/baryon",   f"{fr.dm_baryon_ratio():.3f}", "12π/β₀ = N_w²N_cπ/β₀",   "5.36"),
    ("H₀",         f"{fr.h0_crystal():.2f}",   "100D/(Σ_d+β₀)",              "67.4"),
    ("100θ*",      f"{fr.cmb_100_theta():.4f}", "100/(N_w(D+χ))",             "1.0411"),
    ("T_CMB (K)",   f"{fr.cmb_temperature():.4f}", "(gauss+χ)/β₀ = 19/7",    "2.7255"),
    ("n_s",         f"{fr.spectral_index():.4f}", "1 − κ/D",                  "0.9649"),
    ("ln(10¹⁰A_s)",f"{fr.ln_scalar_amplitude():.4f}", "ln(N_c·β₀) = ln(21)", "3.044"),
    ("Age (Gyr)",   f"{fr.age_analytic():.3f}",  "gauss + χ/β₀ = 97/7",      "13.797"),
    ("N_eff",       f"{fr.n_effective():.3f}",    "N_c + 0.044",               "3.044"),
    ("w_DE",        "−1",                          "Landauer erasure",           "−1"),
]
header_y = 0.97
ax.text(0.02, header_y, "Parameter", fontsize=11, fontweight='bold', transform=ax.transAxes)
ax.text(0.22, header_y, "Crystal", fontsize=11, fontweight='bold', color='crimson', transform=ax.transAxes)
ax.text(0.38, header_y, "Formula", fontsize=11, fontweight='bold', transform=ax.transAxes)
ax.text(0.72, header_y, "Planck", fontsize=11, fontweight='bold', color='navy', transform=ax.transAxes)
for i, (name, val, formula, planck) in enumerate(rows):
    y = 0.92 - i * 0.07
    ax.text(0.02, y, name, fontsize=10, fontfamily='monospace', transform=ax.transAxes)
    ax.text(0.22, y, val, fontsize=10, fontfamily='monospace', color='crimson', transform=ax.transAxes)
    ax.text(0.38, y, formula, fontsize=9, fontfamily='monospace', transform=ax.transAxes)
    ax.text(0.72, y, planck, fontsize=10, fontfamily='monospace', color='navy', transform=ax.transAxes)
plt.savefig('friedmann_cmb.png', dpi=150, bbox_inches='tight'); plt.show()
