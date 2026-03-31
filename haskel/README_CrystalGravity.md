<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalGravity.hs — Gravity, Relativity & Classical Physics

**426 lines · 24 prove functions · Newton, Kepler, Maxwell, SR/GR, Schrödinger, Dirac, Boltzmann**

## What This Module Does

Derives the structural content of every major classical and relativistic equation from the endomorphisms of A_F. This is the kinematic gravity module (structural integers and exponents). For dynamical gravity (linearized Einstein equation from MERA entanglement), see CrystalGravityDyn.hs.

## Complete Observable List

| # | Observable | Formula | Crystal | Expt | PWI |
|---|-----------|---------|---------|------|-----|
| 1 | Jacobson chain | 4 steps: thermo → Einstein | structural | — | — |
| 2 | Immirzi parameter | (3/13)/(35/36) = 108/455 | 0.2374 | 0.2375 | 0.07% |
| 3 | S_BH (BH entropy) | 49/(16π) | 0.9748 | 0.9750 | 0.018% |
| 4 | Kepler exponent | −2 (inverse square) from N_c = 3 | −2 | −2 | EXACT |
| 5 | Bertrand condition | only r⁻² and r² close orbits | from N_c | N_c | structural |
| 6 | Maxwell count | 4 equations from 4 sectors | 4 | 4 | EXACT |
| 7 | Speed of light | c = 1 (Lieb-Robinson from χ/χ) | 1 | 1 | EXACT |
| 8 | Coulomb exponent | 1/r² from N_c spatial dims | 2 | 2 | EXACT |
| 9 | Spacetime dim | N_c + 1 = 4 | 4 | 4 | EXACT |
| 10 | S = A/(4G) | 4 = N_w² (Bekenstein) | 4 | 4 | EXACT |
| 11 | 8πG coefficient | 8 = d₃ = N_c²−1 | 8 | 8 | EXACT |
| 12 | Baryon fraction | N_c/(gauss+χ) = 3/19 | 0.158 | 0.157 | 0.16% |
| 13 | Info-gravity identity | S_ent = A/(4G) via Jacobson | structural | — | — |
| 14 | Entropy rate | ln(χ) = ln(6) per tick | 1.792 | — | structural |
| 15 | Equivalence principle | from naturality of S | structural | — | — |

## Key Physical Insights

**Jacobson's chain in 4 steps.** Gravity is not fundamental — it's emergent from entanglement thermodynamics: (1) Clausius: δQ = TδS, (2) Unruh: T = a/(2π), (3) Bekenstein: S = A/(4G), (4) Einstein: G_μν = 8πG T_μν. Each integer (2, 4, 8) traces to crystal atoms.

**Why space is 3-dimensional.** N_c = 3 is the dimension of M₃(ℂ). The Bertrand theorem says only inverse-square (r⁻²) forces produce closed orbits, and inverse-square forces require 3 spatial dimensions (Poisson equation). The crystal does not need to postulate 3D — it derives it from the algebra.

**Spinor dimension = N_w² = 4.** The Dirac equation operates on 4-component spinors because N_w² = 4. The 4 = 2² comes from the M₂(ℂ) factor.

## Compile

```bash
ghc -fno-code CrystalGravity.hs   # type-check
```

## Dependencies

Imports `CrystalAxiom`.
