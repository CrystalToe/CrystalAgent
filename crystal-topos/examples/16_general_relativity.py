# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""16 — General Relativity from the Crystal"""
from crystal_topos import n_w, n_c, chi, d_total, gauss
import math

print("General Relativity from Two Primes")
print("=" * 55)
print(f"\n  Einstein equation: G_μν + Λg_μν = 8πG T_μν")
print(f"  8π = N_w³ × π = {n_w()**3}π")
print(f"  The gravitational coupling = N_w cubed.")

print(f"\n  Jacobson chain (thermo → gravity):")
print(f"    δQ = TδS  (Clausius)")
print(f"    → Rindler horizon: T = a/(2π), a = acceleration")
print(f"    → Raychaudhuri focusing: δA ∝ R_μν k^μ k^ν")
print(f"    → Einstein: G_μν = {n_w()**3}πG × T_μν")
print(f"    The 2π in T = a/(2π) is the KMS period from the algebra.")

print(f"\n  Immirzi parameter:")
sin2w = n_c() / gauss()
immirzi = sin2w / (35/36)
print(f"    γ_I = sin²θ_W / ((D−β₀)/Σd) = ({n_c()}/{gauss()}) / (35/36)")
print(f"        = {immirzi:.5f}")
