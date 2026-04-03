<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalDiffusion — Heat / Diffusion Equation from (2,3)

## The Deepest Result

Diffusion IS eigenvalue decay. The monad IS the heat equation.

Each Fourier mode k of the temperature field decays as λₖᵗ per tick.
The k=0 mode has λ=1 (conserved → total heat is preserved).
Higher modes have λ<1 (decay → field smooths out).

This is identical to the monad's sector eigenvalue decay:
singlet (λ=1) persists, weak/colour/mixed (λ<1) decay.
The heat equation and the arrow of time are the same phenomenon.

## S = W∘U Decomposition

| Operator | What it does | Crystal constant |
|----------|-------------|-----------------|
| **W** | Source: inject/absorb at each site | Diagonal multiply |
| **U** | Spread: average over neighbours | Hopping (add/subtract) |
| **S = W∘U** | Source after spread | One diffusion tick |

For pure diffusion (no source), W = identity and S = U.
The heat equation is the simplest possible S = W∘U.

## Every Integer from (2,3)

| Quantity | Value | Crystal | Dimension |
|----------|-------|---------|-----------|
| Neighbours (1D) | 2 | N_w | left + right |
| Neighbours (2D) | 4 | N_w² | ±x, ±y |
| Neighbours (3D) | 6 | χ | ±x, ±y, ±z |
| Pattern | 2d | N_w × d | universal |
| Diffusion D | 1/6 | 1/χ | CFL maximum (3D) |
| CFL condition | 2d ≤ 1/D | 2N_c = χ | stability |
| Random walk dim | 3 | N_c | spatial |
| Directions | 6 | χ | per step |
| Stefan exponent | 4 | N_w² | T⁴ radiation |
| Stefan denominator | 15 | N_c(χ−1) | Boltzmann |
| Carnot efficiency | 5/6 | (χ−1)/χ | maximum |
| γ monatomic | 5/3 | (χ−1)/N_c | adiabatic |

## What the Tests Prove

1. **1D heat conservation** — delta function, 1000 ticks, total heat preserved to 10⁻¹⁰
2. **Peak spreading** — maximum decreases (diffusion works)
3. **2D diffusion** — 20×20 grid, N_w²=4 neighbours, heat conserved
4. **3D diffusion** — 8³ grid, χ=6 neighbours, heat conserved
5. **Random walk** — ⟨r²⟩ scales linearly with t (Einstein relation)
6. **Diffusion = monad** — k=0 conserved (singlet), k>0 decay (non-singlet)

## Files

| File | Location | Count | Method |
|------|----------|-------|--------|
| `CrystalDiffusion.hs` | `haskel/` | 34 checks | GHC runtime |
| `CrystalDiffusion.lean` | `proofs/` | 31 theorems | `native_decide` |
| `CrystalDiffusion.agda` | `proofs/` | 31 proofs | `refl` |

## Run

```bash
# Haskell (from haskel/)
ghc -O2 -main-is CrystalDiffusion CrystalDiffusion.hs && ./CrystalDiffusion

# Lean (from proofs/)
lean CrystalDiffusion.lean

# Agda (from proofs/)
agda CrystalDiffusion.agda
```

## Why This Matters

If diffusion — the simplest PDE in physics — isn't S = W∘U, then
nothing is. But it is. The heat equation is pure eigenvalue decay on
a lattice with multiply-add operations. No integral. No Green's function.
No continuum. Just tick.

The CFL stability condition D ≤ 1/(2d) gives D = 1/6 in 3D.
The denominator is χ = N_w × N_c. The CFL condition IS the algebra
telling you how fast information can spread on the lattice.
This is the Lieb-Robinson bound: c = χ/χ = 1.
