<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalMD — Molecular Dynamics from (2,3)

## Overview

Velocity Verlet integrator with Lennard-Jones, Coulomb, and H-bond potentials.
LJ exponents 6,12 traced to χ, 2χ. Force coefficient 24 = d_mixed.

## Integer Traces

| Physical quantity | Value | Crystal derivation |
|---|---|---|
| LJ attractive exponent | 6 | χ |
| LJ repulsive exponent | 12 | 2χ |
| LJ potential coefficient | 4 | N_w² |
| LJ force coefficient | 24 | d_mixed |
| Tetrahedral bond angle | arccos(−1/3) | arccos(−1/N_c) |
| H-bonds A-T | 2 | N_w |
| H-bonds G-C | 3 | N_c |
| Helix residues/turn | 3.6 = 18/5 | (N_c²·N_w)/(χ−1) |
| Flory exponent ν | 2/5 | N_w/(χ−1) |
| Coulomb exponent | 2 | N_c−1 |

## Self-Test

Energy conserved to 3×10⁻⁹, bond angle exact, Coulomb inverse-square verified.

```bash
ghc -O2 -main-is CrystalMD CrystalMD.hs 2>/dev/null && ./CrystalMD
```

## Observable Count

10 new. All integers from (2,3).
