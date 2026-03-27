# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""28 — Muon Mass and the Muon/Electron Ratio"""
from crystal_topos import n_w, n_c, gauss
import math

print("Muon Mass from Two Primes")
print("=" * 55)
v_mev = 246220.0
fermat3 = 2**(2**n_c()) + 1
lambda_h = v_mev / fermat3
m_e = lambda_h / (n_c()**2 * n_w()**4 * gauss())
ratio = n_w()**4 * gauss()
m_mu = m_e * ratio
print(f"\n  m_μ/m_e = N_w⁴ × gauss = {n_w()**4} × {gauss()} = {ratio}")
print(f"  m_e = {m_e:.4f} MeV")
print(f"  m_μ = m_e × {ratio} = {m_mu:.2f} MeV")
print(f"  PDG: 105.658 MeV")
print(f"  PWI: {abs(m_mu - 105.658)/105.658*100:.3f}%")
print(f"\n  Equivalently: m_μ = Λ_h / N_c² = {lambda_h:.2f} / {n_c()**2} = {lambda_h/n_c()**2:.2f}")
