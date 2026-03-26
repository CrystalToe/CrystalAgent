# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""25 — Neutron Stars"""
from crystal_topos import gauss, chi, n_c, d_total, beta0
import math
print("Neutron Stars from the Crystal")
print("=" * 55)
chandrasekhar = (gauss() + chi()) / gauss()
print(f"  Chandrasekhar limit:")
print(f"    M_Ch = (gauss+χ)/gauss × M_☉ = ({gauss()}+{chi()})/{gauss()} = {chandrasekhar:.4f} M_☉")
print(f"    Observed: ~1.4 M_☉")
print(f"    PWI: {abs(chandrasekhar - 1.46)/1.46*100:.2f}%")
print(f"\n  Neutron star radius: ~10 km")
print(f"    R_NS ∝ (gauss/χ) × R_☉ = ({gauss()}/{chi()}) × R_☉")
print(f"\n  Maximum mass (TOV limit):")
print(f"    M_TOV ≈ N_c × M_Ch = {n_c()} × {chandrasekhar:.3f} = {n_c() * chandrasekhar:.3f} M_☉")
print(f"    Observed: ~2.0-2.3 M_☉")
print(f"\n  Neutron degeneracy pressure:")
print(f"    P_deg ∝ (ℏ²/m_n) × n^(5/3)")
print(f"    The 5/3 = (N_c + N_w)/N_c = {(n_c()+2)/n_c():.4f}")
print(f"    Fermi gas exponent from the algebra.")
