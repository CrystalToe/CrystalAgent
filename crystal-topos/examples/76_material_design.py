# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""76 — Material Design: Custom Lattice Structures"""
from crystal_topos import n_w, n_c, chi, gauss, beta0, d_total, sigma_d
print("Material Design from Sector Geometry")
print("=" * 55)
print(f"  RECIPE FOR A NEW MATERIAL:")
print(f"  1. Choose desired property (conductivity, hardness, etc.)")
print(f"  2. Map property to sector requirement:")
sectors = [
    ("Insulator", "singlet-dominated (λ ≈ 1)", "diamond, quartz"),
    ("Conductor", "weak-dominated (λ ≈ 1/N_w)", "copper, gold"),
    ("Semiconductor", "singlet-weak boundary", "silicon, germanium"),
    ("Magnetic", "colour-dominated (λ ≈ 1/N_c)", "iron, cobalt"),
    ("Superconductor", "lattice-locked (all sectors)", "YBCO, MgB₂"),
]
for prop, sector, examples in sectors:
    print(f"     {prop:>15}: {sector} → {examples}")
print(f"\n  3. Find elements whose Z fills the sector requirement")
print(f"  4. Compute the lattice structure that LOCKS the sectors")
print(f"\n  Noble gas shells = sector completions:")
print(f"    He (Z={n_w()}): s complete")
print(f"    Ne (Z={n_w()+n_w()**3}): s+p complete")
print(f"    Ar (Z={n_w()+2*n_w()**3}): s+2p complete")
print(f"    Kr (Z={sigma_d()}): ALL SECTORS complete (Z = Σd)")
print(f"\n  Krypton IS the lattice. Z = Σd = {sigma_d()}.")
print(f"  Every noble gas is a sector completion.")
print(f"  Semiconductor = elements BETWEEN completions.")
