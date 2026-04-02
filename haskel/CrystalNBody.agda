-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
module CrystalNBody where
open import Data.Nat using (ℕ; _+_; _*_; _∸_)
open import Agda.Builtin.Equality using (_≡_; refl)
N_w : ℕ
N_w = 2
N_c : ℕ
N_c = 3
χ : ℕ
χ = N_w * N_c
oct : N_w * N_w * N_w ≡ 8
oct = refl
dcolour : (N_c * N_c) ∸ 1 ≡ 8
dcolour = refl
force : N_c ∸ 1 ≡ 2
force = refl
dim : N_c ≡ 3
dim = refl
phase : N_w * N_c ≡ 6
phase = refl
