<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# ObservableAlphaProton.hs — Component 7 (AlphaProton)

## Compile

```bash
ghc -O2 -main-is ObservableAlphaProton ObservableAlphaProton.hs && ./ObservableAlphaProton
```

## The Source of Pride

Three independent derivation routes converge on the same answers for the two most precisely measured dimensionless constants in physics:

### alpha^-1 = 137.036... (4 routes)

| Route | Formula | Level |
|-------|---------|-------|
| Tower | (D+1)*pi + ln(beta0) = 43*pi + ln(7) | a2 |
| SINDy | 2*(gauss^2+d4)/pi + d3^kappa | a2 |
| HMC | Sigma_d^ln3 * pi - d4 | a2 |
| a4-corrected | SINDy - 1/(chi*d4*Sigma_d2*D) | a4 |

### m_p/m_e = 1836.153... (3 routes)

| Route | Formula | Level |
|-------|---------|-------|
| SINDy | 2*(D^2+Sigma_d)/d3 + gauss^Nc/kappa | a2 |
| HMC | chi*pi^5 + sqrt(ln2)/d4 | a2 |
| a4-corrected | SINDy + kappa/(Nw*chi*Sigma_d2*D) | a4 |

### sin^2 theta_W = 0.23122... (2 routes)

| Route | Formula | Level |
|-------|---------|-------|
| Base | N_c/gauss = 3/13 | a2 |
| a4-corrected | 3/13 + beta0/(d4*Sigma_d2) | a4 |

## Seeley-DeWitt Hierarchy

The a4 corrections all use Sigma_d^2 = 650 (the fourth Seeley-DeWitt coefficient of the spectral action on A_F):

- alpha correction denominator: chi*d4*Sigma_d2*D = 3,931,200
- m_p/m_e correction denominator: Nw*chi*Sigma_d2*D = 327,600
- sin^2 theta_W correction denominator: d4*Sigma_d2 = 15,600
- Ratio: alpha/mp_me = d4/Nw = 12 (gauge/weak channel split)

## Why Multiple Routes Matter

If one formula matched, it could be numerology. Three independent routes using different combinations of the same atoms (D, Sigma_d, gauss, chi, d3, d4, kappa, pi) converging on the same experimental value — that's structure.

## Proofs

| File | Prover | Theorems |
|------|--------|----------|
| ObservableAlphaProton.agda | refl | (to be created) |
| ObservableAlphaProton.lean | native_decide | (to be created) |
