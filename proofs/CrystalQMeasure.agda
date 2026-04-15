-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalQMeasure — Measurement operators + tomography from (2,3)
-- Pure MERA. Imports CrystalQBase only. No engine.

module CrystalQMeasure where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

nW : ℕ
nW = 2

nC : ℕ
nC = 3

χ : ℕ
χ = nW * nC

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

-- §1 Measurement dimensions
projective-outcomes : χ ≡ 6
projective-outcomes = refl

sector-count : d₁ + 1 + 1 + 1 ≡ 4
sector-count = refl

-- §2 Parity
parity-even : d₁ + d₃ ≡ 9
parity-even = refl

parity-odd : d₂ + d₄ ≡ 27
parity-odd = refl

parity-sum : (d₁ + d₃) + (d₂ + d₄) ≡ σD
parity-sum = refl

-- §3 Bell and two-particle
bell-outcomes : χ ≡ 6
bell-outcomes = refl

two-particle : χ * χ ≡ 36
two-particle = refl

povm-norm : σD ≡ 36
povm-norm = refl

-- §4 Tomography: χ²-1 = 35 bases
tomography-bases : χ * χ - 1 ≡ 35
tomography-bases = refl

-- ρ has χ² = 36 real parameters, trace constraint removes 1 → 35
tomo-parameters : χ * χ ≡ 36
tomo-parameters = refl

-- DFT rotation: χ = 6 points per basis
tomo-points-per-basis : χ ≡ 6
tomo-points-per-basis = refl
