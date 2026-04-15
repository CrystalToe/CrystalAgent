<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# haskel/ — 33 Haskell Modules, 198 Observables

All Haskell source lives here. Compile with GHC. No cabal, no stack — raw GHC.

## Quick Start

```bash
# Run everything (auto-detects compile mode per file):
sh ../proofs/haskell_proofs.sh          # 33/33 PASS

# Or run the key tests individually:
ghc -O2 Main.hs -o crystal && ./crystal                                       # 92 observables
ghc -O2 -main-is CrystalFullTest CrystalFullTest.hs -o full_test && ./full_test  # 198 observables
ghc -O2 GravityDynTest.hs -o gravity_dyn_test && ./gravity_dyn_test              # 12/12 gravity

# Clean up:
rm -f *.o *.hi
```

## Module Map

### Foundation

| Module | Lines | Role |
|--------|-------|------|
| CrystalAxiom.hs | 776 | The root. Two primes, six invariants, all types. Everything imports this. |
| Main.hs | — | Certificate driver. Runs original 92 observables, writes GHC_Certificate.txt. |

### Standard Model

| Module | Lines | Role |
|--------|-------|------|
| CrystalGauge.hs | 278 | α, sin²θ_W, α_s, Higgs, leptons, Koide |
| CrystalMixing.hs | 215 | CKM + PMNS matrices, CP violation, Jarlskog |
| CrystalCosmo.hs | 482 | Ω_Λ, Ω_m, n_s, neutrino masses, dark photon |
| CrystalQCD.hs | 1215 | Proton, quarks, full hadron spectrum (largest module) |
| CrystalGravity.hs | 426 | Newton, Kepler, Maxwell, SR/GR, Immirzi, Bekenstein |

### Extended Scan

| Module | Lines | Role |
|--------|-------|------|
| CrystalWACAScan.hs | 2046 | 103 extended observables across 19 sections |
| WACAScanTest.hs | — | Test runner for CrystalWACAScan |

### Precision & Corrections

| Module | Lines | Role |
|--------|-------|------|
| CrystalAlphaProton.hs | — | α⁻¹ and m_p/m_e inside CODATA (Sessions 4-5) |
| CrystalProtonRadius.hs | — | Proton charge radius (Session 6) |
| CrystalHierarchy.hs | — | Seeley-DeWitt implosion, a₄ corrections (Session 8) |
| CrystalFullTest.hs | — | Full 198-observable regression test |

### Dynamical Gravity (Session 12)

| Module | Lines | Role |
|--------|-------|------|
| CrystalGravityDyn.hs | — | Linearized Einstein from MERA, 12 integer proofs |
| GravityDynTest.hs | — | 12/12 integer audit runner |

### Cross-Domain & Structural

| Module | Lines | Role |
|--------|-------|------|
| CrystalCrossDomain.hs | 251 | Feigenbaum, Kleiber, Benford, Von Kármán |
| CrystalAudit.hs | 643 | Naturality audit, acid test |
| CrystalRiemann.hs | 354 | Trace formula, ARIMA, Weil positivity |
| CrystalStructural.hs | — | Structural proof module |
| CrystalNoether.hs | — | Noether proof module |
| CrystalDiscoveries.hs | — | Discoveries proof module |
| CrystalLayer.hs | — | Spectral tower cascade (Session 11) |

### Protein & Mandelbrot (Session 14)

| Module | Lines | Role |
|--------|-------|------|
| CrystalProtein.hs | — | 73 proofs, D=0..D=42 protein force field |
| CrystalMandelbrot.hs | — | 28 proofs, Mandelbrot ↔ A_F functor |

### Quantum Library (96 operators)

| Module | Lines | Role |
|--------|-------|------|
| CrystalQuantum.hs | 421 | Hub: 10 structural theorems |
| CrystalQBase.hs | 167 | Types + Hilbert spaces |
| CrystalQGates.hs | 240 | 27 quantum gates |
| CrystalQChannels.hs | 192 | 10 noise channels |
| CrystalQHamiltonians.hs | 183 | 12 Hamiltonians |
| CrystalQMeasure.hs | 126 | 8 measurements |
| CrystalQEntangle.hs | 204 | 12 entanglement tools |
| CrystalQAlgorithms.hs | 226 | 15 algorithms |
| CrystalQSimulation.hs | 223 | 12 simulation methods |

## Observable Counts

| Source | Count |
|--------|-------|
| Original (Main.hs) | 92 |
| Extended (CrystalWACAScan.hs) | 103 |
| S4-S6 corrections | 3 |
| **Total** | **198** |

## How haskell_proofs.sh Detects Compile Mode

The runner script auto-detects from file content (no hardcoded list):

| Content pattern | Compile mode |
|-----------------|-------------|
| `module Main` + `main =` | `ghc -O2 file.hs -o bin && ./bin` |
| `main =` (no `module Main`) | `ghc -O2 -main-is Module file.hs -o bin && ./bin` |
| no `main` | `ghc -fno-code file.hs` (type-check only) |

Drop a new `.hs` file here, run `sh ../proofs/haskell_proofs.sh`, it picks it up.
