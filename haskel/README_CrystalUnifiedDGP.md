<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalUnifiedDGP — Proof Module README

**Companion to**: *The Unified Data-Generating Process — One Rectangle, One Binding-Energy Function, the Entire Periodic Table* (D. Montgomery, April 2026).

This module verifies the **arithmetic backbone** of the Unified DGP claim. Three implementations, each proving the same set of decidable theorems:

- `CrystalUnifiedDGP.lean` — Lean 4 (uses `native_decide`)
- `CrystalUnifiedDGP.agda` — Agda (decidable equalities, proofs are `refl`)
- `CrystalUnifiedDGP.hs` — Haskell verifier (executable; runs all checks and reports)

## What Gets Proved

| # | Theorem | Statement |
|---|---|---|
| T1 | Tc odd-odd | At Z = 43, would-be lightest A gives odd-odd parity → negative pairing |
| T2 | Pm odd-odd | At Z = 61, same |
| T3 | Au shell distance | distance(118, magic) = 8 (8 below magic 126) |
| T4 | M(n) matches magic | M(1)..M(7) = {2, 8, 20, 28, 50, 82, 126} exactly |
| T5 | Stubborn dual-fail | I, Tb, Lu, Au all dual-gate fail at lightest stable A |
| T6 | Even-even positive | Sample of stable nuclides shows pairing > 0 |
| T7 | Z near magic | Every Z in 1..83 is within distance 22 of a magic number |
| T8 | Magic self-consistent | Magic numbers are L0 closures (cross-check) |
| T9 | Stubborn near magic | Each stubborn (Z, A) within distance 12 of magic on at least one axis |
| T10 | Au-I tied at 8 | Au's N=118 and I's N=74 both at distance 8 from a magic number |

## Building and Running — Haskell

**Requirements**: GHC ≥ 9.0.

```bash
cd /Users/davidmontgomery/coding/entity-project/CrystalAgent/haskel
ghc -O2 -main-is CrystalUnifiedDGP CrystalUnifiedDGP.hs
./CrystalUnifiedDGP
```

Expected output:

```
==========================================================
  Crystal Topos -- Unified DGP Proof Verifier (Haskell)
  WACA Programme, April 2026
==========================================================

  Verifying: all elements emerge from one DGP =
             SEMF + rectangle shell correction at L0.

  [PASS]  T1  Tc has odd-odd at would-be lightest A (negative pairing)
  [PASS]  T2  Pm has odd-odd at would-be lightest A (negative pairing)
  [PASS]  T3  Au's N=118 is exactly 8 away from magic 126
  [PASS]  T4  M(n) for n=1..7 matches the seven magic numbers
  [PASS]  T5  All four stubborn dual-gate fail at lightest stable A
  [PASS]  T6  Sample even-even stable nuclides have pairing > 0
  [PASS]  T7  Every Z = 1..83 is within distance 22 of a magic number
  [PASS]  T8  Magic numbers are L0 closures (self-consistency)
  [PASS]  T9  Stubborn four are all near magic on at least one axis
  [PASS]  T10 Au and I both at distance 8 from magic 82 (deepest shell)

----------------------------------------------------------
  Magic numbers from M(n):
    M(1) = 2
    M(2) = 8
    M(3) = 20
    M(4) = 28
    M(5) = 50
    M(6) = 82
    M(7) = 126

  Stubborn-four shell-distance audit:
    I (Z=53, A=127, N=74):
       distance(Z, magic) = 3
       distance(N, magic) = 8
       pairing sign       = 0 (odd-A)
    Tb (Z=65, A=159, N=94):
       distance(Z, magic) = 15
       distance(N, magic) = 12
       pairing sign       = 0 (odd-A)
    Lu (Z=71, A=175, N=104):
       distance(Z, magic) = 11
       distance(N, magic) = 22
       pairing sign       = 0 (odd-A)
    Au (Z=79, A=197, N=118):
       distance(Z, magic) = 3
       distance(N, magic) = 8
       pairing sign       = 0 (odd-A)

  ALL PROOFS PASS.
  Unified DGP arithmetic backbone verified.
```

