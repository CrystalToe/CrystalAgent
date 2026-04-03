<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalGR.hs — General Relativistic Orbits from (2,3)

## What This Module Does

Schwarzschild geodesic integration via symplectic leapfrog. Mercury precession,
light bending, ISCO, Shapiro delay, photon geodesics, accretion disk temperature,
Einstein ring — all from (2,3).

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector: weak⊕colour (d = 3 + 8 = 11, position + curvature)

| GR Concept | Value | Engine Source |
|-----------|-------|--------------|
| Schwarzschild factor | 2 | N_c − 1 |
| Precession factor | 6 | χ |
| Light bending factor | 4 | N_w² |
| ISCO radius | 6GM | χ·GM |
| ISCO = 3 r_s | 3 | N_c |
| Spacetime dimensions | 4 | N_c + 1 |
| 16πG coefficient | 16 | N_w⁴ |
| Radiative efficiency 8/9 | 8, 9 | d_colour, N_c² |
| Einstein ring factor | 4 | N_w² |

## New Features (this session)

- `diskTemperature` — T(r) ∝ r^{−3/4}, inner edge at ISCO = χ·GM
- `radiativeEfficiency` — η = 1 − √(8/9) where 8 = d_colour, 9 = N_c²
- `einsteinRadius` — θ_E = √(N_w²·GM·D_LS/(D_L·D_S))

## Proof Certificate

- `haskel/CrystalGR.hs` — 23 checks (23 PASS)
- `proofs/CrystalGR.lean` — Lean 4 theorems (by native_decide)
- `proofs/CrystalGR.agda` — Agda proofs (by refl)

## Dependencies

- **Imports CrystalEngine** — atoms, sector operations, tick, normSq
- `Data.Ratio`
