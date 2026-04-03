<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalMD.hs — Molecular Dynamics from (2,3)

## What This Module Does

Velocity Verlet with Lennard-Jones + Coulomb + hydrogen bonds. LJ 6-12
potential where 6 = χ and 12 = 2χ. Bond angles, helix geometry, Flory
exponent — all from (2,3).

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector: weak⊕colour (d=11)

| MD Concept | Value | Engine Source |
|-----------|-------|--------------|
| LJ attractive exponent | 6 | χ |
| LJ repulsive exponent | 12 | 2χ |
| LJ force coefficient | 24 | d_mixed |
| LJ potential coefficient | 4 | N_w² |
| Bond angle arccos(−1/3) | 109.47° | arccos(−1/N_c) |
| H-bonds A-T | 2 | N_w |
| H-bonds G-C | 3 | N_c |
| Helix residues/turn | 18/5 | (N_c²N_w)/(χ−1) |
| Flory ν | 2/5 | N_w/(χ−1) |
| Coulomb exponent | 2 | N_c−1 |

## Proof Certificate

- `haskel/CrystalMD.hs` — 22 checks (22 PASS)
- `proofs/CrystalMD.lean` — Lean 4 theorems (by native_decide)
- `proofs/CrystalMD.agda` — Agda proofs (by refl)

## Dependencies

- **Imports CrystalEngine** — atoms, sector operations, tick, normSq
- `Data.Ratio`