Runtime: < 50 ms. Exit code 0 on full pass, 1 on any failure.

### Cleanup

```bash
rm -f CrystalUnifiedDGP CrystalUnifiedDGP.hi CrystalUnifiedDGP.o
```

## Building — Lean 4

**Requirements**: Lean 4 ≥ 4.0.

```bash
cd /Users/davidmontgomery/coding/entity-project/CrystalAgent/proofs
lean CrystalUnifiedDGP.lean
```

If `lean` returns no errors, all theorems are proved. The `native_decide` tactic compiles each `Bool` expression to native code and evaluates it.

## Building — Agda

**Requirements**: Agda ≥ 2.6 with the standard library.

```bash
cd /Users/davidmontgomery/coding/entity-project/CrystalAgent/proofs
agda CrystalUnifiedDGP.agda
```

Each theorem is a propositional equality of the form `expr ≡ true` or `expr ≡ value`, proved by `refl`. The Agda type-checker normalizes the left-hand side and verifies the equality.

The trial-division `factor` function uses an explicit fuel parameter (256) for structural termination — no `{-# TERMINATING #-}` pragma needed. The fuel covers any number we test (≤ 200).

The T7 sample is a representative subset of Z values to keep type-check fast; the full range claim is verified by the Lean and Haskell modules.

## What These Proofs Show — and What They Do Not

**The proofs verify**: every arithmetic claim in the Unified DGP paper that depends only on integer arithmetic and decidable Boolean predicates. This includes:

- The pairing-sign rule for even-even, odd-odd, and odd-A nuclides
- The exact match between M(1)..M(7) and the seven empirical nuclear magic numbers
- The shell-correction-distance values for the four stubborn elements
- The dual-gate failure of the stubborn four at their lightest stable mass numbers

**Subtle point on Au and I**: Both Au-197 (N=118) and I-127 (N=74) sit at distance 8 from a magic number — Au is 8 below 126, I is 8 below 82. The framework predicts BOTH receive the strongest shell-correction boost among the stubborn four. The Python validator confirms Au is rescued (becomes B/A local maximum); I was already a local maximum even with smooth SEMF, so the boost is icing rather than rescue.

**The proofs do not verify**:
- The numerical SEMF coefficients (A_VOL = 15.8 MeV, etc., are empirical fits — not derivable)
- The continuous "is local maximum at A" predicate (real-valued, not decidable in pure arithmetic)
- The 100% empirical coverage claim (verified by the Python validator running against NIST data)
- The exact magnitude of the shell correction needed to rescue Au (calibrated, not derived)

The proofs are the formal arithmetic backbone. The empirical 100% closure lives in `unified_dgp_v2.py`.

## Companion Files

In this repository:

- `CrystalStratum.{lean, agda, hs}` — earlier proof module (rectangle algebra)
- `CrystalConfluence.{lean, agda, hs}` — earlier (layer hierarchy, M(n))
- `CrystalNobleGas.{lean, agda, hs}` — Tier 1 noble-gas closure
- `CrystalThirdGate.{lean, agda, hs}` — Tier 3 EM transduction
- `CrystalUnifiedDGP.{lean, agda, hs}` — **this module** (Unified DGP closure)

In `todo/d_52/`:

- `unified_dgp.py` — Tier 1 unification (smooth SEMF only — has Au residual)
- `unified_dgp_v2.py` — Tier 2 unification (SEMF + rectangle shell correction — Au rescued)
- `Industrial_Resolution_Stubborn_Four.md` — substitute-search literature analysis
- `Three_WACA_Joint_Closure.md` — finite-framework architecture audit

## License

AGPL-3.0-or-later. Copyright © 2026 Daland Montgomery.
