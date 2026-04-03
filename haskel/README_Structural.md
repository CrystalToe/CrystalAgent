<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalStructural.hs — Structural Proofs

## What This Module Does

Structural proofs for the crystal topos: sector orthogonality,
completeness, dimension identities, eigenvalue ordering.

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector: all sectors (d = 36)

Proves infrastructure theorems used by all other modules.

## Proof Certificate

- `haskel/CrystalStructural.hs` — Structural identity proofs
- `proofs/CrystalStructural.lean` — Lean 4 integer identity proofs
- `proofs/CrystalStructural.agda` — Agda integer identity proofs

## Dependencies

- CrystalEngine — atoms, sector operations
