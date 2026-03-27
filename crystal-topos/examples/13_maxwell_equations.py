# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""13 — Maxwell's Equations from the Crystal"""
from crystal_topos import n_w, n_c, chi, d_total, gauss
import math

print("Maxwell's Equations from Two Primes")
print("=" * 55)
print(f"\n  Maxwell has 4 equations. Why 4?")
print(f"  4 = N_w² = {n_w()**2}")
print(f"  The electromagnetic 2-form F lives in Λ²(ℝ⁴).")
print(f"  dim Λ²(ℝ⁴) = C(4,2) = χ = {chi()}.")
print(f"  The 6 components of F: (E_x, E_y, E_z, B_x, B_y, B_z).")
print(f"  χ = {chi()} = the dimension of the electromagnetic field.")

print(f"\n  Speed of light:")
print(f"    c = 1/√(ε₀μ₀). The product ε₀μ₀ = 1/c².")
print(f"    In crystal units: c is the unit velocity.")
print(f"    Light speed = the causal boundary of End(A_F).")

print(f"\n  Gauge group: U(1) ⊂ End(A_F)")
print(f"    The singlet sector d₁ = 1 carries electromagnetism.")
print(f"    QED IS the singlet endomorphism algebra.")
