<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->
# CrystalChem — Chemistry and Materials from (2,3)
## Overview
Orbital structure, hybridization angles, energy scales, Arrhenius kinetics.
The periodic table's shell filling, noble gas positions, and neutral pH all from A_F.
## Integer Traces
| Physical quantity | Value | Crystal derivation |
|---|---|---|
| s-shell capacity | 2 | N_w |
| p-shell capacity | 6 | χ |
| d-shell capacity | 10 | N_w(χ−1) |
| f-shell capacity | 14 | N_w·β₀ |
| sp3 angle | 109.47° | arccos(−1/N_c) |
| sp2 angle | 120° | 2π/N_c |
| Water angle | 104.48° | arccos(−1/N_w²) |
| He (Z=2) | 2 | N_w |
| Ne (Z=10) | 10 | N_w(χ−1) |
| Ar (Z=18) | 18 | N_w·N_c² |
| Kr (Z=36) | 36 | Σd |
| Neutral pH | 7 | β₀ |
| Protein dielectric | 16 | N_w²(N_c+1) |
| kT(300K) ≈ ε_vdw | ~0.85 | Biology at 300K is a Crystal prediction |
## Self-Test
```bash
ghc -O2 -main-is CrystalChem CrystalChem.hs 2>/dev/null && ./CrystalChem
```
## Observable Count
14 new. All integers from (2,3).
