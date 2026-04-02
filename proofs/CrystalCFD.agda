-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalCFD — Lattice Boltzmann integer identities from (2,3)

module CrystalCFD where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

-- S0: A_F atoms
nW : ℕ
nW = 2

nC : ℕ
nC = 3

chi : ℕ
chi = nW * nC  -- 6

sigmaD : ℕ
sigmaD = 1 + 3 + 8 + 24  -- 36

gauss : ℕ
gauss = nC * nC + nW * nW  -- 13

towerD : ℕ
towerD = sigmaD + chi  -- 42

dMixed : ℕ
dMixed = nW * nW * nW * nC  -- 24

-- S1: D2Q9 lattice structure
d2q9-count : nC * nC ≡ 9
d2q9-count = refl

weight-rest-num : nW * nW ≡ 4
weight-rest-num = refl

weight-rest-den : nC * nC ≡ 9
weight-rest-den = refl

weight-diagonal-den : sigmaD ≡ 36
weight-diagonal-den = refl

cs2-den : nC ≡ 3
cs2-den = refl

-- Weight sum in integers: 4*36 + 4*36 + 4*9 = 9*36 = 324
weight-sum : 4 * 36 + 4 * 36 + 4 * 9 ≡ 324
weight-sum = refl

weight-sum-rhs : 9 * 36 ≡ 324
weight-sum-rhs = refl

-- S2: CFD physical constants
kolmogorov-num : chi ≡ 6
kolmogorov-num = refl

-- chi - 1 = 5 (as addition: 5 + 1 = chi)
kolmogorov-chi-pred : 5 + 1 ≡ chi
kolmogorov-chi-pred = refl

stokes-drag : dMixed ≡ 24
stokes-drag = refl

blasius-den : nW * nW ≡ 4
blasius-den = refl

von-karman-num : nW ≡ 2
von-karman-num = refl

-- S3: Cross-checks
dMixed-alt : 2 * chi * nW ≡ 24
dMixed-alt = refl

sigmaD-product : nC * nC * (nW * nW) ≡ sigmaD
sigmaD-product = refl

-- S4: Atom sanity
nW-val : nW ≡ 2
nW-val = refl

nC-val : nC ≡ 3
nC-val = refl

chi-val : chi ≡ 6
chi-val = refl

sigmaD-val : sigmaD ≡ 36
sigmaD-val = refl

gauss-val : gauss ≡ 13
gauss-val = refl

towerD-val : towerD ≡ 42
towerD-val = refl
