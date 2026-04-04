<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalDiffusion.hs — Heat / Diffusion from (2,3)

**736 lines · 52 functions · 1D/2D/3D diffusion, Gray-Scott, anisotropic, random walk, color mapping**

## What This Module Does

Forward Euler heat equation as S = W∘U. W = source (diagonal injection). U = spread (discrete Laplacian = hopping matrix). Diffusion IS eigenvalue decay — the monad IS the heat equation. No calculus.

Includes reaction-diffusion (Gray-Scott with crystal rates for Turing patterns), anisotropic diffusion using sector eigenvalues, boundary condition choices, multi-source API, sector-based color mapping, and crystal grid parameters. WASM-ready.

## Import Chain

```
CrystalAtoms       ← nW, nC, chi, beta0, sigmaD, towerD, gauss, d1–d4
CrystalSectors     ← CrystalState, sectorDim, extractSector, injectSector
CrystalEigen       ← lambda, wK
CrystalOperators   ← tick, normSq
```

Refactored from CrystalEngine. Zero CrystalEngine import.

## Integer Traces

| Physical quantity | Value | Crystal derivation |
|---|---|---|
| 1D neighbours | 2 | N_w |
| 2D neighbours | 4 | N_w² |
| 3D neighbours | 6 | χ = N_w × N_c |
| Diffusion coeff D | 1/6 | 1/χ (CFL maximum in 3D) |
| CFL condition | 2N_c = χ | stability identity |
| Random walk dims | 3 | N_c |
| Stefan exponent | 4 | N_w² |
| Gray-Scott D_u | 1/6 | 1/χ (mixed eigenvalue) |
| Gray-Scott D_v | 1/24 | 1/d₄ (inhibitor slower) |
| Gray-Scott feed F | 1/42 | 1/D (inverse tower depth) |
| Gray-Scott kill k | 7/1764 | β₀/D² |
| Aniso rate x | 1/2 | λ_weak = 1/N_w |
| Aniso rate y | 1/3 | λ_colour = 1/N_c |
| Aniso rate z | 1/6 | λ_mixed = 1/χ |
| Crystal dx | 1/3 | 1/N_c |
| Crystal dt | 1/42 | 1/D |
| Crystal CFL | 1/28 | 1/(N_w² × β₀) |

## Sections

| § | What | Functions |
|---|------|-----------|
| §1 | Integer identities | neighbours1D, neighbours3D, diffCoeff, randomWalkDim, stefanExp |
| §2 | 1D state | Field, totalHeat, maxVal |
| §3 | S = W∘U (1D) | spread1D, applySource, diffusionTick, pureDiffusionTick, diffusionEvolve |
| §4 | 2D diffusion | Field2D, spread2D, totalHeat2D, evolve2D |
| §5 | 3D diffusion | Field3D, spread3D, totalHeat3D |
| §6 | Random walk | Seed, nextSeed, randomDir, randomWalk, meanR2 |
| §6a | Boundary conditions | BoundaryCondition, getCell1D, getCell2D, spread2DBC |
| §6b | Multi-source API | Source2D, applySources |
| §6c | Reaction-diffusion | GrayScott2D, gsDu/gsDv/gsFeed/gsKill, gsInit, gsTick, gsEvolve |
| §6d | Anisotropic diffusion | spreadAniso2D, spreadAniso3D |
| §6e | Crystal color mapping | RGBA, sectorColor, lerpRGBA, tempToColor, fieldToRGBA, gsToRGBA |
| §6f | Field helpers | getField2D, setField2D, fieldSize2D, emptyField2D, deltaField2D |
| §6g | Crystal grid params | crystalDx, crystalDt, crystalCFL |
| §7-12 | Tests | 49 checks including visual API |

## Compile

```bash
ghc -O2 -main-is CrystalDiffusion CrystalDiffusion.hs && ./CrystalDiffusion
```

## Proofs

| Proof file | Theorems | Method |
|------------|----------|--------|
| CrystalDiffusion.agda | 50 | refl |
| CrystalDiffusion.lean | 50 | native_decide |

### Proof sections

| Section | Count | Covers |
|---------|-------|--------|
| §1-§8 Core | 38 | neighbours, CFL, walk, Fourier, sector, thermal, cross-module, wiring |
| §10 Gray-Scott | 6 | D_u denom, D_v denom, feed denom, kill num/denom, D_v identity |
| §11 Anisotropic | 3 | rate x/y/z denominators |
| §12 Grid params | 3 | dx, dt, CFL denominators |
