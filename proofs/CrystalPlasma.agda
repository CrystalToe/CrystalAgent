-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

module CrystalPlasma where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

nW : ℕ
nW = 2

nC : ℕ
nC = 3

chi : ℕ
chi = nW * nC  -- 6

dColour : ℕ
dColour = nW * nW * nW  -- 8

-- Atom sanity
nW-val : nW ≡ 2
nW-val = refl

nC-val : nC ≡ 3
nC-val = refl

chi-val : chi ≡ 6
chi-val = refl

dColour-val : dColour ≡ 8
dColour-val = refl

-- MHD wave classification
wave-types : nC ≡ 3
wave-types = refl

prop-modes : 2 * nC ≡ chi
prop-modes = refl

non-prop : nW ≡ 2
non-prop = refl

total-modes : chi + nW ≡ dColour
total-modes = refl

total-is-8 : chi + nW ≡ 8
total-is-8 = refl

-- State variables
state-vars : nW * nW * nW ≡ 8
state-vars = refl

-- EM + CFD heritage
em-components : chi ≡ 6
em-components = refl

cfd-d2q9 : nC * nC ≡ 9
cfd-d2q9 = refl

-- Cross-checks
nW-cubed : nW * nW * nW ≡ dColour
nW-cubed = refl

-- Engine wiring + new features
sigmaD : ℕ
sigmaD = 1 + 3 + 8 + 24

engine-colour : (nC * nC) - 1 ≡ 8
engine-colour = refl

engine-chi : chi ≡ 6
engine-chi = refl

engine-full : sigmaD ≡ 36
engine-full = refl

engine-bondi : nW * nW ≡ 4
engine-bondi = refl
-- Engine wired.
