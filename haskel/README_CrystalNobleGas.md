<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalNobleGas — Blessed-Prime Gate for Electron Shells

**Crystal Topos / WACA Programme — April 2026**

## What This Proves

The blessed-prime gate — the arithmetic criterion that governs nuclear magic numbers — also governs noble gas electron counts. Every noble gas through Radon (Z = 86) factors entirely into blessed primes. Oganesson (Z = 118) is the first noble gas position that fails the gate, correctly predicting its anomalous reactivity.

## The Seven Tests

| § | Test | Claim |
|---|---|---|
| 1 | Noble gas Z values | All six (2, 10, 18, 36, 54, 86) factor entirely into blessed primes |
| 2 | Oganesson forbidden | 118 = 2 · 59, with 59 foreign → framework-forbidden |
| 3 | Radon ↔ Heegner-43 | 86 = 2 · 43, and 43 ∈ H directly (Heegner prime) |
| 4 | Shell capacity | Electron shell capacity = N_w · n² = 2n² |
| 5 | Cumulative filling | Noble gas Z values = cumulative sum of doubled shell capacities |
| 6 | Bilinear parent | pronic(n) − square(n) = n (nuclear vs electron shell link) |
| 7 | Capacity differences | Δ(2n²) = 2(2n + 1) — odd-number growth law |

## Key Result: The Bilinear Parent

Nuclear L1 shell sizes and electron shell sizes are both the bilinear form **n · m**:

- **Nuclear**: n(n+1) — consecutive integers (m = n + 1)
- **Electron**: n² — same integer repeated (m = n)
- **Gap**: n(n+1) − n² = n — exact, at every shell

Both carry the N_w = 2 Pauli factor. The nuclear sequence uses all N_c = 3 columns (3D harmonic oscillator); the electron sequence effectively uses N_c = 2 (orbital angular momentum without the strong-force third column). Same parent lattice, different projection.

## Key Result: Oganesson Falsifier

Z = 118 = 2 · 59. The prime 59 is foreign:
- 59 ∉ H = {1, 2, 3, 7, 11, 19, 43, 67, 163}
- 4 · 59 − 1 = 235 ∉ H

Framework prediction: Oganesson should NOT behave as a traditional noble gas.

This matches current relativistic quantum chemistry predictions (Pershina, Schwerdtfeger et al.). Oganesson is expected to be reactive due to relativistic orbital contraction and spin-orbit splitting of the 7p shell. The framework reaches the same conclusion from integer factorization alone.

## Compile

```bash
# Haskell (runtime, formatted output + 7 structural checks)
ghc -O2 -main-is CrystalNobleGas CrystalNobleGas.hs && ./CrystalNobleGas

# Lean 4 (compile-time via native_decide)
lean ../proofs/CrystalNobleGas.lean

# Agda (compile-time via refl)
agda ../proofs/CrystalNobleGas.agda
```

## Factorizations

| Element | Z | Factorization | All blessed? | Notable |
|---|---|---|---|---|
| He | 2 | 2 | ✓ | 2 ∈ H |
| Ne | 10 | 2 · 5 | ✓ | 5 blessed via 4·5−1=19 ∈ H |
| Ar | 18 | 2 · 3² | ✓ | 2, 3 ∈ H |
| Kr | 36 | 2² · 3² | ✓ | 2, 3 ∈ H |
| Xe | 54 | 2 · 3³ | ✓ | 2, 3 ∈ H |
| Rn | 86 | 2 · 43 | ✓ | **43 ∈ H (Heegner prime)** |
| Og | 118 | 2 · 59 | **✗** | **59 foreign → FORBIDDEN** |

## Files

- `CrystalNobleGas.hs` — this directory, executable Haskell verification
- `README_CrystalNobleGas.md` — this file
- `../proofs/CrystalNobleGas.lean` — Lean 4 proof module
- `../proofs/CrystalNobleGas.agda` — Agda proof module

## Supports

- Forthcoming paper: "Same Song, Second Verse" (noble gas blessed-prime gate)
- Chemistry dynamics roadmap: `todo/chemistry_dynamics/ROADMAP.md`
- Prior work: `Multi_Layer_Reinforcement.md` (nuclear layer hierarchy)
- Prior work: `Magic_Numbers.md` (primary formula and blessed-prime criterion)
