# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""87 — Dark Matter Lives in the Colour and Mixed Sectors"""
from crystal_topos import n_w, n_c, chi, gauss, beta0, sigma_d
print("Where Is the Dark Matter?")
print("=" * 55)
omega_L = gauss()/(gauss()+chi())
omega_m = chi()/(gauss()+chi())
omega_b = n_c()/(n_c()*(gauss()+beta0())+1)
omega_DM = omega_m - omega_b
print(f"  COSMIC BUDGET:")
print(f"    Ω_Λ  = gauss/(gauss+χ) = {gauss()}/{gauss()+chi()} = {omega_L:.5f} (dark energy)")
print(f"    Ω_m  = χ/(gauss+χ)     = {chi()}/{gauss()+chi()} = {omega_m:.5f} (all matter)")
print(f"    Ω_b  = 3/61             = {omega_b:.5f} (baryons — us)")
print(f"    Ω_DM = Ω_m − Ω_b       = {omega_DM:.5f} (dark matter)")
print(f"    Planck 2018: 0.2589. PWI: {abs(omega_DM-0.2589)/0.2589*100:.2f}%")
print(f"\n  WHERE IT LIVES:")
print(f"    Visible: singlet(d=1) + weak(d=3) = 4 dimensions")
print(f"    Dark:    colour(d=8) + mixed(d=24) = 32 dimensions")
print(f"    Both gravitate. Only visible couples to photons.")
print(f"\n  Ω_DM/Ω_b = {omega_DM/omega_b:.3f} (Planck: 5.36, PWI: 1.1%)")
print(f"  For every kg of you, there's {omega_DM/omega_b:.1f} kg of dark matter.")
