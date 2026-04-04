<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalPlasma.hs — Magnetohydrodynamics from (2,3)

## HOW THE DYNAMICS WORKS

**There is NO FDTD. There is NO Alfvén integrator. The sector tick on the 36 IS MHD.**

```
Pack MHD state (rho, vx, vy, vz, Bx, By, Bz, energy) → colour sector [8]
  8 state variables = d_colour = N_w³. Exact fit.
       ↓
U step: inter-site disentangler (spatial propagation, uK² = 1/3)
W step: per-site v-B coupling within colour sector (wK 2 = 1/√3)
       ↓
λ_colour = 1/3. Fields contract toward equilibrium.
Singlet λ=1 preserves total energy.
       ↓
Read velocity + B field back from colour sector
```

## Sector Assignment

| Data | Sector | λ | Meaning |
|------|--------|---|---------|
| Total MHD energy | singlet [1] | 1 | Conserved. |
| (unused) | weak [3] | 1/2 | — |
| rho, vx, vy, vz, Bx, By, Bz, e | colour [8] | 1/3 | MHD state. |
| (unused) | mixed [24] | 1/6 | — |

## Import Chain

```
CrystalAtoms       ← nW, nC, chi, d1–d4, sigmaD, towerD
CrystalSectors     ← CrystalState, extractSector, injectSector, zeroState
CrystalEigen       ← lambda, wK, uK
CrystalOperators   ← tick, normSq
```

## Compile

```bash
ghc -O2 -main-is CrystalPlasma CrystalPlasma.hs && ./CrystalPlasma
```
