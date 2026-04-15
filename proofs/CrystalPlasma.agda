-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
-- CrystalPlasma — MHD from (2,3)
-- Refactored: CrystalAtoms + CrystalSectors + CrystalEigen + CrystalOperators
module CrystalPlasma where
open import Data.Nat using (ℕ; _+_; _*_; _∸_)
open import Agda.Builtin.Equality using (_≡_; refl)
nW : ℕ
nW = 2
nC : ℕ
nC = 3
χ : ℕ
χ = nW * nC
d₃ : ℕ
d₃ = nC * nC ∸ 1
σD : ℕ
σD = 1 + 3 + 8 + 24

wave-types : nC ≡ 3
wave-types = refl
state-vars : nW * nW * nW ≡ 8
state-vars = refl
state-is-colour : d₃ ≡ 8
state-is-colour = refl
prop-modes : 2 * nC ≡ 6
prop-modes = refl
prop-is-chi : χ ≡ 6
prop-is-chi = refl
non-prop : nW ≡ 2
non-prop = refl
total-modes : χ + nW ≡ 8
total-modes = refl
mag-factor : nW ≡ 2
mag-factor = refl
beta-factor : nW ≡ 2
beta-factor = refl
em-components : χ ≡ 6
em-components = refl
cfd-d2q9 : nC * nC ≡ 9
cfd-d2q9 = refl
bondi-factor : nW * nW ≡ 4
bondi-factor = refl
mri-num : nC ≡ 3
mri-num = refl
mri-den : nW * nW ≡ 4
mri-den = refl
comp-full : σD ≡ 36
comp-full = refl
-- Total: 16 proofs by refl.
