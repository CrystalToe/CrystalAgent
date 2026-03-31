<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalQuantum.hs — Structural Theorems

**421 lines · 10 theorems · 10/10 PASS · Multi-particle quantum mechanics from End(A_F)**

## What This Module Does

Proves 10 structural theorems about the quantum mechanics that emerges from A_F. These are not observables with experimental values — they are mathematical theorems about the Hilbert space structure, entanglement, and particle content implied by the algebra. Every quantum simulator (Qiskit, Cirq, QuTiP) requires you to SPECIFY dimensions and interactions. The crystal DERIVES them.

## The 10 Theorems

| # | Theorem | Statement | Proof |
|---|---------|-----------|-------|
| 1 | dim(H₂) = Σd | Two particles span 36 dimensions = sum of sector dims | Computation |
| 2 | S_ent = ΔS_arrow | Entanglement entropy = irreversibility = ln(6) | Both = ln(χ) |
| 3 | Fermions = 15 | Antisymmetric states = dim(su(4)) = Pati-Salam | Wedge product |
| 4 | PPT decidable | ℂ²⊗ℂ³ is the unique dimension where PPT ⟺ separable | Horodecki 1996 |
| 5 | End count = 650 | Total endomorphisms = Σd² = gates + internal | Representation |
| 6 | Fock total ≈ e⁶ | Total particle content ≈ 403 | Exponential of χ |
| 7 | ΔE₀₁ = ΔE₂₃ = ln(2) | Energy gaps are symmetric | Spectral symmetry |
| 8 | Interactions = 30 | 2 × 15 fermions = 30 interactions | Product |
| 9 | No time reversal | H ≥ 0 and Heyting → no T̂ operator | Pauli theorem |
| 10 | χ⁴ = 1296 | CNOT dimension ratio = neutrino mass ratio | 6⁴ = 1296 |

## Key Physical Insights

**PPT decidability is unique to (2,3).** The Partial Positive Transpose criterion for entanglement is necessary AND sufficient only in dimensions 2×2 and 2×3. The crystal's Hilbert space ℂ² ⊗ ℂ³ = ℂ^(N_w) ⊗ ℂ^(N_c) is exactly the dimension where entanglement is decidable. No other choice of two primes has this property.

**Entanglement = arrow of time.** S_entangle = ln(χ) = ln(6) = ΔS_arrow. The maximum entanglement entropy of the crystal equals the irreversibility per compression step. Entanglement and the arrow of time are the same thing measured differently.

**Pauli's theorem as Heyting logic.** Time reversal requires a Boolean algebra. The crystal's Heyting algebra is non-Boolean (1/2 ⊥ 1/3). Therefore no anti-unitary T̂ exists. CPT violation is a theorem, not an observation.

## Compile

```bash
ghc -fno-code CrystalQuantum.hs   # type-check
```

## Dependencies

Imports `CrystalAxiom`.
