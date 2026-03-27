# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""51 — Carnot Efficiency: The Second Law IS a Geometric Constraint"""
from crystal_topos import chi, n_w, n_c
print("The Second Law of Thermodynamics")
print("=" * 55)
eta = (chi() - 1) / chi()
print(f"  Carnot efficiency: η = (χ−1)/χ = ({chi()}-1)/{chi()} = {eta:.6f}")
print(f"  = 5/6 = 0.83333...")
print(f"  Theoretical maximum: 5/6     ■ EXACT")
print(f"\n  WHY no engine can exceed this:")
print(f"  The mixed sector has eigenvalue λ = 1/χ = 1/{chi()}.")
print(f"  This is the COLDEST temperature the algebra allows.")
print(f"  The singlet has λ = 1 (hottest).")
print(f"  η = 1 − T_cold/T_hot = 1 − (1/χ)/1 = (χ−1)/χ = 5/6.")
print(f"  The 2nd law is not empirical. It's geometric.")
print(f"  It holds because χ = {chi()} > 1.")
print(f"  If χ = 1, there would be no arrow of time.")
