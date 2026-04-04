<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalProtonRadius — Proton Charge Radius from (2,3)

## What This Module Does

CrystalProtonRadius derives the proton charge radius r_p from the spectral
triple A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ), landing inside both muonic hydrogen
and CODATA uncertainties. Observable #181.

The formula:
```
r_p = (C_F × N_c − T_F/(d₃ × σD)) × ℏ/(m_p c)
    = (4 − 1/576) × 0.2103 fm
    = 0.8410 fm
```

Dual route identity: T_F/(d₃ × σD) = 1/d₄² because 2 × d₃ × σD = d₄² = 576.

Three-body bounds bracket the measurement:
- r_MAX = C_F × N_c × ℏ/(m_p c) — confinement ceiling
- r_MIN = (C_F × N_c − 1/(d₄²−1)) × ℏ/(m_p c) — asymptotic freedom floor

No time evolution. No VEV dependence. Dimensionless ratio × Compton wavelength.

## 11 Prove Functions

| # | Function | What |
|---|----------|------|
| 1 | prove_protonRadius_base | C_F × N_c = 4 (base, no correction) |
| 2 | prove_protonRadius | Full formula, Δ/unc < 1 for both muonic and CODATA |
| 3 | prove_dualRoute_d4sq | 2 × d₃ × σD = d₄² = 576 |
| 4 | prove_protonRadius_dualRoute | Same r_p via 1/d₄² route |
| 5 | prove_protonRadius_rMax | Confinement ceiling above measurements |
| 6 | prove_protonRadius_rMin | AF floor below measurements |
| 7 | prove_protonRadius_band | Band width < 1% of r_max |
| 8 | prove_protonRadius_suppression | Correction/base < 1% (perturbative) |
| 9 | prove_protonRadius_sign | Correction negative (AF shrinks bound state) |
| 10 | prove_protonRadius_rational | 1/576 is rational (gauge-sector split) |
| 11 | prove_protonRadius_ncScaling | N_c=3 tighter than N_c=2 |

## Compile

```bash
ghc -O2 -main-is CrystalProtonRadius CrystalProtonRadius.hs && ./CrystalProtonRadius
```

## Import Chain

CrystalAtoms (qualified as CE, uses CE.nW and CE.nC only).
Refactored: was CrystalEngine.

## Proofs

| Proof file | Theorems | Method |
|------------|----------|--------|
| CrystalProtonRadius.agda | 27 | refl |
| CrystalProtonRadius.lean | 31 | native_decide |
