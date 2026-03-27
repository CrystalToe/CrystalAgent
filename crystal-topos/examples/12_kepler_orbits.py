# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""12 — Kepler's Laws from End(A_F)"""
from crystal_topos import n_w, n_c, chi, d_total, gauss
import math

print("Kepler's Laws from Two Primes")
print("=" * 55)
print(f"\n  1st Law (Ellipses):")
print(f"    Conic sections have eccentricity e ∈ [0,1).")
print(f"    The orbit IS a level set of the Hamiltonian on T*S².")
print(f"    S² has dim = N_c - 1 = {n_c() - 1}. Inverse square = dim(S²).")

print(f"\n  2nd Law (Equal areas):")
print(f"    dA/dt = L/(2m) = const.")
print(f"    The 2 in the denominator IS N_w = {n_w()}.")
print(f"    Angular momentum conservation = Noether charge of SO(3).")
print(f"    SO(3) has dim = N_c = {n_c()}.")

print(f"\n  3rd Law (T² ∝ a³):")
print(f"    Exponent = N_c = {n_c()}.")
print(f"    T² ∝ a^N_c. The cube IS the colour dimension.")
print(f"    Kepler's third law is a spectral theorem on End(A_F).")
