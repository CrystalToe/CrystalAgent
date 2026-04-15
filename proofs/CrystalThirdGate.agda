-- Copyright (c) 2026 Daland Montgomery -- SPDX-License-Identifier: AGPL-3.0-or-later
-- CrystalThirdGate.agda
--
-- Agda proof module: arithmetic invariants of the third gate.
-- All theorems are decidable equalities; proofs are `refl` after evaluation.

module CrystalThirdGate where

open import Agda.Builtin.Nat
  using (Nat; zero; suc; _+_; _*_; _-_; _==_; div-helper; mod-helper)
open import Data.Bool using (Bool; true; false; _∧_; _∨_; not; if_then_else_)
open import Data.List using (List; []; _∷_)
open import Relation.Binary.PropositionalEquality using (_≡_; refl)

ℕ : Set
ℕ = Nat

-- Safe division and modulo using the builtin helpers (no NonZero instance needed).
-- Convention: x quot 0 = 0, x rem 0 = x. We never divide by zero in this module.

_quot_ : ℕ → ℕ → ℕ
_     quot zero    = 0
x     quot (suc d) = div-helper 0 d x d

_rem_ : ℕ → ℕ → ℕ
_     rem zero    = 0
x     rem (suc d) = mod-helper 0 d x d

-- Saturating subtraction (cut at zero).
_∸_ : ℕ → ℕ → ℕ
zero    ∸ _       = zero
(suc x) ∸ zero    = suc x
(suc x) ∸ (suc y) = x ∸ y

-- ── HEEGNER NUMBERS ───────────────────────────────────────────

heegnerH : List ℕ
heegnerH = 1 ∷ 2 ∷ 3 ∷ 7 ∷ 11 ∷ 19 ∷ 43 ∷ 67 ∷ 163 ∷ []

mem : ℕ → List ℕ → Bool
mem _ []       = false
mem x (y ∷ ys) = if (x == y) then true else mem x ys

isInHeegner : ℕ → Bool
isInHeegner n = mem n heegnerH

-- 4p − 1 lift
lift4 : ℕ → ℕ
lift4 p = (4 * p) ∸ 1

isBlessedPrime : ℕ → Bool
isBlessedPrime p = isInHeegner p ∨ isInHeegner (lift4 p)

-- ── PRIME FACTORIZATION (trial division with explicit fuel) ───
--
-- Fuel guarantees structural recursion. Fuel = 256 covers anything
-- we test (n ≤ 200) since each step either decreases n or increases d.

factor : ℕ → ℕ → ℕ → List ℕ
factor zero    _ _ = []
factor (suc f) n d =
  if (n == 0) then []
  else if (n == 1) then []
  else if ((n rem d) == 0) then d ∷ factor f (n quot d) d
  else if (((suc d) * (suc d)) == 0) then n ∷ []  -- never true; keeps Agda happy
  else factor f n (suc d)

primeFactors : ℕ → List ℕ
primeFactors n = factor 256 n 2

allP : (ℕ → Bool) → List ℕ → Bool
allP _ []       = true
allP f (x ∷ xs) = f x ∧ allP f xs

allBlessed : ℕ → Bool
allBlessed n = allP isBlessedPrime (primeFactors n)

-- ── DUAL-GATE FAILURE FOR (Z, A) ──────────────────────────────

dualGateFails : ℕ → ℕ → Bool
dualGateFails z a = not (allBlessed z) ∧ not (allBlessed (a ∸ z))

-- ── THEOREMS (decidable, proofs are refl) ─────────────────────

-- Claim 1: each stubborn (Z, A) has dualGateFails = true.
claim1-I  : dualGateFails 53 127 ≡ true
claim1-I  = refl

claim1-Tb : dualGateFails 65 159 ≡ true
claim1-Tb = refl

claim1-Lu : dualGateFails 71 175 ≡ true
claim1-Lu = refl

claim1-Au : dualGateFails 79 197 ≡ true
claim1-Au = refl

