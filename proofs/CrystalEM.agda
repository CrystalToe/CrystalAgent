-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
module CrystalEM where
open import Data.Nat using (ℕ; _+_; _*_; _∸_)
open import Agda.Builtin.Equality using (_≡_; refl)
N_w : ℕ
N_w = 2
N_c : ℕ
N_c = 3
χ : ℕ
χ = N_w * N_c
em-components : χ ≡ 6
em-components = refl
maxwell-eqs : N_c + 1 ≡ 4
maxwell-eqs = refl
larmor-num : N_c ∸ 1 ≡ 2
larmor-num = refl
rayleigh-wave : N_w * N_w ≡ 4
rayleigh-wave = refl
rayleigh-size : χ ≡ 6
rayleigh-size = refl
planck-exp : χ ∸ 1 ≡ 5
planck-exp = refl
stefan-exp : N_w * N_w ≡ 4
stefan-exp = refl
stefan-denom : N_c * (χ ∸ 1) ≡ 15
stefan-denom = refl
faraday-sector : (N_c * N_c) ∸ 1 ≡ 8
faraday-sector = refl
ampere-sector : N_w * N_w * N_w * N_c ≡ 24
ampere-sector = refl

-- Engine wiring
sigmaD : ℕ
sigmaD = 1 + 3 + 8 + 24

engine-em-sector : (N_c * N_c) ∸ 1 ≡ 8
engine-em-sector = refl

engine-field-comp : χ ≡ 6
engine-field-comp = refl

engine-courant : N_w ≡ 2
engine-courant = refl

engine-full : sigmaD ≡ 36
engine-full = refl
-- Engine wired.
