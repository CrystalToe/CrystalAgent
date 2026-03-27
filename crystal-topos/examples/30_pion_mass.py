# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""30 — Pion Mass: The Goldstone Boson"""
from crystal_topos import n_w, n_c, d_total, gauss, beta0
import math

print("Pion Mass from Two Primes")
print("=" * 55)
v_mev = 246220.0
num = d_total() + gauss() - n_w()  # 53
den = num + 1  # 54
m_p = v_mev / 2**(2**n_c()) * num / den
m_pi = m_p / beta0()
print(f"\n  m_p = v/256 × 53/54 = {m_p:.2f} MeV")
print(f"  m_π = m_p / β₀ = {m_p:.2f} / {beta0()} = {m_pi:.2f} MeV")
print(f"  PDG: 134.977 MeV")
print(f"  PWI: {abs(m_pi - 134.977)/134.977*100:.3f}%")
print(f"\n  The pion IS the proton divided by the running coefficient.")
print(f"  Chiral symmetry breaking = spectral action at scale m_p/β₀.")
