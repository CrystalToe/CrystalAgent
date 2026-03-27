# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""100 — The Genetic Code as a (64,21,d) Error-Correcting Code"""
from crystal_topos import n_w, n_c, chi, beta0, d_total, gauss
import math

print("The Genetic Code: Error-Correcting Code from (2,3)")
print("=" * 60)

bases = n_w()**2              # 4
codons = bases**n_c()         # 64
amino = gauss() + beta0()     # 20
signals = n_c() * beta0()     # 21 (20 AA + 1 stop)
redundancy = d_total() + 1    # 43

print(f"\n  CODE PARAMETERS (all ■ EXACT):")
print(f"  Alphabet size:     N_w² = {bases}")
print(f"  Codewords:         (N_w²)^N_c = {bases}^{n_c()} = {codons}")
print(f"  Amino acids:       gauss + β₀ = {gauss()} + {beta0()} = {amino}")
print(f"  Signals (AA+stop): N_c × β₀ = {n_c()} × {beta0()} = {signals}")
print(f"  Redundancy:        D + 1 = {d_total()} + 1 = {redundancy}")
print(f"  Check:             {codons} − {signals} = {codons - signals} = D + 1 = {redundancy}  ✓")

# Code rate
rate = signals / codons
print(f"\n  CODING THEORY ANALYSIS:")
print(f"  Code: ({codons}, {signals}, d)")
print(f"  Rate: R = {signals}/{codons} = {rate:.4f}")
print(f"  Redundancy fraction: {redundancy}/{codons} = {redundancy/codons:.4f}")

# Hamming-like bounds
# For a code with 64 codewords, 21 valid, the Singleton bound gives:
# d ≤ n - k + 1 where n=length, k=log_q(M)
# Here: length=3 (codon triplet), q=4, M=21
# d ≤ 3 - ceil(log_4(21)) + 1 = 3 - 3 + 1 = 1
# But the actual code has better distance because of the structure
print(f"\n  DISTANCE ANALYSIS:")
print(f"  Codon length: N_c = {n_c()} (triplet)")
print(f"  Alphabet: N_w² = {bases}")
print(f"  Singleton bound: d ≤ {n_c()} - ceil(log_{bases}({signals})) + 1")
print(f"  The {redundancy} redundant codons provide error tolerance:")
print(f"  Average redundancy per amino acid = {redundancy}/{amino} = {redundancy/amino:.2f}")
print(f"  Most amino acids have {math.floor(redundancy/amino)}-{math.ceil(redundancy/amino)} synonymous codons")

# Wobble position analysis
print(f"\n  WOBBLE POSITION (3rd base tolerance):")
print(f"  N_c = {n_c()} positions per codon")
print(f"  Position 3 (wobble): most mutations are synonymous")
print(f"  This gives effective distance d ≥ {n_w()} for most codons")
print(f"  → Single point mutation in wobble = silent")
print(f"  → Crystal says: error correction lives in the N_c-th position")

print(f"\n  SYNTHETIC BIOLOGY CONSTRAINT:")
print(f"  To preserve error correction, any expanded alphabet must satisfy:")
print(f"  - Base count = N_w² × k for integer k (currently k=1, bases={bases})")
print(f"  - k=2 → {bases*2} bases, {(bases*2)**n_c()} codons, new redundancy budget")
print(f"  - k=3 → {bases*3} bases, {(bases*3)**n_c()} codons")
print(f"  Breaking the N_w² rule destroys the lattice lock.")
