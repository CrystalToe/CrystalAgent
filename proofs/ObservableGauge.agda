-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- ObservableGauge.agda — Component 7 (Gauge): coupling + mass identities.
-- All proofs by refl. Zero postulates.

module ObservableGauge where

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

-- alpha_inv staircase steps: D+1 = 43
staircase : towerD + 1 ≡ 43
staircase = refl

-- sin^2 theta_W(OS) = N_w/N_c^2: denom = 9
sin2w-os-denom : nC * nC ≡ 9
sin2w-os-denom = refl

sin2w-os-numer : nW ≡ 2
sin2w-os-numer = refl

-- sin^2 theta_W(MS) = N_c/gauss: gauss = 13
sin2w-ms-denom : gauss ≡ 13
sin2w-ms-denom = refl

sin2w-ms-numer : nC ≡ 3
sin2w-ms-numer = refl

-- alpha_s = N_w/(N_c^2 + d_col) = 2/17
alpha-s-denom : nC * nC + d3 ≡ 17
alpha-s-denom = refl

alpha-s-numer : nW ≡ 2
alpha-s-numer = refl

-- Koide = 2/3: cross-multiply 2*3 = 6
koide-cross : 2 * 3 ≡ 6
koide-cross = refl

-- g_A = N_c^2/beta_0 = 9/7
ga-numer : nC * nC ≡ 9
ga-numer = refl

ga-denom : beta0 ≡ 7
ga-denom = refl

-- alpha(M_Z)^-1: gauss^2 = 169, D = 42
alpha-mz-gauss-sq : gauss * gauss ≡ 169
alpha-mz-gauss-sq = refl

alpha-mz-diff : gauss * gauss - towerD ≡ 127
alpha-mz-diff = refl

-- N_gen = N_w^2 - 1 = 3
ngen : nW * nW - 1 ≡ 3
ngen = refl

-- VEV exponent: D + d3 = 50
vev-exp : towerD + d3 ≡ 50
vev-exp = refl

-- VEV numerator: Sigma_d - 1 = 35
vev-numer : sigmaD - 1 ≡ 35
vev-numer = refl

-- VEV denominator: (D+1) * Sigma_d = 1548
vev-denom : (towerD + 1) * sigmaD ≡ 1548
vev-denom = refl

-- M_Z base: N_c/(N_c^2-1) = 3/8
mz-base-numer : nC ≡ 3
mz-base-numer = refl

mz-base-denom : nC * nC - 1 ≡ 8
mz-base-denom = refl

-- M_Z implosion: (D+1)(chi-1) = 215
mz-implosion : (towerD + 1) * (chi - 1) ≡ 215
mz-implosion = refl

-- M_Z corrected: 637/1720
-- 3/8 - 1/215: cross 3*215 - 8 = 645-8 = 637, 8*215 = 1720
mz-corr-numer : 3 * 215 - 8 ≡ 637
mz-corr-numer = refl

mz-corr-denom : 8 * 215 ≡ 1720
mz-corr-denom = refl

-- M_W: cos^2 theta_W = 1 - 3/13 = 10/13
mw-cos2-numer : gauss - nC ≡ 10
mw-cos2-numer = refl

-- Gamma_W: N_c^2 = 9 (colour factor)
gamma-w-factor : nC * nC ≡ 9
gamma-w-factor = refl

-- One-loop denominator: N_w^4 = 16
oneloop : nW * nW * nW * nW ≡ 16
oneloop = refl

-- Hierarchy: D + d3 = 50
hierarchy : towerD + d3 ≡ 50
hierarchy = refl

-- beta_0 derivation
beta0-check : 3 * beta0 ≡ 11 * nC - 2 * chi
beta0-check = refl
