-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalSectors.agda — Component 3: The four irreps and state space.
-- All proofs by refl. Zero postulates.

module CrystalSectors where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

nW : ℕ
nW = 2

nC : ℕ
nC = 3

d1 : ℕ
d1 = 1

d2 : ℕ
d2 = nW * nW - 1

d3 : ℕ
d3 = nC * nC - 1

d4 : ℕ
d4 = (nW * nW - 1) * (nC * nC - 1)

sigmaD : ℕ
sigmaD = d1 + d2 + d3 + d4

-- Sector dimensions
d1-val : d1 ≡ 1
d1-val = refl

d2-val : d2 ≡ 3
d2-val = refl

d3-val : d3 ≡ 8
d3-val = refl

d4-val : d4 ≡ 24
d4-val = refl

-- Total state space
sigmaD-val : sigmaD ≡ 36
sigmaD-val = refl

-- Partition
partition : d1 + d2 + d3 + d4 ≡ 36
partition = refl

-- Mixed = weak x colour
mixed-tensor : d2 * d3 ≡ d4
mixed-tensor = refl

d4-alt : nC * d3 ≡ d4
d4-alt = refl

-- Sector boundaries (start indices)
start-0 : 0 ≡ 0
start-0 = refl

start-1 : d1 ≡ 1
start-1 = refl

start-2 : d1 + d2 ≡ 4
start-2 = refl

start-3 : d1 + d2 + d3 ≡ 12
start-3 = refl

start-end : d1 + d2 + d3 + d4 ≡ 36
start-end = refl

-- Block sizes for off-diagonal D_F
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

-- Matrix dimension
matrix-dim : sigmaD * sigmaD ≡ 1296
matrix-dim = refl

-- Colour pairs
colour-pairs : 2 * 4 ≡ d3
colour-pairs = refl

-- Mixed groups
mixed-groups : d3 * 3 ≡ d4
mixed-groups = refl

mixed-eq-d2d3 : d3 * d2 ≡ d4
mixed-eq-d2d3 = refl
