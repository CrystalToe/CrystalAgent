# SESSION_HANDOFF_REFACTOR.md

## Status: ACTIVE — Gradual Codebase Refactoring

Last updated: 2026-04-04 (end of day)

## What This Is

The CrystalAgent codebase (~29,000 lines, ~89 Haskell modules) grew organically.
The 12-component architecture exists in the READMEs but not in the file tree.
This refactoring makes the files match the architecture: one file, one component.

**Design principle**: Parallel design (expand → migrate → contract).
Old files stay untouched. New files live alongside. Both compile. Both run.
Nothing is removed until the new path is proven.

## The Single Input Rule

The entire system has ONE optional input: VEV = 246.22 GeV (PDG) or
VEV = 245.17 GeV (Crystal-derived from M_Pl). Everything else is derived
from N_w = 2 and N_c = 3. No parameters. No choices.

## Dependency Chain

```
CrystalAtoms.hs            ← Component 2  (root, imports nothing)
    |
    +-- CrystalSectors.hs   ← Component 3  (state type, sector structure)
    |
    +-- CrystalEigen.hs     ← Component 4  (eigenvalues, W/U half-steps)
    |
CrystalOperators.hs         ← Component 5  (W, U, D_F, J, gamma)
    |
CrystalDynamicEngine.hs     ← Component 10 (tick, HMC, MERA sweep)
    |
CrystalTower.hs             ← Component 6  (42 layers, running alpha, VEV)
    |
CrystalImplosion.hs         ← Component 9  (channels, dual routes, a_4 corrections)
    |
CrystalCorrections.hs       ← Component 8  (7 levels, decision tree, one-loop factor)
    |
ObservableType.hs            ← Shared Obs type, VEV, formatting (imports Atoms + Corrections)
    |
Observable*.hs (×10)         ← Component 7  (157 production observables)
    |
ObservableAll.hs             ← Combined runner (calls all 10 modules)
```

## Four-Column Architecture

Every Observable module uses the same shared pattern from ObservableType.hs:

```haskell
type Formula = Double -> Double    -- takes VEV, returns value

mk :: String -> String -> Formula -> Double -> CLevel -> Obs
mk name formula f expt level = Obs name formula (f vCrystal) (f vPdg) expt level
```

- **Crystal** = f(v_crystal) where v_crystal = 245.17 GeV (derived from M_Pl)
- **CrystalPdg** = f(v_pdg) where v_pdg = 246.22 GeV (PDG experimental)
- **Shift** = |CrystalPdg - Crystal| / Crystal (VEV scheme noise, 0% for dimensionless)
- **Gap** = |Expt - CrystalPdg| / Expt (formula accuracy, Status follows this)
- **Status** = EXACT/TIGHT/GOOD/LOOSE/OVER based on Gap

## Correction Rules (CRITICAL — caused 3 bugs this session)

1. A correction applies ONLY to the specific observable it was derived for
2. Downstream formulas use the UNCORRECTED base
3. Examples:
   - M_Z implosion (v×637/1720) → M_Z mass only. M_W uses v×3/8
   - m_ν3 correction (×10/11) → m_ν3 mass only. ρ_Λ uses tree m_ν1 = v/(2^42×36)
   - m_e muon chain → m_e observable. Nuclear binding uses WACAScan m_e = v/(257×1872)
   - Mass chain (m_t→m_b→m_c→m_s) for quark masses, NOT Lambda_h/10

## Completed Modules

### Core Components (8)

| Module | Component | Tests | Agda | Lean | README |
|--------|-----------|-------|------|------|--------|
| CrystalAtoms.hs | 2. Blocks | 26 PASS | 44 refl | 56 nd | Yes |
| CrystalSectors.hs | 3. Sectors | 24 PASS | 24 refl | 25 nd | Yes |
| CrystalEigen.hs | 4. Eigenvalues | 15 PASS | 15 refl | 15 nd | Yes |
| CrystalOperators.hs | 5. Operators | 21 PASS | 45 refl | 70 nd | Yes |
| CrystalDynamicEngine.hs | 10. Dynamics | 26 PASS | 44 refl | 49 nd | Yes |
| CrystalTower.hs | 6. Tower | 32 PASS | 28 refl | 23 nd | Yes |
| CrystalImplosion.hs | 9. Implosion | 42 PASS | 35 refl | 30 nd | Yes |
| CrystalCorrections.hs | 8. Corrections | 28 PASS | 18 refl | 15 nd | Yes |

