<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalFriedmann.hs — Cosmological Expansion from (2,3)

## What This Module Does

Friedmann equation integration. Ω_Λ, Ω_m, CMB temperature, spectral tilt,
age of the universe — all from (2,3).

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector: weak⊕colour (d=11, a(t) + curvature)

| Cosmological Parameter | Value | Engine Source |
|----------------------|-------|--------------|
| Ω_Λ | 13/19 | gauss/(gauss+χ) |
| Ω_m | 6/19 | χ/(gauss+χ) |
| T_CMB | 19/7 | (gauss+χ)/β₀ |
| 100θ* | 100/96 | 100/(N_w(D+χ)) |
| Age | 97/7 | (gauss·β₀+χ)/β₀ |
| w_DE | −1 | Landauer erasure |
| Matter exponent | 3 | N_c (in 1/a³) |
| Radiation exponent | 4 | N_c+1 (in 1/a⁴) |

## Proof Certificate

- `haskel/CrystalFriedmann.hs` — 23 checks (23 PASS)
- `proofs/CrystalFriedmann.lean` — Lean 4 theorems (by native_decide)
- `proofs/CrystalFriedmann.agda` — Agda proofs (by refl)

## Dependencies

- **Imports CrystalEngine** — atoms, sector operations, tick, normSq
- `Data.Ratio`
