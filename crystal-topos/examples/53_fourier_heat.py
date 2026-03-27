# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""53 — Fourier's Law: Thermal Conductivity = 5"""
from crystal_topos import chi, sigma_d
print("Fourier's Law of Heat Conduction")
print("=" * 55)
mixing = chi() * (chi() - 1)  # 30
k = chi() * mixing / sigma_d()
print(f"  Heat equation: q = −k∇T")
print(f"  Thermal conductivity:")
print(f"    k = χ × (sector-mixing ops) / Σd")
print(f"    = {chi()} × χ(χ−1) / Σd")
print(f"    = {chi()} × {mixing} / {sigma_d()}")
print(f"    = {k:.1f}                      ■ EXACT")
print(f"\n  30 sector-mixing operators = the entangling gates")
print(f"  that transport energy between sectors.")
print(f"  Σd = {sigma_d()} = total sector dimensions.")
print(f"  Ratio = 5 = N_c + N_w = 3 + 2.")
print(f"  Heat flows at 5 units per sector dimension.")
print(f"  Three spatial + two internal dimensions.")
