<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalTower.hs — Component 6: The 42-Layer Tower

## What This Module Is

The spectral tower. D = Σd + χ = 36 + 6 = 42 layers. Each layer coarse-grains
χ = 6 sites into 1. Layer 0 (UV) has χ^D = 6^42 sites. Layer D (IR) has 1 site.

This is Component 6 of the 12-component architecture. It owns:

- Tower structure (D = 42, sites per layer, coarse-graining factor)
- Running coupling (the grand staircase: α⁻¹(d) = (d+1)π + ln β₀)
- VEV derivation (v = M_Pl × 35/(43 × 36 × 2^50) = 245.17 GeV)
- Ascending (W†) and descending (W) layer traversal
- Layer roles (what physics manifests at each scale)
- Implosion correction channel (δ = -35/75852)

## Dependency

```
CrystalAtoms.hs      ← Component 2 (root)
CrystalSectors.hs    ← Component 3 (state type)
CrystalEigen.hs      ← Component 4 (wK for ascend/descend)
    |
CrystalTower.hs      ← Component 6 (this file)
```

Imports CrystalAtoms, CrystalSectors, CrystalEigen. Nothing else.

## The Grand Staircase

```
α⁻¹(d) = (d + 1)π + ln β₀

d =  0:  α⁻¹ =    π + ln 7 =   5.09   (UV, all coupling)
d =  5:  α⁻¹ =  6π  + ln 7 =  20.80
d = 10:  α⁻¹ = 11π  + ln 7 =  36.50   (QCD scale)
d = 18:  α⁻¹ = 19π  + ln 7 =  61.62   (atomic scale)
d = 42:  α⁻¹ = 43π  + ln 7 = 137.036  (frozen, physical)
```

Each layer adds exactly π to the inverse coupling. 43 steps total.

## VEV Derivation

```
v = M_Pl × (Σd − 1) / ((D + 1) × Σd × 2^(D + d₃ − 1))
  = M_Pl × 35 / (43 × 36 × 2^50)
  = 1.22089 × 10¹⁹ × 2.262 × 10⁻¹⁷
  = 245.17 GeV
```

Every factor is from (2, 3): Σd − 1 = 35, D + 1 = 43, Σd = 36, d₃ = 8.
The only measured number is M_Pl.

## Key Formulas

| Quantity | Formula | Value |
|----------|---------|-------|
| Total layers | D = Σd + χ | 42 |
| Sites at layer d | χ^(D−d) | 6^(42−d) |
| Running α⁻¹ | (d+1)π + ln β₀ | 137.036 at D=42 |
| VEV | M_Pl × 35/(43×36×2^50) | 245.17 GeV |
| Lost DOF per tick | Σd − 1 | 35 |
| Entropy per layer | ln χ | ln 6 |
| Implosion δ | −35/75852 | −4.61 × 10⁻⁴ |

## Proofs

| File | Prover | Theorems |
|------|--------|----------|
| CrystalTower.agda | refl | 28 |
| CrystalTower.lean | native_decide | 23 |

## Compile & Test

```bash
ghc -O2 -main-is CrystalTower CrystalTower.hs && ./CrystalTower
```

All 32 tests PASS. Zero existing files modified.
