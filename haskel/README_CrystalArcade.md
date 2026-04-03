<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalArcade.hs — Approximation Layers from (2,3)

## What This Module Does

Every approximation parameter is a controlled degradation of an exact Crystal
module. LJ cutoffs, Barnes-Hut theta, fixed-point bits, LOD levels, mean-field
Ising, Newton-Raphson iterations — all trace to (2,3).

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Key Mappings

| Approximation | Value | Engine Source |
|--------------|-------|--------------|
| Verlet order | 2 | N_w |
| Euler order | 1 | d₁ |
| Octree children | 8 | d_colour = sectorDim 2 |
| LJ cutoff | 3σ | N_c |
| Barnes-Hut θ | 1/2 | 1/N_w |
| Fixed-point bits | 16 | N_w⁴ |
| Spatial hash cells | 3 | N_c |
| LOD levels | 3 | N_c |
| Mean-field T_c | 4 | N_w² |
| Newton-Raphson iter | 2 | N_w |
| Phase space | 6 | χ |

## Proof Certificate

- `haskel/CrystalArcade.hs` — 25 checks (25 PASS)
- `proofs/CrystalArcade.lean` — Lean 4 theorems (by native_decide)
- `proofs/CrystalArcade.agda` — Agda proofs (by refl)

## Dependencies

- **Imports CrystalEngine** — atoms, sector operations, tick, normSq
- `Data.Ratio`
