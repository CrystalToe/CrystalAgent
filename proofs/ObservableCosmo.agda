-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- ObservableCosmo.agda — Component 7 (Cosmo): cosmological identities.
-- All proofs by refl. Zero postulates.

module ObservableCosmo where

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

-- Omega_Lambda + Omega_m = 1: gauss + chi = gauss + chi (trivial)
omega-sum : gauss + chi ≡ 19
omega-sum = refl

omega-l-numer : gauss ≡ 13
omega-l-numer = refl

omega-m-numer : chi ≡ 6
omega-m-numer = refl

-- Omega_L/Omega_m = gauss/chi: cross 13*6 = 78, 6*13 = 78
ratio-cross : gauss * chi ≡ chi * gauss
ratio-cross = refl

ratio-val : gauss * 6 ≡ 78
ratio-val = refl

-- 100*theta denominator: N_w*(D+chi) = 2*48 = 96
theta-denom : nW * (towerD + chi) ≡ 96
theta-denom = refl

-- T_CMB: (gauss+chi)/beta0 = 19/7: cross 19*1 = 19
tcmb-numer : gauss + chi ≡ 19
tcmb-numer = refl

tcmb-denom : beta0 ≡ 7
tcmb-denom = refl

-- Age: gauss * beta0 + chi = 91 + 6 = 97
age-numer : gauss * beta0 + chi ≡ 97
age-numer = refl

age-denom : beta0 ≡ 7
age-denom = refl

-- Omega_DM implosion: gauss*(gauss-N_c) = 13*10 = 130
dm-implosion : gauss * (gauss - nC) ≡ 130
dm-implosion = refl

-- Dual route: N_w*(chi-1)*gauss = 2*5*13 = 130
dm-dual : nW * (chi - 1) * gauss ≡ 130
dm-dual = refl

-- DM/baryon: N_w^2 * N_c = 12
dm-baryon-numer : nW * nW * nC ≡ 12
dm-baryon-numer = refl

-- ln(10^10 A_s): N_c * beta0 = 21
amplitude : nC * beta0 ≡ 21
amplitude = refl

-- Neutrino: 2^42 is the tower power
tower-depth : towerD ≡ 42
tower-depth = refl

-- nu3 correction: 10/11 = (2chi-2)/(2chi-1)
nu3-corr-numer : 2 * chi - 2 ≡ 10
nu3-corr-numer = refl

nu3-corr-denom : 2 * chi - 1 ≡ 11
nu3-corr-denom = refl

-- nu2 correction: 12/13 = (gauss-1)/gauss
nu2-corr-numer : gauss - 1 ≡ 12
nu2-corr-numer = refl

-- nu1: chi^2 = 36
chi-sq : chi * chi ≡ 36
chi-sq = refl

-- Omega_b denominator: N_c*(gauss+beta0)+1 = 3*20+1 = 61
omega-b-denom : nC * (gauss + beta0) + 1 ≡ 61
omega-b-denom = refl

-- w = -1 (trivial, it's a definition)
