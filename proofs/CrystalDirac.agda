-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalDirac.agda — Integer identities for D_F, J, γ operators

module CrystalDirac where

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

sigmaD2 : ℕ
sigmaD2 = d1 * d1 + d2 * d2 + d3 * d3 + d4 * d4

gauss : ℕ
gauss = nW * nW + nC * nC

towerD : ℕ
towerD = sigmaD + chi

fermat3 : ℕ
fermat3 = 257

-- §1 Matrix dimensions
df-dim : sigmaD ≡ 36
df-dim = refl

df-entries : sigmaD * sigmaD ≡ 1296
df-entries = refl

df-off-diag : sigmaD * sigmaD - sigmaD ≡ 1260
df-off-diag = refl

-- §2 Electroweak mixing
sin2w-num : nC ≡ 3
sin2w-num = refl

sin2w-den : gauss ≡ 13
sin2w-den = refl

sin2w-cross : nC * 13 ≡ 3 * gauss
sin2w-cross = refl

hypercharge-num : d3 ≡ 8
hypercharge-num = refl

hypercharge-cross : d3 * 39 ≡ 8 * nC * gauss
hypercharge-cross = refl

-- §3 Strong coupling
alpha-s-den : gauss + nW * nW ≡ 17
alpha-s-den = refl

alpha-s-cross : nW * 17 ≡ 2 * 17
alpha-s-cross = refl

-- §4 CKM
vcb-num : d3 * d4 ≡ 192
vcb-num = refl

vcb-den : beta0 * sigmaD2 ≡ 4550
vcb-den = refl

vcb-factored : 64 * 3 ≡ 192
vcb-factored = refl

vub-den : gauss * gauss ≡ 169
vub-den = refl

-- §5 J operator
-- 8/2 = 4, stated as 2×4 = 8
colour-pairs : 2 * 4 ≡ d3
colour-pairs = refl

-- d₄/d₃ = 3, stated as d₃×3 = d₄
mixed-groups : d3 * 3 ≡ d4
mixed-groups = refl

-- d₄/d₃ = d₂, stated as d₃×d₂ = d₄
mixed-eq-d2 : d3 * d2 ≡ d4
mixed-eq-d2 = refl

-- §6 γ grading
left-dof : 1 + nW + 4 + 12 ≡ 19
left-dof = refl

right-dof : 0 + 1 + 4 + 12 ≡ 17
right-dof = refl

lr-sum : 19 + 17 ≡ 36
lr-sum = refl

lr-eq-sigma : 19 + 17 ≡ sigmaD
lr-eq-sigma = refl

chiral-asymmetry : 19 - 17 ≡ nW
chiral-asymmetry = refl

left-weak : nW ≡ 2
left-weak = refl

right-weak : d2 - nW ≡ 1
right-weak = refl

-- §7 Sector mixing blocks
block-01 : d1 * d2 ≡ 3
block-01 = refl

block-02 : d1 * d3 ≡ 8
block-02 = refl

block-03 : d1 * d4 ≡ 24
block-03 = refl

block-12 : d2 * d3 ≡ 24
block-12 = refl

block-13 : d2 * d4 ≡ 72
block-13 = refl

block-23 : d3 * d4 ≡ 192
block-23 = refl

total-off-diag : 2 * (3 + 8 + 24 + 24 + 72 + 192) ≡ 646
total-off-diag = refl

-- §8 CP violation
cp-phases : 1 ≡ 1
cp-phases = refl

-- §9 Mixed = weak ⊗ colour
mixed-tensor : d2 * d3 ≡ d4
mixed-tensor = refl

colour-mixed : d3 * d4 ≡ d3 * d3 * d2
colour-mixed = refl

strong-block : d3 * d3 ≡ 64
strong-block = refl

-- §10 Neutrino suppression
nu-suppression : towerD * fermat3 * sigmaD ≡ 388584
nu-suppression = refl
