<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalQSimulation.hs — 12 Simulation Methods from (2,3)

## What This Module Does

12 methods: state vector, density matrix, MPS, TEBD, exact diag, Lanczos,
Trotter, QMC, VMC, Wigner function, Clifford, capacity limits.
Bond dimension = chi = 6. No truncation needed.

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector: mixed sector (d = 24)

| Method | Crystal Limit |
|--------|---------------|
| State vector | chi^5 = 7776 (5 particles) |
| Density matrix | chi^3 = 216 (3 particles) |
| Exact diag | chi^4 = 1296 (4 particles) |
| MPS bond dim | chi = 6 (exact) |
| Wigner grid | chi x chi = 6x6 |
| Clifford group | chi^2 = 36 |
| Fock(2) | 1 + 6 + 36 = 43 |

## Proof Certificate

- `haskel/CrystalQSimulation.hs` — 18 checks (17 PASS, 1 FAIL pre-existing QMC normalization)
- `proofs/CrystalQSimulation.lean` — Lean 4 integer identity proofs
- `proofs/CrystalQSimulation.agda` — Agda integer identity proofs

## Dependencies

- **Imports CrystalEngine** (qualified as CE) via CrystalQBase
- CrystalQBase — complex arithmetic, crystal constants
