<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalClassical.hs — From Monad to Orbits

## What This Module Does

Bridges the quantum monad S = W∘U to classical orbital mechanics.
Symplectic integrator (Leapfrog/Verlet) is the classical limit of the monad.
Satellite orbits, Hohmann transfers, gravity assists — all from (2,3).

**This is the TEMPLATE for all Verlet-family dynamics modules.**

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

```haskell
import CrystalEngine
  ( nW, nC, chi, beta0, sigmaD, towerD, gauss
  , d1, d2, d3, d4, lambda
  , CrystalState, sectorStart, sectorDim
  , extractSector, injectSector, normSq, tick
  )
```

### Sector Restriction

Classical mechanics = S restricted to **weak⊕colour** (d = 3 + 8 = 11).

| Classical Concept | Engine Sector | Dimension |
|-------------------|---------------|-----------|
| Position (x,y,z) | weak (sector 1) | d₂ = 3 |
| Velocity (vx,vy,vz) | colour (sector 2, first 3) | 3 of d₃ = 8 |
| Phase space per body | χ = N_w × N_c | 6 |
| Verlet order | N_w | 2 |

### PhaseState ↔ CrystalState Mapping

```haskell
toCrystalState (PhaseState pos vel) =
  [0] ++ pos ++ vel ++ replicate 5 0.0 ++ replicate 24 0.0
  --singlet  weak  colour(3+5)           mixed

fromCrystalState cs = PhaseState (extractSector 1 cs) (take 3 (extractSector 2 cs))
```

## Integer Map

| Quantity | Value | Crystal Source |
|----------|-------|---------------|
| Force exponent (1/r²) | 2 | N_c − 1 |
| Spatial dimensions | 3 | N_c |
| Kepler exponent (T² ∝ r³) | 3 | N_c |
| Kepler coefficient (4π²) | 4 | N_w² |
| Angular momentum components | 3 | N_c(N_c−1)/2 |
| Lagrange points | 5 | χ − 1 |
| Quadrupole coefficient | 32/5 | N_w⁵/(χ−1) |
| Spacetime dimensions | 4 | N_c + 1 |
| Phase space per body | 6 | χ |

## Proof Certificate

- `haskel/CrystalClassical.hs` — 31 checks (31 PASS)
- `proofs/CrystalClassical.lean` — Lean 4 theorems (by native_decide)
- `proofs/CrystalClassical.agda` — Agda proofs (by refl)
- S11 engine wiring proves PhaseState ↔ CrystalState round-trip, sector isolation, tick contraction

## Dependencies

- **Imports CrystalEngine** — atoms, types, sector operations, tick, normSq
- `Data.Ratio` for quadrupole proof
- Domain-specific: PhaseState type, classicalTick (Verlet), orbital mechanics
