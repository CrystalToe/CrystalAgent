<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalPlasma.hs — MHD Plasma Dynamics from (2,3)

## What This Module Does

Magnetohydrodynamics: Alfvén waves, magnetic pressure, plasma beta,
Bondi accretion, MRI growth rate. MHD = EM + CFD merged in colour sector.

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector: colour (d₃ = 8 = EM + fluid merged)

| MHD Concept | Value | Engine Source |
|-----------|-------|--------------|
| MHD state variables | 8 | d_colour = N_w³ |
| Wave types | 3 | N_c |
| Propagating modes | 6 | χ |
| EM components | 6 | χ |
| Bondi factor | 4 | N_w² |
| MRI rate | 3/4 Ω | N_c/N_w² |

## New Features (this session)

- `bondiAccretion` — Ṁ = N_w²·π·G²·M²·ρ/c_s³
- `mriGrowthRate` — max growth = (N_c/N_w²)·Ω = (3/4)Ω

## Proof Certificate

- `haskel/CrystalPlasma.hs` — 25 checks (25 PASS)

## Dependencies

- **Imports CrystalEngine** — atoms, sector operations, tick, normSq
- `Data.Array`
