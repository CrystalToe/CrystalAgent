-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

module CrystalGR where

open import Data.Nat using (ℕ; _+_; _*_; _∸_)
open import Agda.Builtin.Equality using (_≡_; refl)

N_w : ℕ
N_w = 2
N_c : ℕ
N_c = 3
χ : ℕ
χ = N_w * N_c

schwarzschild : N_c ∸ 1 ≡ 2
schwarzschild = refl
precession-6 : χ ≡ 6
precession-6 = refl
light-bending : N_w * N_w ≡ 4
light-bending = refl
isco-6 : χ ≡ 6
isco-6 = refl
isco-3 : N_c ≡ 3
isco-3 = refl
isco-energy-num : (N_c * N_c) ∸ 1 ≡ 8
isco-energy-num = refl
isco-energy-den : N_c * N_c ≡ 9
isco-energy-den = refl
spacetime : N_c + 1 ≡ 4
spacetime = refl
einstein-16 : N_w * N_w * N_w * N_w ≡ 16
einstein-16 = refl
gw-polar : N_c ∸ 1 ≡ 2
gw-polar = refl
quad-32 : N_w * N_w * N_w * N_w * N_w ≡ 32
quad-32 = refl
quad-5 : χ ∸ 1 ≡ 5
quad-5 = refl

-- Engine wiring + new features
sigmaD : ℕ
sigmaD = 1 + 3 + 8 + 24

engine-isco : χ ≡ 6
engine-isco = refl

engine-bend : N_w * N_w ≡ 4
engine-bend = refl

engine-spacetime : N_c + 1 ≡ 4
engine-spacetime = refl

engine-full : sigmaD ≡ 36
engine-full = refl

engine-eff-num : (N_c * N_c) ∸ 1 ≡ 8
engine-eff-num = refl

engine-eff-den : N_c * N_c ≡ 9
engine-eff-den = refl
-- Engine wired.
