<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# ObservableType.hs — Shared Observable Infrastructure

## What This Module Is

The single source of truth for the four-column observable architecture. Every Observable module imports this instead of defining its own types. Change the Obs type, rating thresholds, formatting, or VEV constants — one file, ten modules updated.

## Compile

No standalone main. Compiles automatically as a dependency when you build any Observable module:

```bash
# Any of these will compile ObservableType.hs as a dependency:
ghc -O2 -main-is ObservableMixing ObservableMixing.hs && ./ObservableMixing
ghc -O2 -main-is ObservableAll ObservableAll.hs && ./ObservableAll
```

## What It Exports

### Types

- `Formula = Double -> Double` — every observable is a function of VEV
- `Obs` — record with `oName`, `oForm`, `oCry`, `oCryPdg`, `oExpt`, `oLvl`
- `CLevel(..)` — re-exported from CrystalCorrections: `ExactInteger`, `ExactRational`, `SinglePi`, `KappaOrLn`, `Implosion`, `Running`, `OneLoop`, `Composite`

### VEV Constants

- `vCry = 245.174 GeV` — derived from M_Pl: M_Pl × 35/(43×36×2^50)
- `vPdg = 246.220 GeV` — PDG experimental value

### Constructor

- `mk name formula f expt level` — builds an Obs by calling f(vCry) and f(vPdg)

### Metrics

- `shiftPct` — |CrystalPdg - Crystal| / Crystal × 100. VEV scheme noise. Zero for dimensionless observables, ~0.43% for dimensionful.
- `gapPct` — |Expt - CrystalPdg| / Expt × 100. Formula accuracy. Status follows this.

### Rating

- `rat` — converts gap percentage to status: EXACT (<0.001%), TIGHT (<0.5%), GOOD (<1%), LOOSE (<4.5%), OVER (≥4.5%)

### Formatting

- `row` — prints one observable as a table row: Name | Formula | Crystal | CrystalPdg | Expt | Shift | Gap | Status
- `header` — prints the column headers and separator line
- `check` — prints PASS/FAIL for a boolean test
- `pr`, `pl`, `fv`, `fp` — padding and number formatting helpers

## Why It Exists

Before this module, every Observable*.hs had 45 lines of identical type definitions and formatting code copy-pasted. Ten modules × 45 lines = 450 lines of duplication. A bug in the rating thresholds meant editing 10 files. Adding a column meant editing 10 files. Now it's one file.

## Dependency

```
CrystalAtoms.hs         ← sigmaD, towerD, d3 (for VEV computation)
CrystalCorrections.hs   ← CLevel (correction level tags)
    |
ObservableType.hs        ← THIS FILE
    |
Observable*.hs (×10)     ← import ObservableType
```
