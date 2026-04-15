<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalQuantum — Multi-Particle Quantum Mechanics from End(A_F)

## What This Module Does

CrystalQuantum derives the complete operator algebra for multi-particle quantum
simulation with entanglement from the 650 endomorphisms of A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ).

Seven key discoveries, all from N_w=2, N_c=3:

1. dim(H₂) = χ² = 36 = Σd — two particles span the algebra
2. S_max = ln(χ) = ln(6) — entanglement = irreversibility
3. Fermion states = 15 = dim(su(N_w²)) — Pati-Salam emerges
4. PPT exact for ℂ^N_w ⊗ ℂ^N_c — entanglement decidable
5. 650 endomorphisms = quantum gate set
6. Fock space → e^χ — total particle content
7. Pauli obstruction = Heyting incomparability

Engine wiring (§10a: toCrystalState, quantumTick) was stripped — those are
time-dependent operations that belong in CrystalDynamicEngine.

## Contents (433 lines)

| Section | What |
|---------|------|
| §0 | Crystal constants from CrystalAxiom (Integer) |
| §1 | Hilbert space: dim = χ = 6, eigenvalues, degeneracies |
| §2 | Hamiltonian: energy spectrum, mass gap ln(2), partition Z |
| §3 | Creation/annihilation: ladder factors, number eigenvalues |
| §4 | Multi-particle: tensor dim, symmetric (21), antisymmetric (15), Fock |
| §5 | Entanglement: max entropy ln(6), product (6) vs entangled (30), PPT |
| §6 | Gates: sector-preserving + mixing = χ² = 36, CNOT dim χ⁴ = 1296 |
| §7 | Measurement: sector probabilities, POVM weights |
| §8 | Time evolution: period 2π/mass_gap, discrete step 1/(N_w ln N_w) |
| §9 | Density matrices: thermal state, max mixed purity 1/χ |
| §10 | 10 structural theorems |

## 10 Structural Theorems

| # | Theorem | Proof |
|---|---------|-------|
| 1 | dim(H₂) = χ² = Σd | 36 = 36 |
| 2 | S_max = ln(χ) = arrow of time | ln(6) = ln(6) |
| 3 | Fermion states = 15 = dim(su(4)) | χ(χ-1)/2 = N_w⁴-1 |
| 4 | PPT decidable for N_w ⊗ N_c | 2×3 = 6 ≤ 6 |
| 5 | Gate count = χ² = 36 | End(ℂ^χ) |
| 6 | Fock limit e^χ ≈ 403 | truncated |
| 7 | Ladder symmetric: ΔE₀₁ = ΔE₂₃ = ln(N_w) | ln(2) = ln(2) |
| 8 | Interaction = 2× fermion count | χ(χ-1) = 2·15 |
| 9 | Pauli obstruction = Heyting incomparability | gcd(2,3) = 1 |
| 10 | CNOT = neutrino mixing dim | χ⁴ = 1296 |

## Self-Test (10 theorem checks + info printout)

```
quantumAudit prints: Hilbert space, spectrum, multi-particle, entanglement,
then runs 10 prove* theorems with PASS/FAIL.
```

## Compile

```bash
ghc -O2 -main-is CrystalQuantum CrystalQuantum.hs && ./CrystalQuantum
```

## Import Chain

CrystalAxiom only (Integer atoms: nW, nC, chi, beta0, towerD, sigmaD, sigmaD2, kappa).
Refactored: was CrystalAxiom + CrystalEngine. Engine wiring stripped.

## Proofs

| Proof file | Theorems | Method |
|------------|----------|--------|
| CrystalQuantum.agda | 9 | refl |
| CrystalQuantum.lean | 19 | native_decide |

Engine wiring proofs removed. Structural proofs cover: Hilbert dim, two-particle = Σd,
fermion su(4), entangled count, PPT, gate set, CNOT dim, sector total.
Lean adds: symmetric/antisymmetric dims, mass gap, Fock, purity, cross-checks.
