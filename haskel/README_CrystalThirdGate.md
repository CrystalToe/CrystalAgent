<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalThirdGate — Proof Module README

**Companion to**: *The Third Gate — Rectangle-Derived Detection of Electromagnetic Transduction Anomalies in Doubly-Foreign Mononuclidic Elements* (D. Montgomery, April 2026).

This module verifies the arithmetic invariants that underlie the third gate. Three implementations, each proving the same set of decidable theorems:

- `CrystalThirdGate.lean` — Lean 4 (uses `native_decide`)
- `CrystalThirdGate.agda` — Agda (decidable equalities, proofs are `refl`)
- `CrystalThirdGate.hs` — Haskell verifier (executable; runs all checks and reports)

## What Gets Proved

| # | Theorem | Statement |
|---|---|---|
| T1 | Stubborn four all dual-fail | I, Tb, Lu, Au all have BOTH Z and N foreign at the lightest stable isotope |
| T2 | Heegner set size | |H| = 9 |
| T3 | Blessed primes | {2, 3, 5, 7, 11, 17, 19, 41, 43, 67, 163} all pass the gate |
| T4 | Foreign primes | {13, 23, 29, 31, 37, 47, 53, 59, 71, 79} all fail the gate |
| T5 | Third tier vacuous | 16p − 4 ∈ H has no solutions for small primes — B is closed at two tiers |
| T6 | Magic numbers blessed | All seven nuclear magic numbers factor into blessed primes |
| T7 | Noble gases blessed | Z values for He–Rn factor into blessed primes |
| T8 | Oganesson foreign | Z = 118 = 2·59 contains foreign 59 |
| T9 | Pb lifts to 163 | 4·41 − 1 = 163 (largest Heegner number) |
| T10 | Max Heegner is 163 | Confirms the 163 ceiling |
| T11 | Pm foreign | Z = 61 fails both gate criteria |
| T12 | Stubborn factorizations | Explicit foreign-prime audit of all four (Z, N) pairs |

## Building and Running — Haskell

**Requirements**: GHC ≥ 9.0 (any recent version of the Haskell compiler).

```bash
# From the haskel/ directory:
cd /Users/davidmontgomery/coding/entity-project/CrystalAgent/haskel

# Compile
ghc -O2 -main-is CrystalThirdGate CrystalThirdGate.hs

# Run
./CrystalThirdGate
```

Expected output:

```
==========================================================
  Crystal Topos -- Third Gate Proof Verifier (Haskell)
  WACA Programme, April 2026
==========================================================

  [PASS]  T1  Stubborn four all dual-fail
  [PASS]  T2  Heegner set size is 9
  [PASS]  T3  Blessed primes (11) verified
  [PASS]  T4  Foreign primes (10) verified
  [PASS]  T5  Third-tier 16p-4 vacuous
  [PASS]  T6  Magic numbers all blessed
  [PASS]  T7  Noble gases all blessed
  [PASS]  T8  Oganesson (Z=118) is foreign
  [PASS]  T9  Pb's 41 lifts to 163
  [PASS]  T10 Max Heegner is 163
  [PASS]  T11 Pm (Z=61) is foreign
  [PASS]  T12 Stubborn factorizations correct

----------------------------------------------------------

  STUBBORN FOUR -- detailed factorization audit:

    I (Z=53, A=127, N=74):
       Z factors: [53]   foreign: [53]
       N factors: [2,37]  foreign: [37]
       dualGateFails: True
    Tb (Z=65, A=159, N=94):
       Z factors: [5,13]  foreign: [13]
       N factors: [2,47]  foreign: [47]
       dualGateFails: True
    Lu (Z=71, A=175, N=104):
       Z factors: [71]   foreign: [71]
       N factors: [2,2,2,13]  foreign: [13]
       dualGateFails: True
    Au (Z=79, A=197, N=118):
       Z factors: [79]   foreign: [79]
       N factors: [2,59]  foreign: [59]
       dualGateFails: True

  ALL PROOFS PASS.
```

