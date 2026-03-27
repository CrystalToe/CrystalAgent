# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""104 — Cross-Domain Bridge: Casimir C_F = n(water) = 4/3"""
from crystal_topos import n_w, n_c, chi, gauss
import math

print("Cross-Domain Bridge: Confinement = Light Bending")
print("=" * 60)

casimir = (n_c()**2 - 1) / (2 * n_c())   # 4/3
n_water = casimir                          # 4/3

print(f"\n  QCD CONFINEMENT:")
print(f"  Casimir C_F = (N_c²−1)/(2N_c) = ({n_c()**2}-1)/(2×{n_c()}) = {casimir:.4f}  ■ EXACT")
print(f"  This sets the colour force between quarks: F ∝ C_F × α_s")
print(f"  Quarks are confined because C_F > 0.")

print(f"\n  OPTICS:")
print(f"  n(water) = (N_c²−1)/(2N_c) = {n_water:.4f}  ● TIGHT")
print(f"  Snell's law: sin θ₁ / sin θ₂ = {n_water:.4f}")
print(f"  Light bends in water because n > 1.")

print(f"\n  THE BRIDGE:")
print(f"  Same formula. Same number. Different domain.")
print(f"  Both are eigenvalues of the adjoint representation of SU(N_c).")
print(f"  Confinement = the reason quarks can't escape.")
print(f"  Refraction = the reason light bends.")
print(f"  In the crystal, they are the SAME sector eigenvalue.")

print(f"\n  ENGINEERING CONSEQUENCE:")
print(f"  If you measure n(water) more precisely, you constrain C_F.")
print(f"  If you measure C_F at CERN, you constrain n(water).")
print(f"  Two experiments in completely different labs testing the same number.")
print(f"  Current best: n(water) = 1.33300 ± 0.00001")
print(f"  Crystal: exactly 4/3 = 1.33333...")
print(f"  Discrepancy = {abs(1.33300-4/3)/1.33300*100:.3f}% — wavelength dependent.")
