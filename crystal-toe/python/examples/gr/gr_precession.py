#!/usr/bin/env python3
"""
Crystal GR — Mercury Perihelion Precession
============================================
The 43 arcseconds/century that proved Einstein right.
The 6 in δφ = 6πGM/(ac²(1−e²)) is χ = N_w × N_c.
"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe()
gr = toe.gr()

rs_sun = 2.953  # km
a_merc = 5.791e7; e_merc = 0.2056
prec = gr.precession_analytic(rs_sun, a_merc, e_merc)
orbits_century = 365.25 * 100.0 / 87.969
arcsec = prec * (180/np.pi) * 3600 * orbits_century
print(f"Mercury precession: {arcsec:.2f} arcsec/century (obs: 42.98)")

# Simulate a strong-field precessing orbit
gm = 1.0; rs = gr.schwarzschild_r(gm)
a = 50 * rs; e = 0.5; dtau = 0.5; n = 80000
radii, phis, xs, ys = gr.evolve_orbit(gm, a, e, dtau, n)

fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle(f"Crystal GR — Perihelion Precession\nToe(v={toe.vev():.0f} MeV) → gr() | "
             f"δφ = {gr.precession_factor()}πGM/... where {gr.precession_factor()} = χ = N_w×N_c",
             fontsize=13, fontweight='bold')

axes[0].plot(xs, ys, 'b-', linewidth=0.2)
axes[0].plot(0, 0, 'ko', markersize=8)
axes[0].set_aspect('equal'); axes[0].set_title('Precessing Orbit (strong field)')
axes[0].set_xlabel('x'); axes[0].set_ylabel('y'); axes[0].grid(True, alpha=0.3)

axes[1].plot(np.array(phis)/(2*np.pi), radii, 'r-', linewidth=0.3)
axes[1].set_xlabel('Revolutions'); axes[1].set_ylabel('r / GM')
axes[1].set_title('Radius vs Azimuth'); axes[1].grid(True, alpha=0.3)

planets = ['Mercury','Venus','Earth','Mars']
a_vals = [5.791e7, 1.082e8, 1.496e8, 2.279e8]
e_vals = [0.2056, 0.0068, 0.0167, 0.0934]
precs = [gr.precession_analytic(rs_sun, a, e)*(180/np.pi)*3600*365.25*100/(87.969*(a/5.791e7)**1.5) for a,e in zip(a_vals,e_vals)]
axes[2].barh(planets, precs, color=['gray','orange','royalblue','red'])
axes[2].set_xlabel('arcsec/century'); axes[2].set_title('GR Precession by Planet')
axes[2].grid(True, alpha=0.3, axis='x')

plt.tight_layout()
plt.savefig('gr_precession.png', dpi=150, bbox_inches='tight'); plt.show()
