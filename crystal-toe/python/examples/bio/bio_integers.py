#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Bio — Every Integer Dashboard"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); bio = toe.bio()
fig, ax = plt.subplots(figsize=(10, 10))
fig.suptitle(f"Crystal Bio — Every Coefficient from (N_w, N_c) = ({bio.n_w()}, {bio.n_c()})",
             fontsize=14, fontweight='bold')
ax.axis('off')
rows = [
    ("DNA bases",        str(bio.dna_bases()),      "N_w² (A,T,G,C)"),
    ("Codon length",     str(bio.codon_len()),      "N_c"),
    ("Total codons",     str(bio.codons()),          "(N_w²)^N_c = 4³"),
    ("Amino acids",      str(bio.amino_acids()),    "N_w²(χ−1)"),
    ("Stop codons",      str(bio.stop_codons()),    "N_c"),
    ("Start codons",     str(bio.start_codons()),   "d₁"),
    ("Helix strands",    str(bio.helix_strands()),  "N_w"),
    ("H-bond A-T",       str(bio.hbond_at()),       "N_w"),
    ("H-bond G-C",       str(bio.hbond_gc()),       "N_c"),
    ("BP/turn",          str(bio.bp_per_turn()),    "N_w(χ−1)"),
    ("Lipid bilayer",    str(bio.lipid_layers()),   "N_w"),
    ("Helix/turn",       f"{bio.helix_per_turn():.1f}", "N_c²·N_w/(χ−1) = 18/5"),
    ("Flory ν",          f"{bio.flory_nu():.1f}",   "N_w/(χ−1) = 2/5"),
    ("Kleiber exp",      f"{bio.kleiber_exponent():.2f}", "N_c/N_w² = 3/4"),
    ("Heart rate exp",   f"1/{int(1/bio.heart_rate_exponent())}", "1/N_w²"),
    ("Surface area exp", f"{bio.surface_exponent():.3f}", "N_w/N_c = 2/3"),
    ("Redundancy",       f"{bio.codon_redundancy():.2f}", "≈ N_c"),
]
for i, (name, val, origin) in enumerate(rows):
    y = 0.97 - i * 0.053
    ax.text(0.02, y, name, fontsize=10, fontfamily='monospace', va='top', transform=ax.transAxes)
    ax.text(0.28, y, val, fontsize=10, fontfamily='monospace', va='top',
            fontweight='bold', color='crimson', transform=ax.transAxes)
    ax.text(0.42, y, f'= {origin}', fontsize=9, fontfamily='monospace',
            va='top', transform=ax.transAxes)
plt.savefig('bio_integers.png', dpi=150, bbox_inches='tight'); plt.show()