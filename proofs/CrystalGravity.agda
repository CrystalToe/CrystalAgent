-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalGravity — Gravity observables from (2,3)
-- Engine wired: weak+colour (d=11).

module CrystalGravity where

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

spatial-dim : nC ≡ 3
spatial-dim = refl

spacetime : nC + 1 ≡ 4
spacetime = refl

force-exp : nC ∸ 1 ≡ 2
force-exp = refl

-- 1/r² force: exponent = N_c - 1 = 2

rt-factor : nW * nW ≡ 4
rt-factor = refl

-- S = A/(4G): factor 4 = N_w²

einstein-factor : nW * nW * nW * nW ≡ 16
einstein-factor = refl

-- 16πG: factor 16 = N_w⁴
-- Engine wired.
