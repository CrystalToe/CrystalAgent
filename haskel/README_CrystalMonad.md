<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalMonad — The Monad S = W∘U

## What This Module Does

Implements the discrete time monad over A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ).

Time is ℕ. One tick = one application of S = W∘U. No calculus.

## The Monad

S = W ∘ U where:
- **U** (disentangler): unitary on pair space ℂ^χ². Reversible.
- **W** (isometry): ℂ^χ² → ℂ^χ. Compresses χ² = 36 → χ = 6. Irreversible.

On sector amplitudes, one tick of S multiplies each sector by its eigenvalue:

| Sector   | λ_k  | Fraction | Meaning                    |
|----------|------|----------|----------------------------|
| Singlet  | 1    | 1/1      | Fixed point. Photon.       |
| Weak     | 1/2  | 1/N_w    | Halved each tick.          |
| Colour   | 1/3  | 1/N_c    | Thirded each tick.         |
| Mixed    | 1/6  | 1/χ      | Sixthed each tick.         |

All exact rationals. From N_w = 2, N_c = 3. Nothing else.

## Key Results

- **Arrow of time**: χ > 1 ⟹ W†W = I but WW† ≠ I. Irreversible. Theorem.
- **Second Law**: ΔS = ln(χ) = ln(6) nats per tick. Forced by algebra.
- **H derived**: H = −ln(S)/β gives {0, ln2, ln3, ln6}. Consequence, not input.
- **Uncertainty**: 1/2 ⊥ 1/3 in Heyting order. gcd(2,3) = 1. Coprime. Incomparable.
- **Photon**: λ = 1. Invariant under S. Massless. Never decays.

## Proofs

| System   | File                 | Theorems | Method        |
|----------|----------------------|----------|---------------|
| Lean 4   | CrystalMonad.lean    | 20       | native_decide |
| Agda     | CrystalMonad.agda    | 16       | refl          |
| Haskell  | CrystalMonad.hs      | 12       | runtime       |

## What This Does NOT Do (Yet)

- Multi-site dynamics (needs CrystalMERA for U on pairs)
- Density matrix / decoherence
- Entanglement entropy computation
- Observable predictions (0 new observables)
- Python FFI (future: Toe() class)

## Dependencies

Imports: none (self-contained A_F atoms).
Future: will import CrystalAxiom when integrated into main build.

## Observable Count

0 new. Infrastructure only. Extends to observables via CrystalMERA perturbation.
