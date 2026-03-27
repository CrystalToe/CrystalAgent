# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""35 — Υ Bottomonium"""
from crystal_topos import n_w, n_c, d_total, gauss
import math

print("Υ (Upsilon) from Two Primes")
print("=" * 55)
v_mev = 246220.0
fermat3 = 2**(2**n_c()) + 1
lambda_h = v_mev / fermat3
upsilon_2s = lambda_h * d_total() / n_w()**2
print(f"\n  Υ(2S) = Λ_h × D/N_w² = {lambda_h:.2f} × {d_total()}/{n_w()**2}")
print(f"        = {upsilon_2s:.1f} MeV")
print(f"  PDG: 10023.3 MeV")
print(f"  PWI: {abs(upsilon_2s-10023.3)/10023.3*100:.3f}%")
print(f"\n  The spectral dimension D = {d_total()} sets the bottomonium scale.")
