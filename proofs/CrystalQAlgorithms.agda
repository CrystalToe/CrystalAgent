-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalQAlgorithms — Quantum algorithms from (2,3)
-- Engine wired: mixed sector (d=24).

module CrystalQAlgorithms where

open import Agda.Builtin.Equality
open import Data.Nat using (ℕ; _+_; _*_; _∸_)

nW : ℕ
nW = 2

nC : ℕ
nC = 3

χ : ℕ
χ = nW * nC

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

-- Hilbert space
hilbert-dim : χ ≡ 6
hilbert-dim = refl

gate-set : χ * χ ≡ 36
gate-set = refl

grover-space : χ ≡ 6
grover-space = refl

superdense : χ * χ ≡ 36
superdense = refl

-- Engine wiring
engine-sigmaD : d₁ + d₂ + d₃ + d₄ ≡ σD
engine-sigmaD = refl

engine-sigmaD-val : σD ≡ 36
engine-sigmaD-val = refl

engine-mixed-dim : d₄ ≡ 24
engine-mixed-dim = refl

lambda-mixed-denom : nW * nC ≡ 6
lambda-mixed-denom = refl

no-weak : d₂ ≡ 3
no-weak = refl

no-colour : d₃ ≡ 8
no-colour = refl
-- Engine wired.
