-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalEM — EM field evolution from (2,3)
-- Refactored: CrystalAtoms + CrystalSectors + CrystalEigen + CrystalOperators

module CrystalEM where

open import Data.Nat using (ℕ; _+_; _*_; _∸_)
open import Agda.Builtin.Equality using (_≡_; refl)

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

-- §1 EM field structure
em-components : χ ≡ 6
em-components = refl

e-components : nC ≡ 3
e-components = refl

b-components : nC ≡ 3
b-components = refl

two-form-dim : (nC + 1) * nC ≡ 12
two-form-dim = refl

-- §2 Maxwell equations
maxwell-eqs : nC + 1 ≡ 4
maxwell-eqs = refl

gauss-e-sector : d₁ ≡ 1
gauss-e-sector = refl

gauss-b-sector : d₂ ≡ 3
gauss-b-sector = refl

faraday-sector : d₃ ≡ 8
faraday-sector = refl

ampere-sector : d₄ ≡ 24
ampere-sector = refl

-- §3 Radiation
larmor-num : nC ∸ 1 ≡ 2
larmor-num = refl

larmor-den : nC ≡ 3
larmor-den = refl

rayleigh-wave : nW * nW ≡ 4
rayleigh-wave = refl

rayleigh-size : χ ≡ 6
rayleigh-size = refl

planck-exp : χ ∸ 1 ≡ 5
planck-exp = refl

stefan-exp : nW * nW ≡ 4
stefan-exp = refl

stefan-denom : nC * (χ ∸ 1) ≡ 15
stefan-denom = refl

-- §4 2D FDTD crystal parameters
courant-denom : nW ≡ 2
courant-denom = refl

grid-dx-denom : nC ≡ 3
grid-dx-denom = refl

grid-dt-is-chi : nW * nC ≡ χ
grid-dt-is-chi = refl

-- §5 Thomson cross-section
thomson-num : d₃ ≡ 8
thomson-num = refl

thomson-den : nC ≡ 3
thomson-den = refl

-- §6 Component wiring
comp-em-sector : d₃ ≡ 8
comp-em-sector = refl

comp-field-count : χ ≡ 6
comp-field-count = refl

comp-courant : nW ≡ 2
comp-courant = refl

comp-full-state : σD ≡ 36
comp-full-state = refl

-- §7 Dipole harmonics
dipole-harmonics : χ ≡ 6
dipole-harmonics = refl

-- §8 Gauge
gauge-u1 : d₁ ≡ 1
gauge-u1 = refl

-- Total: 27 proofs by refl. Zero postulates.
