#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""
Crystal GR — Light Bending
============================
δθ = 4GM/(bc²) where 4 = N_w². Same integer as Ryu-Takayanagi.
1.75 arcseconds at the Sun's limb — confirmed 1919 eclipse.
"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe()
gr = toe.gr()

rs_sun = 2.953; r_sun = 6.957e5
bend = gr.light_bending_analytic(rs_sun, r_sun)
arcsec = bend * (180/np.pi) * 3600
print(f"Sun limb deflection: {arcsec:.3f} arcsec (obs: 1.75)")
print(f"Bending factor: {gr.bending_factor()} = N_w² (same as RT: S=A/4G)")

# Deflection vs impact parameter
b_vals = np.linspace(1.5*rs_sun, 50*rs_sun, 200)  # impact parameters
deflections = [gr.light_bending_analytic(rs_sun, b) * (180/np.pi) * 3600 for b in b_vals]

fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle(f"Crystal GR — Light Bending\nToe(v={toe.vev():.0f} MeV) → gr() | "
             f"δθ = {gr.bending_factor()}GM/b where {gr.bending_factor()} = N_w²",
             fontsize=13, fontweight='bold')

axes[0].plot(np.array(b_vals)/rs_sun, deflections, 'orange', linewidth=2)
axes[0].axhline(y=1.75, color='red', linestyle='--', alpha=0.5, label='1.75" (Sun limb)')
axes[0].set_xlabel('Impact parameter b / r_s'); axes[0].set_ylabel('Deflection (arcsec)')
axes[0].set_title('Deflection vs Impact Parameter'); axes[0].legend(); axes[0].grid(True, alpha=0.3)
axes[0].set_yscale('log')

# Photon sphere and effective potential
gm = 1.0; rs = gr.schwarzschild_r(gm)
r_ph = gr.photon_sphere() * gm  # r_ph = 3GM = N_c * GM
print(f"Photon sphere: r = {gr.photon_sphere()} GM = N_c × GM")

ang_l_vals = [3.0, 3.5, 4.0, 5.0]
for L in ang_l_vals:
    r_arr, veff = gr.effective_potential_curve(gm, L, 1.5*rs, 30*rs, 500)
    axes[1].plot(np.array(r_arr)/rs, veff, linewidth=1.5, label=f'L={L:.1f}')
axes[1].axvline(x=r_ph/rs, color='red', linestyle=':', label=f'r_ph = {gr.photon_sphere()} GM')
axes[1].set_xlabel('r / r_s'); axes[1].set_ylabel('V_eff')
axes[1].set_title('Photon Effective Potential'); axes[1].legend(fontsize=9); axes[1].grid(True, alpha=0.3)

# Crystal identity box
axes[2].axis('off')
lines = [
    f"Light bending = {gr.bending_factor()} GM/b",
    f"  {gr.bending_factor()} = N_w² = {gr.n_w()}²",
    f"  Same as Ryu-Takayanagi: S = A/4G",
    f"",
    f"Photon sphere = {gr.photon_sphere()} GM",
    f"  {gr.photon_sphere()} = N_c",
    f"",
    f"Sun limb: {arcsec:.3f} arcsec",
    f"  Observed: 1.75 arcsec",
    f"  Eddington 1919 eclipse",
    f"",
    f"All from (N_w, N_c) = (2, 3)",
]
for i, line in enumerate(lines):
    axes[2].text(0.05, 0.95-i*0.075, line, transform=axes[2].transAxes,
                 fontsize=11, fontfamily='monospace', va='top',
                 fontweight='bold' if 'All from' in line else 'normal')

plt.tight_layout()
plt.savefig('gr_light_bending.png', dpi=150, bbox_inches='tight'); plt.show()