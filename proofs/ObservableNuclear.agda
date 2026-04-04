-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- ObservableNuclear.agda — Component 7 (Nuclear): magic + SEMF identities.
-- All proofs by refl. Zero postulates.

module ObservableNuclear where

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

d3 : ℕ
d3 = nC * nC - 1

sigmaD : ℕ
sigmaD = 1 + 3 + d3 + (nW * nW - 1) * d3

gauss : ℕ
gauss = nC * nC + nW * nW

towerD : ℕ
towerD = sigmaD + chi

-- Magic numbers
magic-2 : nW ≡ 2
magic-2 = refl

magic-8 : d3 ≡ 8
magic-8 = refl

magic-20 : gauss + beta0 ≡ 20
magic-20 = refl

magic-28 : nW * nW * beta0 ≡ 28
magic-28 = refl

magic-50 : towerD + d3 ≡ 50
magic-50 = refl

magic-82 : nW * (towerD - 1) ≡ 82
magic-82 = refl

magic-126 : nW * beta0 * (nC * nC) ≡ 126
magic-126 = refl

-- Proton moment: 14/5
mu-p-numer : nW * beta0 ≡ 14
mu-p-numer = refl

mu-p-denom : chi - 1 ≡ 5
mu-p-denom = refl

-- Neutron moment: 174/91
-- N_w - N_w^3/(gauss*beta0): check 91*N_w - N_w^3 = 91*2-8 = 174
mu-n-cross : 91 * nW - nW * nW * nW ≡ 174
mu-n-cross = refl

mu-n-denom : gauss * beta0 ≡ 91
mu-n-denom = refl

-- Neutron lifetime: D^2/N_w - N_w^2
-- D^2 = 1764
d-sq : towerD * towerD ≡ 1764
d-sq = refl

-- 1764/2 - 4 = 878: check 878*2 + 4*2 = 1764
tau-n-cross : 878 * nW + nW * nW * nW ≡ towerD * towerD
tau-n-cross = refl

-- Iron peak
iron : d3 * beta0 ≡ 56
iron = refl

-- SEMF: check cross-multiplies
semf-surf : nW * 3 ≡ nC * 2
semf-surf = refl

semf-coul-pre : nC * 5 ≡ 3 * (chi - 1)
semf-coul-pre = refl

-- Deuteron: m_e * gauss/N_c: gauss/N_c = 13/3
deut-numer : gauss ≡ 13
deut-numer = refl

deut-denom : nC ≡ 3
deut-denom = refl

-- Alpha: D + gauss = 55, + N_c/beta0 = 3/7
alpha-int : towerD + gauss ≡ 55
alpha-int = refl

-- Proton radius: N_w^2 = 4, gauss*beta0 = 91
rp-zeroth : nW * nW ≡ 4
rp-zeroth = refl

rp-corr-denom : gauss * beta0 ≡ 91
rp-corr-denom = refl
