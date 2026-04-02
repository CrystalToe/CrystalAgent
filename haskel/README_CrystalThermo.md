<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->
# CrystalThermo.hs — Thermodynamic Dynamics from (2,3)

## What This Module Does
Molecular dynamics with Lennard-Jones potential. Velocity Verlet integrator.
Heat capacity, adiabatic indices, Carnot efficiency — all from (2,3).

## Integer Map
| Quantity | Value | Crystal Source |
|----------|-------|---------------|
| LJ attractive exp | 6 | χ |
| LJ repulsive exp | 12 | 2χ |
| LJ force prefactor | 24 | d_mixed = N_w³N_c |
| γ_monatomic | 5/3 | (χ-1)/N_c |
| γ_diatomic | 7/5 | β₀/(χ-1) |
| DOF monatomic | 3 | N_c |
| DOF diatomic | 5 | χ-1 |
| Carnot | 5/6 | (χ-1)/χ |
| ΔS per tick | ln(6) | ln(χ) |
| Stokes drag | 24 | d_mixed |

## Proof Certificate
- `proofs/crystal_thermo_proof.py` — 23/23 PASS
- `proofs/CrystalThermo.lean` — 12 theorems
- `proofs/CrystalThermo.agda` — 11 proofs
