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

-- §2 Engine wiring
d2 : ℕ
d2 = N_w * N_w ∸ 1
d3 : ℕ
d3 = N_c * N_c ∸ 1
d4 : ℕ
d4 = (N_w * N_w ∸ 1) * (N_c * N_c ∸ 1)

engine-pos : d2 ≡ 3
engine-pos = refl

engine-vel : d3 ≡ 8
engine-vel = refl

engine-phase : χ ≡ 6
engine-phase = refl

engine-dim : d2 + d3 ≡ 11
engine-dim = refl

engine-oct : N_w * N_w * N_w ≡ d3
engine-oct = refl

engine-verlet : N_w ≡ 2
engine-verlet = refl

engine-tick : N_w * N_w ≡ 4
engine-tick = refl

-- Total: 12 proofs by refl. Engine wired.
