#!/usr/bin/env python3
"""Crystal Chem — Every Integer Dashboard"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); ch = toe.chem()
fig, ax = plt.subplots(figsize=(10, 10))
fig.suptitle(f"Crystal Chem — Every Coefficient from (N_w, N_c) = ({ch.n_w()}, {ch.n_c()})",
             fontsize=14, fontweight='bold')
ax.axis('off')
rows = [
    ("s-shell capacity",   str(ch.s_capacity()),    "N_w"),
    ("p-shell capacity",   str(ch.p_capacity()),    "χ = N_w·N_c"),
    ("d-shell capacity",   str(ch.d_capacity()),    "N_w(χ−1)"),
    ("f-shell capacity",   str(ch.f_capacity()),    "N_w·β₀"),
    ("sp3 angle (°)",      f"{ch.sp3_angle_deg():.2f}", "arccos(−1/N_c)"),
    ("sp2 angle (°)",      f"{ch.sp2_angle_deg():.1f}", "2π/N_c"),
    ("water angle (°)",    f"{ch.water_angle_deg():.2f}", "arccos(−1/N_w²)"),
    ("Noble He Z",         str(ch.noble_he()),      "N_w"),
    ("Noble Ne Z",         str(ch.noble_ne()),      "N_w(χ−1)"),
    ("Noble Ar Z",         str(ch.noble_ar()),      "N_w·N_c²"),
    ("Noble Kr Z",         str(ch.noble_kr()),      "Σ_d"),
    ("Neutral pH",         str(ch.neutral_ph()),    "β₀"),
    ("Hartree (eV)",       f"{ch.hartree_ev():.2f}",   "α²·m_e·c²"),
    ("Bohr radius (Å)",   f"{ch.bohr_radius():.4f}",  "ℏc/(m_e·c²·α)"),
    ("ε_vdW (eV)",         f"{ch.eps_vdw():.4f}",      "α·E_H/N_c²"),
    ("kT(300K) (eV)",      f"{ch.kt_300():.4f}",       "k_B·300"),
    ("Dielectric",         str(ch.dielectric_protein()), "N_w²(N_c+1)"),
    ("Bohr factor",        str(ch.bohr_factor()),    "N_w (Ry = E_H/N_w)"),
]
for i, (name, val, origin) in enumerate(rows):
    y = 0.97 - i * 0.053
    ax.text(0.02, y, name, fontsize=10, fontfamily='monospace', va='top', transform=ax.transAxes)
    ax.text(0.32, y, val, fontsize=10, fontfamily='monospace', va='top',
            fontweight='bold', color='crimson', transform=ax.transAxes)
    ax.text(0.47, y, f'= {origin}', fontsize=9, fontfamily='monospace',
            va='top', transform=ax.transAxes)
plt.savefig('chem_integers.png', dpi=150, bbox_inches='tight'); plt.show()
