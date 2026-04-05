<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# ObservableOptics.hs — Component 7 (Optics)

## Compile

```bash
ghc -O2 -main-is ObservableOptics ObservableOptics.hs && ./ObservableOptics
```

## Observables (3) — ALL dimensionless, Shift=0

| Name | Formula | Value | Expt | Gap |
|------|---------|-------|------|-----|
| n(water) | C_F = 4/3 | 1.333 | 1.333 | 0.025% |
| n(glass) | N_c/N_w = 3/2 | 1.500 | 1.500 | EXACT |
| n(diamond) | (2gauss+N_c)/(N_w^2*N_c) = 29/12 | 2.417 | 2.417 | 0.014% |

The Casimir factor that confines quarks (4/3) also bends light in water.

## Proofs

| File | Prover | Theorems |
|------|--------|----------|
| ObservableOptics.agda | refl | 6 |
| ObservableOptics.lean | native_decide | 5 |
