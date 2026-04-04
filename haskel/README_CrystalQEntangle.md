<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalQEntangle — Entanglement Analysis from (2,3)

## What This Module Does

CrystalQEntangle provides 16 entanglement analysis tools for quantum states
on the crystal Hilbert space ℂ^χ = ℂ⁶.

The key fact: the crystal algebra gives ℂ^N_w ⊗ ℂ^N_c = ℂ² ⊗ ℂ³, which is
the UNIQUE bipartite dimension where PPT (positive partial transpose)
completely characterises entanglement (Horodecki 1996). Separable ⟺ PPT.
No bound entanglement exists. Entanglement is decidable.

All functions are pure — no time evolution, no tick, no dt.

## Contents (208 lines)

| Section | Functions | What |
|---------|-----------|------|
| §1 Partial trace | partialTrace | Tr₂(\|ψ⟩⟨ψ\|) → reduced density matrix ρ₁ |
| §2 Entropy | vonNeumannEntropy, renyi2Entropy | S = -Tr(ρ ln ρ), S₂ = -ln(Tr(ρ²)) |
| §3 Entanglement measures | concurrence, negativity, entFormation, schmidtCoeffs, mutualInfo, quantumDiscord | 6 measures, negativity is complete for ℂ²⊗ℂ³ |
| §4 PPT criterion | pptTest, entanglementWitness | PPT exact for N_w⊗N_c; witness W = I/χ - \|Φ⟩⟨Φ\| |
| §5 States | bellState, maxEntangled, ghzState | Bell on ℂ³⁶, max entangled (1/√χ)Σ\|k,k⟩, GHZ on ℂ²¹⁶ |
| §6 Operations | purify, entanglementSwap | Purification from ρ; swapping via Bell measurement |

Total: 16 exported functions.

## Compile

```bash
ghc -c CrystalQEntangle.hs
```

No main. Type-check only.

## Import Chain

CrystalQBase only. Pure algebraic — no CrystalEngine, no CrystalAtoms.

## Proofs

| Proof file | Theorems | Method |
|------------|----------|--------|
| CrystalQEntangle.agda | 9 | refl |
| CrystalQEntangle.lean | 9 | native_decide |

Proves: PPT dimensions N_w=2 ⊗ N_c=3, bipartite space χ²=36,
tripartite χ³=216, Schmidt rank=2, Bell count=4, witness 1/χ,
product parameters χ+χ=12.
