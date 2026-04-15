<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalCFD.hs — Lattice Boltzmann Fluid Dynamics from (2,3)

## HOW THE DYNAMICS WORKS

**LBM IS ALREADY S = W∘U. Collision = W. Streaming = U. It was always the tick.**

```
Pack f₀ (rest population) → singlet [1], λ=1 (mass conserved)
Pack f₁..f₈ (8 non-rest) → colour [8]. Exact fit!
       ↓
W step: BGK collision — relax toward equilibrium (local per site)
U step: streaming — pull populations from neighbors
       ↓
S = W∘U = one LBM tick. Read ρ, u, vorticity from distributions.
```

## Sector Assignment

| Data | Sector | λ | Meaning |
|------|--------|---|---------|
| f₀ (rest population) | singlet [1] | 1 | Mass conserved. |
| (unused) | weak [3] | 1/2 | — |
| f₁..f₈ (8 non-rest) | colour [8] | 1/3 | D2Q9 populations. |
| (unused) | mixed [24] | 1/6 | — |

## Three.js Visualization API

| Function | Output | Use |
|----------|--------|-----|
| `gridToRender` | (ux, uy, speed, vorticity, RGBA) per cell | Complete render package |
| `velocityField` | (ux, uy) per cell | ArrowHelper grid (streamlines!) |
| `vorticity2D` | ω per cell | Vortex visualization (∂uy/∂x - ∂ux/∂y) |
| `densityField` | ρ per cell | Height map or pressure contours |
| `speedToColor` | RGBA from speed | Blue→green→yellow→red (sector colors) |
| `vorticityToColor` | RGBA from ω | Blue=CW, red=CCW, green=laminar |

## Compile

```bash
ghc -O2 -main-is CrystalCFD CrystalCFD.hs && ./CrystalCFD
```
