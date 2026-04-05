<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# ObservableCosmo.hs — Component 7 (Cosmo)

## What This Module Is

Dark energy, CMB parameters, neutrino masses. Uses CrystalImplosion
for Omega_DM correction (-1/130 channel).

## Compile

```bash
ghc -O2 -main-is ObservableCosmo ObservableCosmo.hs && ./ObservableCosmo
```

## Dependency

```
CrystalAtoms.hs         <- Component 2
CrystalImplosion.hs     <- Component 9 (Omega_DM channel)
CrystalCorrections.hs   <- Component 8 (level tags)
    |
ObservableCosmo.hs       <- Component 7 (this file)
```

## Observables (17)

### Dark Energy + Density (dimensionless)

| Name | Formula | Value | Expt | Gap |
|------|---------|-------|------|-----|
| Omega_L | 13/19 | 0.6842 | 0.6847 | 0.07% |
| Omega_m | 6/19 | 0.3158 | 0.3153 | 0.16% |
| Omega_b | Om*7/(7+12pi) | 0.04945 | 0.0493 | 0.31% |
| Omega_DM (corr) | Om-Ob-1/130 (imp) | 0.2589 | 0.2589 | 0.007% |
| Om_L/Om_m | 13/6 | 2.1667 | 2.175 | 0.38% |
| Om_DM/Om_b | 12pi/7 | 5.3856 | 5.36 | 0.48% |
| w (DE EoS) | -1 exactly | -1.0 | -1.0 | 0.00% |

### CMB Parameters (dimensionless)

| Name | Formula | Value | Expt | Gap |
|------|---------|-------|------|-----|
| 100*theta* | 100/96 | 1.04167 | 1.0411 | 0.05% |
| n_s | 1-kappa/D | 0.96226 | 0.9649 | 0.27% |
| ln(10^10 A_s) | ln(21) | 3.04452 | 3.044 | 0.02% |
| T_CMB (K) | 19/7 | 2.7143 | 2.7255 | 0.41% |
| Age (Gyr) | 97/7 | 13.857 | 13.797 | 0.44% |
| halo slope | -(1+kappa) | -2.585 | -2.585 | 0.00% |

### Neutrino Masses (dimensionful, Shift~0.43%)

| Name | Formula | CrystalPdg | Expt | Gap |
|------|---------|------------|------|-----|
| m_nu3 (meV) | v/2^42 * 10/11 | 50.89 | 50.7 | 0.38% |
| m_nu2 (meV) | (v/(2^42*chi))*12/13 | 8.61 | 8.6 | 0.15% |
| Sum m_nu (eV) | sum corrected | 0.0609 | 0.0608 | 0.20% |
| rho_L^1/4 (meV) | m_nu1/ln(2) | 2.244 | 2.25 | 0.29% |

## Proofs

| File | Prover | Theorems |
|------|--------|----------|
| ObservableCosmo.agda | refl | 24 |
| ObservableCosmo.lean | native_decide | 19 |
