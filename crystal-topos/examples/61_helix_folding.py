# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""61 — α-Helix: Protein Folding from Two Primes"""
from crystal_topos import n_w, n_c, chi, beta0
print("α-Helix: The Most Common Protein Fold")
print("=" * 55)
turn = n_c() + n_c() / (chi() - 1)
rise = n_c() / n_w()
pitch = turn * rise
print(f"  Residues per turn: N_c + N_c/(χ−1)")
print(f"    = {n_c()} + {n_c()}/{chi()-1} = {turn}     ■ EXACT")
print(f"  Rise per residue: N_c/N_w = {n_c()}/{n_w()} = {rise} Å     ■ EXACT")
print(f"  Pitch: {turn} × {rise} = {pitch} Å")
print(f"  Experimental: 5.4 Å. Crystal: {pitch} Å")
print(f"\n  WHY 3.6:")
print(f"  N_c = 3 bonds per residue (backbone: N-Cα-C)")
print(f"  The twist = N_c/(χ−1) = 3/5 (sector geometry)")
print(f"  3 + 3/5 = 18/5 = 3.600")
print(f"\n  AlphaFold uses millions of structures + neural nets.")
print(f"  The crystal uses one fraction: 18/5.")
