<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalAudit.hs — Audit Infrastructure

## What This Module Does

Cross-module consistency checks. Verifies that all modules agree on
atom values and sector dimensions. Infrastructure module.

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector: all sectors (d = 36)

| Check | Value |
|-------|-------|
| sigmaD | 36 |
| towerD | 42 |
| beta0 | 7 |
| chi | 6 |

## Proof Certificate

- `haskel/CrystalAudit.hs` — 18 cross-module consistency checks
- `proofs/CrystalAudit.lean` — Lean 4 integer identity proofs
- `proofs/CrystalAudit.agda` — Agda integer identity proofs

## Dependencies

- CrystalEngine — atoms, sector operations
- Multiple Crystal* modules — audit targets
