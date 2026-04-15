<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalStratum — Multi-Level Hierarchy of the Magic-Number Formula

Three parallel proof modules (Haskell, Lean, Agda) certifying that the unified magic-number formula's internal partial-sum structure generates a **natural four-layer hierarchy** that accommodates, without tuning, every literature-recognised nuclear magic, doubly-magic, and emergent subshell closure — and produces 14 explicit forbidden-even-integer predictions as falsifiers.

**This module extends `CrystalMagicNumbers`, not replaces it.** CrystalMagicNumbers establishes the primary formula and the 7 canonical magic numbers. CrystalStratum adds the hierarchy structure above, below, and around those primaries.

## Compile

```bash
# Haskell (runtime checks, ~50 structural assertions)
ghc -O2 -main-is CrystalStratum CrystalStratum.hs && ./CrystalStratum

# Lean 4 (compile-time via native_decide)
lean CrystalStratum.lean

# Agda (compile-time via refl only, no division)
agda CrystalStratum.agda
```

All three should pass cleanly. The Haskell version prints a formatted table; the Lean and Agda versions succeed silently (no type errors = all theorems proved).

## What This Module Is

Runtime and compile-time verification that the formula

$$M(n) = N_w \cdot \left[\sum_{k=1}^{N_c}\binom{n}{k} + \binom{n}{2} \cdot \mathbf{1}(n \leq N_c)\right]$$

has **internal partial-sum structure** that produces a naturally nested hierarchy of closure candidates, not just the seven canonical magic numbers at the top.

No observables — this is a proof module extending the hierarchy paper (`Hierarchy_Stratum_Structure.md`) with compile-time certificates. It verifies every claim made in that paper's §2, §3, §6, and §9.

## The Four Hierarchy Layers

The formula sums over `k = 1..N_c = 3` columns. Each partial sum produces a distinct layer:

| Layer | Expression | Sequence | Role |
|---:|---|---|---|
| **L0 primary** | `M(n)` full | 2, 8, 20, 28, 50, 82, 126 | canonical magic (7 numbers) |
| **L1 secondary** | `M^(2)(n) = N_w·[C(n,1) + C(n,2)] + correction` | 2, 8, 20, 30, 42, 56, 72, 90, ... | pronic (Ni-56 here) |
| **L2 tertiary** | `M^(1)(n) = N_w·C(n,1) = 2n` | 2, 4, 6, 8, 10, 12, 14, 16, ... | even numbers (all emergent subshells here) |
| **L3 fine** | `M(n) + rectangle_invariant` | M(n) + {N_w, N_c, χ, β₀, g, 2χ, ...} | within-shell sub-structure |
| **Forbidden** | contains foreign prime | — | framework predicts no closure |

The hierarchy is **not imposed from outside** — it falls out of the formula's own column-wise decomposition. Layer 0 is "all three columns summed"; Layer 1 is "drop the k=3 column"; Layer 2 is "drop the k=2 and k=3 columns"; Layer 3 is "offset from a primary M(n) by a single rectangle invariant."

## What Gets Verified

### Layer 0: Canonical Magic Numbers (7 checks)

Direct evaluation of `M n` for `n = 1..7` reproducing `{2, 8, 20, 28, 50, 82, 126}`. (These duplicate `CrystalMagicNumbers` for self-containment.)

### Layer 1: Pronic / Secondary Closures (6 checks + Ni-56 identity + D identity)

- `M^(2)(n) = n(n+1)` exactly for n ≥ 4 (outside correction region) — this is the **pronic number sequence** OEIS A002378.
- `M^(2)(7) = 7·8 = 56`: **Ni-56 doubly-magic identity.** Ni-56 (Z = N = 28) is the most-cited semi-magic nucleus outside the canonical seven.
- `M^(2)(6) = 6·7 = 42 = D`: the tower-depth invariant appears as a Layer 1 closure.

The L1 sequence continues {72, 90, 110, 132, 156, 182, …}. These are arithmetic candidates for doubly-magic or semi-magic closures not yet prominent in the literature. Predicted weaker but detectable shell effects at appropriately asymmetric isotope chains.

### Layer 2: Tertiary Closures — All Known Emergent Subshells (6 checks)

The even-number sequence `M^(1)(n) = 2n`, restricted to arithmetically-allowed integers, produces the **full set of literature-recognised emergent subshell closures**:

| N | as `2n` | literature |
|---:|---|---|
|  14 | `2·7`  | C-14, Si-28 context |
|  16 | `2·8`  | O-16 doubly magic, neutron-rich O subshell |
|  32 | `2·16` | ⁵²Ca subshell closure |
|  34 | `2·17` | ⁵⁴Ca subshell closure (Steppenbeck, Nature 2013) |
|  40 | `2·20` | Zr, Ni semi-magic |
|  64 | `2·32` | weak Gd subshell |

**All six literature-known emergent subshells land at Layer 2.** Zero false negatives. No tuning.

### Layer 3: Fine-Structure and Dual Readings (5 checks)

Some integers admit multiple valid layer assignments. The important case:

