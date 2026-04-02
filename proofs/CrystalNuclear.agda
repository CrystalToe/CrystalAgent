-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
module CrystalNuclear where
open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)
nW : ℕ
nW = 2
nC : ℕ
nC = 3
chi : ℕ
chi = nW * nC
dColour : ℕ
dColour = nW * nW * nW
sigmaD : ℕ
sigmaD = 1 + 3 + 8 + 24
towerD : ℕ
towerD = sigmaD + chi
-- Magic numbers
magic-2 : nW ≡ 2
magic-2 = refl
magic-8 : dColour ≡ 8
magic-8 = refl
magic-20 : nW * nW * 5 ≡ 20
magic-20 = refl
magic-28 : nW * nW * 7 ≡ 28
magic-28 = refl
magic-50 : nW * 5 * 5 ≡ 50
magic-50 = refl
magic-82 : nW * 41 ≡ 82
magic-82 = refl
magic-126 : nW * 7 * (nC * nC) ≡ 126
magic-126 = refl
-- Structure
alpha-a : nW * nW ≡ 4
alpha-a = refl
iron-peak : dColour * 7 ≡ 56
iron-peak = refl
he4-bind : nW * nW * 7 ≡ 28
he4-bind = refl
isospin : nW ≡ 2
isospin = refl
sigmaD-val : sigmaD ≡ 36
sigmaD-val = refl
