<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalEM.hs — Electromagnetic Field Evolution from (2,3)

## What This Module Does

Yee FDTD (Finite-Difference Time-Domain) for Maxwell's equations.
E and B staggered in space and time — this IS S = W∘U for EM.
Propagation, Rayleigh scattering, Thomson cross-section, Larmor radiation.

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector: colour (d₃ = 8)

| EM Concept | Value | Engine Source |
|-----------|-------|--------------|
| Field components (3E + 3B) | 6 | χ |
| EM sector dimension | 8 | d_colour = N_c²−1 |
| Courant number | 1/2 | 1/N_w |
| Maxwell's equations | 4 | N_c + 1 |
| Speed of light | 1 | χ/χ (Lieb-Robinson) |
| Rayleigh exponent | 4 | N_w² |
| Thomson factor | 8/3 | d_colour/N_c |
| Larmor coefficient | 2/3 | (N_c−1)/N_c |

## Proof Certificate

- `haskel/CrystalEM.hs` — 27 checks (27 PASS)
- `proofs/CrystalEM.lean` — Lean 4 theorems (by native_decide)
- `proofs/CrystalEM.agda` — Agda proofs (by refl)

## Dependencies

- **Imports CrystalEngine** — atoms, sector operations, tick, normSq
- `Data.Ratio`
