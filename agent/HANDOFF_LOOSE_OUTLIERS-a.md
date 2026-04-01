<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# HANDOFF: Five LOOSE Outliers — a₄ Correction Targets

## STATUS

Session completed. VEV repair done. Four-column table working.
34/34 Haskell PASS. 198 observables, 0 wall breaches.

Five observables are LOOSE (1–1.4% PWI). These need a₄ corrections
following the same pattern as Session 8 (m_Υ, m_D, m_ρ, m_φ, Ω_DM, sin²θ₁₃).

## THE FIVE LOOSE OUTLIERS

| # | Observable | Formula | CrystalPdg | Expt | PWI | Notes |
|---|-----------|---------|-----------|------|-----|-------|
| 1 | m_omega (MeV) | m_π×χ(Σd−1)/Σd (= m_rho) | 793.44 | 782.70 | 1.372% | BUG: uses uncorrected rho |
| 2 | m_η (MeV) | Λ/√N_c | 555.29 | 547.86 | 1.357% | Needs new correction |
| 3 | M_Z (GeV) | 3v/8 | 92.33 | 91.19 | 1.256% | Needs new correction |
| 4 | Δm_dec (MeV) | m_s×κ | 148.76 | 147.00 | 1.197% | Needs new correction |
| 5 | m_μ (MeV) | v/2^(2χ−1)×8/9 | 106.87 | 105.66 | 1.144% | Needs new correction |

All five overshoot experiment. All corrections will be NEGATIVE.

## FIX #1: m_omega (BUG — immediate)

m_omega's formula comment says `(= m_rho)` but uses the UNCORRECTED
rho formula `m_π × χ(Σd−1)/Σd = m_π × 35/6`. The corrected rho is
`m_π × 23/4` (with the `−T_F/χ = −1/12` correction from Session 8).

If omega = rho, it should use the corrected formula. This is a one-line
fix in CrystalGauge.hs or wherever proveOmegaMeson is defined.

