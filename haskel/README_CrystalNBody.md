<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalNBody.hs — N-Body Gravitational Dynamics from (2,3)

## What This Module Does

N-body gravitational dynamics with Barnes-Hut octree (O(N log N)) and
symplectic leapfrog integration. Two-body Kepler orbits, Plummer sphere
clusters. All from (2,3).

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector Restriction

Same as CrystalClassical: each body's phase space lives in **weak⊕colour** (d = 11).

| N-Body Concept | Engine Sector | Dimension |
|---------------|---------------|-----------|
| Position per body | weak (sector 1) | d₂ = 3 |
| Velocity per body | colour (sector 2, first 3) | 3 of d₃ = 8 |
| Phase space per body | χ | 6 |
| Oct-tree children | d_colour = N_c²−1 | 8 |
| Force law 1/r² | N_c − 1 | 2 |

## Proof Certificate

- `haskel/CrystalNBody.hs` — 18 checks (17 PASS, 1 pre-existing tuning FAIL)
- `proofs/CrystalNBody.lean` — 14 Lean 4 theorems (by native_decide)
- `proofs/CrystalNBody.agda` — 12 Agda proofs (by refl)

## Dependencies

- **Imports CrystalEngine** — atoms, types, sector operations, tick, normSq
- `Data.Ratio`, `Data.List`
- Domain-specific: Body type, OctTree, Barnes-Hut force, Plummer sphere
