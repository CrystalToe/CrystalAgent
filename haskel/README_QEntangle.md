<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalQEntangle.hs — Entanglement Analysis from (2,3)

## What This Module Does

12 entanglement tools: Schmidt decomposition, von Neumann entropy,
concurrence, negativity, PPT criterion (exact for C^2 x C^3),
entanglement witnesses, distillation, formation.

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector: mixed sector (d = 24)

| Tool | Crystal Source |
|------|---------------|
| PPT space | C^N_w x C^N_c = C^2 x C^3 |
| Schmidt rank | min(N_w, N_c) = 2 |
| Max entanglement | ln(N_w) = ln(2) |
| Hilbert dim | chi = 6 |

## Proof Certificate

- `haskel/CrystalQEntangle.hs` — Entanglement analysis for chi=6 system
- `proofs/CrystalQEntangle.lean` — Lean 4 integer identity proofs
- `proofs/CrystalQEntangle.agda` — Agda integer identity proofs

## Dependencies

- CrystalQBase — complex arithmetic, crystal constants