**N = 34 dual reading**:
- **L2**: `34 = 2·17 = M^(1)(17)` — "first column half-filled at shell 17"
- **L3**: `34 = 28 + 6 = M(4) + χ` — "one rectangle-area step past the fourth major closure"

Both decompositions pass the gate. The physical manifestation of the closure in ⁵⁴Ca can be read either way, and which dominates depends on local single-particle structure (i.e., what the shell-evolution literature investigates experimentally).

Also verified: `N = 32 = M(4) + N_w²`, `N = 128 = M(7) + N_w`, `N = 168 = M(7) + D`.

### All 13 Literature Closures Pass the Gate (14 factorisation checks)

Every integer in the combined canonical + doubly-magic + emergent-subshell set verified to factor entirely into the blessed set `B = {2, 3, 5, 7, 11, 17, 19, 41, 43, 67, 163}`:

```
   2 = 2          ✓       34 = 2·17      ✓
   8 = 2³         ✓       40 = 2³·5      ✓
  14 = 2·7        ✓       50 = 2·5²      ✓
  16 = 2⁴         ✓       56 = 2³·7      ✓
  20 = 2²·5       ✓       64 = 2⁶        ✓
  28 = 2²·7       ✓       82 = 2·41      ✓
  32 = 2⁵         ✓      126 = 2·3²·7    ✓
```

### Forbidden Predictions (14 factorisations)

Even integers ≤ 200 that are **L2-shaped (= 2·k)** but contain foreign primes. The framework predicts no robust subshell closure at any of these. Each is verified by exhibiting its foreign prime factor:

```
  26 = 2·13       ✗ (13 foreign)        92 = 2²·23      ✗ (23 foreign)
  46 = 2·23       ✗ (23 foreign)        94 = 2·47       ✗ (47 foreign)
  52 = 2²·13      ✗ (13 foreign)       104 = 2³·13      ✗ (13 foreign)
  58 = 2·29       ✗ (29 foreign)       106 = 2·53       ✗ (53 foreign)
  62 = 2·31       ✗ (31 foreign)       116 = 2²·29      ✗ (29 foreign)
  74 = 2·37       ✗ (37 foreign)       118 = 2·59       ✗ (59 foreign)
  78 = 2·3·13     ✗ (13 foreign)       122 = 2·61       ✗ (61 foreign)
```

(30 such integers exist in 1..200; 14 are explicitly checked here. Currently consistent with experiment — no robust subshell closure is reported at any of them. A future confirmation of a strong shell gap at any would be a clean falsifier.)

### Shell-Size / Sylvester Connection (6 checks)

For `n ≥ 4`, consecutive shell sizes follow

$$\Delta M(n) = M(n) - M(n-1) = n^2 - n + 2 = \text{Sylvester}(n) + 1$$

where `Sylvester(n) = n² − n + 1` is the recurrence behind Sylvester's sequence `2, 3, 7, 43, 1807, …` that was already central to the Koide derivation (see `Koide_Resolution_Sylvester.md`).

Verified:
- `ΔM(5) = 22 = 5² − 5 + 2`
- `ΔM(6) = 32 = 6² − 6 + 2` — **shell-6 SIZE equals the N = 32 subshell integer**. Same integer appears in two structural roles.
- `ΔM(7) = 44`
- `ΔM(8) = 58 = 2·29` — **shell-8 size contains foreign prime 29**. This is arithmetically why M(8) = 184 cannot be a primary closure: the transition into it crosses a forbidden shell size.

### Decomposition Consistency (6 checks)

Algebraic consistency that the layers stack correctly:

- `M(n) = M^(2)(n) + N_w·C(n,3)` for all n (L0 extends L1 by the k=3 column)
- `M^(2)(n) = M^(1)(n) + N_w·C(n,2) + correction` for all n (L1 extends L2 by the k=2 column plus the kissing-region correction)

## Per-Language Conventions

### Lean 4 (`CrystalStratum.lean`)

Style mirrors `CrystalMagicNumbers.lean`: every theorem is an evaluated-to-numeric equation discharged by `native_decide`. `def M`, `def M2`, `def M1` give the three layers directly. No `forall n` quantification (those need induction proofs and fail `native_decide` on unbounded naturals); each `n` is proved as a separate theorem.

### Agda (`CrystalStratum.agda`)

Style mirrors `CrystalMagicNumbers.agda`: `refl` only. `Agda.Builtin.Nat` lacks a division operator, so the shell-size identities are stated **multiplicatively**: `M n ≡ M (n-1) + (n² − n + 2)` rather than `ΔM(n) = n² − n + 2`. This avoids needing `_/_` while keeping the arithmetic content intact.

### Haskell (`CrystalStratum.hs`)

Self-contained runtime. Style mirrors `CrystalMagicNumbers.hs`: `main` prints a formatted table of all three layers, the dual readings, the literature-closure map, the forbidden predictions, and then runs ~18 structural Boolean checks via `[PASS]`/`[FAIL]` lines.

The blessed set `B` is **computed** from the class-number-one criterion (`p ∈ H or 4p-1 ∈ H`) rather than hard-coded, so the module doubles as a re-derivation of `B = {2, 3, 5, 7, 11, 17, 19, 41, 43, 67, 163}` from the Heegner set alone.

