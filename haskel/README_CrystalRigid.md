<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalRigid.hs — Rigid Body Dynamics from (2,3)

## HOW THE DYNAMICS WORKS

**There is NO Euler integrator. There is NO symplectic stepper. The sector tick on the 36 IS the dynamics.**

```
Pack quaternion scalar (qw) → singlet [1]
Pack quaternion vector (qx,qy,qz) → weak [3]
Pack angular velocity (ωx,ωy,ωz) + inertia → colour [8]
       ↓
   rigidSectorTick (sector-projected tick on the 36)
       ↓
W: Euler equations couple ω components through inertia (wK = 1/√2)
U: quaternion drifts from angular velocity (uK = 1/√3)
       ↓
Quaternion normalization (constraint, Newton-Raphson, zero sqrt)
       ↓
Read quaternion + ω back from sectors
```

## Sector Assignment

| Data | Sector | λ | Meaning |
|------|--------|---|---------|
| qw (quaternion scalar) | singlet [1] | 1 | Preserved. Normalization anchor. |
| qx, qy, qz (orientation) | weak [3] | 1/2 | Orientation evolves. |
| ωx, ωy, ωz, Ix, Iy, Iz, E, L | colour [8] | 1/3 | Angular velocity + inertia. |
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
ghc -O2 -main-is CrystalRigid CrystalRigid.hs && ./CrystalRigid
```
