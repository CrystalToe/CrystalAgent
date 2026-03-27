# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""102 — Optical Metamaterial Design from Crystal Rationals"""
from crystal_topos import n_w, n_c, chi, beta0, gauss
import math

print("Metamaterial Design: Refractive Index = (2,3) Rational")
print("=" * 60)

# Known crystal refractive indices
n_water = (n_c()**2 - 1) / (2 * n_c())       # 4/3
n_glass = n_c() / n_w()                        # 3/2
n_diamond = (2*gauss() + n_c()) / (n_w()**2 * n_c())  # 29/12

print(f"\n  DERIVED REFRACTIVE INDICES:")
print(f"  {'Material':<12} {'Formula':<30} {'Crystal':>8} {'Expt':>8} {'PWI':>8}")
print(f"  {'-'*12} {'-'*30} {'-'*8} {'-'*8} {'-'*8}")
print(f"  {'Water':<12} {'(N_c²−1)/(2N_c)':<30} {n_water:>8.4f} {1.333:>8.3f} {'● TIGHT':>8}")
print(f"  {'Glass':<12} {'N_c/N_w':<30} {n_glass:>8.4f} {1.500:>8.3f} {'■ EXACT':>8}")
print(f"  {'Diamond':<12} {'(2gauss+N_c)/(N_w²N_c)':<30} {n_diamond:>8.4f} {2.417:>8.3f} {'● TIGHT':>8}")

# Extend: what other (2,3) rationals give valid refractive indices?
print(f"\n  CANDIDATE REFRACTIVE INDICES FROM (2,3):")
print(f"  All rationals from crystal invariants in range [1.0, 4.0]:")
print(f"")
invariants = {
    "N_w": n_w(), "N_c": n_c(), "χ": chi(), "β₀": beta0(),
    "gauss": gauss(), "D": 42, "Σd": 36,
}
candidates = []
for n1, v1 in invariants.items():
    for n2, v2 in invariants.items():
        if v2 != 0 and v1 != v2:
            r = v1 / v2
            if 1.0 < r < 4.0:
                candidates.append((r, f"{n1}/{n2}"))
            r2 = (v1 + 1) / v2
            if 1.0 < r2 < 4.0:
                candidates.append((r2, f"({n1}+1)/{n2}"))

# Sort and deduplicate
seen = set()
unique = []
for val, formula in sorted(candidates):
    rounded = round(val, 4)
    if rounded not in seen:
        seen.add(rounded)
        unique.append((val, formula))

print(f"  {'n':>8} {'Formula':<20} {'Possible material':<25}")
print(f"  {'-'*8} {'-'*20} {'-'*25}")

known_materials = {
    1.333: "Water",
    1.500: "Glass (borosilicate)",
    1.544: "Quartz",
    1.770: "Sapphire",
    2.417: "Diamond",
    3.500: "Silicon",
}

for val, formula in unique[:15]:
    material = ""
    for known_n, name in known_materials.items():
        if abs(val - known_n) / known_n < 0.02:
            material = f"← {name}"
            break
    print(f"  {val:>8.4f} {formula:<20} {material:<25}")

print(f"\n  DESIGN PROTOCOL:")
print(f"  1. Choose target n from the (2,3) rational table above")
print(f"  2. Design metamaterial unit cell to match that geometry")
print(f"  3. Crystal predicts: materials at (2,3) rationals will be")
print(f"     more stable than those at irrational n values")
print(f"  4. The lattice prefers its own eigenvalues")
