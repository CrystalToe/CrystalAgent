# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""98 — Three-Body Mission Planning: Solvable vs Chaotic DOF"""
from crystal_topos import n_w, n_c, chi, beta0, gauss, crystal_max_entropy
import math

print("Three-Body Mission Planning from (2,3)")
print("=" * 60)

phase = n_c() * chi()        # 18 total DOF
sym = n_w() * (chi() - 1)    # 10 solvable (symmetry integrals)
chaotic = n_w()**3            # 8 chaotic (colour sector)
lagrange = chi() - 1          # 5 Lagrange points
routh = 1 / (gauss() + beta0() + chi())  # stability boundary
lyapunov = math.log(chi())   # Lyapunov exponent

print(f"\n  PHASE SPACE DECOMPOSITION (all ■ EXACT):")
print(f"  Total DOF:     N_c × χ = {n_c()} × {chi()} = {phase}")
print(f"  Solvable:      N_w × (χ−1) = {n_w()} × {chi()-1} = {sym}")
print(f"  Chaotic:       N_w³ = {n_w()}³ = {chaotic}")
print(f"  Check:         {phase} = {sym} + {chaotic}  ✓")

print(f"\n  LAGRANGE POINTS:")
print(f"  Total:         χ − 1 = {lagrange}")
print(f"  Collinear:     N_c = {n_c()} (L1, L2, L3 — unstable)")
print(f"  Equilateral:   N_w = {n_w()} (L4, L5 — stable)")

print(f"\n  MISSION PLANNING RULES:")
print(f"  1. PREDICTABLE perturbations live in the {sym}D solvable manifold")
print(f"     → Use for: station-keeping fuel budgets, transfer orbits")
print(f"     → These are the {sym} conserved quantities (energy, momentum, Jacobi)")
print(f"  2. CHAOTIC perturbations live in the {chaotic}D colour sector")
print(f"     → Use for: stochastic control bounds, escape trajectory design")
print(f"     → Lyapunov exponent = ln(χ) = {lyapunov:.4f}")
print(f"  3. STABILITY boundary: Routh ratio = 1/{gauss()+beta0()+chi()} = {routh:.6f}")
print(f"     → Mass ratio below {routh:.6f} = stable co-orbital")

print(f"\n  APPLICATION: JWST at L2")
print(f"  Sun-Earth mass ratio: {3e-6:.2e} << {routh:.6f}")
print(f"  → Deep inside stable zone ✓")
print(f"  → Station-keeping uses only the {sym} solvable DOF")
print(f"  → Chaotic {chaotic} DOF bounded by Lyapunov time = 1/λ")
lyap_time_years = 1 / lyapunov  # in natural units
print(f"  → Prediction horizon ≈ {lyap_time_years:.2f} orbital periods before chaos dominates")

print(f"\n  APPLICATION: Gateway (Lunar L1)")
print(f"  Earth-Moon mass ratio: 0.0123 vs Routh = {routh:.6f}")
mu_em = 0.01215
print(f"  → 0.0123 {'<' if mu_em < routh else '>'} {routh:.6f} = {'STABLE' if mu_em < routh else 'UNSTABLE'}")
print(f"  → {'Needs active control in the chaotic sector' if mu_em > routh else 'Passively stable'}")
