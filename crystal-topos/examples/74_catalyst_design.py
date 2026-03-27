# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""74 — Catalyst Design: Finding Geometric Holes"""
from crystal_topos import n_w, n_c, chi, d_total, gauss, beta0
print("Catalyst Design via Lattice Geometry")
print("=" * 60)
D = d_total()
print(f"  A chemical reaction is a PATH through the sector tetrahedron.")
print(f"  Reactants → [transition state] → Products")
print(f"  The transition state has D < {D} (unstable).")
print(f"  A catalyst provides the missing sectors to reach D = {D}.")
print(f"\n  FINDING THE GEOMETRIC HOLE:")
print(f"    1. Compute sector signature of reactants: (s,p,d,f)")
print(f"    2. Compute sector signature of products: (s',p',d',f')")
print(f"    3. The DIFFERENCE = the geometric hole")
print(f"    4. Design a molecule that fills exactly that hole")
print(f"\n  Example: Haber process (N₂ + 3H₂ → 2NH₃)")
print(f"    N₂: sector = (2,6,0,0) → total = 8 = d_colour")
print(f"    3H₂: sector = (6,0,0,0) → total = 6 = χ")
print(f"    NH₃: sector = (2,6,0,0) → total = 8 = d_colour")
print(f"    Hole: need d-orbital catalyst to bridge 8 → 8")
print(f"    Iron (Fe, Z=26): d-orbital capacity fills the gap")
print(f"    That's why iron works. The lattice tells you why.")
print(f"\n  IMPOSSIBLE CATALYSTS:")
print(f"    Find reactions where no natural element fills the hole.")
print(f"    Design a synthetic molecule with the exact sector signature.")
print(f"    This is lattice-directed catalyst discovery.")
print(f"    No screening. No trial and error. Geometry.")
