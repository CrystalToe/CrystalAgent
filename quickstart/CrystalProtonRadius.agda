-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- THE AXIOM: A_F = C + M2(C) + M3(C) — Starting point, not conclusion
-- CrystalProtonRadius.agda — Proton charge radius identities
-- Session 6: Observable #181
-- License: AGPL-3.0
--
-- All proofs by refl. Zero postulates.
-- Agda rules: use - not ∸, no / operator

module CrystalProtonRadius where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat

-- ============================================================
-- Axiom: sector dimensions from A_F
-- ============================================================

n-w : Nat
n-w = 2

n-c : Nat
n-c = 3

chi : Nat
chi = n-w * n-c  -- 6

d1 : Nat
d1 = 1

d2 : Nat
d2 = 3

d3 : Nat
d3 = 8

d4 : Nat
d4 = 24

sigma-d : Nat
sigma-d = d1 + d2 + d3 + d4  -- 36

sigma-d2 : Nat
sigma-d2 = d1 * d1 + d2 * d2 + d3 * d3 + d4 * d4  -- 650

gauss : Nat
gauss = n-c * n-c + n-w * n-w  -- 13

towerD : Nat
towerD = sigma-d + chi  -- 42

-- ============================================================
-- Core identity: 2 * d3 * sigma-d = d4 * d4 = 576
-- ============================================================

dual-route : 2 * d3 * sigma-d ≡ d4 * d4
dual-route = refl

d4-sq-576 : d4 * d4 ≡ 576
d4-sq-576 = refl

two-d3-sigma-d : 2 * d3 * sigma-d ≡ 576
two-d3-sigma-d = refl

-- ============================================================
-- Base formula atoms
-- ============================================================

-- C_F * N_c = (N_c^2 - 1) / 2 = 4
-- Integer form: N_c * N_c - 1 = 8
nc-sq-minus-1 : n-c * n-c - 1 ≡ 8
nc-sq-minus-1 = refl

-- 2 * 4 = 8
two-times-four : 2 * 4 ≡ 8
two-times-four = refl

-- So (N_c^2 - 1) = 2 * 4, confirming C_F * N_c = 4
cf-nc-check : n-c * n-c - 1 ≡ 2 * 4
cf-nc-check = refl

-- ============================================================
-- Correction denominator
-- ============================================================

-- d3 * sigma-d = 288
d3-times-sigma-d : d3 * sigma-d ≡ 288
d3-times-sigma-d = refl

-- 2 * 288 = 576
two-times-288 : 2 * 288 ≡ 576
two-times-288 = refl

-- d4 * d4 = 576
d4-times-d4 : d4 * d4 ≡ 576
d4-times-d4 = refl

-- ============================================================
-- Three-body bounds
-- ============================================================

-- AF floor denominator: d4*d4 - 1 = 575
af-floor-denom : d4 * d4 - 1 ≡ 575
af-floor-denom = refl

-- Band denominator: 575 * 576 = 331200
band-denom : 575 * 576 ≡ 331200
band-denom = refl

-- ============================================================
-- Group theory checks
-- ============================================================

-- d3 = N_c^2 - 1 (adjoint dim)
d3-adjoint : d3 ≡ n-c * n-c - 1
d3-adjoint = refl

-- sigma-d value
sigma-d-val : sigma-d ≡ 36
sigma-d-val = refl

-- Quark pairs: 3 * 2 / 2 = 3
-- (using integer: 3 * (3 - 1) = 6, 6 / 2 = 3 not expressible cleanly)
-- Instead: n-c * (n-c - 1) = 6
quark-pair-product : n-c * (n-c - 1) ≡ 6
quark-pair-product = refl

-- ============================================================
-- N_c scaling
-- ============================================================

-- N_c=2: d4(2) = 2*(4-1) = 6
d4-nc2 : 2 * (2 * 2 - 1) ≡ 6
d4-nc2 = refl

-- N_c=2: eps denom = 36
eps-nc2 : 6 * 6 ≡ 36
eps-nc2 = refl

-- N_c=3: d4(3) = 3*(9-1) = 24
d4-nc3 : 3 * (3 * 3 - 1) ≡ 24
d4-nc3 = refl

-- N_c=3: eps denom = 576
eps-nc3 : 24 * 24 ≡ 576
eps-nc3 = refl

-- N_c=4: d4(4) = 4*(16-1) = 60
d4-nc4 : 4 * (4 * 4 - 1) ≡ 60
d4-nc4 = refl

-- N_c=4: eps denom = 3600
eps-nc4 : 60 * 60 ≡ 3600
eps-nc4 = refl

-- ============================================================
-- Cross-checks with Session 5
-- ============================================================

sigma-d2-val : sigma-d2 ≡ 650
sigma-d2-val = refl

towerD-val : towerD ≡ 42
towerD-val = refl

shared-core : sigma-d2 * towerD ≡ 27300
shared-core = refl

-- alpha channel
alpha-channel : chi * d4 ≡ 144
alpha-channel = refl

-- ============================================================
-- Trace identity
-- ============================================================

-- d3 * sigma-d = 288 = 576 / 2 = d4*d4 / 2
-- Integer form: 2 * (d3 * sigma-d) = d4 * d4
trace-identity : 2 * (d3 * sigma-d) ≡ d4 * d4
trace-identity = refl

-- ============================================================
-- Summary: 24 proofs by refl, zero postulates
-- ============================================================
