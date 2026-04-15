<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalQMeasure — Measurement Operators + Tomography from (2,3)

## What This Module Does

CrystalQMeasure defines 17 measurement and reconstruction operations for
quantum states on ℂ^χ = ℂ⁶.

Two layers:
1. **Measurements** — 8 types (projective, POVM, weak, parity, Bell, homodyne, heterodyne, tomography basis count) plus 4 collapse/probability helpers
2. **Tomography** — 5 reconstruction functions: rotate basis, measure in rotated basis, reconstruct density matrix from all χ²-1 = 35 measurements, compute fidelity

All dimensions from (2,3): χ = 6 outcomes, 4 sectors, parity split 9 vs 27,
χ²-1 = 35 tomography bases, χ² = 36 density matrix parameters.

No time evolution. Pure algebraic.

## Contents (187 lines)

| Section | Functions | What |
|---------|-----------|------|
| §1 Measurements | measureProjective, measurePOVM, measureWeak, measureParity, measureBell, measureHomodyne, measureHeterodyne, tomographyBases | 8 measurement types |
| §2 Collapse & Born | collapse, collapseToSector, bornProbs, sectorProbs | 4 helpers |
| §3 Tomography | tomoRotation, tomoMeasureInBasis, tomoReconstruct, tomoFull, tomoFidelity | 5 reconstruction functions |

Total: 17 exported functions.

## Tomography Pipeline (§3)

Every number from (2,3):

1. `tomoRotation θ` — DFT-like basis rotation by angle θ on ℂ^χ
2. `tomoMeasureInBasis k ψ` — Born probabilities in basis k, where k ∈ {0..χ²-2} = {0..34}
3. `tomoReconstruct results` — average over rotated measurements → diagonal ρ
4. `tomoFull ψ` — full pipeline: measure in all 35 bases, reconstruct
5. `tomoFidelity ψ ρ` — F(ψ,ρ) = ⟨ψ|ρ|ψ⟩, range [0,1]

Why 35? A χ×χ density matrix has χ² = 36 real parameters. Trace = 1 removes one. So χ²-1 = 35 independent measurements needed. 35 = 6² - 1 = (N_w × N_c)² - 1.

## Compile

```bash
ghc -c CrystalQMeasure.hs
```

No main. Type-check only.

## Import Chain

CrystalQBase only. Pure algebraic — no CrystalEngine, no CrystalAtoms.

## Proofs

| Proof file | Theorems | Method |
|------------|----------|--------|
| CrystalQMeasure.agda | 11 | refl |
| CrystalQMeasure.lean | 11 | native_decide |

Proves: projective outcomes=6, parity split 9/27, sum=σD, Bell=6,
two-particle=36, POVM norm=36, tomography bases=35, tomo parameters=36.
