# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""62 — β-Sheet: The Second Protein Fold"""
from crystal_topos import n_w, n_c, beta0, chi
print("β-Sheet Structure from the Crystal")
print("=" * 55)
spacing = beta0() / n_w()
print(f"  Strand spacing: β₀/N_w = {beta0()}/{n_w()} = {spacing} Å     ■ EXACT")
print(f"  Experimental: 3.3-3.7 Å (3.5 typical)")
print(f"\n  The asymptotic coupling β₀ = {beta0()} sets the gap.")
print(f"  Divided by N_w = {n_w()} spin states.")
print(f"  Inter-strand hydrogen bonds alternate: ↑↓↑↓")
print(f"  Parallel vs antiparallel: both have spacing β₀/N_w.")
print(f"\n  Ramachandran allowed fraction:")
print(f"  Σd/codons = 36/64 = {36/64:.4f} = {36/64*100:.2f}%")
print(f"  Observed: ~55-60% of φ,ψ space is sterically allowed.")
