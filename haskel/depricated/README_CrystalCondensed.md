<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalCondensed — Ising/BCS from (2,3)

## Overview

Metropolis Monte Carlo for 2D Ising model on square lattice.
BCS superconducting gap ratio. All coordination numbers and
state counts traced to A_F atoms.

## Integer Traces

| Physical quantity | Value | Crystal derivation |
|---|---|---|
| Square lattice z | 4 | N_w² |
| Cubic lattice z | 6 | χ |
| Ising spin states | 2 | N_w |
| Onsager T_c numerator | 2 | N_w |
| Critical exponent β | 1/8 | 1/N_w³ |
| Ground E per site | −2 | −N_w |
| BCS prefactor | 2 | N_w |

## Self-Test

Phase transition (|M|=1 at T=1, |M|≈0.09 at T=5), Onsager T_c, BCS ratio 3.528.

```bash
ghc -O2 -main-is CrystalCondensed CrystalCondensed.hs 2>/dev/null && ./CrystalCondensed
```

## Observable Count

7 new. All integers from (2,3).
