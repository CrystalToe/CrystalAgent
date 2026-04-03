<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalQBase.hs — Shared Quantum Types from (2,3)

## What This Module Does

Base types for the crystal quantum library. Complex arithmetic, vector and matrix
operations, and all crystal constants derived from N_w=2, N_c=3. Every quantum
module imports this.

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector: all sectors (d = 36)

| Constant | Value | Source |
|----------|-------|--------|
| nW | 2 | input |
| nC | 3 | input |
| chi | 6 | nW * nC |
| dims | [1,3,8,24] | sector decomposition |
| sigmaD | 36 | sum dims |
| sigmaD2 | 650 | sum dims^2 = End(A_F) |
| lambdas | [1, 1/2, 1/3, 1/6] | eigenvalues |
| energies | [0, ln2, ln3, ln6] | -ln(lambda) |
| kappa | ln3/ln2 | scaling dimension |

## Proof Certificate

- `haskel/CrystalQBase.hs` — Provides constants to all CrystalQ* modules
- `proofs/CrystalQBase.lean` — Lean 4 integer identity proofs
- `proofs/CrystalQBase.agda` — Agda integer identity proofs

## Dependencies

- No external Crystal dependencies (this IS the base)
