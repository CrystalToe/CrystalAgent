# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""31 — Rho Meson and Vector Mesons"""
from crystal_topos import n_w, n_c, chi, beta0, d_total, gauss
import math

print("Rho Meson from Two Primes")
print("=" * 55)
v_mev = 246220.0
m_p = v_mev / 2**(2**n_c()) * (d_total()+gauss()-n_w()) / (d_total()+gauss()-n_w()+1)
m_pi = m_p / beta0()
m_rho = m_pi * (d_total() - beta0()) / chi()
ratio = (d_total() - beta0()) / chi()
print(f"\n  m_ρ = m_π × (D−β₀)/χ")
print(f"      = {m_pi:.2f} × ({d_total()}-{beta0()})/{chi()}")
print(f"      = {m_pi:.2f} × 35/6")
print(f"      = {m_rho:.1f} MeV")
print(f"  PDG: 775.26 MeV")
print(f"  PWI: {abs(m_rho - 775.26)/775.26*100:.3f}%")
