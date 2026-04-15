-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

module CrystalProtein where

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
sigmaD2 : ℕ
sigmaD2 = d1 * d1 + d2 * d2 + d3 * d3 + d4 * d4

staircase : towerD + 1 ≡ 43
staircase = refl

shared-core : sigmaD2 * towerD ≡ 27300
shared-core = refl

rama-denom : nW * nW * (nW * nW) * (nW * nW) ≡ 64
rama-denom = refl

rama-numer : sigmaD ≡ 36
rama-numer = refl

helix-numer : nC * chi ≡ 18
helix-numer = refl

helix-denom : chi - 1 ≡ 5
helix-denom = refl

dof-tile : 4 * 9 ≡ sigmaD
dof-tile = refl

imp-hbond : gauss - 1 ≡ 12
imp-hbond = refl

imp-vdw-dist : d4 * d4 ≡ 576
imp-vdw-dist = refl

imp-hb-dist : nC * nC * nC * nW ≡ 54
imp-hb-dist = refl

sin2-corr : d4 * sigmaD2 ≡ 15600
sin2-corr = refl

epsilon-r : nW * nW * nW * nW ≡ 16
epsilon-r = refl

cosmo-split : 29 + 11 + 2 ≡ towerD
cosmo-split = refl

cooling-cross : 5 * sigmaD ≡ 36 * (chi - 1)
cooling-cross = refl
