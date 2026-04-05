<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# ObservableNuclear.hs — Component 7 (Nuclear)

## Compile

```bash
ghc -O2 -main-is ObservableNuclear ObservableNuclear.hs && ./ObservableNuclear
```

## Observables (18)

### Magic Numbers (Level 0, EXACT)

| Number | Formula | From (2,3) |
|--------|---------|-----------|
| 2 | N_w | 2 |
| 8 | N_c^2-1 = d_colour | 8 |
| 20 | gauss+beta0 = 13+7 | 20 |
| 28 | N_w^2*beta0 = 4*7 | 28 |
| 50 | D+d_colour = 42+8 | 50 |
| 82 | N_w*(D-1) = 2*41 | 82 |
| 126 | N_w*beta0*N_c^2 = 2*7*9 | 126 |

### Magnetic Moments (dimensionless)

| Name | Formula | Crystal | Expt | Gap |
|------|---------|---------|------|-----|
| mu_p/mu_N | 14/5 | 2.800 | 2.7928 | 0.26% |
| mu_n/mu_N | 174/91 | 1.9121 | 1.913 | 0.05% |

### Binding Energies (dimensionful via m_e chain)

| Name | Formula | CrystalPdg | Expt | Gap |
|------|---------|------------|------|-----|
| Deuteron BE | m_e*13/3 | 2.218 | 2.225 | 0.31% |
| 4He BE | m_e*(42+13+3/7) | 28.37 | 28.30 | 0.25% |
| R_p (fm) | (N_w^2+N_w/(g*b0))*hc/mp | 0.841 | 0.841 | 0.02% |

### Other

| Name | Formula | Value | Expt | Gap |
|------|---------|-------|------|-----|
| tau_n (s) | D^2/N_w - N_w^2 = 878 | 878 | 878.4 | 0.05% |
| Fe-56 (A) | d3*b0 = 56 | 56 | 56 | 0.00% |
| SEMF surf | N_w/N_c = 2/3 | 0.667 | 0.667 | 0.00% |
| SEMF Coul | 1/N_c = 1/3 | 0.333 | 0.333 | 0.00% |
| SEMF Coul pre | N_c/(chi-1) = 3/5 | 0.600 | 0.600 | 0.00% |
| SEMF pair | 1/N_w = 1/2 | 0.500 | 0.500 | 0.00% |

## Proofs

| File | Prover | Theorems |
|------|--------|----------|
| ObservableNuclear.agda | refl | 22 |
| ObservableNuclear.lean | native_decide | 18 |
