<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->
# CrystalNuclear — Nuclear Physics from (2,3)
## Overview
Semi-empirical mass formula + shell model. All 7 magic numbers and every SEMF exponent from A_F.
## Integer Traces
| Physical quantity | Value | Crystal derivation |
|---|---|---|
| Magic: 2 | 2 | N_w |
| Magic: 8 | 8 | N_w³ = d_colour |
| Magic: 20 | 20 | N_w²(χ−1) |
| Magic: 28 | 28 | N_w²β₀ |
| Magic: 50 | 50 | N_w(χ−1)² |
| Magic: 82 | 82 | N_w(D−1) |
| Magic: 126 | 126 | N_wβ₀N_c² |
| Surface exponent | 2/3 | N_w/N_c |
| Coulomb exponent | 1/3 | 1/N_c |
| Coulomb prefactor | 3/5 | N_c/(χ−1) |
| Pairing exponent | 1/2 | 1/N_w |
| Isospin states | 2 | N_w |
| Alpha particle | 4 | N_w² |
| Iron peak | 56 | d_colour·β₀ |
| B(He-4) | 28 MeV | N_w²β₀ MeV |
## Self-Test
```bash
ghc -O2 -main-is CrystalNuclear CrystalNuclear.hs 2>/dev/null && ./CrystalNuclear
```
## Observable Count
15 new. All integers from (2,3).
