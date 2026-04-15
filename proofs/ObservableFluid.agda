-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

module ObservableFluid where

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

sigmaD : ℕ
sigmaD = 1 + 3 + (nC * nC - 1) + (nW * nW - 1) * (nC * nC - 1)

gauss : ℕ
gauss = nC * nC + nW * nW

towerD : ℕ
towerD = sigmaD + chi

-- Kolmogorov: (Nc+Nw)/Nc = 5/3, cross: 5*Nc = 3*(Nc+Nw)
kolmo-cross : (nC + nW) * 3 ≡ nC * 5
kolmo-cross = refl

-- Kolmogorov micro: N_w^2 = 4
kolmo-micro : nW * nW ≡ 4
kolmo-micro = refl

-- Von Kármán: Nw/(Nc+Nw) = 2/5, cross: 2*5 = (Nc+Nw)*Nw
karman-cross : nW * 5 ≡ (nC + nW) * nW
karman-cross = refl

-- Reynolds: D*(D+gauss) = 42*55 = 2310
reynolds : towerD * (towerD + gauss) ≡ 2310
reynolds = refl

-- Prandtl denominators
prandtl-first : gauss - nC ≡ 10
prandtl-first = refl

prandtl-second : gauss * gauss - nW ≡ 167
prandtl-second = refl

-- Blasius: Nc+1 = 4
blasius : nC + 1 ≡ 4
blasius = refl

-- Kleiber: Nc = 3, Nc+1 = 4 (sum = 1: 1/4 + 3/4)
kleiber-sum : 1 * (nC + 1) ≡ 1 + nC
kleiber-sum = refl

-- Planck: chi-1 = 5
planck : chi - 1 ≡ 5
planck = refl

-- Rayleigh: chi = 6, Nw^2 = 4
rayleigh-size : chi ≡ 6
rayleigh-size = refl

rayleigh-lam : nW * nW ≡ 4
rayleigh-lam = refl
