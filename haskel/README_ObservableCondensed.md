# ObservableCondensed.hs — Component 7 (Condensed)

## Compile

```bash
ghc -O2 -main-is ObservableCondensed ObservableCondensed.hs && ./ObservableCondensed
```

## Observables (15) — ALL dimensionless, Shift=0

### Superconductivity (2)

| Name | Formula | Value | Expt | Gap |
|------|---------|-------|------|-----|
| BCS 2Δ/(kBTc) | 2π/e^γ | 3.527 | 3.528 | 0.02% |
| gamma (E-M) | 7/12 - 1/167 | 0.5774 | 0.5772 | 0.03% |

### Ising Model (3)

| Name | Formula | Value | Expt | Gap |
|------|---------|-------|------|-----|
| Ising states | N_w | 2 | 2 | EXACT |
| Ising crit beta | 1/N_w^3 = 1/8 | 0.125 | 0.125 | EXACT |
| Cubic z | chi | 6 | 6 | EXACT |

### Thermodynamics (4)

| Name | Formula | Value | Expt | Gap |
|------|---------|-------|------|-----|
| Carnot eff | (chi-1)/chi = 5/6 | 0.833 | 0.833 | EXACT |
| Stefan-Boltzmann | Nw*Nc*(gauss+b0) | 120 | 120 | EXACT |
| Thermal k | chi^2*(chi-1)/Sd | 5 | 5 | EXACT |
| Chandrasekhar M | 19/13 | 1.462 | 1.46 | 0.11% |

### Chaos (2)

| Name | Formula | Value | Expt | Gap |
|------|---------|-------|------|-----|
| Feigenbaum δ | D/N_c^2 = 14/3 | 4.667 | 4.669 | 0.05% |
| Routh ratio | 1/26 | 0.0385 | 0.0385 | 0.15% |

### Math Constants (3)

| Name | Formula | Value | Expt | Gap |
|------|---------|-------|------|-----|
| phi (golden) | 13/8 - 1/182 | 1.620 | 1.618 | 0.09% |
| zeta(3) Apéry | 6/5 | 1.200 | 1.202 | 0.18% |
| Catalan G | 11/12 | 0.917 | 0.916 | 0.07% |

### QED (1)

| Name | Formula | Value | Expt | Gap |
|------|---------|-------|------|-----|
| a_e (g-2) | alpha/(2pi) | 0.001160 | 0.001160 | 0.15% |

## Proofs

| File | Prover | Theorems |
|------|--------|----------|
| ObservableCondensed.agda | refl | 18 |
| ObservableCondensed.lean | native_decide | 14 |
