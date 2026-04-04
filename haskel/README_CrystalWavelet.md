<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalWavelet — Discrete Wavelet Transform from (2,3)

## What This Module Does

CrystalWavelet makes the MERA = wavelet identification explicit. The MERA
tensor network IS a discrete wavelet transform:
- U (disentangler) = high-pass filter (extract detail)
- W (isometry) = low-pass filter (coarse-grain + downsample)
- S = W∘U = one wavelet decomposition level = one MERA layer

Every wavelet parameter from (2,3):
- Haar coefficients = N_w = 2
- Downsample factor = N_w = 2
- Daubechies-3 vanishing moments = N_c = 3
- Filter length = χ = 6 = MERA bond dimension
- Tower depth = D = 42 = maximum decomposition levels

Implements: Haar wavelet (convolve + downsample), multi-level decomposition,
perfect reconstruction, Parseval energy conservation, causal cone widths.

No calculus. Convolution = multiply-add. Downsample = take every N_w-th.

## Contents (331 lines)

| Section | What |
|---------|------|
| §0 | Atoms from CrystalAtoms |
| §1 | 10 integer identity constants |
| §2 | Haar wavelet: low-pass (W), high-pass (U), decompose, reconstruct |
| §3 | Multi-level decomposition (= MERA tower) |
| §4 | Energy per level (= entanglement per MERA layer) |
| §5 | MERA ↔ wavelet dictionary |
| §6-§11 | Self-test: 42 checks across 11 sections |

## Self-Test (11 sections, 42 checks)

| Section | What |
|---------|------|
| §1 | 10 integer identities (Haar, Daub, filter, bond, levels) |
| §2 | Perfect reconstruction (error < 1e-12) |
| §3 | Parseval energy conservation |
| §4 | Multi-level: 256 samples, 8 levels, coefficient count |
| §5 | Multi-level Parseval |
| §6 | Multi-level reconstruction |
| §7 | Energy profile (finer levels = more detail) |
| §8 | Causal cone grows as N_w^l × χ |
| §9 | MERA ↔ wavelet dictionary (8 correspondences) |
| §10 | Calculus ban (5 checks) |
| §11 | Cross-module consistency (6 checks) |

## Compile

```bash
ghc -O2 -main-is CrystalWavelet CrystalWavelet.hs && ./CrystalWavelet
```

## Import Chain

CrystalAtoms (nW, nC, chi, beta0, sigmaD, towerD). gauss defined locally.
Refactored: was CrystalEngine.

## Proofs

| Proof file | Theorems | Method |
|------------|----------|--------|
| CrystalWavelet.agda | 33 | refl |
| CrystalWavelet.lean | 18 | native_decide |
