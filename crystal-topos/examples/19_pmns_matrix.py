# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""19 — PMNS Neutrino Mixing Matrix"""
from crystal_topos import n_w, n_c, chi, beta0, d_total, gauss
import math

print("PMNS Matrix from Two Primes")
print("=" * 55)
sin2_12 = n_c() / (n_c()**2 + 1)  # 3/10
sin2_23 = chi() / (chi() + (chi()-1))  # 6/11
sin2_13 = n_w() / (gauss() * chi())  # 2/78

print(f"\n  sin²θ₁₂ = N_c/(N_c²+1) = {n_c()}/{n_c()**2+1} = {sin2_12:.4f}")
print(f"  PDG: 0.307, PWI: {abs(sin2_12 - 0.307)/0.307*100:.2f}%")
print(f"\n  sin²θ₂₃ = χ/(χ+(χ−1)) = {chi()}/{chi()+chi()-1} = {sin2_23:.4f}")
print(f"  PDG: 0.546, PWI: {abs(sin2_23 - 0.546)/0.546*100:.2f}%")
print(f"\n  sin²θ₁₃ = N_w/(gauss×χ) = {n_w()}/({gauss()}×{chi()}) = {sin2_13:.5f}")
print(f"  PDG: 0.0220, PWI: {abs(sin2_13 - 0.0220)/0.0220*100:.1f}%")
print(f"\n  Near-tribimaximal but NOT tribimaximal.")
print(f"  θ₁₃ ≠ 0 → CP violation in lepton sector.")
