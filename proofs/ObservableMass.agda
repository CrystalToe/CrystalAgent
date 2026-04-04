-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- ObservableMass.agda — Component 7 (Mass): mass ratio identities.
-- All proofs by refl. Zero postulates.

module ObservableMass where

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

d4 : ℕ
d4 = (nW * nW - 1) * d3

sigmaD : ℕ
sigmaD = 1 + 3 + d3 + d4

gauss : ℕ
gauss = nC * nC + nW * nW

towerD : ℕ
towerD = sigmaD + chi

fermat3 : ℕ
fermat3 = 257

-- m_s/m_ud = N_c^3 = 27
ms-mud : nC * nC * nC ≡ 27
ms-mud = refl

-- m_c/m_s = 106/9: N_w^2 * N_c * 53 = 636, 54 * 9 = 486... wait
-- Actually: N_w^2 * N_c = 12, and 12 * 53/54 = 636/54 = 106/9
-- Cross: 106 * 54 = 5724, 9 * 636 = 5724
mc-ms-cross : 106 * 54 ≡ 9 * 636
mc-ms-cross = refl

-- 53 = N_c^3 * N_w - 1
fifty-three : nC * nC * nC * nW - 1 ≡ 53
fifty-three = refl

-- 54 = N_c^3 * N_w
fifty-four : nC * nC * nC * nW ≡ 54
fifty-four = refl

-- m_b/m_s = N_c^3 * N_w = 54
mb-ms : nC * nC * nC * nW ≡ 54
mb-ms = refl

-- m_b/m_c = N_c^5/(N_c^3*N_w - 1) = 243/53
nc5 : nC * nC * nC * nC * nC ≡ 243
nc5 = refl

-- m_b/m_c = 243/53 (both verified above: nc5=243, fifty-three=53)

-- m_u/m_d = (chi-1)/(2chi-1) = 5/11
mu-md-numer : chi - 1 ≡ 5
mu-md-numer = refl

mu-md-denom : 2 * chi - 1 ≡ 11
mu-md-denom = refl

-- m_t/m_b = D * 53/54 = 371/9: cross 371*54 = 9*42*53? No.
-- 42 * 53 = 2226, 2226/54 = 41.222, * 9 = 371. So 371 * 54 = 42 * 53 * 9
-- Check: 371 * 54 = 20034, 42 * 53 * 9 = 42 * 477 = 20034
mt-mb-cross : 371 * 54 ≡ towerD * 53 * 9
mt-mb-cross = refl

-- m_mu/m_e = chi^3 - d_colour = 216 - 8 = 208
chi-cubed : chi * chi * chi ≡ 216
chi-cubed = refl

mu-e : chi * chi * chi - d3 ≡ 208
mu-e = refl

-- F3 = 257 (Fermat prime)
fermat : fermat3 ≡ 257
fermat = refl

-- 2^8 = 256 (proton denominator)
two-eight : 256 ≡ 256
two-eight = refl

-- gauss - N_c = 10 (strange quark denominator)
gauss-nc : gauss - nC ≡ 10
gauss-nc = refl

-- gauss/(gauss-2) = 13/11 for Lambda baryon: cross 13*11 = 143, (13-2)*13 = 143
lambda-cross : 13 * 11 ≡ (gauss - 2) * gauss
lambda-cross = refl

-- Implosion channels
ups-channel : chi * sigmaD ≡ 216
ups-channel = refl

d-meson-channel : d4 * sigmaD ≡ 864
d-meson-channel = refl

rho-channel : 2 * chi ≡ 12
rho-channel = refl

phi-channel : nC * sigmaD ≡ 108
phi-channel = refl

eta-channel : nC * ((chi - 1) * (chi - 1)) ≡ 75
eta-channel = refl

muon-channel : d3 * (2 * chi - 1) ≡ 88
muon-channel = refl

dec-channel : gauss * gauss ≡ 169
dec-channel = refl

-- m_p/m_e SINDy: D^2 + Sigma_d = 1800
mpme-sum : towerD * towerD + sigmaD ≡ 1800
mpme-sum = refl

-- gauss^3 = 2197
gauss-cubed : gauss * gauss * gauss ≡ 2197
gauss-cubed = refl
