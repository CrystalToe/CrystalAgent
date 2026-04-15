<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalAudit — Naturality, Solver, Kill Tests from (2,3)

## What This Module Does

CrystalAudit proves that mixing angles and quark mass ratios are not free
parameters — they are forced by the 650 endomorphisms of A_F acting as
naturality constraints. If the naturality squares commute for all 650
endomorphisms simultaneously, there is exactly ONE solution.

Three main results:
1. **7 mixing angles** (V_us, sin²θ₂₃, sin²θ₁₃, V_cb, J, δ_CKM, δ_PMNS) — each forced by a specific subset of the 650 endomorphisms
2. **6 mass ratios** (m_s/m_ud, m_c/m_s, m_b/m_s, m_b/m_c, m_t/m_b, m_u/m_d) — forced by Clebsch-Gordan coefficients of the sector decomposition
3. **The No Free Parameters theorem** — all 13 are forced simultaneously, uniquely

Also: acid tests (solver), kill tests (falsifiability), frontiers (open problems),
and a boundary ledger (what's proved vs assumed).

## Key Naturality Values

| Observable | Value | From (2,3) |
|-----------|-------|------------|
| \|V_us\| | 9/40 | N_c²/(σD + N_w²) |
| sin²θ₂₃ | 6/11 | χ/(2χ−1) |
| sin²θ₁₃ | 1/45 | 1/(σD + N_c²) |
| m_s/m_ud | 27 | N_c³ |
| m_b/m_s | 54 | N_c³ × N_w |
| m_u/m_d | 5/11 | (χ−1)/(2χ−1) |

## Contents (643 lines)

| Section | What |
|---------|------|
| §11b | 7 mixing naturality constraints + uniqueness test |
| §11b2 | 6 mass ratio naturality constraints + uniqueness test |
| §11b3 | No free parameters theorem + mass-mixing duality |
| §11c | Solver: derive angles from endomorphism counts |
| Kill tests | 6 falsifiable predictions |
| Frontiers | Open problems and boundaries |
| Ledger | Proof status of every claim |

## Compile

```bash
ghc -c CrystalAudit.hs
```

No main. Type-check only. Used by Main.hs.

## Import Chain

CrystalAxiom + Data.Ratio only. Zero CrystalEngine. Already clean.

## Proofs

| Proof file | Theorems | Method |
|------------|----------|--------|
| CrystalAudit.agda | 14 | refl |
| CrystalAudit.lean | 15 | native_decide |

Proves: naturality denominators (40, 11, 45), endomorphism counts (576, 650),
mass ratio integers (27, 54, 5/11), tower=42, σD=36, χ²=σD.
