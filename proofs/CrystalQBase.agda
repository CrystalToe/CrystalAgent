-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalQBase — Shared quantum types from (2,3)
-- Standalone: no engine, no imports. Pure types and constants.

module CrystalQBase where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

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
d₂ = nC

d₃ : ℕ
d₃ = nC * nC - 1

d₄ : ℕ
d₄ = nW * nW * nW * nC

σD : ℕ
σD = d₁ + d₂ + d₃ + d₄

towerD : ℕ
towerD = σD + χ

gauss : ℕ
gauss = nW * nW + nC * nC

-- §0 Core atom values
nW-val : nW ≡ 2
nW-val = refl

nC-val : nC ≡ 3
nC-val = refl

χ-val : χ ≡ 6
χ-val = refl

β₀-val : β₀ ≡ 7
β₀-val = refl

-- §1 Sector dimensions
d₁-val : d₁ ≡ 1
d₁-val = refl

d₂-val : d₂ ≡ 3
d₂-val = refl

d₃-val : d₃ ≡ 8
d₃-val = refl

d₄-val : d₄ ≡ 24
d₄-val = refl

-- §2 Derived integers
σD-val : σD ≡ 36
σD-val = refl

towerD-val : towerD ≡ 42
towerD-val = refl

gauss-val : gauss ≡ 13
gauss-val = refl

-- §3 Cross-checks
sector-sum : d₁ + d₂ + d₃ + d₄ ≡ 36
sector-sum = refl

dims-sum : 1 + 3 + 8 + 24 ≡ 36
dims-sum = refl

-- dim(End(A_F)) = Σ d_k² = 650
sigmaD2 : 1 * 1 + 3 * 3 + 8 * 8 + 24 * 24 ≡ 650
sigmaD2 = refl
