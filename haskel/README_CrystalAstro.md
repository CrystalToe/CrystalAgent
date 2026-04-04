<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->
# CrystalAstro — Astrophysical Extremes from (2,3)
## Overview
Lane-Emden stellar structure, Chandrasekhar limit, Schwarzschild, Hawking, stellar scaling.
Every astrophysical exponent from A_F.
## Integer Traces
| Physical quantity | Value | Crystal derivation |
|---|---|---|
| Polytrope (WD) | 3/2 | N_c/N_w |
| Polytrope (rel) | 3 | N_c |
| Schwarzschild | 2 | N_w |
| Hawking T | 8 | d_colour = N_w³ |
| Stefan-Boltzmann | 15 | N_c(χ−1) |
| Eddington | 4 | N_w² |
| MS luminosity | 7/2 | β₀/N_w |
| MS lifetime | 5/2 | (χ−1)/N_w |
| Virial | 2 | N_w |
| Gravitational PE | 3/5 | N_c/(χ−1) |
| Chandrasekhar μ_e | 2 | N_w |
| Jeans T exponent | 3/2 | N_c/N_w |
| Jeans ρ exponent | 1/2 | 1/N_w |
## Self-Test (4 sections, 19 checks)

| Section | What | Checks |
|---------|------|--------|
| S1 | 13 integer identities | 13 |
| S2 | Lane-Emden n=3/2 (white dwarf, ξ₁≈3.654) | 1 |
| S3 | Lane-Emden n=3 (Chandrasekhar, ξ₁≈6.897) | 1 |
| S4 | Structural cross-checks (grav PE, MS exponents, Hawking×Eddington, SB) | 4 |

## Compile

```bash
ghc -O2 -main-is CrystalAstro CrystalAstro.hs && ./CrystalAstro
```

## Import Chain

Data.Ratio + CrystalAtoms (qualified as CE, atoms only: nW, nC, chi, beta0, sigmaD).
Refactored: was CrystalEngine.

## Proofs

| Proof file | Theorems | Method |
|------------|----------|--------|
| CrystalAstro.agda | 10 | refl |
| CrystalAstro.lean | 13 | native_decide |

## Observable Count

13 new. All integers from (2,3).
