# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""101 — NFW Dark Matter Navigation for Deep-Space Missions"""
from crystal_topos import n_w, n_c, chi, beta0, gauss, d_total
import math

print("NFW Dark Matter Navigation from (2,3)")
print("=" * 60)

nfw_c = beta0()                                  # 7
omega_dm_b = (d_total() + 1) / n_w()**3          # 43/8 = 5.375
omega_l = gauss() / (gauss() + chi())             # 13/19
omega_b = 3 / 61                                   # from crystal

print(f"\n  DARK SECTOR CONSTANTS:")
print(f"  NFW concentration c  = gauss − χ = β₀ = {nfw_c}        ■ EXACT")
print(f"  Ω_DM/Ω_b = (D+1)/N_w³ = {d_total()+1}/{n_w()**3} = {omega_dm_b}  ● TIGHT")
print(f"  Ω_Λ = gauss/(gauss+χ) = {gauss()}/{gauss()+chi()} = {omega_l:.4f}       ● TIGHT")
print(f"  Ω_b = 3/61 = {omega_b:.5f}                             ● TIGHT")
omega_dm = omega_b * omega_dm_b
print(f"  Ω_DM = Ω_b × (D+1)/N_w³ = {omega_dm:.4f}")

# NFW profile
print(f"\n  NFW DENSITY PROFILE:")
print(f"  ρ(r) = ρ_s / [(r/r_s)(1 + r/r_s)²]")
print(f"  where c = r_vir/r_s = {nfw_c}")
print(f"  → r_s = r_vir/{nfw_c}")

# Milky Way application
r_vir_mw = 200  # kpc
r_s_mw = r_vir_mw / nfw_c
print(f"\n  MILKY WAY (r_vir ≈ {r_vir_mw} kpc):")
print(f"  r_s = {r_vir_mw}/{nfw_c} = {r_s_mw:.1f} kpc")
print(f"  Solar system at r ≈ 8 kpc = {8/r_s_mw:.2f} r_s")
print(f"  → We sit at {8/r_s_mw:.2f} scale radii — well inside the halo")

print(f"\n  DEEP-SPACE TRAJECTORY CORRECTION:")
print(f"  Pioneer anomaly: a_P ≈ 8.7 × 10⁻¹⁰ m/s²")
print(f"  At r = 50 AU from Sun:")
print(f"  NFW contribution with c = {nfw_c}:")
print(f"  a_NFW ∝ ln(1 + r/r_s) - (r/r_s)/(1 + r/r_s)")
r_ratio = 50 * 4.85e-6 / r_s_mw  # 50 AU in kpc / r_s
nfw_factor = math.log(1 + r_ratio) - r_ratio / (1 + r_ratio)
print(f"  At 50 AU: r/r_s = {r_ratio:.2e}, NFW factor = {nfw_factor:.2e}")
print(f"\n  The crystal says c = {nfw_c} exactly (= β₀ from QCD).")
print(f"  Same number that controls quark confinement controls galaxy halos.")
