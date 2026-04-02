#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Astro — Every Integer Dashboard"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); ast = toe.astro()
fig, ax = plt.subplots(figsize=(10, 10))
fig.suptitle(f"Crystal Astro — Every Coefficient from (N_w, N_c) = ({ast.n_w()}, {ast.n_c()})",
             fontsize=14, fontweight='bold')
ax.axis('off')
pnr = ast.polytrope_nr()
rows = [
    ("Polytrope NR",    f"{pnr[0]}/{pnr[1]}",         "N_c/N_w (white dwarf)"),
    ("Polytrope rel",   str(ast.polytrope_rel()),       "N_c (massive star)"),
    ("Schwarzschild",   str(ast.schwarz()),              "N_w (r_s = 2GM/c²)"),
    ("Hawking",         str(ast.hawking_factor()),       "d_colour = N_w³"),
    ("Stefan-Boltzmann",str(ast.sb_denominator()),       "N_c(χ−1)"),
    ("Eddington",       str(ast.eddington_factor()),     "N_w² (L_Ed = 4πGMc/κ)"),
    ("MS lum exp",      f"{ast.ms_lum_exp()[0]}/{ast.ms_lum_exp()[1]}", "β₀/N_w"),
    ("MS life exp",     f"{ast.ms_life_exp()[0]}/{ast.ms_life_exp()[1]}", "(χ−1)/N_w"),
    ("Virial",          str(ast.virial()),                "N_w (2K+U=0)"),
    ("Grav PE",         f"{ast.grav_pe()[0]}/{ast.grav_pe()[1]}", "N_c/(χ−1)"),
    ("Chandra μ_e",     str(ast.chandra_mu_e()),         "N_w (C/O)"),
    ("Jeans T exp",     f"{ast.jeans_t_exp()[0]}/{ast.jeans_t_exp()[1]}", "N_c/N_w"),
    ("Jeans ρ exp",     f"{ast.jeans_rho_exp()[0]}/{ast.jeans_rho_exp()[1]}", "1/N_w"),
]
for i, (name, val, origin) in enumerate(rows):
    y = 0.97 - i * 0.065
    ax.text(0.02, y, name, fontsize=10, fontfamily='monospace', va='top', transform=ax.transAxes)
    ax.text(0.30, y, val, fontsize=10, fontfamily='monospace', va='top',
            fontweight='bold', color='crimson', transform=ax.transAxes)
    ax.text(0.42, y, f'= {origin}', fontsize=9, fontfamily='monospace',
            va='top', transform=ax.transAxes)
plt.savefig('astro_integers.png', dpi=150, bbox_inches='tight'); plt.show()