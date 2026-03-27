# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""36 — QCD Confinement Scale"""
from crystal_topos import n_w, n_c, d_total, gauss, beta0
import math

print("Λ_QCD from Two Primes")
print("=" * 55)
v_mev = 246220.0
m_p = v_mev / 2**(2**n_c()) * (d_total()+gauss()-n_w()) / (d_total()+gauss()-n_w()+1)
lambda_qcd = m_p * n_c() / gauss()
print(f"\n  m_p = {m_p:.2f} MeV")
print(f"  Λ_QCD = m_p × N_c/gauss = {m_p:.2f} × {n_c()}/{gauss()}")
print(f"        = {lambda_qcd:.2f} MeV")
print(f"  PDG: 218 ± 25 MeV")
print(f"\n  The proton IS Λ_QCD up to gauss/N_c = {gauss()}/{n_c()}.")
print(f"  Confinement scale from the same two primes.")
f_pi = lambda_qcd * n_c() / beta0()
print(f"\n  f_π = Λ_QCD × N_c/β₀ = {lambda_qcd:.2f} × {n_c()}/{beta0()} = {f_pi:.2f} MeV")
print(f"  PDG: 92.07 MeV, PWI: {abs(f_pi-92.07)/92.07*100:.3f}%")
