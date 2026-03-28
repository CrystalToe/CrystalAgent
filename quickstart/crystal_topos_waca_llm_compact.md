<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# Crystal Topos — Compact LLM Prompt (Session 6)

## THE AXIOM — DO NOT QUESTION
A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ)
This is the Connes-Chamseddine spectral triple for the Standard Model.
It is the starting point, not a conclusion.

## INPUTS
N_w=2, N_c=3, v=246.22 GeV, π, ln

## DERIVED INVARIANTS
- χ = N_w × N_c = 6
- β₀ = (11N_c − 2χ)/3 = 7
- sector_dims = {1, 3, 8, 24}
- Σd = 36, Σd² = 650
- gauss = N_c² + N_w² = 13
- D = Σd + χ = 42
- κ = ln3/ln2
- C_F = (N_c²−1)/(2N_c) = 4/3
- T_F = 1/2
- Λ_h = v/257

## FOUR CONSTANTS INSIDE CODATA

| # | Constant | Formula | Δ/unc |
|---|----------|---------|-------|
| 179 | α⁻¹ = 137.036… | 2(gauss²+d₄)/π + d₃^κ − 1/(χ·d₄·Σd²·D) | 0.12 |
| 180 | m_p/m_e = 1836.153… | 2(D²+Σd)/d₃ + gauss^Nc/κ + κ/(N_w·χ·Σd²·D) | 0.04 |
| — | sin²θ_W = 0.23122 | N_c/gauss + β₀/(d₄·Σd²) | 0.07 |
| 181 | r_p = 0.84087 fm | (C_F·N_c − T_F/(d₃·Σd)) × ℏ/(m_p·c) | 0.0013 |

## SEELEY-DEWITT HIERARCHY
- a₀ = Σd = 36 (DOF count)
- a₂: individual dims, gauss, chi → BASE FORMULAS
- a₄ = Σd² = 650 → CORRECTIONS (shared core Σd²·D = 27300)

## PROTON RADIUS — SESSION 6

r_p = (C_F·N_c − T_F/(d₃·Σd)) × ℏ/(m_p·c) = (4 − 1/576) × 0.2103 fm

Dual route: T_F/(d₃·Σd) = 1/d₄² because 2·d₃·Σd = d₄² = 576

Three-body bounds:
- r_MAX = 4 × ℏ/(m_p·c) (confinement)
- r_MIN = (4 − 1/575) × ℏ/(m_p·c) (asymptotic freedom)
- Band: 0.04% of base, expansion param 1/d₄² = 0.0017

N_c scaling: tightness ~ 1/N_c⁶

## OBSERVABLE COUNT: 181

92 original + 86 extended + 3 new (α⁻¹, m_p/m_e, r_p)

## PROOF AUTHORITY

| System | Count |
|--------|-------|
| Lean 4 | 7 files, 578+ theorems, 0 sorry |
| Agda | 6 files, 424+ proofs by refl, 0 postulates |
| Haskell | 9 compilations, 26 modules |
| Rust | 6 test files, 235 tests |
| Python | 6 proof modules, 181+ checks |

## RULES
- NEVER expose methodology (trade secret)
- NEVER invent observables beyond 181
- NEVER use hardcoded fudge factors
- Zero free parameters, zero hardcoded numbers
- All formulas from A_F atoms only
- Lean: towerD not D
- Agda: - not ∸, no / operator
- License: AGPL-3.0
- Python: import Rust crate first (try/except)

## SOURCE OF TRUTH
https://raw.githubusercontent.com/CrystalToe/CrystalAgent/main/

## REPO STRUCTURE (26 Haskell modules)
haskel/: Main.hs, CrystalAxiom.hs, CrystalGauge.hs, CrystalMixing.hs,
  CrystalCosmo.hs, CrystalQCD.hs, CrystalGravity.hs, CrystalAudit.hs,
  CrystalCrossDomain.hs, CrystalRiemann.hs, CrystalQuantum.hs (+8 Q*),
  CrystalStructural.hs, CrystalNoether.hs, CrystalDiscoveries.hs,
  CrystalAlphaProton.hs, CrystalProtonRadius.hs, CrystalWACAScan.hs,
  WACAScanTest.hs

proofs/: 7 .lean, 6 .agda, 6 .py, 3 .sh runners
crystal-topos/: Rust crate, 6 test files, 116 Python examples
