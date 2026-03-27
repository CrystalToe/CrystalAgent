# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""38 — Strange Quark Mass"""
from crystal_topos import n_w, n_c, d_total, gauss, beta0
import math

print("Strange Quark Mass from Two Primes")
print("=" * 55)
v_mev = 246220.0
m_p = v_mev / 2**(2**n_c()) * (d_total()+gauss()-n_w()) / (d_total()+gauss()-n_w()+1)
lambda_qcd = m_p * n_c() / gauss()
m_s = lambda_qcd * n_c() / beta0()
print(f"\n  Λ_QCD = {lambda_qcd:.2f} MeV")
print(f"  m_s = Λ_QCD × N_c/β₀ = {lambda_qcd:.2f} × {n_c()}/{beta0()}")
print(f"      = {m_s:.1f} MeV (MS-bar at 2 GeV)")
print(f"  PDG: 93.4 MeV")
print(f"  PWI: {abs(m_s-93.4)/93.4*100:.3f}%")
