-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- ObservableMixing.agda — Component 7 (Mixing): CKM+PMNS identities.
-- All proofs by refl. Zero postulates.

module ObservableMixing where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

nW : ℕ
nW = 2

nC : ℕ
nC = 3

chi : ℕ
chi = nW * nC

d1 : ℕ
d1 = 1

d2 : ℕ
d2 = nW * nW - 1

d3 : ℕ
d3 = nC * nC - 1

d4 : ℕ
d4 = d2 * d3

sigmaD : ℕ
sigmaD = d1 + d2 + d3 + d4

gauss : ℕ
gauss = nC * nC + nW * nW

towerD : ℕ
towerD = sigmaD + chi

-- |V_us| denominator: Sigma_d + N_w^2 = 36 + 4 = 40
vus-denom : sigmaD + nW * nW ≡ 40
vus-denom = refl

-- |V_us| numerator: N_c^2 = 9
vus-numer : nC * nC ≡ 9
vus-numer = refl

-- Wolfenstein A denominator: N_c + N_w = 5
wolf-a-denom : nC + nW ≡ 5
wolf-a-denom = refl

-- Wolfenstein A numerator: N_w^2 = 4
wolf-a-numer : nW * nW ≡ 4
wolf-a-numer = refl

-- |V_cb| = A x lambda^2: check 4 x 81 = 324 and 5 x 1600 = 8000
-- So V_cb = 324/8000 = 81/2000
vcb-numer : 4 * 81 ≡ 324
vcb-numer = refl

vcb-denom : 5 * 1600 ≡ 8000
vcb-denom = refl

-- V_cb simplifies: 324/8000 = 81/2000 (divide by 4)
vcb-simplify : 324 * 2000 ≡ 81 * 8000
vcb-simplify = refl

-- Jarlskog: (N_w+N_c) = 5
jarl-numer : nW + nC ≡ 5
jarl-numer = refl

-- N_w^3 x N_c^5 = 8 x 243 = 1944
jarl-denom : nW * nW * nW * (nC * nC * nC * nC * nC) ≡ 1944
jarl-denom = refl

-- sin^2 theta_23: 2chi-1 = 11
sinSq23-denom : 2 * chi - 1 ≡ 11
sinSq23-denom = refl

sinSq23-numer : chi ≡ 6
sinSq23-numer = refl

-- sin^2 theta_13 corrected: 11/500
sinSq13-numer : 2 * chi - 1 ≡ 11
sinSq13-numer = refl

sinSq13-denom : nW * nW * ((chi - 1) * (chi - 1) * (chi - 1)) ≡ 500
sinSq13-denom = refl

-- sin^2 theta_W: gauss = 13
sinSqW-denom : gauss ≡ 13
sinSqW-denom = refl

sinSqW-numer : nC ≡ 3
sinSqW-numer = refl

-- cos(2 delta_PMNS) = (d2^2 - d1^2)/(d2^2 + d1^2) = 8/10 = 4/5
cos2-numer : d2 * d2 - d1 * d1 ≡ 8
cos2-numer = refl

cos2-denom : d2 * d2 + d1 * d1 ≡ 10
cos2-denom = refl

-- Cross: 8 x 5 = 4 x 10 (proves 8/10 = 4/5)
cos2-simplify : 8 * 5 ≡ 4 * 10
cos2-simplify = refl

-- Dual route for sin^2 theta_13: both denominators = 4500
sinSq13-dual-a : (towerD + nW * nW - 1) * (nW * nW) * ((chi - 1) * (chi - 1)) ≡ 4500
sinSq13-dual-a = refl

sinSq13-dual-b : sigmaD * ((chi - 1) * (chi - 1) * (chi - 1)) ≡ 4500
sinSq13-dual-b = refl

-- Berry phase vectors
ckm-real : d2 ≡ 3
ckm-real = refl

ckm-imag : d3 ≡ 8
ckm-imag = refl

pmns-real : d2 ≡ 3
pmns-real = refl

pmns-imag : d1 ≡ 1
pmns-imag = refl

-- Total mixing observables
obs-count : 13 ≡ 13
obs-count = refl
