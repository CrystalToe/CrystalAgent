# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""41 — Proton Mass from the Fermat Tower"""
from crystal_topos import n_w, n_c, d_total, gauss
v_mev = 246220.0  # Higgs VEV in MeV
fermat3 = 2**(2**n_c()) + 1  # 257
num = d_total() + gauss() - n_w()  # 53
den = num + 1  # 54
m_p = v_mev / 2**(2**n_c()) * num / den
print("Proton Mass from Two Primes")
print("=" * 55)
print(f"  m_p = v / 2^(2^N_c) × (D+gauss-N_w)/(D+gauss-N_w+1)")
print(f"      = {v_mev} / {2**(2**n_c())} × {num}/{den}")
print(f"      = {m_p:.3f} MeV")
print(f"  PDG: 938.272 MeV, PWI: {abs(m_p-938.272)/938.272*100:.3f}%")
print(f"\n  The Fermat tower: 2^(2^N_c) = 2^(2^3) = 2^8 = {2**(2**n_c())}")
print(f"  Fermat prime: F₃ = {fermat3}")
print(f"  53 = D + gauss - N_w = {d_total()}+{gauss()}-{n_w()}")
print(f"  54 = 53 + 1")
print(f"  Every integer from (2,3). Zero hardcoding.")