Check: does omega physically equal rho? The ω(782) and ρ(775) are
different particles. Their formulas might legitimately differ. If omega
needs its OWN correction (not just copying rho's), derive it fresh.

**File:** `haskel/CrystalQCD.hs` — find `proveOmegaMeson`
**Action:** Either use corrected rho formula, or derive omega's own a₄ correction.

## FIXES #2–5: New a₄ Corrections (derivation needed)

Each correction follows the Session 8 pattern:

```
corrected = base × (1 − X/(channel × Σd² × D))
```

or equivalently:

```
corrected_multiplier = base_multiplier − rational_correction
```

### Requirements for each correction:

1. **Rational fraction** from A_F atoms only (N_w, N_c, dᵢ, Σd, χ, D, gauss, β₀)
2. **Negative sign** (all five overshoot → correction shrinks)
3. **Dual route** — two independent A_F derivations giving same number
4. **Perturbative** — correction < 3% of base
5. **Channel** — which gauge sector (Colour, Weak, Mixed, Full)

### Diagnostic: what correction is needed?

For each, compute: needed = (CrystalPdg − Expt) / Λ_h or / m_π

| Observable | CrystalPdg | Expt | Overshoot | Overshoot/Λ_h |
|-----------|-----------|------|----------|--------------|
| m_η | 555.29 | 547.86 | 7.43 MeV | 7.43/961.80 = 0.00773 ≈ 1/129 |
| M_Z | 92332.5 | 91187.6 | 1144.9 MeV | 1144.9/961.80 = 1.190 ≈ ? |
| Δm_dec | 148.76 | 147.00 | 1.76 MeV | 1.76/961.80 = 0.00183 ≈ 1/547 |
| m_μ | 106.87 | 105.66 | 1.21 MeV | 1.21/961.80 = 0.00126 ≈ 1/794 |

Note: M_Z = 3v/8 is special — it's directly proportional to v, so the
CrystalPdg value IS the PDG VEV divided by 8/3. The 1.256% residual
means the formula `3v/8` itself is off. This one may need a different
approach — the correction lives in the electroweak sector, not QCD.

### Candidates to investigate (from A_F atoms):

For m_η (need ≈ 1/129):
- 1/gauss² = 1/169? No, too small.
- 1/(gauss×(chi−1)×N_w) = 1/(13×5×2) = 1/130 ✓ CLOSE
- This is the SAME fraction as Ω_DM correction! Check dual route.

For M_Z (need ≈ 1.19 × Λ_h correction on v×3/8):
- Different structure — M_Z = v × N_c/(N_c²−1). Correction lives
  in the v→M_Z projection, not in a Λ_h multiplier.
- Try: M_Z = v × (N_c/(N_c²−1) − X) where X is from A_F.
- Needed X ≈ 0.00474 of v. That's 0.00474 ≈ ?
- N_w/(d₃×Σd) = 2/288 = 1/144 = 0.00694? Too big.
- 1/(N_c×Σd²) = 1/1950? Too small.
- This is the hardest one. May need two-step correction.

For Δm_dec (need ≈ 1/547):
- Δm = m_s × κ. Correction on κ or on m_s?
- 1/(d₃×Σd) = 1/288 × something?
- Need more investigation.

For m_μ (need ≈ 1/794):
- m_μ = v/2^(2χ−1) × d₃/N_c². Correction on which factor?
- 1/(d₃×Σd²) = 1/(8×650) = 1/5200? Too small.
- κ/(chi×Σd²) = 1.585/(6×650) = 1/2461? Too small.
- Need to investigate the lepton mass formula's structure.

## THE PATTERN (from Session 8)

Every successful correction so far:

| Observable | Base mult | Correction | Corrected | Dual route identity |
|-----------|----------|-----------|----------|-------------------|
| m_Υ | 10 | −1/8 | 79/8 | N_c³/(χ·Σd) = N_c²/(N_w·Σd) |
| m_D | 2 | −7/144 | 281/144 | D/(d₄·Σd) = 1/d₄ + χ/(d₄·Σd) |
| m_ρ | 35/6 | −1/12 | 23/4 | T_F/χ = N_c/Σd |
| m_φ | 13/12 | −1/54 | 115/108 | N_w/(N_c·Σd) = (d₄−d₃)/(d₄·Σd) |
| Ω_DM | 309/1159 | −1/130 | corrected | 1/(gauss·(gauss−N_c)) = 1/(N_w·(χ−1)·gauss) |
| sin²θ₁₃ | 1/45 | −1/4500 | 11/500 | (D+d_w)·N_w²·(χ−1)² |

Common features:
- Denominator always factors into A_F atoms
- Dual route uses an algebraic identity between A_F invariants
- Sign always negative (crystal overshoots, correction shrinks)
- Correction is perturbative (< 3%)

## FILES TO MODIFY

### For m_omega bug fix:
- `haskel/CrystalQCD.hs` — `proveOmegaMeson` (use corrected formula)

### For new a₄ corrections:
- `haskel/CrystalHierarchy.hs` — add 4 new implosions + dual routes
- `haskel/CrystalQCD.hs` — add corrected prove functions
- `haskel/CrystalGauge.hs` — if M_Z correction lives there
- `haskel/CrystalFullTest.hs` — may need to use corrected versions
- `haskel/Main.hs` — same

### Export pattern (follow Session 8):
```haskell
-- In CrystalHierarchy.hs exports:
, etaImplosion, etaDualRoute
, mzImplosion, mzDualRoute
, decupletImplosion, decupletDualRoute
, muonImplosion, muonDualRoute
```

## RUST + PYTHON VEV DAMAGE (not fixed this session)

31 files hardcode 246.22 or 246220:

### Rust (5 files):
- `crystal-topos/src/base.rs` — lines 285, 299, 305, 377. Core source.
- `crystal-topos/tests/crystal_tests.rs` — lines 449, 466
- `crystal-topos/tests/crystal_fundamentals_tests.rs` — lines 22, 163, 172
- `crystal-topos/tests/crystal_protein_tests.rs` — line 36
- `crystal-topos/tests/crystal_layer_tests.rs` — lines 27, 134

### Python (26 example files):
All `crystal-topos/examples/*.py` that use `v_mev = 246220.0`

### Fix pattern (same as Haskell):
- Derive v from M_Pl in a single source function
- Default = crystal derived (245.17)
- PDG available for gap analysis
- Tests assert against CrystalPdg, not Crystal directly

### Priority:
- `base.rs` first — it's the Rust source, everything else imports from it
- Then tests
- Then Python examples (lowest priority, they're demos)

## WHAT NOT TO TOUCH

- `v_mev = 246220.0` in CrystalWACAScan.hs — stays until full recalibration
- `pdg 246.22` in Derived records — those are comparison targets, correct
- The four-column architecture — working, do not revert
- CrystalVEV.hs — clean, standalone module
- Any file outside haskel/ — not priority

## CURRENT STATE OF REPO

- Branch: master at c5d4715 + local changes (not pushed)
- 15 files modified this session (including new CrystalVEV.hs)
- CrystalVEVTest.hs deleted (redundant)
- 34/34 Haskell PASS
- 198 observables, 0 wall breaches, 5 LOOSE, CV = 0.953

## VEV ARCHITECTURE (do not forget)

- `Toe()` = crystal derived VEV = 245.17 GeV (default, ground truth)
- `Toe(vev="pdg")` = 246.22 GeV (for gap analysis only)
- Four-column table: Crystal | CrystalPdg | Expt | PWI
- PWI = |Expt − CrystalPdg| / Expt (NEVER Crystal vs Expt)
- Two calls, same formulas, different Ruler (pdgRuler)
- 1.004 conversion factor is explanatory, never applied
- See README_VEV.md for full documentation
