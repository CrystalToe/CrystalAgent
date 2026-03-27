# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""46 — Mass Splittings"""
from crystal_topos import n_w, n_c, d_total, gauss, beta0
import math

print("Mass Splittings from Two Primes")
print("=" * 55)
v_mev = 246220.0
fermat3 = 2**(2**n_c()) + 1
lambda_h = v_mev / fermat3
m_e = lambda_h / (n_c()**2 * n_w()**4 * gauss())
m_p = v_mev / 2**(2**n_c()) * (d_total()+gauss()-n_w()) / (d_total()+gauss()-n_w()+1)
lambda_qcd = m_p * n_c() / gauss()

pi_split = n_c()**2 * m_e
np_diff = lambda_qcd / gauss()**2

print(f"\n  π± − π⁰ = N_c² × m_e = {n_c()**2} × {m_e:.4f}")
print(f"          = {pi_split:.3f} MeV")
print(f"  PDG: 4.594 MeV, PWI: {abs(pi_split-4.594)/4.594*100:.3f}%")
print(f"\n  n − p = Λ_QCD / gauss² = {lambda_qcd:.2f} / {gauss()**2}")
print(f"        = {np_diff:.3f} MeV")
print(f"  PDG: 1.293 MeV, PWI: {abs(np_diff-1.293)/1.293*100:.3f}%")
print(f"\n  Electromagnetic splitting = colour² × electron mass.")
print(f"  Isospin splitting = confinement scale / gauss².")
