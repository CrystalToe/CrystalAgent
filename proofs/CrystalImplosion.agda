-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalImplosion.agda — Component 9: Implosion channel identities.
-- All proofs by refl. Zero postulates.

module CrystalImplosion where

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

sigmaD2 : ℕ
sigmaD2 = d1 * d1 + d2 * d2 + d3 * d3 + d4 * d4

gauss : ℕ
gauss = nC * nC + nW * nW

towerD : ℕ
towerD = sigmaD + chi

-- Shared core
shared-core : sigmaD2 * towerD ≡ 27300
shared-core = refl

sigmaD2-is-650 : sigmaD2 ≡ 650
sigmaD2-is-650 = refl

-- Channel denominators
colour-channel : chi * d4 ≡ 144
colour-channel = refl

weak-channel : nW * chi ≡ 12
weak-channel = refl

mixed-channel : d3 * sigmaD ≡ 288
mixed-channel = refl

d4-squared : d4 * d4 ≡ 576
d4-squared = refl

full-channel : towerD ≡ 42
full-channel = refl

-- r_p dual route: 2 x d_3 x Sigma_d = d_4^2
rp-dual : 2 * d3 * sigmaD ≡ d4 * d4
rp-dual = refl

rp-dual-val : 2 * d3 * sigmaD ≡ 576
rp-dual-val = refl

-- Upsilon dual route: N_c^3 x (N_w x Sigma_d) = N_c^2 x (chi x Sigma_d)
-- Both evaluate to N_c^2 x N_w x Sigma_d = 9 x 72 = 648
-- So N_c^3/(chi x Sigma_d) = N_c^2/(N_w x Sigma_d) when chi = N_w x N_c
upsilon-route-a : nC * nC * nC ≡ 27
upsilon-route-a = refl

upsilon-denom-a : chi * sigmaD ≡ 216
upsilon-denom-a = refl

upsilon-denom-b : nW * sigmaD ≡ 72
upsilon-denom-b = refl

upsilon-route-b : nC * nC ≡ 9
upsilon-route-b = refl

-- 27/216 = 9/72 (cross-multiply)
upsilon-cross : 27 * 72 ≡ 9 * 216
upsilon-cross = refl

-- D meson dual route
d-meson-denom : d4 * sigmaD ≡ 864
d-meson-denom = refl

-- rho meson dual route: T_F x Sigma_d = chi x N_c (both = 18)
-- Cross-multiply: 1 x sigmaD = 2 x chi x N_c? No.
-- T_F/chi = 1/(2chi) and N_c/Sigma_d = 3/36 = 1/12. Check 2*chi = 12 = Sigma_d/N_c * N_c? 
-- Actually: 2 * chi = 12 and sigmaD = 36 and N_c = 3
-- 1/(2*chi) = 1/12 and N_c/sigmaD = 3/36 = 1/12. Cross: 1*sigmaD = 2*chi*N_c
rho-cross : sigmaD ≡ 2 * chi * nC
rho-cross = refl

rho-val : 2 * chi ≡ 12
rho-val = refl

-- phi meson dual route: N_w x (d_4 x Sigma_d) = (d_4 - d_3) x (N_c x Sigma_d)
-- N_w/(N_c x Sigma_d) = (d_4-d_3)/(d_4 x Sigma_d)
-- Cross: N_w x d_4 x Sigma_d = (d_4-d_3) x N_c x Sigma_d
-- N_w x d_4 = (d_4-d_3) x N_c ... 2 x 24 = 16 x 3 = 48. Yes.
phi-cross : nW * d4 ≡ (d4 - d3) * nC
phi-cross = refl

phi-numer : d4 - d3 ≡ 16
phi-numer = refl

phi-denom : nC * sigmaD ≡ 108
phi-denom = refl

-- Omega_DM dual route: gauss x (gauss - N_c) = N_w x (chi-1) x gauss
-- gauss - N_c = N_w x (chi - 1)
-- 13 - 3 = 2 x 5 = 10. Yes.
omega-dm-val : gauss * (gauss - nC) ≡ 130
omega-dm-val = refl

omega-dm-alt : nW * (chi - 1) * gauss ≡ 130
omega-dm-alt = refl

omega-dm-factor : gauss - nC ≡ nW * (chi - 1)
omega-dm-factor = refl

-- sin^2 theta_13 dual route
sin13-denom-a : (towerD + (nW * nW - 1)) * (nW * nW) * ((chi - 1) * (chi - 1)) ≡ 4500
sin13-denom-a = refl

sin13-denom-b : sigmaD * ((chi - 1) * (chi - 1) * (chi - 1)) ≡ 4500
sin13-denom-b = refl

-- eta meson dual route
eta-denom-a : nC * ((chi - 1) * (chi - 1)) ≡ 75
eta-denom-a = refl

eta-denom-b : nW * sigmaD + nC ≡ 75
eta-denom-b = refl

-- M_Z dual route
mz-denom : (towerD + 1) * (chi - 1) ≡ 215
mz-denom = refl

mz-alt : (sigmaD + chi + 1) * (nW * nC - 1) ≡ 215
mz-alt = refl

-- decuplet dual route
dec-denom : gauss * gauss ≡ 169
dec-denom = refl

-- muon dual route
muon-denom-a : d3 * (2 * chi - 1) ≡ 88
muon-denom-a = refl

muon-denom-b : nW * nW * nW * nW * (chi - 1) + d3 ≡ 88
muon-denom-b = refl
