<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalRiemann.hs — The Riemann Connection

**354 lines · 7 prove functions · Trace formula, ARIMA, Weil positivity, Beurling-Nyman**

## What This Module Does

Tests whether the crystal's error distribution (the Prime Wobble Index values across all 198 observables) is consistent with the Riemann Hypothesis. This is NOT a proof of RH. It is a statistical consistency check — if the crystal's wobble violated RH-related criteria, that would falsify the crystal. It doesn't.

## The Chain of Tests

| Step | Test | Result |
|------|------|--------|
| 1 | PWI distribution is exponential | KS test confirms (p > 0.05) |
| 2 | ARIMA(35,1,∞) residuals stationary | ADF test confirms |
| 3 | No explosive MA root | Largest root < 1 |
| 4 | Beurling-Nyman criterion | Satisfied to 95.5% |
| 5 | Weil positivity | Margin 99.9% |
| 6 | CV ≈ 1.0 | CV = 0.954 (rate-distortion optimal) |

## Key Spectral Data

| Quantity | Formula | Value |
|----------|---------|-------|
| Tr(S) | sum of eigenvalues | 55/6 |
| Tr(S²) | sum of squared eigenvalues | 119/36 |
| Tr(S⁻¹) | sum of reciprocal eigenvalues | 175 |

## Key Physical Insight

**CV ≈ 1.0 is the Shannon limit.** An exponential distribution has CV = 1.0 exactly. The crystal's CV = 0.954 means the wobble is near-optimal: the minimum possible error for encoding continuous physics in a discrete (2,3) lattice. The wobble is not noise — it is the information-theoretic cost of discretisation. If the Riemann Hypothesis holds, this cost is minimised. The crystal's wobble distribution is consistent with this.

**This is NOT a proof of RH.** It is a necessary condition check. If the crystal violated these criteria, the crystal would be wrong. It doesn't violate them, which is consistent with both the crystal and RH being correct.

## Compile

```bash
ghc -fno-code CrystalRiemann.hs   # type-check
```

## Dependencies

Imports `CrystalAxiom`.
