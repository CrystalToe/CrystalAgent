-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalQSimulation — 12 simulation methods from (2,3)
-- Engine wired: mixed sector (d=24).

module CrystalQSimulation where

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

state-vec-max : χ * χ * χ * χ * χ ≡ 7776
state-vec-max = refl

density-max : χ * χ * χ ≡ 216
density-max = refl

diag-max : χ * χ * χ * χ ≡ 1296
diag-max = refl

fock-2 : 1 + χ + χ * χ ≡ 43
fock-2 = refl

mixed-sector : d₄ ≡ 24
mixed-sector = refl
-- Engine wired.
