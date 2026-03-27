# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""34 — J/ψ Charmonium"""
from crystal_topos import n_w, n_c, gauss, beta0
import math

print("J/ψ from Two Primes")
print("=" * 55)
v_mev = 246220.0
fermat3 = 2**(2**n_c()) + 1
lambda_h = v_mev / fermat3
jpsi = lambda_h * gauss() / n_w()**2
print(f"\n  J/ψ = Λ_h × gauss/N_w² = {lambda_h:.2f} × {gauss()}/{n_w()**2}")
print(f"      = {jpsi:.1f} MeV")
print(f"  PDG: 3096.9 MeV")
print(f"  PWI: {abs(jpsi-3096.9)/3096.9*100:.3f}%")
m_p_est = v_mev / 2**(2**n_c()) * 53/54
m_pi = m_p_est / beta0()
eta_c = jpsi - m_pi
print(f"\n  η_c = J/ψ − m_π = {jpsi:.1f} − {m_pi:.1f} = {eta_c:.1f} MeV")
print(f"  PDG: 2983.9 MeV, PWI: {abs(eta_c-2983.9)/2983.9*100:.3f}%")
print(f"  Hyperfine splitting = exactly one pion mass.")
