# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""49 — Cosmological Constants"""
from crystal_topos import n_w, n_c, chi, beta0, d_total, gauss, crystal_kappa
import math

print("Cosmological Constants from Two Primes")
print("=" * 55)
kappa = crystal_kappa()

# Dark energy
omega_l = gauss() / (gauss() + chi())
print(f"\n  Ω_Λ = gauss/(gauss+χ) = {gauss()}/({gauss()}+{chi()}) = {gauss()}/{gauss()+chi()} = {omega_l:.4f}")
print(f"  Planck: 0.6847, PWI: {abs(omega_l-0.6847)/0.6847*100:.3f}%")

# Spectral index
n_s = 1 - kappa / d_total()
print(f"\n  n_s = 1 − κ/D = 1 − {kappa:.5f}/{d_total()} = {n_s:.5f}")
print(f"  Planck: 0.9649, PWI: {abs(n_s-0.9649)/0.9649*100:.3f}%")

# CMB temperature
t_cmb = (gauss() + chi()) / beta0()
print(f"\n  T_CMB = (gauss+χ)/β₀ = ({gauss()}+{chi()})/{beta0()} = {gauss()+chi()}/{beta0()} = {t_cmb:.4f} K")
print(f"  Obs: 2.7255 K, PWI: {abs(t_cmb-2.7255)/2.7255*100:.3f}%")

# Baryon density
omega_b = 3 / 61
print(f"\n  Ω_b = 3/61 = {omega_b:.5f}")
print(f"  Planck: 0.0490, PWI: {abs(omega_b-0.0490)/0.0490*100:.2f}%")

# DM/baryon ratio
dm_b = (d_total()+1) / n_w()**3
print(f"\n  Ω_DM/Ω_b = (D+1)/N_w³ = {d_total()+1}/{n_w()**3} = {dm_b:.4f}")
print(f"  Planck: 5.36, PWI: {abs(dm_b-5.36)/5.36*100:.2f}%")
