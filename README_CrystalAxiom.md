<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalAxiom.hs — The One Law

**774 lines · Foundation module · All other modules import this**

## The One Law
```
Phys = End(A_F) + Nat(End(A_F))
```
Everything that EXISTS is an endomorphism of A_F. Everything that HAPPENS is a natural transformation between them. There is nothing else.

## What This Module Defines

### The Two Primes
- `nW = 2` — weak generations
- `nC = 3` — colours

### Six Integer Invariants
- `chi = N_w × N_c = 6`
- `beta0 = (11N_c − 2χ)/3 = 7`
- `towerD = Σd + χ = 42` (total spectral dimension)
- `sigmaD = 36` (sum of sector dimensions)
- `sigmaD2 = 650` (sum of squared sector dimensions = total endomorphisms)
- `gauss = N_c² + N_w² = 13`

### The Spectrum
Four sectors with eigenvalues {1, 1/2, 1/3, 1/6} and degeneracies {1, 3, 8, 24}.

### The Heyting Algebra
Uncertainty is a theorem of intuitionistic logic, not a property of measurement. `meet(1/2, 1/3) = 1/6` (fuzzy), `join(1/2, 1/3) = 1` (certain), `1/2 ⊥ 1/3` (incomparable = uncertain).

### Arrow of Time
`χ > 1` → compression → irreversibility. `ΔS = ln(χ) = ln(6)` nats per tick.

### Proof-Carrying Types
`CrystalRat`, `CrystalTrans`, `Derived`, `Measurement`, `Ruler`, `Status`.

## Key Exports
`nW, nC, chi, beta0, towerD, sigmaD, sigmaD2, kappa, pwiRating, showDerived, standardRuler`

## Dependencies
None. This is the root.
