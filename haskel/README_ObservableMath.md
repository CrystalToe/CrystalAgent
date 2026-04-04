# ObservableMath.hs — Component 7 (Math)

## Compile

```bash
ghc -O2 -main-is ObservableMath ObservableMath.hs && ./ObservableMath
```

## Observables (13) — ALL dimensionless, Shift=0

### Irrational (exact basis elements, 4)

| Name | Formula | Value | Gap |
|------|---------|-------|-----|
| sqrt(2) | sqrt(N_w) | 1.41421 | EXACT |
| ln(2) | ln(N_w) | 0.69315 | EXACT |
| pi^2/6 (Basel) | pi^2/chi | 1.64493 | EXACT |
| kappa | ln(N_c)/ln(N_w) | 1.58496 | EXACT |

### Rational Approximations (5)

| Name | Formula | Value | Expt | Gap |
|------|---------|-------|------|-----|
| e (Euler) | (gauss+chi)/beta0 = 19/7 | 2.714 | 2.718 | 0.15% |
| phi (golden) | 13/8 - 1/182 | 1.620 | 1.618 | 0.09% |
| zeta(3) | chi/(chi-1) = 6/5 | 1.200 | 1.202 | 0.18% |
| Catalan G | 1-N_w^2/(D+chi) = 11/12 | 0.917 | 0.916 | 0.07% |
| gamma (E-M) | 7/12 - 1/167 | 0.577 | 0.577 | 0.03% |

### Structural Integers (4)

| Name | Formula | Value | Gap |
|------|---------|-------|-----|
| Bekenstein | N_w^2 = 4 | 4 | EXACT |
| Lagrange pts | chi-1 = 5 | 5 | EXACT |
| 3-body DOF | N_c*chi = 18 | 18 | EXACT |
| R(e+e-,uds) | N_c*sum(Q^2) = 2 | 2 | EXACT |

## Proofs

| File | Prover | Theorems |
|------|--------|----------|
| ObservableMath.agda | refl | 10 |
| ObservableMath.lean | native_decide | 8 |
