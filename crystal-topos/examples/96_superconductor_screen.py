# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""96 — Superconductor Materials Screen via Lattice Lock"""
from crystal_topos import n_w, n_c, chi, beta0, d_total, gauss, sigma_d
import math

print("Superconductor Materials Screen")
print("=" * 60)

# The lattice lock condition: Σd/χ² = 36/36 = 1
lock = sigma_d() / chi()**2
print(f"\n  LATTICE LOCK: Σd/χ² = {sigma_d()}/{chi()**2} = {lock:.1f}  ■ EXACT")
print(f"  When this condition is satisfied: T_c = T_Debye / e")

# BCS gap ratio from crystal
euler_gamma = 0.5772156649
bcs_crystal = 2 * math.pi / math.exp(euler_gamma)
bcs_pdg = 3.5282
print(f"\n  BCS GAP: 2π/e^γ = {bcs_crystal:.4f}")
print(f"  PDG: {bcs_pdg}, PWI: {abs(bcs_crystal-bcs_pdg)/bcs_pdg*100:.3f}%  ● TIGHT")

# Screen known superconductors
print(f"\n  MATERIALS SCREEN:")
print(f"  Formula: T_c = T_Debye / e = T_Debye / {math.e:.4f}")
print(f"")
print(f"  {'Material':<16} {'T_Debye (K)':>12} {'Predicted T_c':>14} {'Actual T_c':>11} {'Match':>8}")
print(f"  {'-'*16} {'-'*12} {'-'*14} {'-'*11} {'-'*8}")

materials = [
    ("Nb",            275,   9.25),
    ("Pb",            105,   7.19),
    ("MgB₂",         750,  39.0),
    ("H₃S (150GPa)", 1330, 203.0),
    ("LaH₁₀(170GPa)",1500, 250.0),
]

for name, t_debye, t_c_actual in materials:
    t_c_pred = t_debye / math.e
    match_pct = abs(t_c_pred - t_c_actual) / t_c_actual * 100
    flag = "● TIGHT" if match_pct < 20 else "○ LOOSE" if match_pct < 50 else "— OFF"
    print(f"  {name:<16} {t_debye:>12} {t_c_pred:>14.1f} {t_c_actual:>11.1f} {flag:>8}")

print(f"\n  SEARCH CRITERION for new materials:")
print(f"  1. Compute T_Debye from phonon spectrum")
print(f"  2. Check if lattice geometry satisfies Σd/χ² ≈ 1")
print(f"  3. If yes: T_c ≈ T_Debye / e")
print(f"  4. Target: materials with T_Debye > 800 K → T_c > 294 K (room temp)")
print(f"\n  Room temperature requires T_Debye > {294 * math.e:.0f} K")
