<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalProtonRadius.hs — Proton Radius from (2,3)

## What This Module Does

Proton charge radius derived from N_c=3 colour structure.
r_p = sqrt(N_c) / (4 pi m_p) type scaling.

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector: colour (d = 8)

| Observable | Crystal Source |
|-----------|---------------|
| Colour factor | N_c = 3 |
| Radius scaling | sqrt(N_c) |

## Proof Certificate

- `haskel/CrystalProtonRadius.hs` — Proton radius from colour sector
- `proofs/CrystalProtonRadius.lean` — Lean 4 integer identity proofs
- `proofs/CrystalProtonRadius.agda` — Agda integer identity proofs

## Dependencies

- CrystalEngine — atoms (nC)
