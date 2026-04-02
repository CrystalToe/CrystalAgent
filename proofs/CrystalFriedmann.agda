-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
module CrystalFriedmann where
open import Data.Nat using (ℕ; _+_; _*_; _∸_)
open import Agda.Builtin.Equality using (_≡_; refl)
N_w : ℕ
N_w = 2
N_c : ℕ
N_c = 3
χ : ℕ
χ = N_w * N_c
β₀ : ℕ
β₀ = 7
gauss : ℕ
gauss = N_c * N_c + N_w * N_w
D : ℕ
D = 36 + χ
omega-L-num : gauss ≡ 13
omega-L-num = refl
omega-den : gauss + χ ≡ 19
omega-den = refl
omega-m-num : χ ≡ 6
omega-m-num = refl
theta-den : N_w * (D + χ) ≡ 96
theta-den = refl
tcmb-num : gauss + χ ≡ 19
tcmb-num = refl
tcmb-den : β₀ ≡ 7
tcmb-den = refl
age-num : gauss * β₀ + χ ≡ 97
age-num = refl
amplitude : N_c * β₀ ≡ 21
amplitude = refl
matter-exp : N_c ≡ 3
matter-exp = refl
rad-exp : N_c + 1 ≡ 4
rad-exp = refl
tower : D ≡ 42
tower = refl
