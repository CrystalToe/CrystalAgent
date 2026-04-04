<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalLayer.hs — MERA Layer

## What This Module Does

Single MERA layer: isometry + disentangler. Building block for the
42-layer tower. Each layer contracts by eigenvalues {1, 1/2, 1/3, 1/6}.

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector: full engine (d = 36)

| Layer Property | Crystal Source |
|---------------|---------------|
| Bond dimension | chi = 6 |
| Contraction | lambda_k eigenvalues |
| Tower depth | towerD = 42 |

## Proof Certificate

- `haskel/CrystalLayer.hs` — MERA layer operations
- `proofs/CrystalLayer.lean` — Lean 4 integer identity proofs
- `proofs/CrystalLayer.agda` — Agda integer identity proofs

## Dependencies

- CrystalEngine — atoms, eigenvalues
