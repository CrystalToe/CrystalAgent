<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalGW.hs — Gravitational Waveforms from (2,3)

## What This Module Does

Binary inspiral waveform generation. Chirp mass, orbital decay, h+ and h×
polarizations, ISCO cutoff — all from (2,3).

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector: weak⊕colour (d=11)

| GW Concept | Value | Engine Source |
|-----------|-------|--------------|
| Quadrupole power | 32/5 | N_w⁵/(χ−1) |
| Polarizations | 2 | N_c − 1 |
| f_GW = 2 f_orb | 2 | N_w |
| Amplitude factor | 4 | N_w² |
| Chirp mass exponents | 3/5, 2/5 | N_c/(χ−1), N_w/(χ−1) |
| ISCO cutoff | 6 | χ |
| Orbital decay | 64/5 | N_w⁶/(χ−1) |
| Kolmogorov in chirp | 5/3 | (χ−1)/N_c |

## Proof Certificate

- `haskel/CrystalGW.hs` — 25 checks (25 PASS)
- `proofs/CrystalGW.lean` — Lean 4 theorems (by native_decide)
- `proofs/CrystalGW.agda` — Agda proofs (by refl)

## Dependencies

- **Imports CrystalEngine** — atoms, sector operations, tick, normSq
- `Data.Ratio`
