-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
module CrystalQFT where

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

spacetime-dim : nW * nW ≡ 4
spacetime-dim = refl
lorentz-gen : nW * nW * (nW * nW) ≡ 16
lorentz-gen = refl
spinor-comp : nW ≡ 2
spinor-comp = refl
photon-pol : 2 + 1 ≡ nC
photon-pol = refl
gluon-colours : nW * nW * nW ≡ 8
gluon-colours = refl
d3-eq-dColour : nC * nC ≡ dColour + 1
d3-eq-dColour = refl
chi-val : chi ≡ 6
chi-val = refl
one-loop : nW * nW * nW * nW ≡ 16
one-loop = refl
thomson-num : dColour ≡ 8
thomson-num = refl
thomson-den : nC ≡ 3
thomson-den = refl
pair-factor : nW ≡ 2
pair-factor = refl
tower-plus-1 : towerD + 1 ≡ 43
tower-plus-1 = refl
ps-4body : nC * 4 ≡ dColour + (nC + 1)
ps-4body = refl
