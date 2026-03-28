<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CHANGELOG — Crystal Topos

## Session 6 — March 29, 2026

### Observable #181: Proton Charge Radius
- **Formula:** `r_p = (C_F·N_c − T_F/(d₃·Σd)) × ℏ/(m_p·c)`
- **Value:** 0.8408705 fm
- **Target:** 0.84087 ± 0.00039 fm (muonic hydrogen)
- **Δ/unc:** 0.0013 — DEEP INSIDE CODATA

### Dual Route Identity
- `T_F/(d₃·Σd) = 1/d₄²` because `2·d₃·Σd = d₄² = 576`
- Two independent derivations yield the same correction

### Three-Body Bounds
- **r_MAX** = `C_F·N_c × ℏ/(m_p·c)` = 0.8412 fm (confinement ceiling)
- **r_MIN** = `(C_F·N_c − 1/(d₄²−1)) × ℏ/(m_p·c)` = 0.8409 fm (AF floor)
- Band width: 3.66 × 10⁻⁴ fm (0.04% of base)
- Expansion parameter: `1/d₄² = 1/576 ≈ 0.0017`

### N_c Scaling
- Tightness ~ 1/N_c⁶: N_c=2 marginal (2.8%), N_c=3 tight (0.17%), N_c→∞ exact
- Reproduces large-N_c (ʼt Hooft) limit: baryons become classical

### Perturbation Analysis
- All atoms shared with other constants (α⁻¹, m_p/m_e, sin²θ_W)
- Deforming any atom by >0.04% breaks other observables
- r_p fully determined: zero degrees of freedom

### New Files
- `haskel/CrystalProtonRadius.hs` — 11 prove functions
- `proofs/CrystalProtonRadius.lean` — 25 theorems (zero sorry)
- `proofs/CrystalProtonRadius.agda` — 24 proofs by refl (zero postulates)
- `crystal-topos/tests/crystal_proton_radius_tests.rs` — 30 tests
- `proofs/crystal_proton_radius_proof.py` — 36 checks

### Proof Status After Session 6

| System | Files | Result |
|--------|-------|--------|
| Lean 4 | 7 (.lean) | 7/7 PASS |
| Agda | 6 (.agda) | 6/6 PASS |
| Haskell/GHC | 5 standalone + Main + Extended | 9/9 PASS |
| Rust | 6 test files | 235 tests |
| Python | 6 proof modules | 182+ PASS |

### Crystal Status
- **Constants inside CODATA: 4** (α⁻¹, m_p/m_e, sin²θ_W, r_p)
- **Observable count: 181**

---

## Session 5 — March 2026

### Three Constants Inside CODATA
- α⁻¹ = 137.0359990814, Δ/unc = 0.12
- m_p/m_e = 1836.1526734346, Δ/unc = 0.04
- sin²θ_W = 0.23121795, Δ/unc = 0.07

### a₄ Seeley-DeWitt Corrections
- Shared core: Σd²·D = 650·42 = 27300
- Dual derivation: heat kernel + one-loop RG
- Gauge-sector split preserved: couplings rational, mass ratios transcendental

### Repo Maintenance
- sync_check.sh, CHANGELOG created
- Observable count: 180

---

## Session 4 — March 2026

### SINDy Discovery
- #179: α⁻¹ base formula via SINDy scan
- #180: m_p/m_e base formula via SINDy scan
- Observable count: 180

---

## Session 3 — March 2026

### Extended Scan
- 86 extended observables (CrystalWACAScan.hs)
- Observable count: 178

---

## Session 2 — March 2026

### Proof Infrastructure
- Lean, Agda, Python proof modules added
- Cross-domain bridges

---

## Session 1 — March 2026

### Foundation
- 92 original observables (Main.hs)
- Rust crate + Python bindings
- CrystalAxiom.hs established
