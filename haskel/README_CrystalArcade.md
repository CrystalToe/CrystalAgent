<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->
# CrystalArcade — Approximation Layers from (2,3)
## Overview
Every game/sim approximation parameter traced to A_F. Cutoffs, precision, LOD — all from (2,3).
## Integer Traces
| Approximation | Value | Crystal derivation |
|---|---|---|
| LJ cutoff | 3σ | N_cσ |
| Barnes-Hut θ | 0.5 | 1/N_w |
| Octree children | 8 | d_colour = N_w³ |
| WCA cutoff | 2^(1/6)σ | N_w^(1/χ)σ |
| Euler order | 1 | d₁ |
| Verlet order | 2 | N_w |
| Fixed-point | 16.16 | N_w⁴.N_w⁴ |
| Spatial hash | 3 cells | N_c |
| LOD levels | 3 | N_c |
| Mean-field T_c | 4 | N_w² |
| Newton-Raphson | 2 iter | N_w |
| Fast α⁻¹ | 137 | ⌊(D+1)π+lnβ₀⌋ |
## Self-Test
```bash
ghc -O2 -main-is CrystalArcade CrystalArcade.hs 2>/dev/null && ./CrystalArcade
```
## Observable Count
12 new. All integers from (2,3).
