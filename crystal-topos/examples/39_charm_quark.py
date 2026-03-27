# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""39 — Charm Quark Mass"""
from crystal_topos import n_w, n_c, gauss
import math

print("Charm Quark Mass from Two Primes")
print("=" * 55)
v_mev = 246220.0
fermat3 = 2**(2**n_c()) + 1
lambda_h = v_mev / fermat3
m_c = lambda_h * n_w()**2 / n_c()
print(f"\n  m_c = Λ_h × N_w²/N_c = {lambda_h:.2f} × {n_w()**2}/{n_c()}")
print(f"      = {m_c:.1f} MeV (MS-bar at m_c)")
print(f"  PDG: 1275 MeV")
print(f"  PWI: {abs(m_c-1275)/1275*100:.3f}%")
print(f"\n  Charm mass = hadron scale × 4/3.")
print(f"  The same 4/3 that is the Casimir factor of QCD.")
