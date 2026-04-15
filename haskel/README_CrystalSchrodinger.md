<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalSchrodinger.hs — Quantum Mechanics from (2,3)

## HOW THE DYNAMICS WORKS

**There is NO split-operator integrator. The sector tick on the 36 IS quantum mechanics.**

```
Pack Re(ψ) → weak [3], Im(ψ) → colour [8]
|ψ|² → singlet [1] (conserved, λ=1)
       ↓
W step: potential rotates Re↔Im at each site (precomputed rotation table)
U step: kinetic coupling hops amplitudes between neighboring sites (uK)
       ↓
S = W∘U = Strang splitting (order N_w = 2). One quantum tick.
       ↓
Read Re, Im, |ψ|² back. Phase→hue. |ψ|²→height.
```

## Sector Assignment

| Data | Sector | λ | Meaning |
|------|--------|---|---------|
| \|ψ\|² (probability) | singlet [1] | 1 | Conserved. |
| Re(ψ) (position-like) | weak [3] | 1/2 | Real amplitude. |
| Im(ψ) (momentum-like) | colour [8] | 1/3 | Imaginary amplitude. |
| Potential + aux | mixed [24] | 1/6 | — |

## Three.js Visualization API

| Function | Output | Three.js use |
|----------|--------|-------------|
| `latticeToRender` | (x, height, RGBA) per vertex | Mesh displacement + vertex color |
| `phaseToColor` | RGBA from Re,Im | Vertex color (phase = hue cycling through sector colors) |
| `probToHeight` | normalized height | Y-displacement of mesh vertices |
| `probCurrent` | arrow magnitudes | Arrow helper field (probability flow) |
| `tunnelingSetup` | ready-to-run lattice | The money shot demo |
| `doubleSlitSetup` | ready-to-run lattice | Interference pattern |
| `harmonicSetup` | ready-to-run lattice | Ground state breathing |

## Import Chain

```
CrystalAtoms       ← nW, nC, chi, beta0, d1–d4, sigmaD, towerD
CrystalSectors     ← CrystalState, extractSector, injectSector, zeroState
CrystalEigen       ← lambda, wK, uK
CrystalOperators   ← tick, normSq
```

## Compile

```bash
ghc -O2 -main-is CrystalSchrodinger CrystalSchrodinger.hs && ./CrystalSchrodinger
```
