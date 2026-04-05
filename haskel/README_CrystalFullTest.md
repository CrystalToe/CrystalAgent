<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# README_CrystalFullTest.md

## Module: CrystalFullTest — Full Regression Test (Phase 5 Rewrite)

**Status:** Phase 5 final task — COMPLETE  
**Lines:** ~625  
**Observables tested:** 198  
**Dynamics tests:** 28  
**Bespoke integrators:** ZERO  

---

## Compile & Run

```bash
cd haskel
ghc -O2 -Wno-x-partial -main-is CrystalFullTest CrystalFullTest.hs && ./CrystalFullTest
```

---

## WHAT THIS MODULE DOES

CrystalFullTest is the final gate. It runs two independent test suites:

1. **198 observable regression** — the four-column gap analysis (unchanged from pre-refactor, except import fix)
2. **28 dynamics regression** — verifies the component stack that all 15 dynamics modules depend on

If both pass, Phase 5 is complete and the codebase is clean.

---

## WHAT CHANGED IN THE REWRITE

### `import CrystalGravity` — REMOVED

Phase 5 replaced `CrystalGravity.hs` with a dynamics module (pack→tick→unpack). The old `CrystalGravity.hs` was a proof module that exported `proveImmirzi` and `proveBHEntropy`. Those functions no longer exist there.

### `proveImmirzi` and `proveBHEntropy` — INLINED

Same formulas. Same integers. Moved into CrystalFullTest §1a. They use `CrystalAxiom.nW`, `CrystalAxiom.nC`, etc. directly (Integer type, matching `crFromInts`).

```haskell
-- Immirzi parameter: (3/13)/(35/36) = 108/455
proveImmirzi c =
  let sw = crFromInts c nC (nW^2 + nC^2)       -- 3/13
      z  = crFromInts c (sigmaD - 1) sigmaD     -- 35/36
  in Derived "Immirzi γ" ... (lqg 0.23753) Computed

-- BH entropy: (β₀²/N_w⁴)/π = 49/(16π)
proveBHEntropy c =
  let coef = crFromInts c (beta0^2) (nW^4)      -- 49/16
  in Derived "S_BH (nats)" ... (pdg 0.975) Computed
```

### `import qualified CrystalAtoms as CA`

CrystalAxiom exports `nW :: Integer`. CrystalAtoms exports `nW :: Int`. Both in scope → collision. CrystalAtoms is qualified as `CA` to resolve.

### §8 Dynamics Regression — ADDED

28 tests verifying the component stack that all 15 dynamics modules use:

| Test group | Count | What |
|------------|-------|------|
| Component atoms | 11 | nW=2, nC=3, χ=6, β₀=7, d₁..d₄, Σd=36, D=42, gauss=13 |
| Eigenvalues | 5 | λ₀=1, λ₁=½, λ₂=⅓, λ₃=⅙, λ_mixed=λ_weak×λ_colour |
| W∘U factorisation | 1 | applyW(applyU(s)) = tick(s) |
| Singlet conservation | 1 | λ₀=1 → singlet unchanged |
| Norm contraction | 1 | normSq(tick s) < normSq(s) |
| Sector isolation | 2 | tick on weak-only leaves other sectors at 0 |
| Pack/unpack round-trip | 2 | extractSector(injectSector(vals)) = vals |
| Denominator product | 1 | 1×N_w×N_c×χ = 36 = Σd |
| wK/uK half-steps | 4 | wK values, wK×uK = λ |

---

## THE FOUR-COLUMN TABLE (198 Observables)

```
Crystal    = Toe()           → formula(standardRuler) → crystal VEV 245.17
CrystalPdg = Toe(vev="pdg") → formula(pdgRuler)      → PDG VEV 246.22
Expt       = experimental value
PWI        = |Expt − CrystalPdg| / Expt  (scheme noise REMOVED)
```

Two calls. Same formulas. Different VEV. The PWI tests formula accuracy, not scheme choice.

### Sources

| Source | Count | Description |
|--------|-------|-------------|
| Original | 92 | CrystalGauge, Mixing, Cosmo, QCD, CrossDomain — called with both rulers |
| Extended | 103 | CrystalWACAScan — PDG VEV internally |
| S4-S6 | 3 | CrystalAlphaProton, CrystalProtonRadius — CODATA precision |
| **Total** | **198** | |

### Rating Scale

| Symbol | Name | PWI Range |
|--------|------|-----------|
| ■ | EXACT | 0% |
| ● | TIGHT | < 0.5% |
| ◐ | GOOD | < 1.0% |
| ○ | LOOSE | < 4.5% |
| ✗ | OVER | ≥ 4.5% |

### Pass Criteria

- Zero wall breaches (PWI < 4.5% for all 198)
- CV < 1.0 (Shannon-optimal)
- All 28 dynamics tests pass

---

## IMPORT STRUCTURE

```haskell
-- Observable proof modules (Phases 1-4, unchanged)
import CrystalAxiom
import CrystalGauge
import CrystalMixing
import CrystalCosmo
import CrystalQCD
import CrystalCrossDomain
import qualified CrystalWACAScan as WS
import qualified CrystalAlphaProton as AP
import qualified CrystalProtonRadius as PR

-- import CrystalGravity   ← REMOVED (now dynamics module)

-- Component stack (Phase 5, for dynamics regression)
import qualified CrystalAtoms as CA
import CrystalSectors (CrystalState, extractSector, injectSector, zeroState)
import CrystalEigen (lambda, wK, uK)
import CrystalOperators (tick, applyW, applyU, normSq)
```

---

## OUTPUT SECTIONS

```
§1  VEV values (Toe() vs Toe(vev="pdg"))
§2  Count verification (92 + 103 + 3 = 198)
§3  Rating legend
§4  Four-column table (all 198 observables)
§5  Combined statistics (mean PWI, CV, max, wall breaches)
§6  Scheme noise diagnostic (v-dependent vs dimensionless)
§7  CV target check
§8  Top 5 outliers
§9  Dynamics regression (28 component stack tests)
§10 Final verdict (PASS/FAIL)
```

---

## EXPECTED OUTPUT (final lines)

```
══ §9 DYNAMICS REGRESSION (Phase 5: Component Stack) ══
  The dynamics IS the tick on the 36. O(1) per site.
  ...
  PASS  nW = 2
  PASS  nC = 3
  PASS  chi = 6
  ...
  PASS  wK * uK = lambda
  
  Dynamics: 28/28 PASS
  All dynamics tests pass. Component stack verified.

════════════════════════════════════════════════════════════
  RESULT: ALL 198 OBSERVABLES PASS + 28/28 DYNAMICS TESTS PASS
  Phase 5 complete. CrystalGravity → dynamics. Component stack verified.
════════════════════════════════════════════════════════════
```

---

## PHASE 5 — COMPLETE

| Phase | What | Status |
|-------|------|--------|
| Phase 1 (Quantum) | 7 swapped + 4 deprecated | ✅ |
| Phase 2 (Misc Standalone) | 7 swapped + 4 deprecated | ✅ |
| Phase 3 (Axiom-only) | 3 files already clean | ✅ |
| Phase 4 (Orchestrators) | Main.hs CrossDomain→Universal | ✅ |
| Phase 5 (Dynamics) | 15 modules + CrystalFullTest rewrite | ✅ |

All dynamics through the 36. Zero bespoke integrators. O(1) per site.
