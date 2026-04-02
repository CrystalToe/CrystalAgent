#!/usr/bin/env python3
"""Crystal EM — Every Integer Dashboard"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); em = toe.em()
fig, ax = plt.subplots(figsize=(10, 8))
fig.suptitle(f"Crystal EM — Every Coefficient from (N_w, N_c) = ({em.n_w()}, {em.n_c()})", fontsize=14, fontweight='bold')
ax.axis('off')
rows = [
    ("EM components",   str(em.em_components()),    "χ = N_w × N_c"),
    ("E components",    "3",                         "N_c"),
    ("B components",    "3",                         "N_c"),
    ("2-form dim",      "6",                         "C(N_c+1, 2) = χ"),
    ("Maxwell eqs",     str(em.maxwell_equations()), "N_c + 1"),
    ("Polarizations",   str(em.polarization_states()),"N_c − 1"),
    ("c (speed)",       "1",                          "χ/χ"),
    ("Larmor coeff",    "2/3",                        "(N_c−1)/N_c"),
    ("Rayleigh λ exp",  str(em.rayleigh_wave_exp()), "N_w²"),
    ("Rayleigh d exp",  str(em.rayleigh_size_exp()), "χ"),
    ("Planck λ exp",    str(em.planck_exponent()),   "χ − 1"),
    ("Stefan T exp",    str(em.stefan_exponent()),   "N_w²"),
    ("Stefan denom",    str(em.stefan_denom()),      "N_c(χ−1)"),
    ("Z₀ denom",       "120",                        "N_w·N_c·(gauss+β₀)"),
]
for i, (name, val, origin) in enumerate(rows):
    y = 0.95 - i * 0.065
    ax.text(0.02, y, name, fontsize=11, fontfamily='monospace', va='top', transform=ax.transAxes)
    ax.text(0.35, y, val, fontsize=11, fontfamily='monospace', va='top', fontweight='bold', color='crimson', transform=ax.transAxes)
    ax.text(0.45, y, f'= {origin}', fontsize=10, fontfamily='monospace', va='top', transform=ax.transAxes)
plt.savefig('em_integers.png', dpi=150, bbox_inches='tight'); plt.show()
