#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal QInfo — Every Integer Dashboard"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); qi = toe.qinfo()
fig, ax = plt.subplots(figsize=(10, 10))
fig.suptitle(f"Crystal QInfo — Every Coefficient from (N_w, N_c) = ({qi.n_w()}, {qi.n_c()})",
             fontsize=14, fontweight='bold')
ax.axis('off')
s = qi.steane_code()
rows = [
    ("Qubit states",     str(qi.qubit_states()),    "N_w"),
    ("Pauli matrices",   str(qi.pauli_matrices()),  "N_c (σ_x,σ_y,σ_z)"),
    ("Pauli group",      str(qi.pauli_group()),     "N_w² (+ identity)"),
    ("Bell states",      str(qi.bell_states()),     "N_w²"),
    ("Toffoli inputs",   str(qi.toffoli()),         "N_c"),
    ("Steane code",      f"[{s[0]},{s[1]},{s[2]}]", "[β₀, d₁, N_c]"),
    ("Steane corrects",  str(qi.steane_corrects()), "(N_c−1)/2"),
    ("Shor code",        f"{qi.shor_n()} qubits",  "N_c² = D2Q9"),
    ("MERA bond dim",    str(qi.mera_bond()),       "χ"),
    ("MERA depth",       str(qi.mera_depth()),      "D = Σ_d + χ"),
    ("Bell entropy",     f"{qi.bell_entropy():.4f}","ln(N_w)"),
    ("MERA entropy",     f"{qi.mera_link_entropy():.4f}", "ln(χ)"),
    ("Teleport bits",    str(qi.teleport_bits()),   "N_w"),
    ("Superdense bits",  str(qi.superdense_bits()), "N_w"),
    ("Hamming check",    str(qi.hamming_check()),   "β₀ = N_w^N_c − 1"),
    ("Coprimality",      str(qi.coprimality_check()), "gcd(N_w,N_c) = 1"),
    ("Uncertainty",      f"1/{qi.uncertainty_meet()[1]}", "1/χ"),
]
for i, (name, val, origin) in enumerate(rows):
    y = 0.97 - i * 0.053
    ax.text(0.02, y, name, fontsize=10, fontfamily='monospace', va='top', transform=ax.transAxes)
    ax.text(0.30, y, val, fontsize=10, fontfamily='monospace', va='top',
            fontweight='bold', color='crimson', transform=ax.transAxes)
    ax.text(0.50, y, f'= {origin}', fontsize=9, fontfamily='monospace',
            va='top', transform=ax.transAxes)
plt.savefig('qinfo_integers.png', dpi=150, bbox_inches='tight'); plt.show()