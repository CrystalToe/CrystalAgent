# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""24 — Electron Mass from the Hadron Scale"""
from crystal_topos import n_w, n_c, gauss
import math

print("Electron Mass from Two Primes")
print("=" * 55)
v_mev = 246220.0
fermat3 = 2**(2**n_c()) + 1  # 257
lambda_h = v_mev / fermat3
m_e = lambda_h / (n_c()**2 * n_w()**4 * gauss())
factor = n_c()**2 * n_w()**4 * gauss()
print(f"\n  Λ_h = v / F₃ = {v_mev} / {fermat3} = {lambda_h:.2f} MeV")
print(f"  m_e = Λ_h / (N_c² × N_w⁴ × gauss)")
print(f"      = {lambda_h:.2f} / ({n_c()**2} × {n_w()**4} × {gauss()})")
print(f"      = {lambda_h:.2f} / {factor}")
print(f"      = {m_e:.4f} MeV")
print(f"  PDG: 0.51100 MeV")
print(f"  PWI: {abs(m_e - 0.51100)/0.51100*100:.3f}%")
print(f"\n  1872 = 9 × 16 × 13 = N_c² × N_w⁴ × gauss")
print(f"  The three quadratic invariants of A_F.")
