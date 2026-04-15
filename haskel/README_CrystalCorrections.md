<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalCorrections.hs — Component 8: The Seven Correction Levels

## What This Module Is

The classification system for observables. Every observable has a correction
level that tells you what kind of mathematical structure connects the algebra
to the measurement.

This is Component 8 of the 12-component architecture. It owns:

- The 7 correction levels (exact integer through compositeness)
- The decision tree (which level does an observable belong to?)
- One-loop factor (1 + N_c/(16 pi^2) x ln(sqrt(N_w) x d_3/N_c^2) = 1.004)
- Beta function coefficients (beta_0 = 7, beta_1 = 48, all from (2,3))
- Level classification helpers (isExact, isPerturbative, needsPi, etc.)

## Dependency

```
CrystalAtoms.hs          <- Component 2 (root)
    |
CrystalCorrections.hs    <- Component 8 (this file)
```

Imports CrystalAtoms only. Does NOT import CrystalImplosion (Component 9).
This module CLASSIFIES which level an observable needs.
CrystalImplosion COMPUTES the specific implosion corrections.

## The Seven Levels

| Level | Name | PWI Range | Count | What |
|-------|------|-----------|-------|------|
| 0 | Exact Integer | 0.00% | ~60 | Counting reps, quantum numbers |
| 1 | Exact Rational | 0.00% | ~45 | Ratios of building blocks |
| 2 | Single pi | 0.00-0.1% | ~35 | Complex geometry of A_F |
| 3 | kappa or ln | 0.01-0.1% | ~20 | RG flow, sector scaling |
| 4 | One-loop | 0.1-1.0% | ~15 | Virtual particle corrections |
| 5 | Running | 0.1-0.5% | ~10 | Energy-scale dependence |
| 6 | Implosion | 0.01-0.1% | ~8 | Tower layer corrections |
| 7 | Compositeness | 0.1-4.0% | ~55 | Sums from multiple layers |

## The Decision Tree

```
1. Is the value an integer?
   YES -> Level 0
   NO  -> continue

2. Is value x {1, pi, 1/pi} a clean ratio of building blocks?
   YES and no pi needed -> Level 1
   YES and pi needed    -> Level 2
   NO                   -> continue

3. Is value x {kappa, 1/kappa} a clean ratio?
   YES -> Level 3
   NO  -> continue

4. Does Level 0-3 formula give 99-100% of the value?
   YES -> Level 4 (one-loop correction fills the gap)
   NO  -> continue

5. Does PDG quote at specific energy scale?
   YES -> Level 5 (running needed)
   NO  -> continue

6. Is base x small rational correction?
   YES -> Level 6 (implosion)
   NO  -> continue

7. Sum of terms from different scales?
   YES -> Level 7 (compositeness)
   NO  -> Unclassified
```

## One-Loop Factor

```
factor = 1 + N_c/(16 pi^2) x ln(sqrt(N_w) x d_3/N_c^2)
       = 1 + 3/157.91 x ln(sqrt(2) x 8/9)
       = 1.004

VEV gap: v_PDG/v_crystal = 246.22/245.17 = 1.004 = the one-loop factor
```

## Proofs

| File | Prover | Theorems |
|------|--------|----------|
| CrystalCorrections.agda | refl | 18 |
| CrystalCorrections.lean | native_decide | 15 |

## Compile & Test

```bash
ghc -O2 -main-is CrystalCorrections CrystalCorrections.hs && ./CrystalCorrections
```
