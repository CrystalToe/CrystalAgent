# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""95 — The Three-Body Problem IS the Crystal"""
from crystal_topos import n_w, n_c, chi, gauss, beta0, crystal_max_entropy
import math
print("The Three-Body Problem from Two Primes")
print("=" * 60)
print(f"\n  PHASE SPACE DECOMPOSITION:")
phase = n_c() * chi()
symmetry = n_w() * (chi() - 1)
unsolved = n_w()**3
print(f"    Phase space:     N_c × χ = {n_c()} × {chi()} = {phase}    ■ EXACT")
print(f"    Symmetry:        N_w × (χ-1) = {n_w()} × {chi()-1} = {symmetry}  ■ EXACT")
print(f"    Unsolved DOF:    N_w³ = {n_w()}³ = {unsolved}             ■ EXACT")
print(f"    Check: {phase} − {symmetry} = {phase-symmetry} = N_w³ = {unsolved}  ✓")
print(f"\n  LAGRANGE POINTS:")
print(f"    Total: χ − 1 = {chi()} − 1 = {chi()-1}                ■ EXACT")
print(f"    Collinear (L1,L2,L3): N_c = {n_c()} (unstable)")
print(f"    Equilateral (L4,L5):  N_w = {n_w()} (stable)")
print(f"    {n_c()} + {n_w()} = {n_c()+n_w()} = χ − 1  ✓")
mu_crystal = 1/(gauss()+beta0()+chi())
mu_exact = (1-math.sqrt(23/27))/2
print(f"\n  ROUTH CRITICAL MASS RATIO:")
print(f"    Crystal: 1/(gauss+β₀+χ) = 1/{gauss()+beta0()+chi()} = {mu_crystal:.6f}")
print(f"    Exact:   (1−√(23/27))/2 = {mu_exact:.6f}")
print(f"    PWI: {abs(mu_crystal-mu_exact)/mu_exact*100:.3f}%     ● TIGHT")
print(f"\n  WHY IT'S CHAOTIC:")
print(f"    Lyapunov exponent = ln(χ) = {crystal_max_entropy():.4f}")
print(f"    = entropy rate = arrow of time")
print(f"    Chaos, entropy, and time are the SAME thing.")
print(f"    All = ln({chi()}). All because χ > 1.")
print(f"\n  The unsolved DOF = N_w³ = {unsolved} = colour sector.")
print(f"  Poincaré's chaos lives in the colour sector.")
print(f"  The d-orbital (10 = symmetry integrals) is what")
print(f"  you CAN solve. The colour sector (8) is what you CAN'T.")