## Why It Matters

Before this hierarchy, the framework had a clean claim ("M(n) reproduces the 7 canonical magic numbers") but an awkward silence on Ni-56 and the emergent subshells at N = 14, 16, 32, 34, 40. The magic-numbers paper [1] flagged this as a scope limitation.

The hierarchy resolves the gap **without adding a single new parameter or rule**. The partial sums `M^(1)(n)` and `M^(2)(n)` are already inside the formula — they are what you get by summing up to column 1 or column 2 instead of all three. The four-layer structure is mechanical, not designed.

What makes it non-trivial is that the resulting layer assignments match experiment:

- All 7 canonical magic → Layer 0 (full formula)
- Ni-56 (most cited doubly-magic outside the canonical seven) → Layer 1 (pronic)
- All 6 literature-known emergent subshells → Layer 2 (even)
- Zero false negatives across all 13 checks

The framework is now graded rather than binary: strong closures at L0, weaker at L1, weaker still at L2, with dual-reading reinforcement at specific integers (N = 32, 34 appear in multiple layers simultaneously, predicting stronger-than-generic Layer 2 closure — which matches the experimental status of ⁵²Ca and ⁵⁴Ca among emergent subshells).

## The 30-Integer Falsifier

The hierarchy's graded "allowed" structure is half the prediction. The other half is the hard forbidden list:

> **30 even integers in 1..200 contain foreign primes (13, 23, 29, 31, 37, 47, 53, 59, 61, 71, 73, 79, 83, 89, 97).**

The framework predicts no robust subshell closure at any of them. Currently (April 2026) this is consistent with the experimental literature. Any future discovery of a strong shell gap at N = 46, 58, 62, 74, 94, 106, 118, 122, or any of the others is a direct falsifier of the blessed-prime criterion.

This is the module's sharpest empirical stake: a specific enumerable list of predictions with no wiggle room.

## Related Files

- `./Hierarchy_Stratum_Structure.md` — the hierarchy paper (§2 defines the layers; §3.1 tables the literature match; §3.3 enumerates the forbidden predictions; §5 discusses graded closure strength)
- `./CrystalStratum.lean` — Lean 4 compile-time certificate
- `./CrystalStratum.agda` — Agda compile-time certificate (multiplicative forms only)
- `./CrystalStratum.hs` — Haskell runtime certificate with formatted output
- `../Magic_Numbers.md` (stable) — primary-formula paper that this module extends
- `../../haskel/CrystalMagicNumbers.hs`, `../../proofs/CrystalMagicNumbers.lean`, `../../proofs/CrystalMagicNumbers.agda` — the primary-formula proofs this module builds on

## Relationship to CrystalMagicNumbers

`CrystalMagicNumbers` proves:
1. `M(n) = {2, 8, 20, 28, 50, 82, 126}` at `n = 1..7`.
2. `M(8) = 184 = 2³·23` introduces the foreign prime 23.
3. Every canonical magic number factors into `B`.

`CrystalStratum` proves additionally:
1. The **partial sums** `M^(1)(n)` and `M^(2)(n)` define Layers 2 and 1 respectively.
2. **Every** literature-recognised closure (canonical + Ni-56 + 6 emergent subshells) lands at one of L0/L1/L2.
3. **Dual readings** exist (N = 32 and N = 34 at both L2 and L3), and their coexistence is an arithmetic feature of the rectangle, not an ambiguity.
4. The shell-size identity `ΔM(n) = n² − n + 2 = Sylvester(n) + 1` connects the magic-number spacing to the Sylvester chain underlying the Koide derivation.
5. **14 explicit forbidden predictions** for L2-shaped integers containing foreign primes.

The two modules together give a complete formal certification of the magic-number results claimed in the `Magic_Numbers.md` and `Hierarchy_Stratum_Structure.md` papers.

## ~50 Checks, 0 Observables, 0 Free Parameters

This module doesn't add to the observable count. It certifies that the four-layer hierarchy generated by the formula's partial sums matches every literature-recognised closure without tuning, and produces 14 explicit falsifier predictions for subshell closures that should not exist. No fitting. No input from nuclear physics beyond the list of what experiment has observed.

## References

[1] D. Montgomery, *Nuclear Magic Numbers as Prime-Gated Linkage Optimization on the 2 × 3 Rectangle.* Crystal Topos / WACA Programme (April 2026).

[2] D. Montgomery, *Hierarchy and Stratum Structure — Magic Numbers as a Multi-Level Cascade.* Crystal Topos / WACA Programme (April 2026). [This module is the formal companion to this paper.]

[3] D. Steppenbeck et al., *Nature* **502** (2013) 207. Original N = 34 finding.

[4] F. Wienholtz et al., *Nature* **498** (2013) 346. N = 32 in ⁵²Ca.

[5] OEIS A002378: Pronic (oblong) numbers n(n+1).

[6] OEIS A018226: The piecewise form of the magic-number formula.

[7] Review of shell migration at N = 32, 34 around Ca, arXiv:2412.17588 (2024).
