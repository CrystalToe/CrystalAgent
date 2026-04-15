<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalLattice — Rectangle/Natural-Path Theorem

## One Sentence

Standalone runtime audit of the Rectangle paper's prime taxonomy: proves that
Crystal Topos towers can only link via primes ≥ 5 coprime to 6, that those
primes partition into three structural classes, and that the Fermat ladder
terminates at exactly F₃ because of Mihailescu's identity 3² − 2³ = 1.

## What It Is

`CrystalLattice.hs` is the **GHC witness** for the paper
*The Crystal Lattice: Why Towers in Our Universe Must Be Linked by Primes ≥ 5*
(v4, Zenodo 10.5281/zenodo.19521966 and successor).

Every integer claim it verifies is mirrored as a machine-checked proof in:

- `proofs/CrystalLattice.lean` — Lean 4, via `native_decide`
- `proofs/CrystalLattice.agda` — Agda, via `refl` under `--safe`

The Haskell file adds nothing new mathematically. It is a **human-runnable
certificate**: compile, run, see the full prime taxonomy and a pass/fail
audit of every claim.

## Dependencies

**None.** Standalone. No `CrystalAtoms`, no `CrystalEngine`, no external
library imports. Re-derives the 10 invariants it needs (N_w, N_c, χ, β₀, D,
Σd, Σd², gauss, d_colour, towerD) locally so the file compiles in isolation.

This is deliberate. The Rectangle paper is a self-contained result and its
audit should be self-contained too.

## What It Proves (and Prints)

### Class 1 — CONSTRUCTIBLE (Fermat primes)

| n | F_n | Framework role |
|---|---|---|
| 0 | 3 | N_c (colour dimension) |
| 1 | 5 | χ − 1 |
| 2 | 17 | N_c² + d_colour (α_s = 2/17) |
| 3 | 257 | 2^(2^N_c) + 1 (Λ_h denominator) |
| 4 | 65537 | **excluded** — exponent 16 > d_colour = 8 |

### Class 2 — BOUNDARY (twin-prime flanks of D = 42)

| Prime | Role |
|---|---|
| 41 | D − 1. In Magic 82 = N_w × (D−1) |
| 43 | D + 1. In α⁻¹ = 43π + ln 7 |

### Class 3 — LINKING (coprime-to-6 sub-lattice)

| Prime | Role |
|---|---|
| 7 | β₀ = D/χ |
| 11 | (11·N_c − 2·χ)/3 = β₀; PMNS sin²θ₂₃ = 6/11 |
| 13 | gauss = N_w² + N_c² |
| 19 | gauss + χ; in Ω_Λ = 13/19, T_CMB = 19/7 |
| 53 | χ·N_c² − 1; in m_p = v/2⁸ × 53/54 |
| 61 | in Ω_DM denominator 1159 = 19 × 61 |
| 97 | Age = 97/7 Gyr |
| 103 | in Ω_DM numerator 309 = 3 × 103 |

### Theorem 10 (Fermat-Ladder Termination)

Mihailescu identity **3² − 2³ = 1** at (N_w, N_c) = (2, 3) forces
d_colour to have two equal expressions: N_c² − 1 = 8 and N_w^N_c = 8.
Counterfactuals (2, 4) and (2, 5) both fail the identity; F₅ is composite
(641 × 6700417, Euler 1732).

Total audit: **26 PASS / 26** on a clean run.

## How to Compile

**Minimum:**

```sh
cd haskel
ghc -O2 -main-is CrystalLattice CrystalLattice.hs -o crystal_lattice
./crystal_lattice
```

