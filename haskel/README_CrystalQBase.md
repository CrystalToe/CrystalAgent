<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalQBase — Shared Quantum Types from (2,3)

## What This Module Does

CrystalQBase is the foundation of the quantum subsystem. It defines three things:

1. **Complex arithmetic** — a `Cx` type (pair of Doubles) with add, sub, mul, scale,
   conjugate, norm², and exp. This is the field that all quantum vectors and matrices
   live over.

2. **Vector and matrix operations** — `Vec = [Cx]` and `Mat = [[Cx]]` with the standard
   linear algebra: basis vectors, inner product, normalisation, matrix multiply,
   dagger (conjugate transpose), trace, and diagonal construction.

3. **Crystal constants** — the 16 numbers derived from N_w=2, N_c=3 that every quantum
   module needs: sector dimensions [1,3,8,24], eigenvalues [1, 1/2, 1/3, 1/6],
   energies [0, ln2, ln3, ln6], mass gap ln(2), max entropy ln(6), κ = ln3/ln2.

Every other CrystalQ* module imports this. Nothing imports CrystalQBase — it is
the root of the quantum dependency tree, and it imports nothing itself.

## Contents (170 lines)

| Section | What | Exports |
|---------|------|---------|
| §0 Constants | nW, nC, chi, beta0, dims, sigmaD, sigmaD2, gauss, dTotal, kappa, lambdas, energies, maxEntropy, massGap, sectorNames, sectorColors | 16 |
| §1 Complex | Cx type, cx, cxAdd, cxSub, cxMul, cxScale, cxConj, cxNorm2, cxExp, cxZero, cxOne | 11 |
| §2 Vec | Vec type, vNew, vBasis, vEqual, vAdd, vScale, vNorm, vNormalize, vDot, vProb, vEntropy | 11 |
| §3 Mat | Mat type, mNew, mIdentity, mMul, mApply, mDagger, mTrace, mFromDiag, mFromVecs | 9 |

No main function. No self-test. Pure types and functions — consumed by QGates,
QEntangle, QMeasure, QFT, QInfo, and CrystalQuantum.

## Compile

```bash
# Type-check only (no main in this module):
ghc -c CrystalQBase.hs
```

## Import Chain

**Standalone.** Zero Crystal* imports. Defines its own constants locally from
the two primes N_w=2, N_c=3. Does not use CrystalAtoms or CrystalEngine.

## Proofs

| Proof file | Theorems | Method |
|------------|----------|--------|
| CrystalQBase.agda | 15 | refl |
| CrystalQBase.lean | 15 | native_decide |

Both prove: nW=2, nC=3, χ=6, β₀=7, d₁=1, d₂=3, d₃=8, d₄=24, σD=36,
towerD=42, gauss=13, sector sum=36, dims sum=36, Σd²=650.
