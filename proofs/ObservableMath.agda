-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

module ObservableMath where

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

gauss : ℕ
gauss = nC * nC + nW * nW

towerD : ℕ
towerD = 1 + 3 + (nC * nC - 1) + (nW * nW - 1) * (nC * nC - 1) + chi

-- e: (gauss+chi)/beta0 = 19/7
euler-numer : gauss + chi ≡ 19
euler-numer = refl

euler-denom : beta0 ≡ 7
euler-denom = refl

-- phi: gauss = 13, N_w^3 = 8
phi-numer : gauss ≡ 13
phi-numer = refl

phi-denom : nW * nW * nW ≡ 8
phi-denom = refl

phi-corr : gauss * nW * beta0 ≡ 182
phi-corr = refl

-- Catalan: D + chi = 48
catalan-denom : towerD + chi ≡ 48
catalan-denom = refl

-- Bekenstein
bekenstein : nW * nW ≡ 4
bekenstein = refl

-- Lagrange
lagrange : chi - 1 ≡ 5
lagrange = refl

-- 3-body
threebody : nC * chi ≡ 18
threebody = refl

-- R ratio: sum Q^2 for uds. N_c * (4+1+1) = 3*6 = 18, /9 = 2.
-- Cross: N_c * 6 = 18, 18/9 = 2. Check: 2*9 = 18 = N_c*chi
r-cross : nC * chi ≡ 2 * (nC * nC)
r-cross = refl
