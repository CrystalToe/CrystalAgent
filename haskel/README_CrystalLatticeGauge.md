<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalLatticeGauge.hs — Wilson Lattice Gauge Theory from (2,3)

## What This Module Does

Wilson plaquette action as S = W∘U. SU(3) gauge links, Wilson loops,
string tension, Casimir operators, confinement — all from (2,3).

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector: colour (d₃ = 8, gauge links)

| Gauge Concept | Value | Engine Source |
|-------------|-------|--------------|
| SU(3) generators | 8 | d₃ = N_c²−1 |
| Plaquettes per site | 6 | χ |
| Lattice coupling β | 6 | χ |
| β₀ (asymptotic freedom) | 7 | (11N_c−2χ)/3 |
| Spacetime dimensions | 4 | N_c + 1 |
| String tension num/den | 3/8 | N_c/d_colour |
| Casimir C_F | 4/3 | (N_c²−1)/(2N_c) |

## Proof Certificate

- `haskel/CrystalLatticeGauge.hs` — 46 checks (46 PASS)

## Dependencies

- **Imports CrystalEngine** — atoms, d1-d4, sector operations, tick, normSq
