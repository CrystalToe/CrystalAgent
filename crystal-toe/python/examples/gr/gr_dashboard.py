#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""
Crystal GR — Every Integer from (2,3)
=======================================
Dashboard proving every GR coefficient derives from N_w=2, N_c=3.
"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe()
gr = toe.gr()

gm = 1.0; rs = gr.schwarzschild_r(gm)

# All GR integers
integers = {
    'r_s = 2GM':        (2, 'N_c − 1'),
    'Precession = 6':   (gr.precession_factor(), 'χ = N_w × N_c'),
    'Bending = 4':      (gr.bending_factor(), 'N_w²'),
    'ISCO = 6GM':       (gr.isco_factor(), 'χ'),
    'ISCO = 3r_s':      (gr.photon_sphere(), 'N_c'),
    'Spacetime = 4D':   (gr.spacetime_dim(), 'N_c + 1'),
    'E²_ISCO = 8/9':    (8, 'd_colour = N_c²−1'),
    'Shapiro = 2,4':    (2, 'N_c−1, N_w²'),
    '16πG':             (16, 'N_w⁴'),
}

fig, axes = plt.subplots(2, 2, figsize=(16, 12))
fig.suptitle(f"Crystal GR — Every Integer from (N_w, N_c) = ({gr.n_w()}, {gr.n_c()})\n"
             f"Toe(v={toe.vev():.0f} MeV) → gr()",
             fontsize=14, fontweight='bold')

# 1. Table of integers
ax = axes[0][0]; ax.axis('off')
rows = list(integers.items())
for i, (name, (val, origin)) in enumerate(rows):
    y = 0.95 - i * 0.1
    ax.text(0.02, y, name, transform=ax.transAxes, fontsize=12, fontfamily='monospace', va='top')
    ax.text(0.45, y, str(val), transform=ax.transAxes, fontsize=12, fontfamily='monospace', 
            va='top', fontweight='bold', color='crimson')
    ax.text(0.55, y, f'= {origin}', transform=ax.transAxes, fontsize=11, fontfamily='monospace', va='top')
ax.set_title('GR Coefficients', fontsize=13)

# 2. Precessing orbit
ax2 = axes[0][1]
radii, phis, xs, ys = gr.evolve_orbit(gm, 30*rs, 0.4, 0.3, 50000)
ax2.plot(xs, ys, 'b-', linewidth=0.2)
ax2.plot(0, 0, 'ko', markersize=8)
theta = np.linspace(0, 2*np.pi, 100)
ax2.plot(gr.isco_radius(gm)*np.cos(theta), gr.isco_radius(gm)*np.sin(theta), 'r--', linewidth=1, alpha=0.5)
ax2.set_aspect('equal'); ax2.set_title(f'Precession: δφ = {gr.precession_factor()}πGM/...')
ax2.grid(True, alpha=0.3)

# 3. Effective potential
ax3 = axes[1][0]
for L_frac, lbl in [(0.9,'0.9 L_ISCO'),(1.0,'L_ISCO'),(1.2,'1.2 L_ISCO')]:
    L = L_frac * gr.isco_angular_momentum(gm)
    r_arr, veff = gr.effective_potential_curve(gm, L, 1.5*rs, 30*rs, 300)
    ax3.plot(np.array(r_arr)/rs, veff, linewidth=2, label=lbl)
ax3.axvline(x=3, color='red', linestyle=':', alpha=0.5, label=f'ISCO = {gr.photon_sphere()} r_s')
ax3.set_xlabel('r / r_s'); ax3.set_ylabel('V_eff')
ax3.set_title('Effective Potential'); ax3.legend(); ax3.grid(True, alpha=0.3)

# 4. Redshift + Schwarzschild metric
ax4 = axes[1][1]
r_vals = np.linspace(1.01*rs, 15*rs, 300)
metric = [gr.schwarzschild_metric(r, rs) for r in r_vals]
redshift = [gr.gravitational_redshift(rs, r) for r in r_vals]
ax4.plot(r_vals/rs, metric, 'b-', linewidth=2, label='g_tt = 1−r_s/r')
ax4.plot(r_vals/rs, redshift, 'r-', linewidth=2, label='z = 1/√(1−r_s/r) − 1')
ax4.axvline(x=1, color='black', linestyle='-', alpha=0.3, label='r = r_s (horizon)')
ax4.axvline(x=3, color='red', linestyle=':', alpha=0.3, label=f'ISCO = {gr.photon_sphere()} r_s')
ax4.set_xlabel('r / r_s'); ax4.set_ylim(-1, 5)
ax4.set_title('Metric & Redshift'); ax4.legend(fontsize=9); ax4.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('gr_dashboard.png', dpi=150, bbox_inches='tight'); plt.show()