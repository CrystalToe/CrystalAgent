-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

module CrystalNoether where

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
d2 = nC
d3 : ℕ
d3 = nC * nC - 1
d4 : ℕ
d4 = nC * nC * nC - nC
sigmaD : ℕ
sigmaD = d1 + d2 + d3 + d4
towerD : ℕ
towerD = sigmaD + chi
gauss : ℕ
gauss = nC * nC + nW * nW

gauge-total : 1 + (nW * nW - 1) + d3 ≡ 12
gauge-total = refl

lorentz-chi : nC * (nC + 1) ≡ 2 * chi
lorentz-chi = refl

solvable : gauss - nC ≡ 10
solvable = refl

algebra-dim : 1 + nW * nW + nC * nC ≡ 14
algebra-dim = refl

carnot : 5 * chi ≡ (chi - 1) * chi
carnot = refl

stefan : nW * nC * (gauss + beta0) ≡ 120
stefan = refl

lattice : sigmaD ≡ chi * chi
lattice = refl

neutron : towerD * towerD ≡ 882 * nW
neutron = refl

karman : nW * 5 ≡ 2 * (chi - 1)
karman = refl

casimir : d3 * 3 ≡ 4 * (2 * nC)
casimir = refl

codons : (nW * nW) * (nW * nW) * (nW * nW) ≡ 64
codons = refl

amino : nC * beta0 ≡ 21
amino = refl

depth : (1 + nW * nW + nC * nC) * nC ≡ towerD
depth = refl

sd2 : d1 * d1 + d2 * d2 + d3 * d3 + d4 * d4 ≡ 650
sd2 = refl
