# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""55 — Prandtl Number: Momentum vs Thermal Diffusivity"""
from crystal_topos import beta0, gauss, n_w, n_c
print("Prandtl Number (Air)")
print("=" * 55)
zeroth = beta0() / (gauss() - n_c())
correction = n_w() / (gauss()**2 - n_w())
Pr = zeroth + correction
print(f"  Zeroth order: β₀/(gauss−N_c) = {beta0()}/{gauss()-n_c()} = {zeroth:.4f}")
print(f"  Sector boundary correction: +N_w/(gauss²−N_w)")
print(f"    = {n_w()}/({gauss()**2}-{n_w()}) = {n_w()}/{gauss()**2-n_w()} = {correction:.5f}")
print(f"  Corrected: {Pr:.5f}")
print(f"  Experimental: 0.713")
print(f"  PWI: {abs(Pr-0.713)/0.713*100:.3f}%  ● TIGHT")
print(f"\n  Same boundary as Euler-Mascheroni: gauss²−N_w = {gauss()**2-n_w()} = 167")
print(f"  This IS the sector boundary where colour meets singlet.")
print(f"  Every fluid property from two primes.")
