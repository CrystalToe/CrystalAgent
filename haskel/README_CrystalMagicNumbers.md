<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalMagicNumbers.hs — Unified Magic-Number Formula with Prime-Structural Gating

## Compile

```bash
ghc -O2 -main-is CrystalMagicNumbers CrystalMagicNumbers.hs && ./CrystalMagicNumbers
```

## What This Module Is

Runtime verification that all seven observed nuclear magic numbers — 2, 8, 20, 28, 50, 82, 126 — follow from a single closed-form expression with zero free parameters, and that the predicted eighth value (184) is blocked by a prime-factorisation constraint derived from the rectangle's arithmetic support.

No observables — this is a proof module. It verifies the arithmetic identities in `Magic_Numbers.md` directly, prints a line-by-line factorisation table, and runs a battery of structural checks.

## The Unified Formula

$$M(n) = N_w \cdot \left[\sum_{k=1}^{N_c}\binom{n}{k} + \binom{n}{2} \cdot \mathbf{1}(n \leq N_c)\right]$$

with `(N_w, N_c) = (2, 3)`. Every parameter is rectangle-derived:

- `N_w = 2` — weak multiplicity, factor and correction coefficient
- `N_c = 3` — colour multiplicity, serves two roles simultaneously:
  1. truncation bound of the main sum (only 1-, 2-, 3-body linkages fit inside the rectangle's three columns)
  2. saturation threshold in the Iverson bracket (3D physical space saturates at n = 3 kissing neighbours)
- `C(n, 2)` — the unique 2-body simplex contribution; no other binomial term fits

The formula generates `{2, 8, 20, 28, 50, 82, 126}` at `n = 1..7` and `184` at `n = 8`.

## What Gets Verified

### The Seven Magic Numbers (7 checks)

Direct evaluation of `M n` at each `n = 1..7` against the observed magic values. All seven are reproduced by one expression.

### The Predicted Ceiling (1 check)

`M 8 = 184`, consistent with Wigner's 1948 spherical-nucleus formula. This value is the one that breaks in the prime-gate picture.

### Base/Bonus Decomposition (3 checks)

The formula factors into two rectangle-meaningful pieces:
- `mBase n = N_w · (C(n,1) + C(n,2) + C(n,3))` — simplex-skeleton count (edges + triangles + tetrahedra, doubled)
- `mBonus n = N_w · C(n,2) · [n ≤ N_c]` — 2-body kissing bonus, active only while 3D space has room

Verified that the bonus vanishes for all `n ≥ 4` and is active at `n = 1, 2, 3`.

### Piecewise OEIS A018226 Equivalence (3 checks)

The unified formula matches the published piecewise form of OEIS A018226 (Omar E. Pol, 2009):
- `n ≤ 3`: `M(n) = n(n+1)(n+2)/3` (doubled tetrahedral numbers, cumulative 3D-HO shell capacity)
- `n ≥ 4`: `M(n) = n(n²+5)/3` (Wigner spherical-nucleus formula, equal to `2·[C(n,1)+C(n,2)+C(n,3)]`)

Verified that the gap between the two branches is exactly `n(n-1) = 2·C(n,2)` — which is the kissing-bonus term in the unified form.

### Prime-Structural Gating (5 checks)

The blessed prime set is defined by a **single number-theoretic criterion** (not a three-way union):

> **B = { p prime : p ∈ H  or  4p − 1 ∈ H }**

where H = {1, 2, 3, 7, 11, 19, 43, 67, 163} is the Heegner set (the nine class-number-one imaginary quadratic discriminants). This gives:

```
B = {2, 3, 5, 7, 11, 17, 19, 41, 43, 67, 163}
```

- The first condition captures the Heegner primes: 2, 3, 7, 11, 19, 43, 67, 163.
- The second condition captures 5, 17, 41 via the Rabinowitz–Frobenius theorem: n² − n + k generates primes for n = 1..k−1 iff 4k − 1 is Heegner. These are **Euler's lucky primes**.

No separate Fermat clause is required (3 ∈ H; 4·5−1 = 19 ∈ H). No separate Rabinowitz-41 clause (4·41−1 = 163 ∈ H). The Fermat primes below β₀ = 7 fall inside B automatically.

Verified:
- **All seven observed magic numbers factor entirely into B.** M(5) uses the Euler-lucky prime 5; M(6) uses the Euler-lucky prime 41 (lifted via 163); M(7) uses all three rectangle primes 2, 3, 7.
- **M(8) = 184 = 2³·23 introduces the foreign prime 23.** 23 fails the criterion: the imaginary quadratic field Q(√−23) has class number 3, and 4·23−1 = 91 = 7·13 is not in H. The tower cannot remain spherical at this count.
- **Partial recoveries at n = 9, 10, 11.** M(9) = 2·3·43, M(10) = 2·5²·7, M(11) = 2·3·7·11 all factor into B. The arithmetic admits these values, but the tower has already broken sphericity at n = 8 and does not re-establish it.
- **Permanent break at n = 12.** M(12) = 596 = 2²·149 introduces the foreign prime 149 (class number > 1, no Rabinowitz lift). Subsequent values (M(13) = 754 = 2·13·29) accumulate additional foreign primes, including **13** itself — predicted foreign by the unified criterion since h(Q(√−13)) = 2 and 4·13−1 = 51 ∉ H.

### The 13 Question (answered)

13 is the rectangle's gauge invariant g = N_c² + N_w² (the squared diagonal) but is **not** in B. The unified criterion predicts this: h(Q(√−13)) = 2 and 4·13−1 = 51 = 3·17 is not in H. 13's geometric role in the rectangle (gauge / Pythagorean diagonal) is orthogonal to its arithmetic role (outside class-number-one support). The module verifies this directly.

### Rectangle-Native Identities (3 checks)

Three observed magic numbers admit especially clean rectangle expressions through the framework's invariants:

| Magic | Rectangle identity |
|---:|---|
| 28  | `N_w² · β₀`                       (= 4·7) |
| 82  | `N_w · (D − 1)`                   (= 2·41, the Rabinowitz twin) |
| 126 | `N_w · N_c² · β₀`                 (= 2·9·7) |

## Why It Matters

Before this unification, the observed magic numbers were understood as the union of two disjoint arithmetic sequences:
- **Regime A** (cumulative kissing numbers): n=1..3 giving {2, 8, 20}
- **Regime B** (Wigner binomial): n=4..7 giving {28, 50, 82, 126}

The two regimes matched at n=1 (both give 2) but disagreed at n=2, 3. No single closed form was known to reproduce all seven observed values.

The unified formula collapses the two regimes into one expression by recognising `N_c = 3` as serving dual structural roles — bounding the simplex dimension AND gating when 3D physical space saturates. The piecewise form published in OEIS (Omar Pol, 2009) is equivalent to this unified form, with the Iverson bracket `[n ≤ N_c]` making the rectangle's double-use explicit rather than leaving it as an external switch.

The prime-gating argument then explains why seven of the formula's infinite values are observed as magic closures and the eighth is not: M(8) = 2³·23 contains a prime that lies outside the rectangle's Heegner-bounded arithmetic support, so the sphericity required for a magic closure cannot be maintained. The observed fact — no spherical N=184 or Z=184 nucleus has been confirmed, and superheavy stability requires deformation — matches the prime-gate prediction exactly.

## Related Files

- `../Magic_Numbers.md` — the main paper (10 pages, 16 references)
- `../proofs/CrystalMagicNumbers.lean` — Lean 4 version, `native_decide`
- `../proofs/CrystalMagicNumbers.agda` — Agda version, `refl`
- `../magic_numbers_stability.html` — interactive Three.js visualisation of the stability/break transitions
- `../proofs/CrystalNuclear.lean` — earlier nuclear identity proofs (kept for continuity with older framing)
- `../haskel/ObservableNuclear.hs` — nuclear observable tallies inside the numerical test harness

## 18 Checks, 0 Observables, 0 Free Parameters

This module doesn't add to the observable count. It certifies that the seven observed magic numbers are structural invariants of the (2, 3) rectangle, gated by the **class-number-one criterion** B = {p prime : p ∈ H or 4p − 1 ∈ H} derived from the Heegner-163 arithmetic ceiling — a single number-theoretic principle, not a multi-source union. No fitting. No input from nuclear physics.
