-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalMD — Molecular Dynamics integer identities from (2,3)

module CrystalMD where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

-- S0: A_F atoms
nW : ℕ
nW = 2

nC : ℕ
nC = 3

chi : ℕ
chi = nW * nC  -- 6

dMixed : ℕ
dMixed = nW * nW * nW * nC  -- 24

-- Atom sanity
nW-val : nW ≡ 2
nW-val = refl

nC-val : nC ≡ 3
nC-val = refl

chi-val : chi ≡ 6
chi-val = refl

dMixed-val : dMixed ≡ 24
dMixed-val = refl

-- S1: LJ exponents
lj-att : chi ≡ 6
lj-att = refl

lj-rep : 2 * chi ≡ 12
lj-rep = refl

lj-pot-coeff : nW * nW ≡ 4
lj-pot-coeff = refl

lj-force-coeff : dMixed ≡ 24
lj-force-coeff = refl

lj-double-force : 2 * dMixed ≡ 48
lj-double-force = refl

lj-coeff-trace : nW * nW * chi ≡ dMixed
lj-coeff-trace = refl

-- S2: Bond angle denominator
tetra-den : nC ≡ 3
tetra-den = refl

-- S3: H-bonds
hbond-AT : nW ≡ 2
hbond-AT = refl

hbond-GC : nC ≡ 3
hbond-GC = refl

-- S4: Helix = 18/5
helix-num : nC * nC * nW ≡ 18
helix-num = refl

-- chi - 1 = 5 (as addition)
helix-den : 5 + 1 ≡ chi
helix-den = refl

-- S5: Flory nu = 2/5
flory-num : nW ≡ 2
flory-num = refl

flory-den : 5 + 1 ≡ chi
flory-den = refl

-- S6: Coulomb exponent (N_c - 1 = 2, as addition)
coulomb-exp : 2 + 1 ≡ nC
coulomb-exp = refl

-- S7: Cross-checks
two-chi : 2 * chi ≡ 12
two-chi = refl

dMixed-alt : 2 * chi * nW ≡ 24
dMixed-alt = refl

nC-sq-nW : nC * nC * nW ≡ 18
nC-sq-nW = refl

nW-sq : nW * nW ≡ 4
nW-sq = refl

-- Engine wiring
sigmaD : ℕ
sigmaD = 1 + 3 + 8 + 24

engine-lj : chi ≡ 6
engine-lj = refl

engine-rep : chi + chi ≡ 12
engine-rep = refl

engine-full : sigmaD ≡ 36
engine-full = refl
-- Engine wired.
