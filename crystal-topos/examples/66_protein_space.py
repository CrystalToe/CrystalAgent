# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""66 — The Protein Folding Space"""
from crystal_topos import n_w, n_c, gauss, beta0, chi, sigma_d, d_total
import math
print("Protein Folding from Lattice Geometry")
print("=" * 55)
aa = gauss() + beta0()
print(f"  Amino acid alphabet: gauss + β₀ = {aa}")
print(f"  Typical protein length: ~300 residues")
print(f"  Configuration space: {aa}^300 = 10^{300*math.log10(aa):.0f}")
print(f"\n  BUT: Ramachandran constraint limits this.")
print(f"  Allowed fraction: Σd/codons = {sigma_d()}/64 = {sigma_d()/64:.4f}")
print(f"  Effective space: {aa}^300 × {sigma_d()/64:.3f}^300")
print(f"               = 10^{300*(math.log10(aa) + math.log10(sigma_d()/64)):.0f}")
print(f"\n  Levinthal's paradox: how does a protein fold in ms")
print(f"  when the search space is 10^{300*math.log10(aa):.0f}?")
print(f"\n  Crystal answer: the D={d_total()} manifold has a UNIQUE")
print(f"  ground state for each amino acid sequence.")
print(f"  The protein doesn't search — it falls.")
print(f"  Folding time ∝ ln(L) × D, not exp(L).")
print(f"  The energy landscape IS the sector tetrahedron.")
