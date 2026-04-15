-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

module ObservableCondensed where

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

-- Euler-Mascheroni denominators
em-first : gauss - 1 ≡ 12
em-first = refl

em-second : gauss * gauss - nW ≡ 167
em-second = refl

-- Ising
ising : nW ≡ 2
ising = refl

ising-beta-denom : nW * nW * nW ≡ 8
ising-beta-denom = refl

cubic-z : chi ≡ 6
cubic-z = refl

-- Thermodynamics
carnot-numer : chi - 1 ≡ 5
carnot-numer = refl

stefan : nW * nC * (gauss + beta0) ≡ 120
stefan = refl

thermal-numer : chi * chi * (chi - 1) ≡ 180
thermal-numer = refl

thermal-denom : sigmaD ≡ 36
thermal-denom = refl

chandrasekhar : gauss + chi ≡ 19
chandrasekhar = refl

-- Feigenbaum
feigenbaum-numer : towerD ≡ 42
feigenbaum-numer = refl

feigenbaum-denom : nC * nC ≡ 9
feigenbaum-denom = refl

-- Cross: 14*9 = 3*42
feigenbaum-cross : 14 * (nC * nC) ≡ nC * towerD
feigenbaum-cross = refl

-- Routh
routh-denom : gauss + beta0 + chi ≡ 26
routh-denom = refl

-- Math: golden ratio 13/8, correction 1/182
phi-numer : gauss ≡ 13
phi-numer = refl

phi-denom : nW * nW * nW ≡ 8
phi-denom = refl

phi-corr : gauss * nW * beta0 ≡ 182
phi-corr = refl

-- Catalan: D + chi = 48
catalan-denom : towerD + chi ≡ 48
catalan-denom = refl
