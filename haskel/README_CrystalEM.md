<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalEM.hs — Electromagnetic Field Evolution from (2,3)

## HOW THE DYNAMICS WORKS

**There is NO Yee FDTD. There is NO finite difference scheme. The tick on the 36 IS Maxwell.**

```
Pack E(3) and B(3) into colour sector [8] of a CrystalState
       ↓
   emSectorTick (sector-projected tick on the 36)
       ↓
E-B coupling within colour sector, Courant = 1/N_w = 1/2
       ↓
Read E and B back from colour sector
```

For a lattice of N sites, each site is a CrystalState. One EM tick:

1. **U step** (inter-site disentangler): couples neighboring colour sectors. The spatial curl. Coupling weight = uK² = 1/N_c = 1/3.
2. **W step** (per-site): `emSectorTick` applies E-B coupling within the colour sector of each site. Courant = 1/N_w.
3. **S = W∘U**: one tick of EM. Done.

Speed of light: c = χ/χ = 1 (Lieb-Robinson bound).
Energy conservation: total EM energy → singlet, λ_singlet = 1.

## Sector Assignment

| Data | Sector | λ | Meaning |
|------|--------|---|---------|
| Total EM energy | singlet [1] | 1 | Conserved. |
| (unused) | weak [3] | 1/2 | — |
| E(3) + B(3) + 2 aux | colour [8] | 1/3 | EM fields contract. |
| (unused) | mixed [24] | 1/6 | — |

## Import Chain

```
CrystalAtoms       ← nW, nC, chi, beta0, sigmaD, towerD, gauss, d1–d4
CrystalSectors     ← CrystalState, sectorDim, extractSector, injectSector, zeroState
CrystalEigen       ← lambda, wK, uK
CrystalOperators   ← tick, normSq
```

## Compile

```bash
ghc -O2 -main-is CrystalEM CrystalEM.hs && ./CrystalEM
```

## Proofs

Unchanged from previous — integer identities (chi=6, nC+1=4, etc.) are the same.
