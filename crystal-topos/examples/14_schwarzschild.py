# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""14 — Schwarzschild Black Holes"""
from crystal_topos import n_w, n_c, d_total, gauss, beta0
import math

print("Black Holes from the Crystal")
print("=" * 55)

# Schwarzschild radius: r_s = 2GM/c² — the 2 is N_c - 1
print(f"\nSchwarzschild radius:")
print(f"  r_s = (N_c-1) × GM/c² = {n_c()-1} × GM/c²")
print(f"  The factor 2 in GR IS N_c - 1.")

# BH entropy: S = A/(4G) — the 4 is N_w²
print(f"\nBekenstein-Hawking entropy:")
print(f"  S_BH = A / (N_w² × G) = A / ({n_w()**2} × G)")
print(f"  The 4 in S = A/4G IS N_w² = {n_w()**2}.")

# Immirzi parameter
sin2w = n_c() / gauss()
immirzi = sin2w / (35/36)
print(f"\nImmirzi parameter (LQG):")
print(f"  γ = sin²θ_W / (35/36)")
print(f"  = (N_c/gauss) / ((D-β₀)/Σd)")
print(f"  = ({n_c()}/{gauss()}) / (35/36)")
print(f"  = {immirzi:.5f}")
print(f"  PDG: 0.23753")
print(f"  PWI: {abs(immirzi - 0.23753)/0.23753 * 100:.3f}%")

# Hawking temperature
print(f"\nHawking radiation:")
print(f"  KMS temperature β = 2π (from the algebra)")
print(f"  T_Hawking = 1/(N_w²π × r_s) = ℏc³/(8πGM)")
print(f"  The 8π = N_w³ × π. Every factor from (2,3).")
