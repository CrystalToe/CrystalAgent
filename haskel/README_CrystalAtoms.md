<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalAtoms — Component 2: Building Blocks

## One Sentence

Fifteen numbers derived from N_w = 2 and N_c = 3, plus VEV as the single
optional input — the complete vocabulary of all physics.

## What It Is

CrystalAtoms is the root of the dependency tree. It imports nothing.
Every other module in the Crystal Topos imports CrystalAtoms (directly
or transitively). It defines the 15 building blocks that appear in
every observable, every coupling constant, every operator entry.

## The 15 Atoms

| Symbol | Value | Formula | Type |
|--------|-------|---------|------|
| N_w | 2 | input (from M_2) | Int |
| N_c | 3 | input (from M_3) | Int |
| chi | 6 | N_w x N_c | Int |
| beta_0 | 7 | (11N_c - 2chi)/3 | Int |
| d_1 | 1 | singlet dimension | Int |
| d_2 | 3 | N_w^2 - 1 | Int |
| d_3 | 8 | N_c^2 - 1 | Int |
| d_4 | 24 | (N_w^2-1)(N_c^2-1) | Int |
| Sigma_d | 36 | d_1+d_2+d_3+d_4 | Int |
| Sigma_d^2 | 650 | d_1^2+d_2^2+d_3^2+d_4^2 | Int |
| D | 42 | Sigma_d+chi | Int |
| gauss | 13 | N_w^2+N_c^2 | Int |
| F_3 | 257 | 2^(2^N_c)+1 | Int |
| C_F | 4/3 | (N_c^2-1)/(2N_c) | Double |
| T_F | 1/2 | 1/N_w | Double |
| kappa | ln3/ln2 | ln(N_c)/ln(N_w) | Double |

kappa is the only irrational. Everything else is a ratio of small integers.

## The Single Optional Input

VEV = 246.22 GeV. The Higgs vacuum expectation value from PDG.

Without VEV: all observables are dimensionless ratios.
With VEV: ratios become physical masses and energies.

One input. One. Everything else is derived from A_F = C + M_2(C) + M_3(C).

## Position in the Architecture

CrystalAtoms is Component 2 of the 12-component architecture. It is
the root node. All other components import it:

```
CrystalAtoms.hs         <- Component 2, imports nothing
    |
    +-- CrystalSectors.hs   <- Component 3, imports Atoms
    |
    +-- CrystalEigen.hs     <- Component 4, imports Atoms
    |
CrystalOperators.hs     <- Component 5, imports Atoms + Sectors + Eigen
    |
CrystalDynamicEngine.hs <- Component 10, imports all four
```

CrystalEngine.hs (the old monolithic module) remains untouched.
Both paths coexist. Parallel design.

## Dependency

```
CrystalAtoms.hs  ->  imports nothing
```

## Files

| File | Purpose |
|------|---------|
| haskel/CrystalAtoms.hs | The module (26 tests, all PASS) |
| proofs/CrystalAtoms.agda | 44 integer identities, all by refl |
| proofs/CrystalAtoms.lean | 56 integer identities, all by native_decide |
| haskel/README_CrystalAtoms.md | This file |

## Run

```bash
cd haskel
ghc -O2 -main-is CrystalAtoms CrystalAtoms.hs && ./CrystalAtoms
```
