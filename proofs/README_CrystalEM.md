<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalEM.hs — Electromagnetic Field Evolution from (2,3)

## What This Module Does

Yee FDTD = monad S = W∘U on the EM sector. Propagates EM waves at c = 1.
Larmor radiation, Rayleigh scattering, Planck/Stefan-Boltzmann — all from (2,3).

## The EM Integer Map

| Quantity | Value | Crystal Source |
|----------|-------|---------------|
| EM field components | 6 | χ = N_w × N_c |
| E components | 3 | N_c |
| B components | 3 | N_c |
| 2-form dim C(4,2) | 6 | χ |
| Maxwell equations | 4 | N_c + 1 |
| c (speed of light) | 1 | χ/χ |
| Larmor coefficient | 2/3 | (N_c-1)/N_c |
| Rayleigh λ exponent | 4 | N_w² |
| Rayleigh size exponent | 6 | χ |
| Planck λ exponent | 5 | χ-1 |
| Stefan T exponent | 4 | N_w² |
| Stefan denominator | 15 | N_c(χ-1) |
| U(1) gauge group | 1 | singlet sector |

## Key Result

Wave propagates at exactly c = 1 (peak displacement = expected c×t to machine precision).
The Yee FDTD preserves ∇·B = 0 exactly (staggered grid guarantee).

## Proof Certificate

- `proofs/crystal_em_proof.py` — 34/34 PASS
- `proofs/CrystalEM.lean` — 18 theorems
- `proofs/CrystalEM.agda` — 11 proofs
