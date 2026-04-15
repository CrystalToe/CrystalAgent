<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalQGates — Quantum Gates from End(A_F)

## What This Module Does

CrystalQGates defines the complete gate set for quantum computation on the
crystal Hilbert space. Standard qubit gates (Pauli, Hadamard, rotations)
are generalised from ℂ² to ℂ^χ = ℂ⁶. Multi-particle gates act on the
tensor product ℂ^χ ⊗ ℂ^χ = ℂ³⁶ = ℂ^Σd. Three-particle gates (Toffoli, CSWAP)
act on ℂ^χ³ = ℂ²¹⁶ and are implemented as vector functions, not explicit matrices.

All gates are pure matrices or vector maps. No time evolution, no tick, no dt.

## Contents (243 lines)

### §1 Single-particle gates (ℂ⁶ → ℂ⁶) — 12 gates

| Gate | What |
|------|------|
| gateI | Identity |
| gateX | Cyclic shift \|k⟩ → \|k+1 mod χ⟩ |
| gateY | -i × X × Z |
| gateZ | Phase diag(1, ω, ω², …, ω^(χ-1)), ω = e^(2πi/χ) |
| gateH | DFT matrix (1/√χ) |
| gateS | Phase S: diag(1, e^(iπ/χ), …) |
| gateT | Phase T: diag(1, e^(iπ/(2χ)), …) |
| gateRx(θ) | Rotation around X |
| gateRy(θ) | Rotation around Y |
| gateRz(θ) | Phase rotation diag(e^(-iθk/χ)) |
| gateU3(θ,φ,λ) | Universal = Rz(φ) Ry(θ) Rz(λ) |
| gateSX | √X |

### §2 Multi-particle gates — 14 gates

| Gate | Space | What |
|------|-------|------|
| gateCNOT | ℂ³⁶ | Controlled sector shift |
| gateCZ | ℂ³⁶ | Controlled phase |
| gateSWAP | ℂ³⁶ | \|i,j⟩ → \|j,i⟩ |
| gateiSWAP | ℂ³⁶ | SWAP with i phase |
| gateSqrtSWAP | ℂ³⁶ | Half swap, generates entanglement |
| gateToffoli | ℂ²¹⁶ | CCX on 3 particles (vector function) |
| gateCSWAP | ℂ²¹⁶ | Fredkin on 3 particles (vector function) |
| gateXX(θ) | ℂ³⁶ | Coupled sector flips |
| gateYY(θ) | ℂ³⁶ | Coupled Y-rotations |
| gateZZ(θ) | ℂ³⁶ | Correlated phase evolution |
| gateECR | ℂ³⁶ | Echoed cross-resonance |
| gateGivens(i,j,θ) | ℂ⁶ | Rotation between levels i and j |
| gatefSWAP | ℂ³⁶ | Fermionic SWAP (parity sign) |
| gateMatchgate(θ,φ) | ℂ⁶ | Parity-preserving unitary |

### §3 Application helpers — 2 functions

applySingle, applyTwo — both are mApply (matrix × vector).

## Compile

```bash
ghc -c CrystalQGates.hs
```

No main. Type-check only.

## Import Chain

CrystalQBase only. Pure algebraic — no CrystalEngine, no CrystalAtoms.

## Proofs

| Proof file | Theorems | Method |
|------------|----------|--------|
| CrystalQGates.agda | 8 | refl |
| CrystalQGates.lean | 8 | native_decide |

Proves: χ=6, χ²=36 (two-particle space), χ³=216 (Toffoli space),
χ⁴=1296 (process matrix), Pauli group size=4, Givens pairs=30,
tensor product = Σd.
