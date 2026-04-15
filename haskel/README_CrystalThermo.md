<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalThermo.hs — Thermodynamic Dynamics from (2,3)

**564 lines · 47 functions · LJ MD, gamma, Carnot, thermostat, Maxwell-Boltzmann, virial pressure**

## What This Module Does

Lennard-Jones molecular dynamics with Velocity Verlet integrator. Every thermodynamic constant from A_F: gamma_mono=5/3=(χ−1)/N_c, gamma_di=7/5=β₀/(χ−1), Carnot=5/6=(χ−1)/χ, Stokes drag=24=d_mixed, entropy per tick=ln(χ)=ln(6).

Includes thermostat (velocity rescaling), Maxwell-Boltzmann speed distribution histogram, virial pressure measurement, particle→sector color mapping, Stefan-Boltzmann denominator. WASM-ready.

## Import Chain

```
CrystalAtoms       ← nW, nC, chi, beta0, sigmaD, towerD, gauss, d1–d4
CrystalSectors     ← CrystalState, sectorDim, extractSector, injectSector, zeroState
CrystalEigen       ← lambda
CrystalOperators   ← tick, normSq
```

Refactored from CrystalEngine. Zero CrystalEngine import.

## Integer Traces

| Physical quantity | Value | Crystal derivation |
|---|---|---|
| LJ attractive | 6 | χ |
| LJ repulsive | 12 | 2χ |
| LJ force coeff | 24 | d_mixed |
| γ_monatomic | 5/3 | (χ−1)/N_c |
| γ_diatomic | 7/5 | β₀/(χ−1) |
| DOF monatomic | 3 | N_c |
| DOF diatomic | 5 | χ−1 |
| Carnot efficiency | 5/6 | (χ−1)/χ |
| Entropy/tick | ln(6) | ln(χ) |
| Stokes drag | 24 | d_mixed |
| MB speed exp | 2 | N_c−1 |
| Virial dim factor | 1/3 | 1/N_c |
| Stefan denom | 15 | N_c(χ−1) |
| Crystal dt | 1/42 | 1/D |

## Sections

| § | What | Key functions |
|---|------|---------------|
| S1 | LJ potential | ljPotential, ljForceMag (24=d_mixed prefactor) |
| S2 | Particle type | Particle, ljAccel |
| S3 | Velocity Verlet | thermoTick, thermoTickEngine |
| S4 | Thermodynamics | kineticE, temperature, potentialE, totalE |
| S5 | Constants | gammaMonatomic, gammaDiatomic, carnotEfficiency, entropyPerTick |
| S6 | Integer proofs | proveLJattractive through proveStokes |
| S6a | Thermostat | thermostat (velocity rescaling) |
| S6b | Maxwell-Boltzmann | particleSpeeds, speedHistogram, mbSpeedExp |
| S6c | Virial pressure | virialPressure (with 1/N_c factor) |
| S6d | Color mapping | particleToColor, colorParticles (sector colors by KE) |
| S6e | Crystal params | crystalDtThermo, stefanDenom, kmsTemperature |
| S7-S8 | Tests | 30+ checks |

## Compile

```bash
ghc -O2 -main-is CrystalThermo CrystalThermo.hs && ./CrystalThermo
```

## Proofs

| Proof file | Theorems | Method |
|------------|----------|--------|
| CrystalThermo.agda | 22 | refl |
| CrystalThermo.lean | 22 | native_decide |
