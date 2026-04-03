<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalQChannels.hs — Quantum Channels from (2,3)

## What This Module Does

10 quantum channels: depolarising, amplitude/phase damping, bit/phase flip,
thermal relaxation, Kraus operators, Lindblad master equation, process tomography.
All rates and targets derived from sector eigenvalues and dimensions.

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector: mixed sector (d = 24)

| Channel | Crystal Source |
|---------|---------------|
| Depolarise target | I/chi = I/6 |
| Amplitude damp | sector eigenvalue decay |
| Phase damp | off-diagonal contraction |
| Bit flip | cyclic sector shift |
| Phase flip | crystal phase gate |
| Thermal | Gibbs at KMS beta=2pi |
| Kraus count | chi^2 + 1 = 37 |
| Process matrix | chi^4 = 1296 |
| Lindblad | creation/annihilation ops |

## Proof Certificate

- `haskel/CrystalQChannels.hs` — 11 checks (11 PASS)
- `proofs/CrystalQChannels.lean` — Lean 4 integer identity proofs
- `proofs/CrystalQChannels.agda` — Agda integer identity proofs

## Dependencies

- **Imports CrystalEngine** (qualified as CE) via CrystalQBase
- CrystalQBase — complex arithmetic, vector/matrix operations
