-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- ObservableType.agda — VEV derivation and rating threshold identities.

module ObservableType where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

nW : ℕ
nW = 2

nC : ℕ
nC = 3

d3 : ℕ
d3 = nC * nC - 1

sigmaD : ℕ
sigmaD = 1 + 3 + d3 + (nW * nW - 1) * d3

towerD : ℕ
towerD = sigmaD + nW * nC

-- VEV numerator: Sigma_d - 1 = 35
vev-numer : sigmaD - 1 ≡ 35
vev-numer = refl

-- VEV denominator part 1: D + 1 = 43
vev-staircase : towerD + 1 ≡ 43
vev-staircase = refl

-- VEV denominator part 2: Sigma_d = 36
vev-sigma : sigmaD ≡ 36
vev-sigma = refl

-- VEV exponent: D + d3 = 50
vev-exp : towerD + d3 ≡ 50
vev-exp = refl

-- Full denominator: (D+1) * Sigma_d = 1548
vev-denom : (towerD + 1) * sigmaD ≡ 1548
vev-denom = refl
