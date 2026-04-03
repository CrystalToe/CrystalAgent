<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalWavelet — The MERA IS a Wavelet Transform

## The Identification

| MERA | Wavelet | Crystal constant |
|------|---------|-----------------|
| Disentangler | High-pass filter (detail) | U operator |
| Isometry | Low-pass filter (approximation) | W operator |
| One MERA layer | One wavelet level | S = W∘U |
| Bond dimension | Filter length | χ = 6 |
| Tower depth | Maximum levels | D = 42 |
| Causal cone | Filter support | N_w^l × χ |
| Entanglement entropy | Detail energy | per level |

This is not an analogy. The MERA IS a discrete wavelet transform applied
to quantum states instead of signals. The math is identical.

## Daubechies Family from (2,3)

| Wavelet | Taps | Crystal | Vanishing moments |
|---------|------|---------|-------------------|
| Haar (Daub-1) | 2 | N_w | 1 |
| Daub-3 | 6 | χ = N_w×N_c | N_c = 3 |
| Daub-5 | 10 | N_w(χ−1) | χ−1 = 5 |
| Daub-7 | 14 | N_wβ₀ | β₀ = 7 |

The Daubechies filter lengths ARE the electron shell capacities:
s=2, p=6, d=10, f=14. The wavelet resolution hierarchy IS the
atomic orbital hierarchy. Same numbers. Same algebra.

## What the Tests Prove

1. **Perfect reconstruction** — decompose then reconstruct = original (error < 10⁻¹²)
2. **Parseval** — energy preserved across decomposition (single level and multi-level)
3. **Multi-level** — 256-sample signal decomposes into 8 = log₂(256) levels
4. **Coefficient count** — total coefficients = signal length (nothing lost)
5. **Energy profile** — finer levels have more detail energy (UV dominates)
6. **Causal cone** — grows as N_w^l × χ (matches MERA causal cone exactly)

## Files

| File | Location | Count | Method |
|------|----------|-------|--------|
| `CrystalWavelet.hs` | `haskel/` | 39 checks | GHC runtime |
| `CrystalWavelet.lean` | `proofs/` | 31 theorems | `native_decide` |
| `CrystalWavelet.agda` | `proofs/` | 30 proofs | `refl` |

## Run

```bash
ghc -O2 -main-is CrystalWavelet CrystalWavelet.hs && ./CrystalWavelet
lean CrystalWavelet.lean
agda CrystalWavelet.agda
```

## Why This Matters

The MERA was invented as a tensor network for quantum states.
Wavelets were invented for signal processing.
They are the SAME mathematical object.

The Crystal Topos makes this concrete: the bond dimension χ = 6
that appears in the MERA is the same χ = 6 that appears as the
Daubechies-3 filter length. The tower depth D = 42 that counts
MERA layers is the maximum wavelet decomposition depth.
The causal cone that determines entanglement structure is the
filter support that determines wavelet resolution.

This means: every wavelet compression algorithm (JPEG 2000, etc.)
is doing a MERA on classical data. And every MERA simulation is
doing wavelet compression on quantum data.
