# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""42 — Top Quark Mass"""
from crystal_topos import n_w, n_c, gauss, beta0
import math

print("Top Quark Mass from Two Primes")
print("=" * 55)
v_mev = 246220.0
m_t = v_mev * beta0() / (gauss() - n_c())
print(f"\n  m_t = v × β₀/(gauss−N_c)")
print(f"      = {v_mev} × {beta0()}/({gauss()}−{n_c()})")
print(f"      = {v_mev} × {beta0()}/{gauss()-n_c()}")
print(f"      = {m_t:.0f} MeV")
print(f"  PDG: 172760 MeV (pole)")
print(f"  PWI: {abs(m_t-172760)/172760*100:.3f}%")
print(f"\n  The only quark with Yukawa coupling O(1).")
print(f"  β₀/(gauss−N_c) = 7/10: pure spectral data.")
