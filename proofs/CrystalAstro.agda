-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
module CrystalAstro where
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
-- Polytropes
poly-rel : nC ≡ 3
poly-rel = refl
-- BH & radiation
schwarz : nW ≡ 2
schwarz = refl
hawking : dColour ≡ 8
hawking = refl
sb-denom : nC * 5 ≡ 15
sb-denom = refl
eddington : nW * nW ≡ 4
eddington = refl
-- Main sequence
ms-lum : 7 + 1 ≡ dColour
ms-lum = refl
ms-life : 5 + 1 ≡ chi
ms-life = refl
-- Structure
virial : nW ≡ 2
virial = refl
-- Cross-checks
hawking-edd : dColour * (nW * nW) ≡ 32
hawking-edd = refl
ms-sum : nW + 5 ≡ 7
ms-sum = refl
