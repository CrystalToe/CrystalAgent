<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalOptics — Ray/Wave Optics from (2,3)

## Overview

Snell ray tracing + Fresnel coefficients. Rayleigh scattering and Planck radiance.
Index of refraction of water traced to Casimir factor C_F = (N_c²−1)/(2N_c) = 4/3.

## Integer Traces

| Physical quantity | Value | Crystal derivation |
|---|---|---|
| IOR water | 4/3 | C_F = (N_c²−1)/(2N_c) |
| IOR glass | 3/2 | N_c / N_w |
| Rayleigh λ exponent | 4 | N_w² |
| Rayleigh size exponent | 6 | χ |
| Planck λ exponent | 5 | χ−1 |

## Self-Test

Snell exact, total internal reflection, Brewster Rp=0, sky blue ratio ~5.8, Wien peak.

```bash
ghc -O2 -main-is CrystalOptics CrystalOptics.hs 2>/dev/null && ./CrystalOptics
```

## Observable Count

5 new (n_water, n_glass, Rayleigh 4, Rayleigh 6, Planck 5). All integers from (2,3).
