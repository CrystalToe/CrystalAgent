<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalCFD.hs — Lattice Boltzmann Fluid Dynamics from (2,3)

## What This Module Does

D2Q9 Lattice Boltzmann Method. Poiseuille flow, lid-driven cavity.
Collide-stream = S = W∘U on the colour sector. All from (2,3).

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector: colour (d₃ = 8)

| CFD Concept | Value | Engine Source |
|-----------|-------|--------------|
| D2Q9 velocities | 9 | N_c² |
| Colour sector | 8 | d₃ = N_c²−1 |
| Sound speed² | 1/3 | 1/N_c |
| Weight rest | 4/9 | N_w²/N_c² |
| Weight cardinal | 1/9 | 1/N_c² |
| Weight diagonal | 1/36 | 1/Σd |
| Kolmogorov −5/3 | −(χ−1)/N_c | |
| Stokes drag | 24 | d_mixed |
| Blasius 1/4 | 1/N_w² | |
| Von Kármán 2/5 | N_w/(χ−1) | |

## Proof Certificate

- `haskel/CrystalCFD.hs` — 20 checks (20 PASS)
- `proofs/CrystalCFD.lean` — Lean 4 theorems (by native_decide)
- `proofs/CrystalCFD.agda` — Agda proofs (by refl)

## Dependencies

- **Imports CrystalEngine** — atoms, sector operations, tick, normSq
- `Data.Array`, `Data.List`, `Data.Ratio`
