-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalQuantum — Multi-particle quantum operators from (2,3)
-- Engine wired: colour⊕mixed sector (d=32).

module CrystalQuantum where

open import Agda.Builtin.Equality
open import Data.Nat using (ℕ; _+_; _*_; _∸_)

nW : ℕ
nW = 2

nC : ℕ
nC = 3

χ : ℕ
χ = nW * nC  -- 6

β₀ : ℕ
β₀ = 7

d₁ : ℕ
d₁ = 1

d₂ : ℕ
d₂ = nW * nW ∸ 1  -- 3

d₃ : ℕ
d₃ = nC * nC ∸ 1  -- 8

d₄ : ℕ
d₄ = (nW * nW ∸ 1) * (nC * nC ∸ 1)  -- 24

σD : ℕ
σD = d₁ + d₂ + d₃ + d₄  -- 36

towerD : ℕ
towerD = σD + χ  -- 42

-- §1 Hilbert space
hilbert-dim : χ ≡ 6
hilbert-dim = refl

two-particle : χ * χ ≡ 36
two-particle = refl

two-particle-sigmaD : χ * χ ≡ σD
two-particle-sigmaD = refl

-- §4 Multi-particle
-- antisymmetric = χ(χ-1)/2 = 15 = N_w⁴ - 1 = dim(su(4))
fermion-su4 : (nW * nW) * (nW * nW) ∸ 1 ≡ 15
fermion-su4 = refl

-- §5 Entanglement
entangled : χ * (χ ∸ 1) ≡ 30
entangled = refl

ppt-bound : nW * nC ≡ 6
ppt-bound = refl

-- §6 Gates
total-gates : χ * χ ≡ 36
total-gates = refl

cnot-dim : χ * χ * χ * χ ≡ 1296
cnot-dim = refl

-- §7 Sector
sector-total : σD ≡ 36
sector-total = refl

-- ═══════════════════════════════════════════════════════════════
-- ENGINE WIRING PROOFS
-- ═══════════════════════════════════════════════════════════════

engine-sigmaD : d₁ + d₂ + d₃ + d₄ ≡ σD
engine-sigmaD = refl

engine-sigmaD-val : σD ≡ 36
engine-sigmaD-val = refl

engine-colour-mixed : d₃ + d₄ ≡ 32
engine-colour-mixed = refl

engine-colour-dim : d₃ ≡ 8
engine-colour-dim = refl

engine-mixed-dim : d₄ ≡ 24
engine-mixed-dim = refl

lambda-colour-denom : nC ≡ 3
lambda-colour-denom = refl

lambda-mixed-denom : nW * nC ≡ 6
lambda-mixed-denom = refl

no-weak : d₂ ≡ 3
no-weak = refl
-- Engine wired.
