# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""22 — W Boson Mass"""
from crystal_topos import n_w, n_c, chi, gauss
import math

print("W Boson Mass from Two Primes")
print("=" * 55)
v_mev = 246220.0
sin2w = n_c() / gauss()
m_w = v_mev / 2 * math.sqrt(n_c() / gauss()) * math.sqrt(gauss() / (gauss() - n_c()))
# Simpler: M_W = v × g/2, g² = 4π α/sin²θ
alpha = 1.0 / (43 * math.pi + math.log(7))
g2 = 4 * math.pi * alpha / sin2w
m_w2 = v_mev / 2 * math.sqrt(g2)
print(f"\n  sin²θ_W = N_c/gauss = {n_c()}/{gauss()}")
print(f"  α = 1/((D+1)π + ln β₀) = 1/(43π + ln 7)")
print(f"  g² = 4πα/sin²θ_W = {g2:.6f}")
print(f"  M_W = v/2 × √g² = {m_w2:.1f} MeV")
print(f"  PDG: 80377 MeV")
print(f"  PWI: {abs(m_w2 - 80377)/80377*100:.3f}%")
