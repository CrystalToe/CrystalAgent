<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalDiscoveries — New Discoveries from (2,3)

## What This Module Does

CrystalDiscoveries proves 39 integer identities across four domains — all
derived from N_w=2, N_c=3. These are structural discoveries: numbers that
appear in physics turn out to be algebraic combinations of the crystal atoms.

No time evolution. No VEV dependence. Pure integer algebra.

## Five Check Groups (39 checks total)

### Cosmological Partition (9 checks)
D = 42 splits as 29 + 11 + 2:
- Dark energy: D − gauss = 42 − 13 = **29**
- CDM: gauss − N_w = 13 − 2 = **11**
- Baryons: N_w = **2**
- Sum: 29 + 11 + 2 = 42 = D ✓

### Nuclear Magic Numbers (13 checks)
Every magic number from (2,3):
- 2 = N_w, 8 = d₃, 20 = gauss + β₀, 28 = σD − d₃ = χ² − d₃ = (N_c+1)β₀
- 50 = D + d₃ = σD₂/gauss, 82 = N_c⁴ + 1 = (D−1)N_w, 126 = N_c × D

### CKM Quark Mixing (7 checks)
Cabibbo angle structure: gauss×(d₄+1)+1 = 326, hierarchy from sector dimensions.

### Quantum Information Bridges (4 checks)
Bell states d₃ = N_w^N_c = 8, Steane [7,1,3] = [β₀, d₁, N_c], Eddington d₄ = N_w×N_c×(N_c+1).

### Structural Identities (6 checks)
gauss=13, σD=χ²=36, σD₂=650, D=42, D−gauss=29, gauss−N_w=11.

## Compile

```bash
# Type-check only (no main function):
ghc -c CrystalDiscoveries.hs

# Run from GHCi:
# ghci CrystalDiscoveries.hs -e runAll
```

No `main` defined. Module exports `runAll :: IO ()`.

## Import Chain

CrystalAtoms (qualified as CE, uses CE.nW and CE.nC only).
Refactored: was CrystalEngine.

## Proofs

| Proof file | Theorems | Method |
|------------|----------|--------|
| CrystalDiscoveries.agda | 40 | refl |
| CrystalDiscoveries.lean | 35 | native_decide |

Covers all 39 runtime checks plus cross-identities.
