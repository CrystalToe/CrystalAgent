-- Copyright (c) 2026 Daland Montgomery  SPDX: AGPL-3.0-or-later
module CrystalGR where
open import Data.Nat using (ℕ; _+_; _*_; _∸_)
open import Agda.Builtin.Equality using (_≡_; refl)

N_w : ℕ
N_w = 2
N_c : ℕ
N_c = 3
χ : ℕ
χ = N_w * N_c
σ_d : ℕ
σ_d = 1 + 3 + 8 + 24

schwarz : N_c ∸ 1 ≡ 2
schwarz = refl
precession : χ ≡ 6
precession = refl
bending : N_w * N_w ≡ 4
bending = refl
isco6 : χ ≡ 6
isco6 = refl
isco3 : N_c ≡ 3
isco3 = refl
photon-sphere : N_c ≡ 3
photon-sphere = refl
isco-e-num : (N_c * N_c) ∸ 1 ≡ 8
isco-e-num = refl
isco-e-den : N_c * N_c ≡ 9
isco-e-den = refl
spacetime : N_c + 1 ≡ 4
spacetime = refl
coeff-16 : N_w * N_w * N_w * N_w ≡ 16
coeff-16 = refl
gr-correction : N_c ≡ 3
gr-correction = refl
d-colour : (N_c * N_c) ∸ 1 ≡ 8
d-colour = refl
sigma-d : σ_d ≡ 36
sigma-d = refl
lambda-weak : N_w ≡ 2
lambda-weak = refl
lambda-colour : N_c ≡ 3
lambda-colour = refl
