<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalCFD — Lattice Boltzmann Fluid Dynamics from (2,3)

## Overview

Lattice Boltzmann Method (LBM) on D2Q9 lattice.
Monad S = W·U: collision (BGK relaxation) = W, streaming (propagation) = U.

## Integer Traces

| Physical quantity | Value | Crystal derivation |
|---|---|---|
| D2Q9 velocity count | 9 | N_c² |
| Kolmogorov exponent | −5/3 | −(χ−1)/N_c |
| Stokes drag | 24 | d_mixed |
| Blasius exponent | 1/4 | 1/N_w² |
| Von Kármán constant | 2/5 | N_w/(χ−1) |
| Rest weight | 4/9 | N_w²/N_c² |
| Cardinal weight | 1/9 | 1/N_c² |
| Diagonal weight | 1/36 | 1/Σd |
| Sound speed² | 1/3 | 1/N_c |

## Self-Test

Poiseuille channel flow (body-force driven), mass conservation, density uniformity.

```bash
ghc -O2 -main-is CrystalCFD CrystalCFD.hs 2>/dev/null && ./CrystalCFD
```

## Observable Count

0 new (infrastructure). All integers from (2,3).
