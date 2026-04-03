<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalQuantum — Multi-Particle Quantum Operators from End(A_F)

## What This Module Does

CrystalQuantum derives the complete operator algebra for multi-particle
quantum simulation from the 650 endomorphisms of A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ).
Everything from Hilbert space dimension to entanglement measures to gate
counts traces to (N_w=2, N_c=3).

### Key Results

- **Hilbert space:** dim(H₁) = χ = 6. dim(H₂) = χ² = 36 = Σd (two particles span the algebra).
- **Spectrum:** E_k = −ln(λ_k) = {0, ln2, ln3, ln6}. Mass gap = ln(N_w). Symmetric ladder: ΔE₀₁ = ΔE₂₃.
- **Multi-particle:** Bosons = χ(χ+1)/2 = 21. Fermions = χ(χ−1)/2 = 15 = dim(su(N_w²)) — Pati-Salam emerges.
- **Entanglement:** S_max = ln(χ) = ΔS_arrow. PPT exact for ℂ^N_w ⊗ ℂ^N_c (Horodecki).
- **Gates:** Total = χ² = 36 single-particle gates. CNOT = χ⁴ = 1296. End(A_F) = 650.
- **Time:** Natural period T = 2π/ln(N_w). Discrete step dt = 1/(N_w ln N_w).
- **Density matrix:** Max mixed purity = 1/χ.

### Integer Traces

| Quantity | Value | Crystal derivation |
|---|---|---|
| Hilbert dim | 6 | χ |
| Two-particle dim | 36 | χ² = Σd |
| Bosons | 21 | χ(χ+1)/2 |
| Fermions | 15 | χ(χ−1)/2 = dim(su(N_w²)) |
| Entangled states | 30 | χ(χ−1) |
| Entanglement fraction | 5/6 | (χ−1)/χ |
| Gates | 36 | χ² |
| CNOT dim | 1296 | χ⁴ |
| Endomorphisms | 650 | Σd² |
| Fock limit | e⁶ | e^χ |

## Engine Wiring

**Status: WIRED.** Module #19 on the Engine Wiring Work List.

### What Changed

1. **`import qualified CrystalEngine as CE`** — engine functions (tick, extractSector,
   injectSector, CrystalState, lambda, normSq, zeroState) imported from engine.
2. **Atoms stay from CrystalAxiom** — CrystalQuantum uses Integer throughout;
   CrystalAxiom provides Integer atoms. CrystalEngine provides Int engine functions.
   No local atom redefinitions.
3. **`toCrystalState` / `fromCrystalState`** — packs quantum state data (eigenvalues,
   energies, entanglement metrics) into colour (d₃=8) + mixed (d₄=24) = 32 slots.
4. **`proveSectorRestriction`** — round-trip test on 32-component vector.
5. **Engine wiring checks** added to `quantumAudit`.
6. **`main`** added to run audit as standalone.

### Sector

**Colour⊕mixed (d=32).** Quantum operator algebra spans colour (momentum/spin
structure, d=8) and mixed (entangled/interaction DOF, d=24). No weak-sector
coupling — quantum operators act on internal Hilbert space, not on spatial geometry.

## Self-Test

```bash
ghc -O2 -main-is CrystalQuantum CrystalQuantum.hs && ./CrystalQuantum
```

10 structural theorems + engine wiring checks.

## Proof Certificate

- `proofs/CrystalQuantum.lean` — quantum + engine wiring theorems
- `proofs/CrystalQuantum.agda` — quantum + engine wiring proofs
