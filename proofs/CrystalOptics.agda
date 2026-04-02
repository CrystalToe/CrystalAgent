-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalOptics — Ray/Wave Optics integer identities from (2,3)

module CrystalOptics where

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

sigmaD : ℕ
sigmaD = 1 + 3 + 8 + 24  -- 36

-- Atom sanity
nW-val : nW ≡ 2
nW-val = refl

nC-val : nC ≡ 3
nC-val = refl

chi-val : chi ≡ 6
chi-val = refl

gauss-val : gauss ≡ 13
gauss-val = refl

-- S1: Casimir factor C_F = (N_c^2-1)/(2*N_c) = 8/6 = 4/3
-- Numerator
cF-num : nC * nC ≡ 9
cF-num = refl

-- N_c^2 - 1 = 8 (as addition: 8 + 1 = N_c^2)
cF-num-pred : 8 + 1 ≡ nC * nC
cF-num-pred = refl

-- Denominator
cF-den : 2 * nC ≡ 6
cF-den = refl

-- C_F denominator = chi
cF-den-is-chi : 2 * nC ≡ chi
cF-den-is-chi = refl

-- C_F numerator = d_colour = N_w^3
cF-num-is-dColour : 8 ≡ nW * nW * nW
cF-num-is-dColour = refl

-- Cross-multiply: 4 * 6 = 8 * 3 (proves 4/3 = 8/6)
cF-cross : 4 * (2 * nC) ≡ (nW * nW * nW) * nC
cF-cross = refl

-- S2: IOR glass = N_c / N_w = 3/2
glass-num : nC ≡ 3
glass-num = refl

glass-den : nW ≡ 2
glass-den = refl

-- S3: Rayleigh exponents
rayleigh-lambda : nW * nW ≡ 4
rayleigh-lambda = refl

rayleigh-size : chi ≡ 6
rayleigh-size = refl

-- S4: Planck exponent: 5 = chi - 1 (as addition: 5 + 1 = chi)
planck-exp : 5 + 1 ≡ chi
planck-exp = refl

-- S5: Cross-checks
casimir-colour : nC * nC ≡ nW * nW * nW + 1
casimir-colour = refl

chi-m1-decompose : 5 ≡ nW * nW + 1
chi-m1-decompose = refl

weight-cross : nW * nW * (nC * nC) ≡ sigmaD
weight-cross = refl