**Typical (matching the repo's other modules):**

```sh
cd haskel
ghc -O2 -Wno-x-partial -main-is CrystalLattice CrystalLattice.hs -o crystal_lattice
./crystal_lattice
```

**One-liner (compile and run, delete binary):**

```sh
ghc -O2 -main-is CrystalLattice CrystalLattice.hs -o /tmp/cl && /tmp/cl && rm /tmp/cl*
```

**As part of the repo's global runner:**

```sh
cd proofs
sh haskell_proofs.sh    # auto-discovers and runs CrystalLattice.hs along with 70+ others
```

The global runner's exit code is non-zero if any module fails; the standalone
run's stdout shows `RESULT: n/n — all green.` on success.

### GHC version

Known good: GHC ≥ 8.10 (uses no language extensions beyond Haskell 2010 and
does not depend on `base` versions newer than 4.14). Tested under 9.4.

### Expected output

```
══════════════════════════════════════════════════════════════════
 CrystalLattice.hs — Prime taxonomy of the Crystal Topos (v3)
 A_F = C (+) M_2(C) (+) M_3(C).  chi = 6. D = 42.
══════════════════════════════════════════════════════════════════

── CLASS 1: CONSTRUCTIBLE (Fermat) primes F_n = 2^(2^n)+1 ──
  F_0 = 3       N_c = 3 (colour dim)
  F_1 = 5       chi - 1 = 5 (Planck exp, Chandra 3/5, Flory 2/5)
  F_2 = 17      N_c^2 + d_colour = 9 + 8 (in alpha_s = 2/17)
  F_3 = 257     2^(2^N_c) + 1 (in Lambda_h = v/257)
  F_4 = 65537 : EXPONENT 2^4 = 16 > d_colour = 8; NO crystal home.
                (F_4 IS prime, but there is no primitive sector with dim 16.)
  F_5 = 2^32+1 = 641 * 6700417 : COMPOSITE (Euler 1732).

── FERMAT LADDER TERMINATION (v4) ──
  Weak-power chain:  N_w^0=1, N_w^1=2, N_w^2=4, N_w^3=8=d_colour  TERMINATOR
  Mihailescu at (2,3): N_c^2 - N_w^N_c = 1   (uniquely forces d_colour agreement)
  Counterfactual (2,4):  4^2 - 2^4 = 0    (no Mihailescu; but F_4=65537 IS prime)
  Counterfactual (2,5):  2^5 - 5^2 = 7    (no Mihailescu; F_5 is composite)
  Sector-Fermat bijection: 4 sectors {1,3,8,24} ↔ 4 Fermats {3,5,17,257}

── CLASS 2: BOUNDARY primes (adjacent to tower invariants) ──
  41    D - 1 (in Magic 82 = N_w * (D-1))
  43    D + 1 (Heegner, in alpha^-1 = 43*pi + ln 7)
  37    chi^2 + 1 (not yet used; candidate for layer D=36+1)

── CLASS 3: LINKING primes (coprime-to-6 sub-lattice) ──
  7     beta0 = D/chi (in alpha^-1, iron peak 56 = 8*7)
  11    in (11 N_c - 2 chi)/3 = beta0, PMNS sin^2 th23 = 6/11
  ...

── TWIN-PRIME SANDWICH of tower depth D = 42 ──
  (41, D, 43): BOTH flanks prime, twin pair, both coprime to 6. PASS.

── COSMOLOGICAL LINKING SIGNATURE ──
  Omega_L = 13/19     primes-ratio: YES
  T_CMB (K) = 19/7    primes-ratio: YES
  Age (Gyr) = 97/7    primes-ratio: YES

── AUDIT ──
  PASS  chi = 6
  PASS  D  = 42
  PASS  Sum of sector dims = 36 = chi^2
  ...

  RESULT: 26/26 — all green.
══════════════════════════════════════════════════════════════════
```

## Structure of the Source File

```
§0  ATOMS            — 10 local constants (N_w..gauss)
§1  ORTHOGONALITY    — Theorems 1-3: gcd, coprime-to-6, Catalan identity
§2  THREE CLASSES    — Fermat / Boundary / Linking prime lists with roles
§3  TWIN SANDWICH    — (D-1, D+1) = (41, 43) audit
§4  COSMO SIGNATURE  — Ω_Λ = 13/19, T_CMB = 19/7, Age = 97/7
§4b FERMAT TERMINATION — Theorem 10: why F_4 is excluded, Mihailescu
§5  AUDIT            — 26 named checks, each a Bool
§6  MAIN             — prints taxonomy table and audit results
```

All data structures are simple `[(Int, String)]` or records — no monads, no
type-class machinery. A first-year Haskell reader can follow every line.

## Position in the Architecture

`CrystalLattice` is a **leaf** module. It is not imported by anything and it
imports nothing. It exists to certify the Rectangle paper's claims outside
the main observable tree.

```
(CrystalAtoms tree)          (CrystalLattice)
         ↓                           ↓
    ... 70+ modules ...        standalone
         ↓                           ↓
 198 observables              3 prime classes
                              + Fermat ladder
                              + 3 cosmo ratios
```

This isolation is a feature: if the Rectangle paper is ever revised, the
file can be edited without risk of breaking the main catalogue.

## Cross-references

| File | Language | Verification tactic | Theorems |
|---|---|---|---|
| `CrystalLattice.hs` | Haskell | `Bool` audit, runtime | Theorems 1-10 |
| `proofs/CrystalLattice.lean` | Lean 4 | `native_decide` | Theorems 1-10 |
| `proofs/CrystalLattice.agda` | Agda | `refl` under `--safe` | Theorems 1-10 |

All three sources agree on every integer claim. If any one disagrees with
the other two, the disagreement is a bug, not a disagreement of fact.

## Reporting Discrepancies

If the Haskell run shows `FAIL` on any check:

1. Check the Lean proof for the same identity — it is machine-verified.
2. If Lean passes and Haskell fails, the Haskell bug is in the check's
   boolean expression (not in the framework).
3. If Lean and Haskell both fail, the framework's integer algebra has
   shifted and the paper's Theorem statement needs revision.

Case (3) has never occurred.

## License

AGPL-3.0-or-later. The file header carries the SPDX identifier.

## Paper

*The Crystal Lattice: Why Towers in Our Universe Must Be Linked by Primes ≥ 5*
— D. Montgomery, April 2026, v4.
Zenodo concept DOI: https://doi.org/10.5281/zenodo.19521966
