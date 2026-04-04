# ObservableFluid.hs — Component 7 (Fluid)

## Compile

```bash
ghc -O2 -main-is ObservableFluid ObservableFluid.hs && ./ObservableFluid
```

## Observables (11) — ALL dimensionless, Shift=0

### Turbulence (3)

| Name | Formula | Value | Expt | Gap |
|------|---------|-------|------|-----|
| Kolmogorov -5/3 | (N_c+N_w)/N_c = 5/3 | 1.667 | 1.667 | EXACT |
| Kolmogorov micro | 1/N_w^2 = 1/4 | 0.250 | 0.250 | EXACT |
| Von Kármán | N_w/(N_c+N_w) = 2/5 | 0.400 | 0.400 | EXACT |

### Pipe Flow (2)

| Name | Formula | Value | Expt | Gap |
|------|---------|-------|------|-----|
| Re_c | D*(D+gauss) = 2310 | 2310 | 2300 | 0.43% |
| Prandtl (air) | 7/10 + 2/167 | 0.712 | 0.713 | 0.14% |

### Scaling Laws (3)

| Name | Formula | Value | Expt | Gap |
|------|---------|-------|------|-----|
| Blasius exp | 1/(N_c+1) = 1/4 | 0.250 | 0.250 | EXACT |
| Kleiber exp | N_c/(N_c+1) = 3/4 | 0.750 | 0.750 | EXACT |
| Benford P(1) | log10(N_w) | 0.301 | 0.301 | EXACT |

### Wave Scattering (3)

| Name | Formula | Value | Expt | Gap |
|------|---------|-------|------|-----|
| Planck λ exp | chi-1 = 5 | 5 | 5 | EXACT |
| Rayleigh size | chi = 6 | 6 | 6 | EXACT |
| Rayleigh λ | N_w^2 = 4 | 4 | 4 | EXACT |

## Proofs

| File | Prover | Theorems |
|------|--------|----------|
| ObservableFluid.agda | refl | 12 |
| ObservableFluid.lean | native_decide | 10 |
