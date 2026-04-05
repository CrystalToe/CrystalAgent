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

-- §11a Accretion disc
disc-temp-num : N_c ≡ 3
disc-temp-num = refl
disc-temp-den : N_c + 1 ≡ 4
disc-temp-den = refl
stefan-boltzmann : N_c + 1 ≡ 4
stefan-boltzmann = refl
doppler-beaming : N_c ≡ 3
doppler-beaming = refl
disc-aspect : N_w * N_c ≡ 6
disc-aspect = refl
rad-eff-num : (N_c * N_c) ∸ 1 ≡ 8
rad-eff-num = refl
rad-eff-den : N_c * N_c ≡ 9
rad-eff-den = refl
shadow-27 : N_c * N_c * N_c ≡ 27
shadow-27 = refl
disc-viscosity : N_c * N_c + N_w * N_w ≡ 13
disc-viscosity = refl
disc-phase : (N_w * N_w ∸ 1) * (N_c * N_c ∸ 1) ≡ 24
disc-phase = refl
isco-boost : (N_c * N_c) ∸ 1 ≡ 8
isco-boost = refl
kerr-eff : N_c ≡ 3
kerr-eff = refl
