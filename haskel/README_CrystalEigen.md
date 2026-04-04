<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalEigen — Component 4: The Four Eigenvalues

## One Sentence

Four contraction rates {1, 1/2, 1/3, 1/6}, one per sector, forced by the
algebra — the heartbeat that creates the arrow of time.

## What It Is

CrystalEigen owns the eigenvalues and the W/U half-step factors.
It knows nothing about the state type or operators. It defines rates, not structure.

## The Four Eigenvalues

| Sector | lambda_k | Denominator | Energy E_k = -ln(lambda_k) | Meaning |
|--------|----------|-------------|---------------------------|---------|
| Singlet | 1 | 1 | 0 | Immortal. Never decays. |
| Weak | 1/2 | N_w = 2 | ln 2 | Fast decay. Position contracts. |
| Colour | 1/3 | N_c = 3 | ln 3 | Medium decay. Orientation contracts. |
| Mixed | 1/6 | chi = 6 | ln 6 | Slow decay. Detail contracts. |

Key identities:
- lambda_mixed = lambda_weak x lambda_colour (1/6 = 1/2 x 1/3)
- Product of denominators: 1 x 2 x 3 x 6 = 36 = Sigma_d
- Sum of reciprocals: 1 + 1/2 + 1/3 + 1/6 = 2

## W and U Half-Steps

The tick S = W o U factorises symmetrically:
- W contracts by sqrt(lambda_k) per sector (vertical isometry)
- U contracts by sqrt(lambda_k) per sector (horizontal disentangler)
- wK(k) x uK(k) = lambda(k)

The sqrt values (1/sqrt(2), 1/sqrt(3), 1/sqrt(6)) are the ONLY sqrt
in the entire codebase. Evaluated once at module load. Never in the tick loop.

## Exports

| Export | Type | What it is |
|--------|------|-----------|
| lambda | Int -> Double | sector eigenvalue: {1, 1/2, 1/3, 1/6} |
| wK | Int -> Double | W contraction: sqrt(lambda_k) |
| uK | Int -> Double | U contraction: sqrt(lambda_k) |

## Dependency

```
CrystalAtoms.hs    <- Component 2 (needs nW_d, nC_d, chi_d)
    |
CrystalEigen.hs    <- this module
```

## Files

| File | Purpose |
|------|---------|
| haskel/CrystalEigen.hs | The module (15 tests, all PASS) |
| proofs/CrystalEigen.agda | 15 integer identities, all by refl |
| proofs/CrystalEigen.lean | 15 integer identities, all by native_decide |
| haskel/README_CrystalEigen.md | This file |

## Run

```bash
cd haskel
ghc -O2 -main-is CrystalEigen CrystalEigen.hs && ./CrystalEigen
```
