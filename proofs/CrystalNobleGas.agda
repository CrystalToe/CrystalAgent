-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later
--
-- CrystalNobleGas.agda
-- Proves: blessed-prime gate holds for noble gas electron counts
-- Supports: "Same Song, Second Verse" paper (forthcoming)

module CrystalNobleGas where

open import Data.Nat using (ℕ; zero; suc; _+_; _*_; _∸_; _≡ᵇ_)
open import Data.Bool using (Bool; true; false; _∧_; _∨_; not)
open import Relation.Binary.PropositionalEquality using (_≡_; refl)

-- ============================================================
-- § 0: RECTANGLE CONSTANTS
-- ============================================================

Nw : ℕ
Nw = 2

Nc : ℕ
Nc = 3

-- ============================================================
-- § 1: HEEGNER SET AND BLESSED-PRIME TEST
-- Uses ≡ᵇ (boolean equality) to avoid large-literal pattern match
-- ============================================================

inH : ℕ → Bool
inH n = (n ≡ᵇ 1) ∨ (n ≡ᵇ 2) ∨ (n ≡ᵇ 3) ∨ (n ≡ᵇ 7) ∨ (n ≡ᵇ 11) ∨ (n ≡ᵇ 19) ∨ (n ≡ᵇ 43) ∨ (n ≡ᵇ 67) ∨ (n ≡ᵇ 163)

isBlessed : ℕ → Bool
isBlessed p = inH p ∨ inH (4 * p ∸ 1)

isForeign : ℕ → Bool
isForeign p = not (isBlessed p)

-- ============================================================
-- § 2: NOBLE GAS FACTORS — ALL BLESSED
-- ============================================================

-- He: Z = 2
he-blessed : isBlessed 2 ≡ true
he-blessed = refl

-- Ne: Z = 10 = 2 · 5, both blessed
ne-factor : 10 ≡ 2 * 5
ne-factor = refl

ne-blessed-2 : isBlessed 2 ≡ true
ne-blessed-2 = refl

ne-blessed-5 : isBlessed 5 ≡ true
ne-blessed-5 = refl

-- Ar: Z = 18 = 2 · 3²
ar-factor : 18 ≡ 2 * 3 * 3
ar-factor = refl

ar-blessed-3 : isBlessed 3 ≡ true
ar-blessed-3 = refl

-- Kr: Z = 36 = 2² · 3²
kr-factor : 36 ≡ 2 * 2 * 3 * 3
kr-factor = refl

-- Xe: Z = 54 = 2 · 3³
xe-factor : 54 ≡ 2 * 3 * 3 * 3
xe-factor = refl

-- Rn: Z = 86 = 2 · 43
rn-factor : 86 ≡ 2 * 43
rn-factor = refl

rn-blessed-43 : isBlessed 43 ≡ true
rn-blessed-43 = refl

-- 43 directly in H
h43-in-H : inH 43 ≡ true
h43-in-H = refl

-- ============================================================
-- § 3: OGANESSON (Z = 118) IS FORBIDDEN
-- 118 = 2 · 59, and 59 is foreign
-- ============================================================

og-factor : 118 ≡ 2 * 59
og-factor = refl

og-foreign-59 : isForeign 59 ≡ true
og-foreign-59 = refl

-- ============================================================
-- § 4: ELECTRON SHELL CAPACITY = Nw · n²
-- ============================================================

electronShellCap : ℕ → ℕ
electronShellCap n = Nw * n * n

eshell-1 : electronShellCap 1 ≡ 2
eshell-1 = refl

eshell-2 : electronShellCap 2 ≡ 8
eshell-2 = refl

eshell-3 : electronShellCap 3 ≡ 18
eshell-3 = refl

eshell-4 : electronShellCap 4 ≡ 32
eshell-4 = refl

eshell-5 : electronShellCap 5 ≡ 50
eshell-5 = refl

-- ============================================================
-- § 5: NOBLE GAS Z = CUMULATIVE SHELL FILLING
-- ============================================================

noble-z-He : 2 ≡ 2
noble-z-He = refl

noble-z-Ne : 10 ≡ 2 + 8
noble-z-Ne = refl

noble-z-Ar : 18 ≡ 2 + 8 + 8
noble-z-Ar = refl

noble-z-Kr : 36 ≡ 2 + 8 + 8 + 18
noble-z-Kr = refl

noble-z-Xe : 54 ≡ 2 + 8 + 8 + 18 + 18
noble-z-Xe = refl

noble-z-Rn : 86 ≡ 2 + 8 + 8 + 18 + 18 + 32
noble-z-Rn = refl

-- ============================================================
-- § 6: BILINEAR PARENT — n² vs n(n+1), gap = n
-- ============================================================

pronic : ℕ → ℕ
pronic n = n * (n + 1)

square : ℕ → ℕ
square n = n * n

gap-1 : pronic 1 ∸ square 1 ≡ 1
gap-1 = refl

gap-2 : pronic 2 ∸ square 2 ≡ 2
gap-2 = refl

gap-3 : pronic 3 ∸ square 3 ≡ 3
gap-3 = refl

gap-4 : pronic 4 ∸ square 4 ≡ 4
gap-4 = refl

gap-5 : pronic 5 ∸ square 5 ≡ 5
gap-5 = refl

gap-6 : pronic 6 ∸ square 6 ≡ 6
gap-6 = refl

gap-7 : pronic 7 ∸ square 7 ≡ 7
gap-7 = refl

-- ============================================================
-- § 7: SHELL CAPACITY DIFFERENCES = Nw · (2n + 1)
-- ============================================================

cap-diff-1 : electronShellCap 2 ∸ electronShellCap 1 ≡ 2 * 3
cap-diff-1 = refl

cap-diff-2 : electronShellCap 3 ∸ electronShellCap 2 ≡ 2 * 5
cap-diff-2 = refl

cap-diff-3 : electronShellCap 4 ∸ electronShellCap 3 ≡ 2 * 7
cap-diff-3 = refl

cap-diff-4 : electronShellCap 5 ∸ electronShellCap 4 ≡ 2 * 9
cap-diff-4 = refl

-- ============================================================
-- § 8: 5 IS BLESSED VIA 4p-1 CRITERION
-- ============================================================

blessed-5-via : 4 * 5 ∸ 1 ≡ 19
blessed-5-via = refl

h19-in-H : inH 19 ≡ true
h19-in-H = refl
