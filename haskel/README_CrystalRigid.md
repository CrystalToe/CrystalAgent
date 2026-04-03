<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalRigid.hs — Rigid Body Dynamics from (2,3)

## What This Module Does

Quaternion integrator + Euler equations for rigid body rotation. Tumbling
asymmetric tops, tennis racket instability, moments of inertia — all from (2,3).

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector Restriction: weak (d=3, rotation)

| Rigid Body Concept | Value | Engine Source |
|-------------------|-------|--------------|
| Rotation axes | 3 | N_c |
| Quaternion components | 4 | N_w² |
| Inertia tensor (independent) | 6 | χ |
| Rigid DOF (3 translate + 3 rotate) | 6 | χ |
| Rotation matrix entries | 9 | N_c² |
| I_sphere | 2/5 | N_w/(χ−1) |
| I_rod | 1/12 | 1/(2χ) |
| I_disk | 1/2 | 1/N_w |
| I_shell | 2/3 | N_w/N_c |

## Proof Certificate

- `haskel/CrystalRigid.hs` — 24 checks (24 PASS)
- `proofs/CrystalRigid.lean` — Lean 4 theorems (by native_decide)
- `proofs/CrystalRigid.agda` — Agda proofs (by refl)

## Dependencies

- **Imports CrystalEngine** — atoms, sector operations, tick, normSq
- `Data.Ratio`
