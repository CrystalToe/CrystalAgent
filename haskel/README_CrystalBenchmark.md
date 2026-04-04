<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalBenchmark — Trp-cage (1L2Y) Protein Folding Benchmark

## What This Module Does

CrystalBenchmark runs the Trp-cage miniprotein (PDB: 1L2Y, 20 residues) through
the CrystalFold pipeline and compares the result to the experimental structure
via RMSD. It tests 5 conditioning configurations (0, 20, 50, 100, 200 rounds)
each followed by 100 folding ticks.

The folding itself happens in CrystalFold, which uses S = W∘U ticks from
CrystalOperators. This module is the benchmark runner — it provides the
reference structure, computes RMSD, and writes PDB files for visualization.

No (2,3) integer identities are derived here. All algebra comes from CrystalFold's
imports of CrystalAtoms → CrystalSectors → CrystalEigen → CrystalOperators.

## Contents (96 lines)

| What | Detail |
|------|--------|
| trpCageSeq | 20 amino acid sequence [Asn,Leu,Tyr,...,Ser] |
| ref1L2Y | 20 Cα reference coordinates from PDB |
| rmsdCalc | RMSD between two coordinate sets |
| center, rescale | Centering and radius-of-gyration normalization |
| caPos | Extract Cα positions from folded chain |
| main | Run 5 configs, print RMSD/Rg/contacts/helix%, write PDB |

## Compile

```bash
ghc -O2 -main-is CrystalBenchmark CrystalBenchmark.hs && ./CrystalBenchmark
```

Requires CrystalFold.hs (and its dependencies: CrystalAtoms, CrystalEigen,
CrystalSectors, CrystalOperators) compiled first.

## Import Chain

CrystalFold only. Dead CrystalEngine import removed.
All (2,3) derivation flows through CrystalFold → CrystalAtoms.

## Proofs

| Proof file | Theorems | Method |
|------------|----------|--------|
| CrystalBenchmark.agda | 3 | refl |
| CrystalBenchmark.lean | 3 | native_decide |

Benchmark parameters only (residue count=20, ref coords=20, configs=5).
Integer algebra proofs are in CrystalFold and CrystalAtoms.
