<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalAxiom.hs — The One Law

**776 lines · Foundation module · All other modules import this**

## The One Law

```
Phys = End(A_F) + Nat(End(A_F))
```

Everything that EXISTS is an endomorphism of A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ). Everything that HAPPENS is a natural transformation between endomorphisms. There is nothing else. This single axiom generates all of physics.

## What This Module Defines

### The Two Primes

The entire framework starts here:

- `nW = 2` — weak isospin generations, the dimension of the M₂(ℂ) factor. This is why there are 2 spin states, 2 helicities, 2 neutrinos per generation at low energy. Every power of 2 in physics traces here.
- `nC = 3` — colour charges, the dimension of the M₃(ℂ) factor. This is why quarks come in 3 colours, space has 3 dimensions, and the strong force has 8 gluons (N_c² − 1 = 8). Every power of 3 traces here.

### The Four Sector Dimensions

From the representation theory of A_F:

```
sector_dims = [1, N_c, N_c² − 1, N_w³ × N_c] = [1, 3, 8, 24]
```

These are the irreducible representation dimensions. They correspond to:
- d₁ = 1: the U(1) singlet (hypercharge)
- d₂ = 3: the SU(3) fundamental (quarks)
- d₃ = 8: the SU(3) adjoint (gluons)
- d₄ = 24: the mixed fermion representation

### Six Integer Invariants

Every formula in every module ultimately reduces to combinations of these six numbers, all computed from 2 and 3:

| Invariant | Formula | Value | Role |
|-----------|---------|-------|------|
| χ | N_w × N_c | 6 | Euler characteristic, sector count |
| β₀ | (11N_c − 2χ)/3 | 7 | One-loop QCD β-function coefficient |
| Σd | Σ sector_dims | 36 | Seeley-DeWitt a₀ (topological) |
| Σd² | Σ (sector_dims)² | 650 | Seeley-DeWitt a₄ (total endomorphisms) |
| gauss | N_c² + N_w² | 13 | Sum of squares of the two primes |
| D | Σd + χ | 42 | Total spectral dimension (tower height) |

### Transcendental Invariant

```
κ = ln(N_c)/ln(N_w) = ln(3)/ln(2) ≈ 1.585
```

The Hausdorff dimension of the (2,3) Cantor set. This is the only irrational crystal invariant. It enters neutrino physics (N_eff = N_c + κ/D), spectral running, and fractal structure.

### The Spectrum

Four eigenvalues of the spectral operator with their degeneracies:

| Eigenvalue | Degeneracy | Sector |
|------------|------------|--------|
| 1 | 1 | Singlet |
| 1/2 | 3 | Colour fundamental |
| 1/3 | 8 | Colour adjoint |
| 1/6 | 24 | Mixed fermion |

The eigenvalues are 1/d_i (reciprocals of sector dims). The degeneracies ARE the sector dims. This is the spectral action's Dirac operator restricted to A_F.

### The Heyting Algebra and Uncertainty

The spectral eigenvalues form a Heyting algebra under the natural order:
- `meet(1/2, 1/3) = 1/6` — the joined state is fuzzy (both colours present)
- `join(1/2, 1/3) = 1` — perfectly certain (one or the other)
- `1/2 ⊥ 1/3` — incomparable = quantum uncertainty

Uncertainty is a theorem of intuitionistic logic, not a property of measurement apparatus. The algebra IS non-boolean. No interpretation needed.

### Arrow of Time

The compression monad S maps the full algebra to its centre:
- S sends χ = 6 states to 1 state
- Entropy per tick: ΔS = ln(χ) = ln(6) ≈ 1.792 nats
- Since χ > 1, this compression is irreversible
- Time exists because the algebra is non-commutative

### Coupling Constants

All three Standard Model couplings derive from the invariants:

```
α⁻¹ = (D+1)π + ln(β₀) = 43π + ln(7) ≈ 137.036
sin²θ_W = N_c/gauss = 3/13 ≈ 0.2308
α_s = N_w/(gauss + N_w²) = 2/17 ≈ 0.1176
```

### Proof-Carrying Types

The module defines Haskell types that carry their proofs:
- `CrystalRat` — exact rational arithmetic
- `CrystalTrans` — transcendental expressions (π, ln combinations)
- `Derived` — a physical observable with crystal prediction + measurement + rating
- `Measurement` — experimental value with uncertainty
- `Ruler` — the one dimensionful measurement (M_Pl = 1.220890 × 10¹⁹ GeV). VEV is derived: v = M_Pl × 35/(43×36×2⁵⁰)
- `Status` — EXACT / TIGHT / GOOD / LOOSE / OVER rating

## Key Exports

`nW, nC, chi, beta0, towerD, sigmaD, sigmaD2, gauss, kappa, alpha, sin2w, alpha_s, pwiRating, showDerived, standardRuler, crystalAxiom`

## Compile

```bash
ghc -fno-code CrystalAxiom.hs   # type-check only (Curry-Howard proof)
```

## Dependencies

None. This is the root. Every other module imports this.