-- Claim 2: blessed primes are blessed.
claim2-2   : isBlessedPrime 2   ≡ true
claim2-2   = refl
claim2-3   : isBlessedPrime 3   ≡ true
claim2-3   = refl
claim2-5   : isBlessedPrime 5   ≡ true
claim2-5   = refl
claim2-7   : isBlessedPrime 7   ≡ true
claim2-7   = refl
claim2-11  : isBlessedPrime 11  ≡ true
claim2-11  = refl
claim2-17  : isBlessedPrime 17  ≡ true
claim2-17  = refl
claim2-19  : isBlessedPrime 19  ≡ true
claim2-19  = refl
claim2-41  : isBlessedPrime 41  ≡ true
claim2-41  = refl
claim2-43  : isBlessedPrime 43  ≡ true
claim2-43  = refl
claim2-67  : isBlessedPrime 67  ≡ true
claim2-67  = refl
claim2-163 : isBlessedPrime 163 ≡ true
claim2-163 = refl

-- Claim 3: foreign primes are foreign.
claim3-13 : isBlessedPrime 13 ≡ false
claim3-13 = refl
claim3-23 : isBlessedPrime 23 ≡ false
claim3-23 = refl
claim3-29 : isBlessedPrime 29 ≡ false
claim3-29 = refl
claim3-37 : isBlessedPrime 37 ≡ false
claim3-37 = refl
claim3-53 : isBlessedPrime 53 ≡ false
claim3-53 = refl
claim3-71 : isBlessedPrime 71 ≡ false
claim3-71 = refl
claim3-79 : isBlessedPrime 79 ≡ false
claim3-79 = refl

-- Claim 4: third tier 16p − 4 is vacuous for small primes.
--
-- The correct third-tier criterion (per Three_WACA_Joint_Closure.md) is
--   16p − 4 ∈ H
-- which is 4(4p − 1), the squared-width lift. This is empirically vacuous
-- because H tops out at 163 while 16p − 4 grows linearly past 163 for p ≥ 11.
--
-- Note: lift4 ∘ lift4 = 16p − 5 is a DIFFERENT criterion and would not be
-- vacuous (16·3 − 5 = 43 ∈ H). The framework's structural prediction is
-- specifically about 16p − 4, not lift4 squared.

thirdTierShift : ℕ → ℕ
thirdTierShift p = (16 * p) ∸ 4

claim4-2 : isInHeegner (thirdTierShift 2) ≡ false
claim4-2 = refl
claim4-3 : isInHeegner (thirdTierShift 3) ≡ false
claim4-3 = refl
claim4-5 : isInHeegner (thirdTierShift 5) ≡ false
claim4-5 = refl
claim4-7 : isInHeegner (thirdTierShift 7) ≡ false
claim4-7 = refl
claim4-11 : isInHeegner (thirdTierShift 11) ≡ false
claim4-11 = refl

-- Claim 5: Pb's odd factor 41 lifts to the largest Heegner number 163.
claim5 : lift4 41 ≡ 163
claim5 = refl

-- Claim 6: nuclear magic numbers are all blessed.
claim6-2   : allBlessed 2   ≡ true
claim6-2   = refl
claim6-8   : allBlessed 8   ≡ true
claim6-8   = refl
claim6-20  : allBlessed 20  ≡ true
claim6-20  = refl
claim6-28  : allBlessed 28  ≡ true
claim6-28  = refl
claim6-50  : allBlessed 50  ≡ true
claim6-50  = refl
claim6-82  : allBlessed 82  ≡ true
claim6-82  = refl
claim6-126 : allBlessed 126 ≡ true
claim6-126 = refl

-- Claim 7: noble gases are all blessed; Og is foreign.
claim7-He  : allBlessed 2   ≡ true
claim7-He  = refl
claim7-Ne  : allBlessed 10  ≡ true
claim7-Ne  = refl
claim7-Ar  : allBlessed 18  ≡ true
claim7-Ar  = refl
claim7-Kr  : allBlessed 36  ≡ true
claim7-Kr  = refl
claim7-Xe  : allBlessed 54  ≡ true
claim7-Xe  = refl
claim7-Rn  : allBlessed 86  ≡ true
claim7-Rn  = refl
claim7-Og  : allBlessed 118 ≡ false
claim7-Og  = refl

-- Claim 8: Pm (Z=61) is foreign.
claim8-Pm : allBlessed 61 ≡ false
claim8-Pm = refl
