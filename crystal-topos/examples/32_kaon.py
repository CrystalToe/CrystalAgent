# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""32 — Kaon Masses from the Crystal"""
from crystal_topos import n_w, n_c, beta0, d_total, gauss
import math

print("Kaon Masses from Two Primes")
print("=" * 55)
v_mev = 246220.0
m_p = v_mev / 2**(2**n_c()) * (d_total()+gauss()-n_w()) / (d_total()+gauss()-n_w()+1)
m_pi = m_p / beta0()
fermat3 = 2**(2**n_c()) + 1
lambda_h = v_mev / fermat3
m_e = lambda_h / (n_c()**2 * n_w()**4 * gauss())
m_kc = m_pi * (gauss() - n_w()) / n_c()
m_k0 = m_kc + m_e * beta0()
print(f"\n  K± = m_π × (gauss−N_w)/N_c = m_π × {gauss()-n_w()}/{n_c()}")
print(f"     = {m_kc:.2f} MeV  (PDG: 493.677, PWI: {abs(m_kc-493.677)/493.677*100:.3f}%)")
print(f"\n  K⁰ = K± + m_e×β₀ = {m_kc:.2f} + {m_e*beta0():.2f}")
print(f"     = {m_k0:.2f} MeV  (PDG: 497.611, PWI: {abs(m_k0-497.611)/497.611*100:.3f}%)")
