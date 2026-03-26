# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""27 — Gravitational Waves: LIGO from End(A_F)"""
from crystal_topos import n_c, n_w, chi, d_total
print("Gravitational Waves from the Crystal")
print("=" * 55)
print(f"\n  GW polarisations: 2 (+ and ×)")
print(f"    = N_c - 1 = {n_c()-1} (massless spin-2)")
print(f"    Graviton has spin N_c - 1 = 2")
print(f"\n  Quadrupole formula:")
print(f"    Leading order: l = N_c - 1 = {n_c()-1} (quadrupole)")
print(f"    No dipole radiation (momentum conservation)")
print(f"    No monopole radiation (mass conservation)")
print(f"\n  LIGO detection GW150914:")
print(f"    f_peak ∝ c³/(G×M_total)")
print(f"    Every constant from the crystal:")
print(f"      c from LR bound (χ = {chi()})")
print(f"      G from hierarchy (e^{d_total()}/35)")
print(f"\n  Ringdown:")
print(f"    Damped oscillation → Kerr BH")
print(f"    QNM frequencies: ω = ω_R + i/τ")
print(f"    Spectrum from BH area = 4π r_s² (4π = N_w² × π)")
