-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalAtoms.agda — Integer identities for the 15 building blocks.
-- All proofs by refl. Zero postulates. Every atom from N_w = 2, N_c = 3.

module CrystalAtoms where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

-- §0 The two primes
nW : ℕ
nW = 2

nC : ℕ
nC = 3

-- §1 Derived integers

chi : ℕ
chi = nW * nC

chi-val : chi ≡ 6
chi-val = refl

beta0 : ℕ
beta0 = 7

beta0-from-atoms : (11 * nC) ≡ (3 * beta0 + 2 * chi)
beta0-from-atoms = refl

d1 : ℕ
d1 = 1

d2 : ℕ
d2 = nW * nW - 1

d2-val : d2 ≡ 3
d2-val = refl

d3 : ℕ
d3 = nC * nC - 1

d3-val : d3 ≡ 8
d3-val = refl

d4 : ℕ
d4 = (nW * nW - 1) * (nC * nC - 1)

d4-val : d4 ≡ 24
d4-val = refl

sigmaD : ℕ
sigmaD = d1 + d2 + d3 + d4

sigmaD-val : sigmaD ≡ 36
sigmaD-val = refl

sigmaD2 : ℕ
sigmaD2 = d1 * d1 + d2 * d2 + d3 * d3 + d4 * d4

sigmaD2-val : sigmaD2 ≡ 650
sigmaD2-val = refl

towerD : ℕ
towerD = sigmaD + chi

towerD-val : towerD ≡ 42
towerD-val = refl

gauss : ℕ
gauss = nW * nW + nC * nC

gauss-val : gauss ≡ 13
gauss-val = refl

fermat3 : ℕ
fermat3 = 257

-- §2 Key identities

-- Mixed = weak ⊗ colour
mixed-tensor : d4 ≡ d2 * d3
mixed-tensor = refl

-- d₄ factors as N_c × (N_c² − 1)
d4-alt : d4 ≡ nC * d3
d4-alt = refl

-- Σd decomposition
sigmaD-sum : d1 + d2 + d3 + d4 ≡ 36
sigmaD-sum = refl

-- Tower = state space + internal
tower-decomp : sigmaD + chi ≡ 42
tower-decomp = refl

-- Product of eigenvalue denominators
eigen-product : 1 * nW * nC * chi ≡ sigmaD
eigen-product = refl

-- §3 CKM-related identities

vcb-num : d3 * d4 ≡ 192
vcb-num = refl

vcb-den : beta0 * sigmaD2 ≡ 4550
vcb-den = refl

-- 192 = 2⁶ × 3
vcb-factored-a : 64 * 3 ≡ 192
vcb-factored-a = refl

-- gauss² = 169
gauss-sq : gauss * gauss ≡ 169
gauss-sq = refl

-- Strong coupling denominator
alpha-s-den : gauss + nW * nW ≡ 17
alpha-s-den = refl

-- §4 Electroweak identities

-- sin²θ_W cross-multiply: N_c × 13 = 3 × gauss
sin2w-cross : nC * 13 ≡ 3 * gauss
sin2w-cross = refl

-- Hypercharge cross-multiply: d₃ × 39 = 8 × N_c × gauss
hypercharge-cross : d3 * 39 ≡ 8 * nC * gauss
hypercharge-cross = refl

-- §5 Neutrino suppression

nu-suppression : towerD * fermat3 * sigmaD ≡ 388584
nu-suppression = refl

-- §6 Chirality identities

left-total : 1 + nW + 4 + 12 ≡ 19
left-total = refl

right-total : 0 + 1 + 4 + 12 ≡ 17
right-total = refl

lr-sum : 19 + 17 ≡ sigmaD
lr-sum = refl

chiral-asym : 19 - 17 ≡ nW
chiral-asym = refl

-- §7 Block sizes for off-diagonal D_F

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

-- §8 Structural identities

-- d₄/d₂ = d₃ (stated as multiplication)
d4-from-d2d3 : d2 * d3 ≡ d4
d4-from-d2d3 = refl

-- d₄/d₃ = d₂ (stated as multiplication)
d4-from-d3d2 : d3 * d2 ≡ d4
d4-from-d3d2 = refl

-- Colour pairs: d₃ = 2 × 4
colour-pairs : 2 * 4 ≡ d3
colour-pairs = refl

-- Mixed groups: d₄ = d₃ × 3
mixed-groups : d3 * 3 ≡ d4
mixed-groups = refl

-- Matrix dimension squared
matrix-size : sigmaD * sigmaD ≡ 1296
matrix-size = refl

-- Off-diagonal count
off-diag-count : sigmaD * sigmaD - sigmaD ≡ 1260
off-diag-count = refl

-- §9 CP violation phase count
-- (N_c − 1)(N_c − 2)/2 = 1, stated as 2 × 1 = (N_c − 1) × (N_c − 2)
cp-phases : 2 * 1 ≡ (nC - 1) * (nC - 2)
cp-phases = refl

-- §10 Biology identities

amino-acids : nW * nW * (chi - 1) ≡ 20
amino-acids = refl

codons : 4 * 4 * 4 ≡ 64
codons = refl

codon-base : nW * nW ≡ 4
codon-base = refl
