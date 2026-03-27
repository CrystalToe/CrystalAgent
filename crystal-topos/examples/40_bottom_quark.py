# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""40 — Bottom Quark Mass"""
from crystal_topos import n_w, n_c, d_total, gauss
import math

print("Bottom Quark Mass from Two Primes")
print("=" * 55)
v_mev = 246220.0
fermat3 = 2**(2**n_c()) + 1
lambda_h = v_mev / fermat3
m_e = lambda_h / (n_c()**2 * n_w()**4 * gauss())
m_b = lambda_h * gauss() / n_c() + m_e * d_total()
print(f"\n  m_b = Λ_h × gauss/N_c + m_e × D")
print(f"      = {lambda_h:.2f} × {gauss()}/{n_c()} + {m_e:.4f} × {d_total()}")
print(f"      = {lambda_h*gauss()/n_c():.1f} + {m_e*d_total():.1f}")
print(f"      = {m_b:.1f} MeV (MS-bar at m_b)")
print(f"  PDG: 4180 MeV")
print(f"  PWI: {abs(m_b-4180)/4180*100:.3f}%")
print(f"\n  The D×m_e = {d_total()}×{m_e:.3f} = {m_e*d_total():.1f} MeV correction")
print(f"  is spectral-dimension QED dressing.")
