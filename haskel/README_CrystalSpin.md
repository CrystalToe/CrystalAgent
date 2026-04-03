<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalSpin.hs — Bloch Equations / NMR from (2,3)

## What This Module Does

Spin dynamics without calculus. The Bloch equations dM/dt = γ(M×B) − R(M−M₀)
are replaced by M(t+1) = relax(rotate(M(t))). Rotation = matrix multiply.
Relaxation = scalar multiply. No differential equation. No integral. Just tick.

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

Spin lives in the **weak sector** (d₂ = 3). The Bloch vector (Mx, My, Mz)
maps directly to the 3 components of weak.

| Spin Operation | Engine Mapping | Eigenvalue |
|---------------|----------------|------------|
| W: precession (rotation) | isometry within weak sector | norm-preserving |
| U: T1 relaxation (Mz → M₀) | contraction rate = λ_weak | 1/N_w = 1/2 |
| U: T2 relaxation (Mx,My → 0) | contraction rate = λ_colour | 1/N_c = 1/3 |

Spin does NOT touch singlet, colour, or mixed sectors.
Engine tick on weak contracts norm² by λ_weak² = 1/4 = 1/N_w².

### BlochVec ↔ CrystalState Mapping

```haskell
toCrystalState (mx, my, mz) = [0] ++ [mx, my, mz] ++ replicate 32 0.0
fromCrystalState cs = let [mx, my, mz] = extractSector 1 cs in (mx, my, mz)
```

## Integer Map

| Quantity | Value | Crystal Source |
|----------|-------|---------------|
| Spin states | 2 | N_w |
| Bloch components | 3 | N_c |
| Pauli matrices | 3 | N_c |
| g-factor | 2 | N_w |
| Multiplicity (2s+1) | 2 | N_w |
| Stern-Gerlach beams | 2 | N_w |
| T1 denominator | 2 | N_w (= λ_weak) |
| T2 denominator | 3 | N_c (= λ_colour) |
| T1/T2 ratio | 3/2 | N_c/N_w |
| Phase space (Bloch + momentum) | 6 | χ |
| Spatial dimensions | 3 | N_c |
| Rotation matrix size | 9 | N_c² |

## Proof Certificate

- `haskel/CrystalSpin.hs` — 47 checks (47 PASS)
- `proofs/CrystalSpin.lean` — 38 Lean 4 theorems (by native_decide)
- `proofs/CrystalSpin.agda` — 38 Agda proofs (by refl)
- §11 engine wiring exercises imported CrystalEngine functions

## Dependencies

- **Imports CrystalEngine** — atoms, types, sector operations, tick, normSq
- No external packages
- Domain-specific: BlochVec type, applyW (precession), applyU (relaxation)
