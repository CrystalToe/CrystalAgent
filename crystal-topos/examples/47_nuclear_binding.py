# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""47 — Nuclear Binding Energies"""
from crystal_topos import n_w, n_c, d_total, gauss, beta0, chi
import math

print("Nuclear Binding from Two Primes")
print("=" * 55)
v_mev = 246220.0
fermat3 = 2**(2**n_c()) + 1
lambda_h = v_mev / fermat3
m_e = lambda_h / (n_c()**2 * n_w()**4 * gauss())
m_p = v_mev / 2**(2**n_c()) * (d_total()+gauss()-n_w()) / (d_total()+gauss()-n_w()+1)
m_pi = m_p / beta0()

# Deuteron binding
deut_be = m_pi * n_c() / (chi() * beta0())
print(f"\n  Deuteron BE = m_π × N_c/(χ×β₀) = {m_pi:.2f} × {n_c()}/({chi()}×{beta0()})")
print(f"             = {deut_be:.3f} MeV")
print(f"  Exp: 2.225 MeV, PWI: {abs(deut_be-2.225)/2.225*100:.2f}%")

# 4He binding
he4_be = m_pi * n_w() * n_c() / beta0()
print(f"\n  ⁴He BE = m_π × N_w×N_c/β₀ = {m_pi:.2f} × {n_w()*n_c()}/{beta0()}")
print(f"         = {he4_be:.2f} MeV")
print(f"  Exp: 28.296 MeV")

# Neutron lifetime
tau_n = d_total()**2 / n_w() - n_w()**2
print(f"\n  τ_n = D²/N_w − N_w² = {d_total()}²/{n_w()} − {n_w()}² = {d_total()**2//n_w()} − {n_w()**2} = {tau_n:.0f} s")
print(f"  Exp: 878.4 s, PWI: {abs(tau_n-878.4)/878.4*100:.3f}%")
