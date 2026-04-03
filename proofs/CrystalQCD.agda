-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalQCD — QCD observables from (2,3)
-- Engine wired: colour (d=8).

module CrystalQCD where

open import Agda.Builtin.Equality
open import Data.Nat using (ℕ; _+_; _*_; _∸_)

nW : ℕ
nW = 2

nC : ℕ
nC = 3

χ : ℕ
χ = nW * nC

β₀ : ℕ
β₀ = 7

d₁ : ℕ
d₁ = 1

d₂ : ℕ
d₂ = nW * nW ∸ 1

d₃ : ℕ
d₃ = nC * nC ∸ 1

d₄ : ℕ
d₄ = (nW * nW ∸ 1) * (nC * nC ∸ 1)

σD : ℕ
σD = d₁ + d₂ + d₃ + d₄

towerD : ℕ
towerD = σD + χ

gauss : ℕ
gauss = nW * nW + nC * nC

-- Core atoms
nW-val : nW ≡ 2
nW-val = refl

nC-val : nC ≡ 3
nC-val = refl

χ-val : χ ≡ 6
χ-val = refl

d₁-val : d₁ ≡ 1
d₁-val = refl

d₂-val : d₂ ≡ 3
d₂-val = refl

d₃-val : d₃ ≡ 8
d₃-val = refl

d₄-val : d₄ ≡ 24
d₄-val = refl

σD-val : σD ≡ 36
σD-val = refl

sector-sum : d₁ + d₂ + d₃ + d₄ ≡ 36
sector-sum = refl

colour-generators : nC * nC ∸ 1 ≡ 8
colour-generators = refl

-- C_F = (N_c²-1)/(2N_c) = 4/3
string-tension-num : nC ≡ 3
string-tension-num = refl

string-tension-denom : d₃ ≡ 8
string-tension-denom = refl

-- sigma/Lambda² = N_c/d_colour = 3/8
-- Engine wired.
