<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# ObservableMass.hs — Component 7 (Mass)

## What This Module Is

Mass ratios (dimensionless) and absolute masses (dimensionful).
Uses CrystalImplosion for 7 corrected hadron masses.

## Dependency

```
CrystalAtoms.hs         <- Component 2
CrystalImplosion.hs     <- Component 9 (7 implosion channels)
CrystalCorrections.hs   <- Component 8 (level classification)
    |
ObservableMass.hs        <- Component 7 (this file)
```

## Compile

```bash
ghc -O2 -main-is ObservableMass ObservableMass.hs && ./ObservableMass
```

## Observables (31)

### Mass Ratios (dimensionless, Shift=0)

| Name | Formula | Value | Expt | Gap |
|------|---------|-------|------|-----|
| m_s/m_ud | N_c^3 | 27 | 27.23 | 0.85% |
| m_c/m_s | N_w^2*N_c*53/54 = 106/9 | 11.778 | 11.783 | 0.04% |
| m_b/m_s | N_c^3*N_w | 54 | 53.94 | 0.11% |
| m_b/m_c | N_c^5/(N_c^3*N_w-1) = 243/53 | 4.585 | 4.578 | 0.15% |
| m_u/m_d | (chi-1)/(2chi-1) = 5/11 | 0.4545 | 0.455 | 0.10% |
| m_t/m_b | D*53/54 = 371/9 | 41.222 | 41.26 | 0.09% |
| m_mu/m_e | chi^3-d_col = 208 | 208 | 206.77 | 0.60% |
| m_p/m_e | SINDy+a4 corr | 1836.15 | 1836.15 | PPM |

### Leptons (dimensionful, Shift~0.43%)

| Name | Formula | CrystalPdg | Expt | Gap |
|------|---------|------------|------|-----|
| m_mu (MeV) | v/2^11*8/9*87/88 (imp) | 105.65 | 105.658 | 0.006% |
| m_e (MeV) | m_mu_corr/208 | 0.508 | 0.511 | 0.60% |
| m_t (GeV) | v/sqrt(N_w) | 174.10 | 172.57 | 0.89% |

### QCD Scale (dimensionful)

| Name | Formula | CrystalPdg | Expt | Gap |
|------|---------|------------|------|-----|
| Lam_h (MeV) | v/F3 = v/257 | 961.80 | 957.78 | 0.42% |
| f_pi (MeV) | Lam*sNc/((Nc+Nw)*sgauss) | 92.41 | 92.07 | 0.37% |
| m_pi0 (MeV) | f_pi*sqrt(gauss/chi) | 136.02 | 134.98 | 0.77% |
| m_p (MeV) | v/2^8 * 53/54 | 943.99 | 938.27 | 0.61% |
| m_n (MeV) | v/2^8 * 53/54 | 943.99 | 939.57 | 0.47% |

### Hadrons with Implosion Corrections (from CrystalImplosion)

| Name | Formula | Channel | CrystalPdg | Expt | Gap |
|------|---------|---------|------------|------|-----|
| m_Ups (MeV) | Lam*79/8 | -1/8 (chi*Sd=216) | 9497.7 | 9460.3 | 0.40% |
| m_D (MeV) | Lam*281/144 | -7/144 (d4*Sd=864) | 1876.8 | 1869.7 | 0.38% |
| m_rho (MeV) | m_pi*23/4 | -1/12 (2chi=12) | 782.1 | 775.3 | 0.88% |
| m_omega (MeV) | m_pi*23/4 | -1/12 (inherited) | 782.1 | 782.7 | 0.08% |
| m_phi (MeV) | Lam*115/108 | -1/54 (Nc*Sd=108) | 1024.1 | 1019.5 | 0.46% |
| m_eta (MeV) | Lam/s3*74/75 | -1/75 (Nc*(chi-1)^2) | 547.9 | 547.86 | 0.005% |
| dm_dec (MeV) | ms*kap*167/169 | -2/169 (gauss^2) | 147.0 | 147.0 | 0.001% |

### Hadrons Tree-Level

| Name | Formula | CrystalPdg | Expt | Gap |
|------|---------|------------|------|-----|
| m_J/psi (MeV) | Lam*13/4 | 3125.8 | 3096.9 | 0.93% |
| m_B (MeV) | Lam*11/2 | 5289.9 | 5279.7 | 0.19% |
| m_K (MeV) | m_pi*sqrt(14*35/36) | 501.8 | 497.6 | 0.85% |
| m_Lam (MeV) | m_p*13/11 | 1115.6 | 1115.7 | 0.006% |
| m_Omega (MeV) | Lam*7/4 | 1683.1 | 1672.5 | 0.64% |

## Key Identities

All from (2,3). Zero free parameters.

- 53 = N_c^3 * N_w - 1 (proton numerator)
- 54 = N_c^3 * N_w (proton denominator)
- 257 = 2^(2^N_c) + 1 = F3 (Fermat prime, hadron scale)
- 208 = chi^3 - d_colour = 216 - 8 (muon/electron ratio)
- Lambda_h = v/F3 (one number sets all hadron masses)

## Proofs

| File | Prover | Theorems |
|------|--------|----------|
| ObservableMass.agda | refl | 30 |
| ObservableMass.lean | native_decide | 22 |
