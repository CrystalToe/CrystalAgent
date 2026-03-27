# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""105 — Cross-Domain Bridge: β₀ = NFW Concentration = 7"""
from crystal_topos import n_w, n_c, chi, beta0, gauss
import math

print("Cross-Domain Bridge: QCD Running = Galaxy Halos")
print("=" * 60)

b0 = beta0()  # 7
nfw = gauss() - chi()  # 13 - 6 = 7

print(f"\n  QCD (PARTICLE PHYSICS):")
print(f"  β₀ = (11N_c − 2χ)/3 = (11×{n_c()} − 2×{chi()})/3 = {b0}  ■ EXACT")
print(f"  This is the one-loop beta function coefficient.")
print(f"  It governs asymptotic freedom: quarks are free at high energy,")
print(f"  confined at low energy. β₀ = {b0} controls the running of α_s.")

print(f"\n  COSMOLOGY (GALAXY STRUCTURE):")
print(f"  NFW c = gauss − χ = {gauss()} − {chi()} = {nfw}  ■ EXACT")
print(f"  The NFW concentration parameter sets the shape of dark matter halos.")
print(f"  c = {nfw} is the ratio of virial radius to scale radius.")

print(f"\n  THE BRIDGE:")
print(f"  β₀ = NFW c = {b0}")
print(f"  The number that tells quarks how strongly to bind")
print(f"  is the SAME number that tells galaxies how to shape their halos.")
print(f"  Both = {b0}. Both derived from (2,3).")

print(f"\n  WHY THIS MATTERS:")
print(f"  1. Lattice QCD constrains β₀ from first principles")
print(f"  2. Galaxy surveys (SDSS, DES) constrain NFW c from observations")
print(f"  3. Crystal says they must agree: both = {b0}")
print(f"  4. Any tension between particle physics and cosmology")
print(f"     would falsify the crystal's structure at sector level")
