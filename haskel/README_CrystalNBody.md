<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalNBody.hs — N-Body Gravitational Dynamics from (2,3)

## THE DYNAMICS IS THE TICK ON THE 36.

Each body is a CrystalState (36 Doubles). Time evolution = `S = W∘U`.
Direct O(N²) or Barnes-Hut O(N log N) force via octree.

## Build

```bash
cd haskel/
ghc -O2 -main-is CrystalNBody CrystalNBody.hs && ./CrystalNBody

cd proofs/
agda CrystalNBody.agda
lean CrystalNBody.lean
```

## Sector Assignment

| Data | Sector | Dim | λ | Meaning |
|------|--------|-----|---|---------|
| KE marker | singlet [1] | 1 | 1 | Conserved |
| Position (x,y,z) | weak [3] | 3 = N_c | 1/2 | Halved per tick |
| Vel + Force + KE + mass | colour [8] | 8 = N_c²−1 | 1/3 | Thirded per tick |
| (unused) | mixed [24] | 24 | 1/6 | — |

## HOW THE DYNAMICS WORKS

```
Pack pos → weak [3], vel+force+KE+mass → colour [8]
       ↓
U step: inter-body gravitational disentangler
        Direct O(N²): pairwise -GM dr/r³
        Tree O(N log N): Barnes-Hut octree (8 = d_colour children)
        Forces stored in each body's colour sector
       ↓
W step: per-body sector tick
        v' = v + wK₁ × f    (wK₁ = 1/√2)
        x' = x + uK₂ × v'   (uK₂ = 1/√3)
       ↓
Read positions + velocities back from sectors
```

```haskell
nbodyTickDirect eps2 = wStep . uStepDirect eps2
nbodyTickTree theta eps2 box = wStep . uStepTree theta eps2 box
```

## Complete API (43 functions)

### Dynamics (12)
`bodyTick`, `wStep`, `uStepDirect`, `uStepTree`, `nbodyTickDirect`, `nbodyTickTree`, `evolveNBody`, `evolveNBodyFinal`, `evolveNBodyTree`, `evolveNBodyTreeFinal`, `gravAccelDirect`, `treeAccel`

### Octree (3)
`buildTree`, `insertBody`, `octant`

### Observables (7)
`totalKE`, `potentialEnergy`, `totalEnergy`, `totalMomentum`, `totalAngMom`, `centerOfMass`, `virialRatio`

### Trajectory Extractors — Three.js / WASM (12)
`snapX`, `snapY`, `snapZ`, `snapR`, `snapSpeed`, `snapPositions`, `snapEnergy`, `positions2D`, `positions2DMass`, `positions3D`, `allPositions`, `allVelocities`

### Initialization (6)
`twoBodyKepler`, `threeBodyFigureEight`, `plummerSphere`, `solarSystemInner`, `galaxyDisk`, `collidingGalaxies`

### Visual API (4)
`colorBodies`, `colorBodiesBySpeed`, `glowRadius`, `sectorColor`

### Pack/Unpack (6)
`packBody`, `readPos`, `readVel`, `readForce`, `readKE`, `readMass`

## Integer Map

| Quantity | Value | Source |
|----------|-------|--------|
| Octree children | 8 | 2^N_c = N_w^N_c = d_colour |
| Force exponent | 2 | N_c − 1 |
| Spatial dim | 3 | N_c |
| Phase/body | 6 | χ = N_w × N_c |
| W coupling | 1/√2 | √(1/N_w) |
| U coupling | 1/√3 | √(1/N_c) |
| Multipole order | 2 | N_c − 1 |

## Import Pattern

```haskell
import CrystalAtoms (nW, nC, chi, beta0, sigmaD, towerD, gauss, d1, d2, d3, d4)
import CrystalSectors (CrystalState, sectorDim, extractSector, injectSector, zeroState)
import CrystalEigen (lambda, wK, uK)
import CrystalOperators (tick, normSq)
```
