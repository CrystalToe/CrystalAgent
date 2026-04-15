<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalQInfo — Quantum Information from (2,3)

## What This Module Does

CrystalQInfo derives every integer in quantum information theory from N_w=2,
N_c=3, plus implements working error correction circuits.

Two layers:
1. **Structural proofs** — 13 integer identities (qubit=2, Steane [7,1,3], etc.)
2. **Error correction circuits** — encode, inject error, detect syndrome, correct, decode

The key insight: gcd(N_w, N_c) = gcd(2,3) = 1 (coprime). This forces
meet(1/2, 1/3) = 1/6 = 1/χ — the uncertainty principle is coprimality.

No time evolution. Pure structural proof + algebraic circuits.

## Error Correction Circuits (§2a)

**Steane code** [β₀, d₁, N_c] = [7, 1, 3]:
- `steaneEncode sector` → 7 carriers (β₀ copies of sector index)
- `steaneInjectError pos carriers` → flip carrier at pos by +1 mod χ
- `steaneSyndrome carriers` → position of error (-1 if none)
- `steaneCorrect carriers` → majority vote repair
- `steaneDecode carriers` → extract logical sector
- Corrects (N_c-1)/2 = 1 error. All χ = 6 sectors survive round-trip.

**Shor code** [N_c², d₁, N_c] = [9, 1, 3]:
- `shorEncode sector` → 9 carriers (N_c blocks of N_c)
- `shorDecode carriers` → block-majority then cross-block majority
- Same round-trip guarantee.

## 13 Integer Identities (§6)

| # | Quantity | Value | From (2,3) |
|---|---------|-------|------------|
| 1 | Qubit | 2 | N_w |
| 2 | Pauli | 3 | N_c |
| 3 | Pauli group | 4 | N_w² |
| 4 | Bell states | 4 | N_w² |
| 5 | Steane n | 7 | β₀ = N_w^N_c - 1 |
| 6 | Steane d | 3 | N_c |
| 7 | Steane corrects | 1 | (N_c-1)/2 |
| 8 | Shor n | 9 | N_c² |
| 9 | Toffoli | 3 | N_c |
| 10 | MERA bond | 6 | χ |
| 11 | MERA depth | 42 | D |
| 12 | Teleport | 2 | N_w |
| 13 | Uncertainty | 1/6 | 1/χ |

## Self-Test (6 sections, 25 checks)

| Section | What | Checks |
|---------|------|--------|
| S1 | 13 integer identities | 13 |
| S2 | Entropy: Bell, MERA, ln(χ) = ln(N_w) + ln(N_c) | 3 |
| S3 | Heyting: coprime, complementarity | 2 |
| S4 | Hamming bound, Shor=CFD | 2 |
| S5 | Teleport-superdense duality | 1 |
| S6 | Error correction: Steane + Shor round-trips, all χ sectors | 4 |

## Compile

```bash
ghc -O2 -main-is CrystalQInfo CrystalQInfo.hs && ./CrystalQInfo
```

## Import Chain

Data.Ratio + CrystalAtoms (qualified as CE, atoms only).
Refactored: was CrystalEngine.

## Proofs

| Proof file | Theorems | Method |
|------------|----------|--------|
| CrystalQInfo.agda | 19 | refl |
| CrystalQInfo.lean | 22 | native_decide |

Added: error correction circuit dimensions (steane carriers=7, shor carriers=9,
shor blocks=3, sector values=6, distance corrects=1).
