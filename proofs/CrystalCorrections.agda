-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalCorrections.agda — Component 8: Correction level identities.
-- All proofs by refl. Zero postulates.

module CrystalCorrections where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

nW : ℕ
nW = 2

nC : ℕ
nC = 3

chi : ℕ
chi = nW * nC

d3 : ℕ
d3 = nC * nC - 1

d4 : ℕ
d4 = (nW * nW - 1) * d3

sigmaD : ℕ
sigmaD = 1 + 3 + d3 + d4

towerD : ℕ
towerD = sigmaD + chi

beta0 : ℕ
beta0 = 7

-- Beta function coefficients
-- beta_1 = (34 N_c^2 - 10 N_c chi + 3 chi) / 3
-- = (34 x 9 - 10 x 3 x 6 + 3 x 6) / 3
-- = (306 - 180 + 18) / 3 = 144/3 = 48
beta1-numer : 34 * (nC * nC) - 10 * nC * chi + 3 * chi ≡ 144
beta1-numer = refl

-- Can't do division by 3 directly, but verify:
beta1-check : 48 * 3 ≡ 34 * (nC * nC) - 10 * nC * chi + 3 * chi
beta1-check = refl

beta1-is-48 : 48 * 3 ≡ 144
beta1-is-48 = refl

-- One-loop denominator: 16 = N_w^4
oneloop-denom : nW * nW * nW * nW ≡ 16
oneloop-denom = refl

-- 16 pi^2 is the loop suppression (verified as integer part)
nw-fourth : nW * nW * nW * nW ≡ 16
nw-fourth = refl

-- beta_0 x beta_1 = 7 x 48 = 336
beta-product : beta0 * 48 ≡ 336
beta-product = refl

-- beta_0^2 = 49
beta0-sq : beta0 * beta0 ≡ 49
beta0-sq = refl

-- Level count: 8 levels (0 through 7)
level-count : 7 + 1 ≡ 8
level-count = refl

-- Tower + 1 = 43 (staircase steps, used in alpha_inv)
staircase-steps : towerD + 1 ≡ 43
staircase-steps = refl

-- d_3 = 8 (colour adjoint, appears in one-loop factor)
d3-is-8 : d3 ≡ 8
d3-is-8 = refl

-- N_c^2 = 9 (appears in one-loop factor denominator)
nc-sq : nC * nC ≡ 9
nc-sq = refl

-- 11 N_c = 33 (beta_0 numerator first term)
eleven-nc : 11 * nC ≡ 33
eleven-nc = refl

-- 2 chi = 12 (beta_0 numerator second term)
two-chi : 2 * chi ≡ 12
two-chi = refl

-- 33 - 12 = 21 = 3 x beta_0
beta0-numer : 11 * nC - 2 * chi ≡ 3 * beta0
beta0-numer = refl

-- beta_0 derivation (multiplication form)
beta0-deriv : 3 * beta0 ≡ 11 * nC - 2 * chi
beta0-deriv = refl

-- Total estimated observables: 60+45+35+20+15+10+8+55 = 248
obs-total : 60 + 45 + 35 + 20 + 15 + 10 + 8 + 55 ≡ 248
obs-total = refl
