# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""43 — Tau Lepton Mass"""
from crystal_topos import n_w, n_c, gauss, beta0
import math

print("Tau Lepton Mass from Two Primes")
print("=" * 55)
v_mev = 246220.0
fermat3 = 2**(2**n_c()) + 1
lambda_h = v_mev / fermat3
m_tau = lambda_h * gauss() / beta0()
print(f"\n  m_τ = Λ_h × gauss/β₀ = {lambda_h:.2f} × {gauss()}/{beta0()}")
print(f"      = {m_tau:.1f} MeV")
print(f"  PDG: 1776.86 MeV")
print(f"  PWI: {abs(m_tau-1776.86)/1776.86*100:.3f}%")
print(f"\n  The heaviest lepton locked to the QCD hadron scale")
print(f"  through gauss/β₀ = {gauss()}/{beta0()} — the confinement ratio.")
