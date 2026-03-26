# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""
01 — Hello Crystal
The simplest possible crystal-topos program.
Everything from N_w=2, N_c=3.
"""
from crystal_topos import QuantumState, n_w, n_c, chi, beta0, gauss, d_total

print("Crystal Topos — The Two Primes")
print(f"  N_w = {n_w()}")
print(f"  N_c = {n_c()}")
print(f"  χ   = N_w × N_c = {chi()}")
print(f"  β₀  = (11N_c − 2χ)/3 = {beta0()}")
print(f"  gauss = N_c² + N_w² = {gauss()}")
print(f"  D   = Σd + χ = {d_total()}")
print()

# Create a particle. It lives in ℂ⁶ because 6 = 2 × 3.
psi = QuantumState.singlet()
print(f"State: {psi}")
print(f"Dimension: {psi.dim()}")
print(f"Sector probabilities: {psi.sector_probs()}")
print()
print("The particle is in the singlet — the ground state.")
print("Energy = 0. It sits still. The universe starts here.")
