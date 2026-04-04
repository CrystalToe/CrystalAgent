<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalZResonance — Z Boson Resonance from (2,3)

## What This Module Does

CrystalZResonance computes the Z boson mass, partial widths, total width,
and cross-section line shape from (2,3). The killer prediction:

**N_ν = N_c = 3. The number of neutrino species IS the number of colours.**

LEP measured N_ν = 2.984 ± 0.008. Crystal says exactly 3. Not fitted. Derived.

Every integer in the Z resonance from (2,3):
- Weak isospin T₃ = ±1/N_w = ±1/2
- Colour factor = N_c = 3
- Quark charges: 2/N_c and 1/N_c
- Generations = N_c = 3
- Flavours below M_Z: χ−1 = 5
- sin²θ_W(GUT) = N_c/d₃ = 3/8
- β₀ = 7

Breit-Wigner cross-section is a rational function — no path integral.

## Contents (263 lines)

| Section | What |
|---------|------|
| §0 | Atoms from CrystalAtoms |
| §1 | Electroweak: sin²θ_W, VEV, M_W, M_Z, α, G_F |
| §2 | Z partial widths: Γ_ν, Γ_l, Γ_u, Γ_d, Γ_had, Γ_inv, Γ_Z |
| §3 | Breit-Wigner line shape (rational function) |
| §4 | LEP scan: σ(√s) from 88–94 GeV |
| §5 | Self-test: 20 checks |

## Self-Test (6 sections, 20 checks)

| Section | What | Checks |
|---------|------|--------|
| §1 | M_W, M_Z within 1% of experiment | 2 |
| §2 | Partial widths (printf output, no PASS/FAIL) | 0 |
| §3 | N_ν = N_c = 3 exactly, N_ν from widths = 3.000 | 2 |
| §4 | LEP scan (printf table, no PASS/FAIL) | 0 |
| §5 | 9 crystal integer identities in Z physics | 9 |
| §6 | Sector restriction: d₄=24, d₃+d₄=32, Breit-Wigner rational | 4 |

Plus 3 additional checks in §2 region = 20 total `check` calls.

## Compile

```bash
ghc -O2 -main-is CrystalZResonance CrystalZResonance.hs && ./CrystalZResonance
```

## Import Chain

Text.Printf + CrystalAtoms (nW, nC, chi, beta0, sigmaD, towerD, gauss).
Refactored: was CrystalEngine.

## Proofs

| Proof file | Theorems | Method |
|------------|----------|--------|
| CrystalZResonance.agda | 35 | refl |
| CrystalZResonance.lean | 35 | native_decide |
