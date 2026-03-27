# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""15 — Special Relativity from End(A_F)"""
from crystal_topos import n_w, n_c, chi, d_total
import math

print("Special Relativity from Two Primes")
print("=" * 55)
print(f"\n  Spacetime dimension = N_w² = {n_w()**2}")
print(f"  Minkowski signature: (1, N_c) = (1, {n_c()})")
print(f"  The metric η = diag(+1, −1, −1, −1).")
print(f"  3 spatial dims = N_c = {n_c()} (colour IS space).")
print(f"  1 time dim = singlet sector d₁ = 1.")

print(f"\n  Lorentz group:")
print(f"    SO(1,3) has dim = C(4,2) = χ = {chi()}")
print(f"    6 generators: 3 boosts + 3 rotations = N_c + N_c = 2N_c")
print(f"    The Lorentz group IS the chi-dimensional manifold.")

print(f"\n  E = mc²:")
print(f"    The mass-energy equivalence is the spectral action")
print(f"    evaluated on the singlet sector. E = ⟨1|H|1⟩ = mc².")
