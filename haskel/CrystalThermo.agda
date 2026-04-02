-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
module CrystalThermo where
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
lj-attract : χ ≡ 6
lj-attract = refl
lj-repulse : N_w * χ ≡ 12
lj-repulse = refl
lj-force : N_w * N_w * N_w * N_c ≡ 24
lj-force = refl
gamma-mono-num : χ ∸ 1 ≡ 5
gamma-mono-num = refl
dof-mono : N_c ≡ 3
dof-mono = refl
dof-di : χ ∸ 1 ≡ 5
dof-di = refl
carnot-num : χ ∸ 1 ≡ 5
carnot-num = refl
carnot-den : χ ≡ 6
carnot-den = refl
stokes : N_w * N_w * N_w * N_c ≡ 24
stokes = refl
beta0-val : β₀ ≡ 7
beta0-val = refl
