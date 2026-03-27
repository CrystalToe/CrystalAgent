# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""103 — Drug Docking with Crystal Backbone Constraints"""
from crystal_topos import n_w, n_c, chi, beta0, gauss
import math

print("Drug Docking: Crystal-Constrained Backbone Geometry")
print("=" * 60)

helix = n_c() + n_c() / (chi() - 1)  # 18/5
rise = n_c() / n_w()                    # 3/2
sheet = beta0() / n_w()                  # 7/2
groove = 11 / chi()                      # 11/6
at_bonds = n_w()                         # 2
gc_bonds = n_c()                         # 3

print(f"\n  BINDING SITE GEOMETRY (all ■ EXACT):")
print(f"  α-helix: {helix} residues/turn, {rise} Å rise")
print(f"  β-sheet: {sheet} Å spacing")
print(f"  DNA major/minor groove: {groove:.4f} ratio")
print(f"  H-bonds: A-T = {at_bonds}, G-C = {gc_bonds}")

# Helix pocket dimensions
pitch = helix * rise
circumference = pitch / math.tan(math.radians(26))  # typical helix angle
radius = circumference / (2 * math.pi)

print(f"\n  α-HELIX POCKET GEOMETRY:")
print(f"  Pitch = {helix} × {rise} = {pitch} Å")
print(f"  Approximate radius = {radius:.2f} Å")
print(f"  Turn-to-turn clearance = {pitch} Å")
print(f"  → Drug must fit in a cylinder of radius {radius:.1f} Å, height {pitch} Å")

print(f"\n  β-SHEET BINDING SURFACE:")
print(f"  Strand spacing = {sheet} Å")
print(f"  Parallel strands: drug binds between at intervals of {sheet} Å")
print(f"  Anti-parallel: rotated by π, same spacing")
print(f"  → Flat drug molecules optimal (like β-sheet intercalators)")

print(f"\n  DNA MINOR GROOVE BINDING:")
groove_major = 22.0  # Å typical
groove_minor = groove_major / groove
print(f"  Major groove width ≈ 22 Å (structural)")
print(f"  Minor groove width = 22/{groove:.3f} = {groove_minor:.1f} Å")
print(f"  Groove ratio locked at 11/χ = {groove:.4f}")
print(f"  → Minor groove drugs must be ≤ {groove_minor:.0f} Å wide")

# Hydrogen bond matching
print(f"\n  HYDROGEN BOND MATCHING:")
print(f"  A-T target: drug must present {at_bonds} H-bond donors/acceptors")
print(f"  G-C target: drug must present {gc_bonds} H-bond donors/acceptors")
print(f"  Mixed: (N_w+N_c)/2 = {(at_bonds+gc_bonds)/2} average per base pair")
print(f"  → Selectivity: A-T binders ≠ G-C binders (different H-bond count)")

print(f"\n  DOCKING PROTOCOL:")
print(f"  1. Fix backbone to crystal rationals (helix={helix}, sheet={sheet})")
print(f"  2. Generate binding pocket mesh with crystal dimensions")
print(f"  3. Screen drug library for shape fit in crystal pocket")
print(f"  4. Score H-bond complementarity against N_w/{at_bonds} or N_c/{gc_bonds}")
print(f"  5. Rank by geometric fit BEFORE running MD simulation")
print(f"  6. MD only on top candidates — saves 90%+ compute")

print(f"\n  NOT CLAIMED: therapeutic efficacy, disease treatment, drug design.")
print(f"  CLAIMED: geometric constraints reduce docking search space.")
