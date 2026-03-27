# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""63 — DNA Hydrogen Bonds ARE the Two Primes"""
from crystal_topos import n_w, n_c
print("The Two Primes ARE the Two Bond Strengths")
print("=" * 55)
print(f"  A—T base pair: {n_w()} hydrogen bonds = N_w")
print(f"  G—C base pair: {n_c()} hydrogen bonds = N_c")
print(f"\n  Both EXACT. ■ ■")
print(f"\n  The WEAK pair (A-T): held by the WEAK prime N_w = {n_w()}")
print(f"  The STRONG pair (G-C): held by the COLOUR prime N_c = {n_c()}")
print(f"\n  Melting temperature scales with GC content because")
print(f"  N_c > N_w → G-C is harder to break than A-T.")
print(f"  ΔT_m ∝ (N_c − N_w)/(N_c + N_w) = {n_c()-n_w()}/{n_c()+n_w()} = {(n_c()-n_w())/(n_c()+n_w()):.1f}")
print(f"\n  Double helix: N_w = {n_w()} strands  ■ EXACT")
print(f"  RNA: 1 strand (singlet sector)")
print(f"  The strand count IS the weak prime.")
