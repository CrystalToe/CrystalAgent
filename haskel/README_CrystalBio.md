<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->
# CrystalBio — Biological Scaling from (2,3)
## Overview
Genetic code structure, allometric scaling, DNA/protein parameters.
20 amino acids = N_w²(χ−1). Biology is executable from the same algebra as particle physics.
## Integer Traces
| Physical quantity | Value | Crystal derivation |
|---|---|---|
| DNA bases | 4 | N_w² |
| Codon length | 3 | N_c |
| Total codons | 64 | (N_w²)^N_c |
| Amino acids | 20 | N_w²(χ−1) |
| Stop codons | 3 | N_c |
| H-bonds A-T | 2 | N_w |
| H-bonds G-C | 3 | N_c |
| Double helix | 2 strands | N_w |
| BP per turn | 10 | N_w(χ−1) |
| Lipid bilayer | 2 | N_w |
| α-helix | 3.6/turn | N_c²N_w/(χ−1) |
| Kleiber | 3/4 | N_c/N_w² |
| Heart/lifespan | 1/4 | 1/N_w² |
| Surface area | 2/3 | N_w/N_c |
| Flory ν | 2/5 | N_w/(χ−1) |
## Self-Test
```bash
ghc -O2 -main-is CrystalBio CrystalBio.hs 2>/dev/null && ./CrystalBio
```
## Observable Count
15 new. All integers from (2,3).
