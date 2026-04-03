<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalNoether.hs — Noether Theorem from (2,3)

## What This Module Does

Noether's theorem in the crystal topos: every symmetry of S = W∘U
gives a conserved quantity. Sector structure provides the symmetries.

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector: all sectors (d = 36)

Conservation laws from sector decomposition.

## Proof Certificate

- `haskel/CrystalNoether.hs` — Noether conservation proofs
- `proofs/CrystalNoether.lean` — Lean 4 integer identity proofs
- `proofs/CrystalNoether.agda` — Agda integer identity proofs

## Dependencies

- CrystalEngine — atoms, sector operations
