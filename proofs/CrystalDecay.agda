-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalDecay — Particle Decay integer identities from (2,3)

module CrystalDecay where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

-- S0: A_F atoms
nW : ℕ
nW = 2

nC : ℕ
nC = 3

chi : ℕ
chi = nW * nC  -- 6

gauss : ℕ
gauss = nC * nC + nW * nW  -- 13

-- S1: Decay constants
dColour : ℕ
dColour = nW * nW * nW  -- 8

dMixed : ℕ
dMixed = nW * nW * nW * nC  -- 24

betaConst : ℕ
betaConst = dMixed * dColour  -- 192

-- Atom sanity
nW-val : nW ≡ 2
nW-val = refl

nC-val : nC ≡ 3
nC-val = refl

chi-val : chi ≡ 6
chi-val = refl

gauss-val : gauss ≡ 13
gauss-val = refl

-- S2: Beta constant
dColour-val : dColour ≡ 8
dColour-val = refl

dMixed-val : dMixed ≡ 24
dMixed-val = refl

betaConst-val : betaConst ≡ 192
betaConst-val = refl

beta-product : 24 * 8 ≡ 192
beta-product = refl

-- S3: Weinberg angle (integer parts)
weinberg-num : nC ≡ 3
weinberg-num = refl

weinberg-den : gauss ≡ 13
weinberg-den = refl

-- S4: PMNS theta_23 (integer parts)
-- chi = 6, 2*chi - 1 = 11
theta23-num : chi ≡ 6
theta23-num = refl

-- 2*chi = 12, so 2*chi - 1 = 11 (as addition: 11 + 1 = 2*chi)
theta23-den-check : 11 + 1 ≡ 2 * chi
theta23-den-check = refl

-- sin^2(2 theta_23) numerator: 4 * chi * (chi - 1) = 120
-- Since chi = 6, chi - 1 = 5: 4 * 6 * 5 = 120
sin22-num : 4 * chi * 5 ≡ 120
sin22-num = refl

-- Denominator: (2*chi - 1)^2 = 11^2 = 121
sin22-den : 11 * 11 ≡ 121
sin22-den = refl

-- S5: Phase space dimension
phase-dim-2 : nC * 2 ≡ 2 + (nC + 1)
phase-dim-2 = refl

phase-dim-3 : nC * 3 ≡ 5 + (nC + 1)
phase-dim-3 = refl

phase-dim-4 : nC * 4 ≡ dColour + (nC + 1)
phase-dim-4 = refl

-- S6: Cross-checks
dColour-cubed : nW * nW * nW ≡ 8
dColour-cubed = refl

dMixed-alt : 2 * chi * nW ≡ 24
dMixed-alt = refl

gauss-decompose : nC * nC + nW * nW ≡ 13
gauss-decompose = refl