### Observable Infrastructure (1)

| Module | Role | Agda | Lean | README |
|--------|------|------|------|--------|
| ObservableType.hs | Shared Obs, Formula, mk, formatting | 5 refl | 5 nd | Yes |

### Observable Modules (10, Component 7)

| Module | Obs | Domain | Agda | Lean | README |
|--------|-----|--------|------|------|--------|
| ObservableMixing.hs | 13 | CKM, PMNS, Weinberg | 30 refl | 22 nd | Yes |
| ObservableGauge.hs | 16 | α⁻¹, M_Z, M_W, widths | 27 refl | 21 nd | Yes |
| ObservableMass.hs | 31 | ratios, hadrons, leptons, quarks, m_p/m_e | 32 refl | 24 nd | Yes |
| ObservableCosmo.hs | 17 | Ω_Λ, CMB, neutrinos, ρ_Λ | 21 refl | 18 nd | Yes |
| ObservableNuclear.hs | 18 | magic numbers, binding, moments, R_p | 24 refl | 20 nd | Yes |
| ObservableBio.hs | 20 | genetics, folding, chemistry | 19 refl | 12 nd | Yes |
| ObservableCondensed.hs | 15 | BCS, Ising, thermo, chaos | 18 refl | 14 nd | Yes |
| ObservableFluid.hs | 11 | Kolmogorov, Reynolds, Rayleigh | 12 refl | 10 nd | Yes |
| ObservableOptics.hs | 3 | n_water, n_glass, n_diamond | 6 refl | 5 nd | Yes |
| ObservableMath.hs | 13 | e, φ, √2, ζ(3), Basel | 10 refl | 8 nd | Yes |
| **TOTAL** | **157** | | | | |

### Combined Runner (1)

| Module | Role | README |
|--------|------|--------|
| ObservableAll.hs | Runs all 10 modules, prints grand total | Yes |

### Verification Module (1)

| Module | Obs | Role | Agda | Lean | README |
|--------|-----|------|------|------|--------|
| ObservableAlphaProton.hs | 9 | 4 routes to α⁻¹, 3 to m_p/m_e | 12 refl | 11 nd | Yes |

### Structural Proof Modules (refactored imports, no new observables)

| Module | Lines | Proofs | Agda | Lean | README |
|--------|-------|--------|------|------|--------|
| CrystalMandelbrot.hs | 384 | 38 | — | — | — |
| CrystalProtein.hs | 743 | 73 | 14 refl | 14 nd | Yes |
| CrystalFold.hs | 503 | sim | 10 refl | 6 nd | Yes |
| CrystalNoether.hs | 147 | 18 | 14 refl | 14 nd | Yes |

## Deprecated Files (safe to retire, old path still compiles)

### Root / Type System (replaced by CrystalAtoms)
- CrystalEngine.hs, CrystalAxiom.hs

### Dynamics (replaced by CrystalDynamicEngine + CrystalTower)
- CrystalHMC.hs, CrystalLayer.hs, CrystalMERA.hs, CrystalHierarchy.hs, CrystalDirac.hs, CrystalVEV.hs

### Observable Producers (replaced by Observable*.hs)
- CrystalGauge.hs (309), CrystalMixing.hs (216), CrystalQCD.hs (1284)
- CrystalCosmo.hs (483), CrystalWACAScan.hs (2083), CrystalCrossDomain.hs (251)
- CrystalNuclear.hs (327), CrystalBio.hs (315), CrystalCondensed.hs (315)
- CrystalOptics.hs, CrystalAlphaProton.hs

## What's Next

### 1. Dynamics (15 files, ~6,800 lines) — NEXT SESSION

| File | Lines | Domain |
|------|-------|--------|
| CrystalGravity.hs | 427 | gravity |
| CrystalGravityDyn.hs | 277 | gravity dynamics |
| CrystalGR.hs | 573 | general relativity |
| CrystalGW.hs | 489 | gravitational waves |
| CrystalFriedmann.hs | 405 | Friedmann equations |
| CrystalNBody.hs | 553 | N-body simulation |
| CrystalMD.hs | 400 | molecular dynamics |
| CrystalCFD.hs | 503 | computational fluid dynamics |
| CrystalPlasma.hs | 448 | plasma physics |
| CrystalDiffusion.hs | 405 | diffusion |
| CrystalEM.hs | 422 | electromagnetism |
| CrystalSchrodinger.hs | 484 | Schrödinger equation |
| CrystalClassical.hs | 527 | classical mechanics |
| CrystalThermo.hs | 447 | thermodynamics |
| CrystalRigid.hs | 450 | rigid body |

