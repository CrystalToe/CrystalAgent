<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalQMeasure.hs — Measurement Operators from (2,3)

## What This Module Does

8 measurement operators: sector projectors, POVM elements, Born rule
on crystal state, weak measurement, measurement disturbance.

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector: mixed sector (d = 24)

| Measurement | Crystal Source |
|-------------|---------------|
| POVM dim | chi = 6 |
| Sector outcomes | 4 sectors |
| Projectors | chi = 6 basis states |
| State space | sigmaD = 36 |

## Proof Certificate

- `haskel/CrystalQMeasure.hs` — Measurement operators for chi=6 system
- `proofs/CrystalQMeasure.lean` — Lean 4 integer identity proofs
- `proofs/CrystalQMeasure.agda` — Agda integer identity proofs

## Dependencies

- CrystalQBase — complex arithmetic, crystal constants
