# ObservableGauge.hs — Component 7 (Gauge)

## What This Module Is

Gauge coupling constants, electroweak masses, and widths. Mix of
dimensionless and dimensionful observables. Uses CrystalImplosion
(Component 9) for the M_Z correction.

## Dependency

```
CrystalAtoms.hs         <- Component 2 (root)
    |
CrystalImplosion.hs     <- Component 9 (M_Z correction channel)
CrystalCorrections.hs   <- Component 8 (level classification)
    |
ObservableGauge.hs       <- Component 7 (this file)
```

## Observables (16)

### Dimensionless (Crystal = CrystalPdg, VEV cancels)

| Name | Formula | Value | Expt | PWI |
|------|---------|-------|------|-----|
| alpha^-1 | 43pi+ln7 | 137.034 | 137.036 | 0.001% |
| sin^2 th_W(OS) | 2/9 | 0.2222 | 0.22305 | 0.37% |
| sin^2 th_W(MS) | 3/13 | 0.2308 | 0.23122 | 0.19% |
| alpha_s(M_Z) | 2/17 | 0.1176 | 0.1180 | 0.30% |
| Koide Q | 2/3 | 0.6667 | 0.6667 | 0.005% |
| g_A | 9/7 | 1.2857 | 1.2756 | 0.79% |
| alpha(M_Z)^-1 | gauss^2-D+1/kap | 127.63 | 127.95 | 0.25% |
| N_gen | 3 | 3 | 3 | 0.00% |

### Dimensionful (Crystal /= CrystalPdg, VEV matters)

| Name | Formula | Crystal | CrystalPdg | Expt | PWI |
|------|---------|---------|------------|------|-----|
| v (GeV) | M_Pl*35/(43*36*2^50) | 245.17 | 246.22 | 246.22 | 0.000% |
| m_H (GeV) | v*sqrt(6/e^pi) | 124.84 | 125.37 | 125.09 | 0.228% |
| M_Z (GeV) | v*637/1720 (implosion) | 90.80 | 91.19 | 91.19 | 0.000% |
| M_W (GeV) | M_Z*sqrt(10/13) | 80.64 | 80.98 | 80.37 | 0.76% |
| m_tau (GeV) | v*e^(-pi^2/2) | 1.763 | 1.771 | 1.777 | 0.35% |
| m_t (GeV) | v/sqrt(2) | 173.36 | 174.10 | 172.57 | 0.89% |
| Gamma_W (GeV) | GF*MW^3*9/(6pi*s2) | 2.082 | 2.091 | 2.085 | 0.30% |
| Gamma_Z (GeV) | GF*MZ^3*S/(6pi*s2) | 2.505 | 2.516 | 2.495 | 0.83% |

## Implosion Channel (from CrystalImplosion)

M_Z uses the implosion correction:
- Base: v * N_c/(N_c^2-1) = v * 3/8
- Correction: -v / ((D+1)(chi-1)) = -v/215
- Result: v * 637/1720
- Dual route: (Sigma_d+chi+1)*(N_w*N_c-1) = 43*5 = 215

## Compile & Test

```bash
ghc -O2 -main-is ObservableGauge ObservableGauge.hs && ./ObservableGauge
```