All import CrystalEngine → need CrystalAtoms swap + possible multi-import split.

### 2. Quantum (11 files, ~3,230 lines)

CrystalQuantum, QBase, QGates, QChannels, QEntangle, QInfo, QMeasure, QSimulation, QAlgorithms, QHamiltonians, QFT. Import swaps only.

### 3. Main.hs Update

Point orchestrator at new modules. Verify old and new produce identical output.

### 4. The 157→198 Gap

43 observables from Main.hs not yet in Observable modules:
- Heavy hadrons (B_c, B_s, Λ_b, Ξ_c, Σ_c, Ω_c, D_s, ψ(2S), Υ(2S), η_c, Δ(1232), Ξ)
- MS-bar pole masses (m_b, m_c)
- Cross-domain extras (σ_πN, m_n−m_p, π±−π⁰, hadronic VP, f_K/f_π)
- Cosmo extras (N_eff, Ω_b/Ω_m, Y_p, sin²θ_W running)

Each is just another `mk` entry in an existing module. No new modules needed.

### 5. Rust/WASM Port

Production architecture to port: ObservableType + 10 Observable modules + CrystalAtoms + CrystalImplosion + CrystalCorrections ≈ 2,000 lines. Pure functions, no IO. Direct Rust translation.

## Compile Commands

```bash
# Core modules
ghc -O2 -main-is CrystalAtoms CrystalAtoms.hs && ./CrystalAtoms
ghc -O2 -main-is CrystalSectors CrystalSectors.hs && ./CrystalSectors
ghc -O2 -main-is CrystalEigen CrystalEigen.hs && ./CrystalEigen
ghc -O2 -main-is CrystalOperators CrystalOperators.hs && ./CrystalOperators
ghc -O2 -main-is CrystalDynamicEngine CrystalDynamicEngine.hs && ./CrystalDynamicEngine
ghc -O2 -main-is CrystalTower CrystalTower.hs && ./CrystalTower

# Observable modules
ghc -O2 -main-is ObservableMixing ObservableMixing.hs && ./ObservableMixing
ghc -O2 -main-is ObservableGauge ObservableGauge.hs && ./ObservableGauge
ghc -O2 -main-is ObservableMass ObservableMass.hs && ./ObservableMass
ghc -O2 -main-is ObservableCosmo ObservableCosmo.hs && ./ObservableCosmo
ghc -O2 -main-is ObservableNuclear ObservableNuclear.hs && ./ObservableNuclear
ghc -O2 -main-is ObservableBio ObservableBio.hs && ./ObservableBio
ghc -O2 -main-is ObservableCondensed ObservableCondensed.hs && ./ObservableCondensed
ghc -O2 -main-is ObservableFluid ObservableFluid.hs && ./ObservableFluid
ghc -O2 -main-is ObservableOptics ObservableOptics.hs && ./ObservableOptics
ghc -O2 -main-is ObservableMath ObservableMath.hs && ./ObservableMath

# Combined runner (all 10 modules)
ghc -O2 -main-is ObservableAll ObservableAll.hs && ./ObservableAll

# Verification
ghc -O2 -main-is ObservableAlphaProton ObservableAlphaProton.hs && ./ObservableAlphaProton

# Structural proofs
ghc -O2 -main-is CrystalMandelbrot CrystalMandelbrot.hs && ./CrystalMandelbrot
ghc -O2 -main-is CrystalProtein CrystalProtein.hs && ./CrystalProtein
ghc -O2 -main-is CrystalFold CrystalFold.hs && ./CrystalFold
ghc -O2 -main-is CrystalNoether CrystalNoether.hs && ./CrystalNoether
```

## Rules

1. **Parallel design**: Old and new paths coexist. Both compile.
2. **One file, one component**: No mixing components in a single module.
3. **Dependency flows one way**: Atoms → Sectors/Eigen → Operators → Engine/Tower.
4. **Do NOT modify existing files**: Only additions. Old files retire after migration.
5. **One input**: VEV (optional). Everything else from (2, 3).
6. **Proofs for everything**: Agda (refl) and Lean (native_decide).
7. **README for everything**: Each module documents what it owns.
8. **DRY**: ObservableType.hs defines Obs/Formula/mk ONCE. No copy-paste.
9. **Corrections don't cascade**: Each observable gets its own correction only.
