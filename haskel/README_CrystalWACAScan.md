<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalanalysisScan.hs — 44 New Observables

**927 lines · Zero hardcoded numbers · 3 EXACT + 41 TIGHT**

## The Hadron Scale
```
Λ_h = v/(2^(2^N_c) + 1) = v/257 = 958.05 MeV
```
257 is the third Fermat prime. Every heavy hadron factorises through it.

## Highlights

| Observable | Formula | PWI |
|-----------|---------|-----|
| η' meson | Λ_h itself | 0.029% |
| m_τ | Λ_h × gauss/β₀ | 0.134% |
| M_Pl/v | e^D/(β₀(χ−1)) = e⁴²/35 | 0.209% |
| μ_p/μ_N | N_w×β₀/(χ−1) = 14/5 | 0.258% |
| τ_n | D²/N_w = 882 s | 0.410% |
| φ (golden ratio) | gauss/N_w³ = 13/8 | 0.431% |
| ζ(3) = f_K/f_π | χ/(χ−1) = 6/5 | 0.175% |
| γ (Euler-Masch) | β₀/(gauss−1)−1/(gauss²−N_w) | 0.025% |

## Derivation Chain
21 steps from (2, 3, v, π, ln) → all 44 observables. Zero bare numbers in executable code.

## Dependencies
Standalone (redefines constants internally for independence).