The runtime is essentially instantaneous (< 50 ms on a modern laptop). The exit code is 0 on success, 1 on any failure.

### Cleanup

```bash
rm -f CrystalThirdGate CrystalThirdGate.hi CrystalThirdGate.o
```

## Building — Lean 4

**Requirements**: Lean 4 ≥ 4.0 (or Mathlib environment if you want to extend the theorems).

```bash
cd /Users/davidmontgomery/coding/entity-project/CrystalAgent/proofs
lean CrystalThirdGate.lean
```

If `lean` returns no errors, all theorems are proved. The `native_decide` tactic compiles each `Bool` expression to native code and evaluates it — this is the standard Lean 4 approach for decidable arithmetic claims of this form.

## Building — Agda

**Requirements**: Agda ≥ 2.6, with the standard library available.

```bash
cd /Users/davidmontgomery/coding/entity-project/CrystalAgent/proofs
agda CrystalThirdGate.agda
```

Each theorem is a propositional equality of the form `expr ≡ true` or `expr ≡ false`, proved by `refl`. The Agda type-checker normalizes the left-hand side and verifies the equality. If type-checking succeeds, the theorems hold.

The `{-# TERMINATING #-}` pragma on `factorAux` is used because Agda's termination checker cannot easily verify the trial-division algorithm. The function is in fact terminating (each recursive call either decreases `n` or increases `d` toward `sqrt(n)`); a more verbose well-founded version is left as an exercise.

## What These Proofs Show — and What They Do Not

**The proofs verify**: every arithmetic claim in the Third Gate paper that depends only on integer factorization, set membership, and decidable Boolean predicates over the Heegner set H. This includes the foreignness audit, the third-tier vacuity, and the explicit factorization of the four stubborn elements.

**Subtle point on the third-tier criterion** (T5):

The correct third-tier expression is `16p − 4 = 4(4p − 1)` — the squared-width lift, level Γ(N_w² = 4) extended once more. This is empirically vacuous: no small prime p produces a value in H.

This is **NOT** the same as `lift4 ∘ lift4 = 16p − 5`, which would NOT be vacuous: at p = 3, lift4(11) = 43 ∈ H. The framework's structural prediction is specifically about the level-extension `16p − 4`, not function composition.

All three proof modules use the correct `16p − 4` form. An earlier Agda draft used `lift4 ∘ lift4` and correctly failed to type-check at p=3 — a small bug that flagged the imprecision and was fixed before the module passed.

**The proofs do not verify**:
- The empirical statistical result (1 in 1.6M random alignment) — this is a frequentist computation, validated by the Python simulator
- The cross-domain medical-transducer correspondence — this is a literature claim
- The continuous resonance score itself — only its sign and rank-ordering invariants

The proofs are the formal arithmetic backbone. The empirical content lives in the simulator (`em_resonance_simulator.py`) and the industrial analysis (`Industrial_Resolution_Stubborn_Four.md`).

## Companion Files

In this repository:

- `CrystalStratum.{lean, agda, hs}` — earlier proof module (Tier 1: shell closures)
- `CrystalConfluence.{lean, agda, hs}` — earlier module (Tier 1.5: layer hierarchy)
- `CrystalNobleGas.{lean, agda, hs}` — Tier 1 noble-gas closure module
- `CrystalThirdGate.{lean, agda, hs}` — **this module** (Tier 3: EM transduction)

In `todo/d_52/`:

- `Industrial_Resolution_Stubborn_Four.md` — the substitute-search literature analysis
- `em_resonance_simulator.py` — the ranking computation (Tb #1, Lu #2, I #3, Au #4 of 81)
- `Stubborn_Four_Cross_Domain.md` — the original WACA observation
- `element_validator_v2.py` — Tier 2 dual-gate validator (94% accuracy)

## License

AGPL-3.0-or-later. Copyright © 2026 Daland Montgomery.
