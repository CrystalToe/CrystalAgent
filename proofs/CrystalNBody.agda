-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalNBody.agda — Integer identities in N-body gravitational dynamics.
-- All from (N_w, N_c) = (2, 3). Machine-checked by refl.

module CrystalNBody where

open import Data.Nat using (ℕ; zero; suc; _+_; _*_; _∸_)
open import Agda.Builtin.Equality using (_≡_; refl)

N_w : ℕ
N_w = 2

N_c : ℕ
N_c = 3

χ : ℕ
χ = N_w * N_c

σ_d : ℕ
σ_d = 1 + 3 + 8 + 24

-- §1 Octree: 8 children = 2^N_c = N_w^N_c = d_colour
oct-children : N_w * N_w * N_w ≡ 8
oct-children = refl

d-colour : (N_c * N_c) ∸ 1 ≡ 8
d-colour = refl

oct-is-dcolour : N_w * N_w * N_w ≡ (N_c * N_c) ∸ 1
oct-is-dcolour = refl

-- §2 Force and spatial dimensions
force-exponent : N_c ∸ 1 ≡ 2
force-exponent = refl

spatial-dim : N_c ≡ 3
spatial-dim = refl

-- §3 Phase space per body
phase-per-body : χ ≡ 6
phase-per-body = refl

-- §4 Sector dimensions
d-weak : N_c ≡ 3
d-weak = refl

d-mixed : N_w * N_w * N_w * N_c ≡ 24
d-mixed = refl

d-total : σ_d ≡ 36
d-total = refl

-- §5 Eigenvalue denominators
lambda-weak-denom : N_w ≡ 2
lambda-weak-denom = refl

lambda-colour-denom : N_c ≡ 3
lambda-colour-denom = refl

lambda-mixed-denom : χ ≡ 6
lambda-mixed-denom = refl

-- §6 Coupling weight denominators
wk-uk-weak : N_w ≡ 2
wk-uk-weak = refl

wk-uk-colour : N_c ≡ 3
wk-uk-colour = refl

-- §7 Multipole order
multipole-order : N_c ∸ 1 ≡ 2
multipole-order = refl

-- §8 Octant index bits
octant-bits : N_c ≡ 3
octant-bits = refl

-- Total proofs by refl. Zero postulates.
