# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""23 — Z Boson Mass"""
from crystal_topos import n_w, n_c, gauss, beta0, d_total
import math

print("Z Boson Mass from Two Primes")
print("=" * 55)
v_mev = 246220.0
sin2w = n_c() / gauss()  # 3/13
cos2w = 1 - sin2w        # 10/13
alpha = 1.0 / ((d_total() + 1) * math.pi + math.log(beta0()))
g2 = 4 * math.pi * alpha / sin2w
m_w = v_mev / 2 * math.sqrt(g2)
m_z = m_w / math.sqrt(cos2w)
print(f"\n  M_Z = M_W / cos θ_W")
print(f"  cos²θ_W = 1 - N_c/gauss = {gauss()-n_c()}/{gauss()}")
print(f"  M_Z = {m_z:.1f} MeV")
print(f"  PDG: 91188 MeV")
print(f"  PWI: {abs(m_z - 91188)/91188*100:.3f}%")
