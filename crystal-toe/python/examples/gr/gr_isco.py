#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""
Crystal GR — ISCO & Black Hole Orbits
=======================================
r_ISCO = 6GM = χ·GM = 3·r_s = N_c·r_s
E_ISCO = √(8/9) = √(d_colour/N_c²)
"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe()
gr = toe.gr()

gm = 1.0
rs = gr.schwarzschild_r(gm)
r_isco = gr.isco_radius(gm)
e_isco = gr.isco_energy()

print(f"r_s     = {rs:.1f} GM")
print(f"r_ISCO  = {r_isco:.1f} GM = {r_isco/rs:.0f} r_s = {gr.isco_factor()} GM (χ = N_w×N_c)")
print(f"E_ISCO  = {e_isco:.6f} = √(8/9) = √(d_colour/N_c²)")

fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle(f"Crystal GR — ISCO & Black Hole Orbits\nToe(v={toe.vev():.0f} MeV) → gr() | "
             f"r_ISCO = {gr.isco_factor()}GM = χ·GM, E = √(8/9)",
             fontsize=13, fontweight='bold')

# Orbits at different radii: above, at, and plunging
for r_init, label, color in [(10*rs,'r=10r_s (stable)','blue'), 
                               (r_isco,'r=ISCO','red'),
                               (4*rs,'r=4r_s (plunge)','purple')]:
    e = 0.0 if r_init >= r_isco else 0.3
    dtau = 0.3; n = 30000
    try:
        radii, phis, xs, ys = gr.evolve_orbit(gm, r_init, e, dtau, n)
        axes[0].plot(xs, ys, color=color, linewidth=0.3, label=label, alpha=0.7)
    except:
        pass

theta = np.linspace(0, 2*np.pi, 100)
axes[0].fill(rs*np.cos(theta), rs*np.sin(theta), color='black', alpha=0.8, label='Black hole')
axes[0].plot(r_isco*np.cos(theta), r_isco*np.sin(theta), 'r--', linewidth=1, label=f'ISCO={gr.isco_factor()}GM')
axes[0].set_aspect('equal'); axes[0].legend(fontsize=8)
axes[0].set_title('Orbits near Black Hole'); axes[0].grid(True, alpha=0.3)

# Effective potential for different L values
l_isco = gr.isco_angular_momentum(gm)
for frac, color in [(0.8,'purple'),(1.0,'red'),(1.2,'blue'),(1.5,'green')]:
    L = frac * l_isco
    r_arr, veff = gr.effective_potential_curve(gm, L, 1.5*rs, 40*rs, 500)
    axes[1].plot(np.array(r_arr)/rs, veff, color=color, linewidth=1.5, label=f'L={frac:.1f}L_ISCO')
axes[1].axvline(x=r_isco/rs, color='red', linestyle=':', alpha=0.5, label='ISCO')
axes[1].set_xlabel('r / r_s'); axes[1].set_ylabel('V_eff')
axes[1].set_title('Effective Potential'); axes[1].legend(fontsize=9); axes[1].grid(True, alpha=0.3)

# Redshift vs radius
r_vals = np.linspace(1.1*rs, 20*rs, 200)
z_vals = [gr.gravitational_redshift(rs, r) for r in r_vals]
axes[2].plot(r_vals/rs, z_vals, 'darkred', linewidth=2)
axes[2].axvline(x=r_isco/rs, color='red', linestyle=':', label=f'ISCO = {int(r_isco/rs)} r_s')
axes[2].set_xlabel('r / r_s'); axes[2].set_ylabel('Redshift z')
axes[2].set_title('Gravitational Redshift'); axes[2].legend(); axes[2].grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('gr_isco.png', dpi=150, bbox_inches='tight'); plt.show()