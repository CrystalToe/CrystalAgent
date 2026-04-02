#!/usr/bin/env python3
"""Crystal QFT — Feynman Rules: every counting factor from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); qf = toe.qft()
fig, ax = plt.subplots(figsize=(12, 8))
fig.suptitle(f"Crystal QFT — Feynman Rules from (N_w, N_c) = ({qf.n_w()}, {qf.n_c()})", fontsize=14, fontweight='bold')
ax.axis('off')
rows = [
    ("Spacetime dim",    str(qf.spacetime_dim()),    "N_w²"),
    ("Lorentz gen",      str(qf.lorentz_generators()),"χ = d(d−1)/2"),
    ("Dirac γ matrices", str(qf.dirac_gammas()),     "N_w²"),
    ("Weyl spinor",      str(qf.spinor_comp()),      "N_w"),
    ("Photon pol",       str(qf.photon_pol()),        "N_c − 1"),
    ("Gluon colours",    str(qf.gluon_colours()),     "N_c² − 1 = d₃"),
    ("β₀ (QCD)",         str(qf.qcd_beta0()),         "(11N_c − 2χ)/3"),
    ("1-loop 16π²",      str(qf.one_loop_factor()),   "N_w⁴"),
    ("Propagator 1/p²",  str(qf.propagator_exp()),    "N_c − 1"),
    ("Thomson 8/3",      "8/3",                        "d_colour/N_c"),
    ("σ numerator",      str(qf.spacetime_dim()),     "N_w² (= 4πα²)"),
    ("σ denominator",    str(qf.n_c()),               "N_c (colour avg)"),
    ("Pair threshold",   "2m",                         "N_w·m"),
    ("α⁻¹",             f"{qf.alpha_inv():.2f}",     "(D+1)π + ln(β₀)"),
]
for i, (name, val, origin) in enumerate(rows):
    y = 0.96 - i * 0.065
    ax.text(0.02, y, name, fontsize=10.5, fontfamily='monospace', va='top', transform=ax.transAxes)
    ax.text(0.30, y, val, fontsize=10.5, fontfamily='monospace', va='top', fontweight='bold', color='crimson', transform=ax.transAxes)
    ax.text(0.42, y, f'= {origin}', fontsize=10, fontfamily='monospace', va='top', transform=ax.transAxes)
plt.savefig('qft_feynman.png', dpi=150, bbox_inches='tight'); plt.show()
