# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""33 — Eta and Eta Prime Mesons"""
from crystal_topos import n_w, n_c, beta0, gauss
import math

print("η and η' from Two Primes")
print("=" * 55)
v_mev = 246220.0
fermat3 = 2**(2**n_c()) + 1
lambda_h = v_mev / fermat3
m_eta = lambda_h * n_w()**2 / beta0()
m_etap = lambda_h
print(f"\n  Λ_h = v/F₃ = v/{fermat3} = {lambda_h:.2f} MeV")
print(f"\n  η  = Λ_h × N_w²/β₀ = {lambda_h:.2f} × {n_w()**2}/{beta0()}")
print(f"     = {m_eta:.2f} MeV  (PDG: 547.862, PWI: {abs(m_eta-547.862)/547.862*100:.3f}%)")
print(f"\n  η' = Λ_h = {m_etap:.2f} MeV")
print(f"     PDG: 957.78 MeV, PWI: {abs(m_etap-957.78)/957.78*100:.3f}%")
print(f"\n  The η' IS the hadron scale. The U(1)_A anomaly = Fermat prime.")
