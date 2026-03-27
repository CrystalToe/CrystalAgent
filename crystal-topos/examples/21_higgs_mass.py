# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""21 — Higgs Boson Mass from the Crystal"""
from crystal_topos import n_w, n_c, chi, beta0, d_total, gauss, sigma_d
import math

print("Higgs Mass from Two Primes")
print("=" * 55)
v_mev = 246220.0
m_h = v_mev * math.sqrt(2 * n_c() / gauss())
print(f"\n  m_H = v × √(2N_c/gauss)")
print(f"      = {v_mev} × √(2×{n_c()}/{gauss()})")
print(f"      = {v_mev} × √({2*n_c()}/{gauss()})")
print(f"      = {m_h:.1f} MeV")
print(f"  PDG: 125100 MeV")
print(f"  PWI: {abs(m_h - 125100)/125100*100:.3f}%")
print(f"\n  The Higgs quartic λ = N_c/gauss = 3/13.")
print(f"  m_H = v√(2λ). Every number from (2,3).")
