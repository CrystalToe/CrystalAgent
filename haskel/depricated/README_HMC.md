<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalHMC — Hamiltonian Monte Carlo on the MERA

## What It Is

HMC without calculus. The three steps of traditional HMC map exactly
to three sector restrictions of S = W∘U:

| Traditional HMC | Crystal HMC | Sector |
|----------------|-------------|--------|
| Draw momentum p ~ N(0,1) | Inject random into weak sector | d₂ = 3 |
| Leapfrog (Hamilton's equations) | N ticks of S\|_{weak⊕colour} | d₂ + d₃ = 11 |
| Accept/reject (Metropolis) | Compare energies | d₄ = 24 |

HMC is not *implemented using* S = W∘U. HMC *is* S = W∘U.

## No Calculus

| Traditional | Crystal | Why |
|------------|---------|-----|
| Action = ∫ L dt | Action = Σ dₖ\|ψₖ\|²Eₖ | Sum, not integral |
| Gradient = ∂S/∂φ | Gradient = 2ψᵢ × Eₖ | Multiply, not derivative |
| Leapfrog = solve ODE | Leapfrog = tick() | Discrete update, not ODE |
| Accept = exp(-ΔH) | Accept = compare | Single exp for threshold, not dynamics |
| Path integral | Sector restriction | Finite sum over 4 sectors |

The only transcendental in the hot loop is one `exp(-ΔH)` per proposal
for the Metropolis criterion. This is a THRESHOLD COMPARISON, not dynamics.
The dynamics are pure multiply-add.

## MERA Sampling

The MERA has D = 42 layers, each with Σd = 36 dimensions.
Total state space: 42 × 36 = 1512 components.

CrystalHMC samples all 42 layers simultaneously:

```
for each layer d = 0..41:
    1. inject random momentum (3 components)
    2. leapfrog trajectory (20 steps of tick)
    3. accept/reject (compare energies)
```

This explores:
- **Inter-layer correlations** — how UV (D=0) talks to IR (D=41)
- **Phase transitions** — topology changes in the MERA at critical temperature
- **Entanglement entropy** — every HMC sample measures S_ent at every cut

## Crystal Constants in HMC

| Constant | Value | Crystal | Role in HMC |
|----------|-------|---------|-------------|
| Momentum dim | 3 | d₂ = N_w²−1 | Random draw dimension |
| Phase space | 6 | χ = N_w×N_c | Leapfrog dimension |
| Verlet order | 2 | N_w | Leapfrog accuracy |
| Mixed dim | 24 | d₄ | Accept/reject space |
| MERA layers | 42 | D = Σd+χ | Sweep depth |
| State dim | 36 | Σd | Components per layer |
| LCG multiplier | 650 | Σd² | Pseudo-random |
| LCG increment | 7 | β₀ | Pseudo-random |
| LCG modulus | 65536 | 2^(N_w⁴) | Pseudo-random |
| S = A/(4G) | 4 | N_w² | Entanglement entropy |

## What You Discover

### Phase 1: Single-layer HMC
Sample the 36-dim state on one layer. Measure sector fractions.
The singlet dominates at late times (arrow of time).

### Phase 2: Full MERA HMC
Sample all 42 layers jointly. Measure correlations between layers.
If δS = δ⟨H_A⟩ holds per sample, every sample IS a linearized
Einstein equation. You're sampling gravity.

### Phase 3: Temperature scan
Vary the KMS temperature β = 2π/T. At critical T, the MERA
changes topology — this is a cosmological phase transition with
no continuum description. Only the discrete engine can see it.

## Files

| File | Location | Count | Method |
|------|----------|-------|--------|
| `CrystalHMC.hs` | `haskel/` | 26 checks | GHC runtime |
| `CrystalHMC.lean` | `proofs/` | 33 theorems | `native_decide` |
| `CrystalHMC.agda` | `proofs/` | 33 proofs | `refl` |

## Run

```bash
# Haskell (from haskel/)
ghc -O2 -main-is CrystalHMC CrystalHMC.hs && ./CrystalHMC

# Lean (from proofs/)
lean CrystalHMC.lean

# Agda (from proofs/)
agda CrystalHMC.agda
```

## Relationship to Other Modules

```
CrystalMonadProof.hs    proves S = W∘U is unique
CrystalEngine.hs        builds S = W∘U on 36 dims
CrystalHMC.hs           samples S = W∘U on 42 × 36 dims  ← YOU ARE HERE
    ↓ restricts to
CrystalClassical.hs     Verlet (positions + momenta)
CrystalCondensed.hs     Metropolis (accept/reject)
CrystalThermo.hs        MD (LJ forces)
... all 21 dynamics
```

CrystalHMC is not a new method. It's the recognition that HMC was
always S = W∘U, and the MERA gives it a natural home: 42 layers of
36-dimensional state, sampled by the monad.
