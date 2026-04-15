-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalOperators.agda — Integer identities for the five operators.
-- W, U, D_F, J, γ acting on the 36-dimensional state.
-- All proofs by refl. Zero postulates.

module CrystalOperators where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

-- Import atoms (repeated here for self-contained verification)
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

-- ═══════════════════════════════════════════════════════════════
-- §0 State space
-- ═══════════════════════════════════════════════════════════════

state-dim : sigmaD ≡ 36
state-dim = refl

-- Sector boundaries
sector0-end : d1 ≡ 1
sector0-end = refl

sector1-end : d1 + d2 ≡ 4
sector1-end = refl

sector2-end : d1 + d2 + d3 ≡ 12
sector2-end = refl

sector3-end : d1 + d2 + d3 + d4 ≡ 36
sector3-end = refl

-- ═══════════════════════════════════════════════════════════════
-- §1 Eigenvalue identities
-- ═══════════════════════════════════════════════════════════════

-- Product: 1 × 2 × 3 × 6 = 36 = Σd
eigen-product : 1 * nW * nC * chi ≡ sigmaD
eigen-product = refl

-- Sum of reciprocals (cross-multiplied):
-- 1/1 + 1/2 + 1/3 + 1/6 = 2, stated as 6+3+2+1 = 12 and 12/6 = 2
eigen-recip-num : chi + nC + nW + 1 ≡ 12
eigen-recip-num = refl

-- ═══════════════════════════════════════════════════════════════
-- §2 D_F matrix structure
-- ═══════════════════════════════════════════════════════════════

df-dim : sigmaD ≡ 36
df-dim = refl

df-entries : sigmaD * sigmaD ≡ 1296
df-entries = refl

df-off-diag : sigmaD * sigmaD - sigmaD ≡ 1260
df-off-diag = refl

-- 6 off-diagonal blocks from C(4,2) = 6
-- Sizes of each block
block-sw : d1 * d2 ≡ 3
block-sw = refl

block-sc : d1 * d3 ≡ 8
block-sc = refl

block-sm : d1 * d4 ≡ 24
block-sm = refl

block-wc : d2 * d3 ≡ 24
block-wc = refl

block-wm : d2 * d4 ≡ 72
block-wm = refl

block-cm : d3 * d4 ≡ 192
block-cm = refl

total-off-diag : 2 * (3 + 8 + 24 + 24 + 72 + 192) ≡ 646
total-off-diag = refl

-- ═══════════════════════════════════════════════════════════════
-- §3 Coupling identities (the 13 off-diagonal entries)
-- ═══════════════════════════════════════════════════════════════

-- sin²θ_W = N_c/gauss = 3/13
sin2w-cross : nC * 13 ≡ 3 * gauss
sin2w-cross = refl

-- Hypercharge: d₃/(N_c·gauss) = 8/39
hypercharge-cross : d3 * 39 ≡ 8 * nC * gauss
hypercharge-cross = refl

-- Strong coupling: N_w/(gauss+N_w²) = 2/17
alpha-s-den : gauss + nW * nW ≡ 17
alpha-s-den = refl

alpha-s-cross : nW * 17 ≡ 2 * (gauss + nW * nW)
alpha-s-cross = refl

-- V_cb = d₃d₄/(β₀Σd²) = 192/4550
vcb-num : d3 * d4 ≡ 192
vcb-num = refl

vcb-den : beta0 * sigmaD2 ≡ 4550
vcb-den = refl

-- 192 factorisation
vcb-192-a : 64 * 3 ≡ 192
vcb-192-a = refl

-- V_ub denominator: gauss² = 169
vub-den : gauss * gauss ≡ 169
vub-den = refl

-- Neutrino suppression: D × F₃ × Σd = 388584
nu-suppress : towerD * fermat3 * sigmaD ≡ 388584
nu-suppress = refl

-- Y_u denominator: Σd × gauss = 468
yu-den : sigmaD * gauss ≡ 468
yu-den = refl

-- Y_e denominator: 2 × gauss × F₃ = 6682
ye-den : nW * gauss * fermat3 ≡ 6682
ye-den = refl

-- ═══════════════════════════════════════════════════════════════
-- §4 J operator structure
-- ═══════════════════════════════════════════════════════════════

-- Colour has 4 swap pairs
colour-pairs : 2 * 4 ≡ d3
colour-pairs = refl

-- Mixed = 3 groups of 8
mixed-groups : d3 * 3 ≡ d4
mixed-groups = refl

mixed-eq : d2 * d3 ≡ d4
mixed-eq = refl

-- ═══════════════════════════════════════════════════════════════
-- §5 γ grading structure
-- ═══════════════════════════════════════════════════════════════

-- Left-handed DOF per sector: 1 + 2 + 4 + 12 = 19
left-dof : 1 + nW + 4 + 12 ≡ 19
left-dof = refl

-- Right-handed DOF per sector: 0 + 1 + 4 + 12 = 17
right-dof : 0 + 1 + 4 + 12 ≡ 17
right-dof = refl

-- Sum = Σd
lr-sum : 19 + 17 ≡ sigmaD
lr-sum = refl

-- Asymmetry = N_w
lr-asym : 19 - 17 ≡ nW
lr-asym = refl

-- Left-handed weak = N_w
left-weak : nW ≡ 2
left-weak = refl

-- Right-handed weak = d₂ − N_w = 1
right-weak : d2 - nW ≡ 1
right-weak = refl

-- Half of colour = 4
colour-half : 4 + 4 ≡ d3
colour-half = refl

-- Half of mixed = 12
mixed-half : 12 + 12 ≡ d4
mixed-half = refl

-- ═══════════════════════════════════════════════════════════════
-- §6 CP violation
-- ═══════════════════════════════════════════════════════════════

-- Number of CP-violating phases = (N_c−1)(N_c−2)/2 = 1
-- Stated as: 2 × 1 = (N_c − 1) × (N_c − 2)
cp-phases : 2 * 1 ≡ (nC - 1) * (nC - 2)
cp-phases = refl

-- ═══════════════════════════════════════════════════════════════
-- §7 Tensor product structure
-- ═══════════════════════════════════════════════════════════════

-- d₄ = d₂ × d₃ (mixed = weak ⊗ colour)
tensor-dim : d2 * d3 ≡ d4
tensor-dim = refl

-- λ_mixed = λ_weak × λ_colour stated as:
-- chi = nW × nC (denominators multiply)
eigen-mixed : nW * nC ≡ chi
eigen-mixed = refl

-- Colour self-product
colour-sq : d3 * d3 ≡ 64
colour-sq = refl

-- Colour × mixed
colour-mixed : d3 * d4 ≡ d3 * d3 * d2
colour-mixed = refl
