<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalMD.hs — Molecular Dynamics from (2,3)

## HOW THE DYNAMICS WORKS

**There is NO Velocity Verlet. There is NO ODE. The sector tick on the 36 IS the dynamics.**

```
Pack position (x,y,z) → weak [3]
Pack velocity (vx,vy,vz) → colour [8]
       ↓
U step: inter-particle disentangler computes LJ forces,
        stores in each particle's colour sector
       ↓
W step: per-particle sector tick
        velocity kicked by force (wK = 1/√2)
        position drifted by velocity (uK = 1/√3)
       ↓
Read position + velocity back from sectors
```

Each particle is a full CrystalState. LJ force IS the inter-particle U disentangler coupling. Every LJ coefficient is a crystal integer: attractive χ=6, repulsive 2χ=12, force d_mixed=24, potential N_w²=4, cutoff N_c=3σ.

## Sector Assignment

| Data | Sector | λ | Meaning |
|------|--------|---|---------|
| KE marker | singlet [1] | 1 | Conserved quantity. |
| x, y, z | weak [3] | 1/2 | Position evolves. |
| vx, vy, vz, fx, fy, fz, KE, PE | colour [8] | 1/3 | Velocity + force. |
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
ghc -O2 -main-is CrystalMD CrystalMD.hs && ./CrystalMD
```
