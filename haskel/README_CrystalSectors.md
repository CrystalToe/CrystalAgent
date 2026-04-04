<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalSectors — Component 3: The Four Sectors

## One Sentence

The algebra A_F = C + M_2(C) + M_3(C) decomposes into four irreducible
representations with dimensions 1, 3, 8, 24 — this module defines WHAT EXISTS.

## What It Is

CrystalSectors owns the 36-dimensional state space and its four-sector partition.
It knows nothing about eigenvalues or operators. It defines structure, not dynamics.

## The Four Sectors

| Sector | Index | Dimension | Formula | What lives here |
|--------|-------|-----------|---------|----------------|
| Singlet | 0 | d_1 = 1 | -- | Photon, conserved quantities, bond lengths |
| Weak | 1 | d_2 = 3 | N_w^2 - 1 | Positions, W/Z bosons, left-handed fermions |
| Colour | 2 | d_3 = 8 | N_c^2 - 1 | Momenta, gluons, dihedral angles |
| Mixed | 3 | d_4 = 24 | (N_w^2-1)(N_c^2-1) | Quarks, coordinates, side chains |
| **Total** | | **Sigma_d = 36** | d_1+d_2+d_3+d_4 | **Full CrystalState** |

Key identity: d_4 = d_2 x d_3 (mixed = weak tensor colour).

## Exports

| Export | Type | What it is |
|--------|------|-----------|
| CrystalState | type | [Double] of length 36 |
| zeroState | CrystalState | 36 zeros |
| sectorOf | Int -> Int | component index -> sector (0-3) |
| sectorStart | Int -> Int | first index of sector k |
| sectorDim | Int -> Int | dimension of sector k |
| extractSector | Int -> CrystalState -> [Double] | pull out sector k |
| injectSector | Int -> [Double] -> CrystalState -> CrystalState | put values into sector k |

## Dependency

```
CrystalAtoms.hs     <- Component 2 (needs d1, d2, d3, d4, sigmaD)
    |
CrystalSectors.hs   <- this module
```

## Files

| File | Purpose |
|------|---------|
| haskel/CrystalSectors.hs | The module (24 tests, all PASS) |
| proofs/CrystalSectors.agda | 24 integer identities, all by refl |
| proofs/CrystalSectors.lean | 25 integer identities, all by native_decide |
| haskel/README_CrystalSectors.md | This file |

## Run

```bash
cd haskel
ghc -O2 -main-is CrystalSectors CrystalSectors.hs && ./CrystalSectors
```
