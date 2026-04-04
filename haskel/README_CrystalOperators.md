<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalOperators — Component 5: The Five Operators

## One Sentence

Five operators act on the 36-dimensional state: W contracts vertically,
U disentangles horizontally, D_F mixes sideways, J conjugates particles
with antiparticles, and gamma grades left from right — all from (2,3).

## What It Is

Component 5 ONLY. Sectors live in CrystalSectors (Component 3).
Eigenvalues live in CrystalEigen (Component 4). This module uses
both to define the operators that ACT on the state.

## The Five Operators

| Operator | Direction | What it does |
|----------|-----------|-------------|
| W | vertical | Coarse-grains between MERA layers (sqrt(lambda) per sector) |
| U | horizontal | Decouples within a layer (sqrt(lambda) per sector) |
| D_F | sideways | Mixes amplitude BETWEEN sectors (13 off-diagonal couplings) |
| J | conjugation | Maps particle to antiparticle (J^2 = I) |
| gamma | chirality | Splits left from right (gamma^2 = I, L-R = N_w) |

## Exports

| Export | What it is |
|--------|-----------|
| applyW, applyU | W and U applied to CrystalState |
| tick | S = W o U, diagonal, 36 multiplies |
| evolve | N ticks |
| tickFull | Full D_F tick with off-diagonal mixing, 36x36 matmul |
| dfTick | The 36x36 matrix (computed once) |
| SectorCoupling(..) | Data type for off-diagonal entries |
| offDiagonalCouplings | All 13 couplings |
| applyJ | Charge conjugation |
| colourConj, mixedConj | Sector-specific conjugation |
| jSquaredIsIdentity | Verify J^2 = I |
| chiralityOf | +1 left, -1 right per component |
| applyGamma | Chirality grading |
| projectLeft, projectRight | Chiral projections |
| gammaSquaredIsIdentity | Verify gamma^2 = I |
| leftDOF, rightDOF | DOF counts per sector |
| checkAnticommutation | {D_F, gamma} magnitude |
| checkCommutator | [D_F, J] magnitude (CP violation) |
| mixingStrength, totalMixing, mixingSummary | Mixing observables |
| normSq, sectorWeight, entropy, energy | State observables |

## The 13 Off-Diagonal Couplings

| Coupling | Sectors | Value | Formula |
|----------|---------|-------|---------|
| Y_e | singlet-weak | 1.5e-4 | T_F/(gauss*F3) |
| Y_mu | singlet-weak | 8.4e-3 | T_F*gauss/(N_c*F3) |
| Y_tau | singlet-weak | 4.7e-2 | T_F*F3/(d4*Sd*pi) |
| g_W | weak-colour | 0.231 | N_c/gauss = 3/13 |
| g_1 | weak-colour | 0.205 | d3/(N_c*gauss) = 8/39 |
| g_s | colour-mixed | 0.118 | N_w/(gauss+N_w^2) = 2/17 |
| Y_u | weak-mixed | 8.5e-3 | N_w^2/(Sd*gauss) |
| V_us | weak-mixed | 0.224 | C_F^2/(kappa*(chi-1)) |
| V_cb | weak-mixed | 0.042 | d3*d4/(b0*Sd2) = 192/4550 |
| V_ub | weak-mixed | 0.004 | T_F*C_F/gauss^2 |
| nu | singlet-mixed | 2.6e-6 | 1/(D*F3*Sd) |
| gamma-g | singlet-colour | 0 | forbidden |
| WWZ | weak self | 0.074 | N_c/(gauss*pi) |

## Dependency

```
CrystalAtoms.hs      <- Component 2
    |
    +-- CrystalSectors.hs  <- Component 3
    |
    +-- CrystalEigen.hs    <- Component 4
    |
CrystalOperators.hs  <- this module (imports all three above)
```

## Files

| File | Purpose |
|------|---------|
| haskel/CrystalOperators.hs | The module (21 tests, all PASS) |
| proofs/CrystalOperators.agda | 45 integer identities, all by refl |
| proofs/CrystalOperators.lean | 70 integer identities, all by native_decide |
| haskel/README_CrystalOperators.md | This file |

## Run

```bash
cd haskel
ghc -O2 -main-is CrystalOperators CrystalOperators.hs && ./CrystalOperators
```
