-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

module ObservableAlphaProton where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

nW : ℕ
nW = 2

nC : ℕ
nC = 3

chi : ℕ
chi = nW * nC

beta0 : ℕ
beta0 = 7

d1 : ℕ
d1 = 1

d2 : ℕ
d2 = 3

d3 : ℕ
d3 = 8

d4 : ℕ
d4 = 24

sigmaD : ℕ
sigmaD = d1 + d2 + d3 + d4

gauss : ℕ
gauss = nC * nC + nW * nW

towerD : ℕ
towerD = sigmaD + chi

-- Sigma_d^2 = 1 + 9 + 64 + 576 = 650
sigmaD2 : ℕ
sigmaD2 = d1 * d1 + d2 * d2 + d3 * d3 + d4 * d4

sigmaD2-val : sigmaD2 ≡ 650
sigmaD2-val = refl

-- gauss^2 = 169
gauss-sq : gauss * gauss ≡ 169
gauss-sq = refl

-- gauss^2 + d4 = 193
sindy-sum : gauss * gauss + d4 ≡ 193
sindy-sum = refl

-- D^2 + Sigma_d = 1764 + 36 = 1800
mpme-sum : towerD * towerD + sigmaD ≡ 1800
mpme-sum = refl

-- 2 * 1800 / 8 = 450
mpme-term1 : 2 * (towerD * towerD + sigmaD) ≡ d3 * 450
mpme-term1 = refl

-- gauss^3 = 2197
gauss-cubed : gauss * gauss * gauss ≡ 2197
gauss-cubed = refl

-- alpha corr denom: chi * d4 * 650 * 42
alpha-corr : chi * d4 * sigmaD2 * towerD ≡ 3931200
alpha-corr = refl

-- mpme corr denom: Nw * chi * 650 * 42
mpme-corr : nW * chi * sigmaD2 * towerD ≡ 327600
mpme-corr = refl

-- sin2tw corr denom: d4 * 650
sin2-corr : d4 * sigmaD2 ≡ 15600
sin2-corr = refl

-- ratio: 3931200 / 327600 = 12 = d4/Nw
corr-ratio : 12 * 327600 ≡ 3931200
corr-ratio = refl

d4-over-nw : d4 ≡ 12 * nW
d4-over-nw = refl

-- D + 1 = 43 (Tower staircase steps)
staircase : towerD + 1 ≡ 43
staircase = refl
