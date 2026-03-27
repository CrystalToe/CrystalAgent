# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""20 — Weak Mixing Angle and Coupling Constants"""
from crystal_topos import n_w, n_c, chi, beta0, d_total, gauss
import math

print("Coupling Constants from Two Primes")
print("=" * 55)
alpha = 1.0 / ((d_total() + 1) * math.pi + math.log(beta0()))
sin2w = n_c() / gauss()
alpha_s = n_w() / (gauss() + n_w()**2)

print(f"\n  α⁻¹ = (D+1)π + ln β₀ = {d_total()+1}π + ln {beta0()}")
print(f"      = {1/alpha:.4f}")
print(f"  PDG: 137.036, PWI: {abs(1/alpha - 137.036)/137.036*100:.4f}%")

print(f"\n  sin²θ_W = N_c/gauss = {n_c()}/{gauss()} = {sin2w:.5f}")
print(f"  PDG: 0.23122, PWI: {abs(sin2w - 0.23122)/0.23122*100:.3f}%")

print(f"\n  α_s = N_w/(gauss+N_w²) = {n_w()}/({gauss()}+{n_w()**2}) = {n_w()}/{gauss()+n_w()**2}")
print(f"      = {alpha_s:.5f}")
print(f"  PDG: 0.1179, PWI: {abs(alpha_s - 0.1179)/0.1179*100:.2f}%")

print(f"\n  Three couplings. Three exact rationals.")
print(f"  α from π and ln. sin²θ from N_c/gauss. α_s from N_w/(gauss+N_w²).")
