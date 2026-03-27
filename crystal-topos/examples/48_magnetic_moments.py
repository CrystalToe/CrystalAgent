# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""48 — Nucleon Magnetic Moments"""
from crystal_topos import n_w, n_c, chi, beta0, d_total, gauss
import math

print("Nucleon Magnetic Moments from Two Primes")
print("=" * 55)
mu_p = n_w() * beta0() / (chi() - 1)
mu_n_val = -n_c() * beta0() / (chi() * n_w()) + n_w()**3 / (gauss() * beta0())
mu_n_simple = -n_c() * beta0() / (chi() * n_w())
print(f"\n  μ_p/μ_N = N_w × β₀/(χ−1) = {n_w()} × {beta0()}/({chi()}-1)")
print(f"         = {n_w()*beta0()}/{chi()-1} = {mu_p:.4f}")
print(f"  PDG: 2.7928, PWI: {abs(mu_p-2.7928)/2.7928*100:.3f}%")

mu_n_corr = -n_c() * beta0() / (chi() * n_w()) - n_w()**3 / (gauss() * beta0())
print(f"\n  μ_n/μ_N = −N_c×β₀/(χ×N_w) − N_w³/(gauss×β₀)")
print(f"         = −{n_c()*beta0()}/{chi()*n_w()} − {n_w()**3}/{gauss()*beta0()}")
print(f"         = {mu_n_corr:.4f}")
print(f"  PDG: −1.9130, PWI: {abs(mu_n_corr-(-1.9130))/1.9130*100:.3f}%")
print(f"\n  Proton: simple ratio from β₀ and χ.")
print(f"  Neutron: sector boundary correction −N_w³/(gauss×β₀) = −8/91.")
