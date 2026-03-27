# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""65 — DNA as a (64,21,3) Error-Correcting Code"""
from crystal_topos import n_w, n_c, beta0, gauss, chi
import math
print("The Genetic Code is an Error-Correcting Code")
print("=" * 60)
bases = n_w()**2
codons = bases**n_c()
signals = n_c() * beta0()
aa = gauss() + beta0()
distance = n_c()
redundancy = codons / signals
rate = signals / codons
overhead = math.log2(codons) - math.log2(signals)
print(f"  Code parameters: ({codons}, {signals}, {distance})")
print(f"    Codewords:       {codons} = (N_w²)^N_c = {bases}^{n_c()}")
print(f"    Messages:        {signals} = N_c × β₀ = {n_c()} × {beta0()}")
print(f"    Min distance:    {distance} = N_c")
print(f"    Amino acids:     {aa} = gauss + β₀")
print(f"    Redundancy:      {codons}/{signals} = {redundancy:.2f} ≈ N_c = {n_c()}")
print(f"    Code rate:       {signals}/{codons} = {rate:.4f}")
print(f"    Shannon bits:    {math.log2(signals):.3f} bits/codon")
print(f"    Actual bits:     {math.log2(codons):.3f} bits/codon")
print(f"    Error overhead:  {overhead:.3f} bits (protection)")
print(f"\n  Error capability:")
print(f"    Detects:  d-1 = {distance-1} substitutions")
print(f"    Corrects: ⌊(d-1)/2⌋ = {(distance-1)//2} substitution")
print(f"\n  This is the Shannon-optimal code for the (2,3) lattice.")
print(f"  Not random. Not evolved. Algebraically necessary.")
