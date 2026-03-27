# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""17 — Neutrino Masses from the Crystal"""
from crystal_topos import n_w, n_c, chi, beta0, d_total, gauss
import math

print("Neutrino Masses from Two Primes")
print("=" * 55)
v_mev = 246220.0
fermat3 = 2**(2**n_c()) + 1
lambda_h = v_mev / fermat3
m_e = lambda_h / (n_c()**2 * n_w()**4 * gauss())

# Seesaw scale
m_nu_scale = m_e**2 / (v_mev * n_w())
print(f"\n  Seesaw: m_ν ~ m_e² / (v × N_w)")
print(f"        = {m_e:.4f}² / ({v_mev} × {n_w()})")
print(f"        = {m_nu_scale*1e3:.4f} eV")

# Mass squared differences
dm21 = m_e**2 / (v_mev * d_total())
print(f"\n  Δm²₂₁ scale: m_e²/(v×D)")
print(f"  Normal ordering: m₁ < m₂ < m₃")
print(f"\n  Crystal prediction: Dirac neutrinos (not Majorana).")
print(f"  Falsifiable: 0νββ null result at LEGEND, nEXO (2030+).")
print(f"  If 0νββ detected → crystal is dead.")
