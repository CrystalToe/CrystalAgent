<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalFullTest.hs — Integration Test

## What This Module Does

Full integration test suite. Runs all module self-tests and cross-checks.

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector: all sectors (d = 36)

| Test | Count |
|------|-------|
| Module tests | 64 modules |
| Cross-checks | gauss=13, nC=3 |

## Proof Certificate

- `haskel/CrystalFullTest.hs` — 92 integration checks
- `proofs/CrystalFullTest.lean` — Lean 4 integer identity proofs
- `proofs/CrystalFullTest.agda` — Agda integer identity proofs

## Dependencies

- All Crystal* modules
