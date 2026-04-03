<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalDiffusion.hs — Heat / Diffusion from (2,3)

## What This Module Does

Diffusion without calculus. The heat equation ∂u/∂t = D∇²u is replaced by
u(t+1) = u(t) + D × hop(u). The discrete Laplacian is a hopping matrix,
not a derivative. Diffusion IS eigenvalue decay. The monad IS the heat equation.

Covers 1D, 2D, and 3D diffusion plus random walks.

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

```haskell
import CrystalEngine
  ( nW, nC, chi, beta0, sigmaD, towerD, gauss
  , d1, d2, d3, d4, lambda
  , CrystalState, sectorDim, extractSector, injectSector
  , normSq, tick
  )
```

### Sector Restriction

Diffusion lives in **weak sector** (d₂ = 3, spatial dimensions).
The field u(x,t) exists on a lattice in N_c = 3 spatial dimensions.

| Diffusion Concept | Engine Mapping |
|-------------------|----------------|
| Diffusion coefficient D = 1/6 | λ_mixed = 1/χ = 1/6 |
| k=0 mode conserved (heat conservation) | λ_singlet = 1 (immortal) |
| Higher modes decay exponentially | λ_k < 1 for k > 0 |
| 1D neighbours | N_w = 2 |
| 2D neighbours | N_w² = 4 |
| 3D neighbours | χ = 6 |
| CFL stability: D ≤ 1/(2N_c) = 1/χ | Engine identity: 2N_c = χ |
| Spatial dimensions | d_weak = N_c = 3 |

## Integer Map

| Quantity | Value | Crystal Source |
|----------|-------|---------------|
| Neighbours 1D | 2 | N_w |
| Neighbours 2D | 4 | N_w² |
| Neighbours 3D | 6 | χ = N_w × N_c |
| Diffusion coefficient | 1/6 | 1/χ |
| Random walk dimensions | 3 | N_c |
| Stefan-Boltzmann exponent | 4 | N_w² |
| Stefan-Boltzmann denominator 15 | 15 | N_c(χ−1) |
| Carnot numerator | 5 | χ − 1 |
| Gamma (monatomic) | 5/3 | (χ−1)/N_c |
| LCG multiplier | 650 | Σd² |
| LCG increment | 7 | β₀ |

## Proof Certificate

- `haskel/CrystalDiffusion.hs` — 44 checks (42 PASS, 2 pre-existing tuning FAILs)
- `proofs/CrystalDiffusion.lean` — 38 Lean 4 theorems (by native_decide)
- `proofs/CrystalDiffusion.agda` — 38 Agda proofs (by refl)
- §11 engine wiring proves D = λ_mixed, k=0 ↔ λ_singlet, spatial dim = d_weak

## Dependencies

- **Imports CrystalEngine** — atoms, eigenvalues, sector operations, tick, normSq
- No external packages
- Domain-specific: Field, Field2D, Field3D types, spread/diffusion functions
