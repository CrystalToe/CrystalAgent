<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalQGates.hs — Quantum Gates from End(A_F)

## What This Module Does

12 single-particle + 15 multi-particle quantum gates from the 650
endomorphisms of A_F = C + M_2(C) + M_3(C). Pauli group on C^chi = C^6.

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector: mixed sector (d = 24)

| Gate Set | Crystal Source |
|----------|---------------|
| Single gates | chi^2 = 36 |
| Multi gates | chi(chi-1)/2 = 15 |
| CNOT dim | chi^4 = 1296 |
| Pauli group | chi^2 = 36 elements |

## Proof Certificate

- `haskel/CrystalQGates.hs` — Gate algebra for chi=6 system
- `proofs/CrystalQGates.lean` — Lean 4 integer identity proofs
- `proofs/CrystalQGates.agda` — Agda integer identity proofs

## Dependencies

- CrystalQBase — complex arithmetic, crystal constants
