# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""37 — Quark Mass Ratios as Exact Rationals"""
from crystal_topos import n_w, n_c, d_total, gauss, chi
import math

print("Quark Mass Ratios from Two Primes")
print("=" * 55)
num = d_total() + gauss() - n_w()  # 53
den = num + 1  # 54
mt_mb = d_total() * num / den
mb_ms = n_c()**3 * n_w()
mc_ms = n_w()**2 * n_c() * num / den
mu_md = n_c()**2 / (gauss() + chi())
print(f"\n  m_t/m_b = D × 53/54 = {d_total()} × {num}/{den} = {mt_mb:.4f}")
print(f"  PDG: 41.3,  PWI: {abs(mt_mb-41.3)/41.3*100:.2f}%")
print(f"\n  m_b/m_s = N_c³ × N_w = {n_c()**3} × {n_w()} = {mb_ms}")
print(f"  PDG: 44.7")
print(f"\n  m_c/m_s = N_w² × N_c × 53/54 = {mc_ms:.4f}")
print(f"  PDG: 11.8")
print(f"\n  m_u/m_d = N_c²/(gauss+χ) = {n_c()**2}/({gauss()}+{chi()}) = {mu_md:.4f}")
print(f"  PDG: 0.474, PWI: {abs(mu_md-0.474)/0.474*100:.3f}%")
print(f"\n  Every ratio is an exact rational from (2,3).")
