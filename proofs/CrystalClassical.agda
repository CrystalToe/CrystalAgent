-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalClassical.agda — Integer identities in classical orbital mechanics.
-- All from (N_w, N_c) = (2, 3). Machine-checked by refl.

module CrystalClassical where

open import Data.Nat using (ℕ; zero; suc; _+_; _*_; _∸_)
open import Agda.Builtin.Equality using (_≡_; refl)

-- §0 A_F atoms
N_w : ℕ
N_w = 2

N_c : ℕ
N_c = 3

χ : ℕ
χ = N_w * N_c  -- 6

β₀ : ℕ
β₀ = 7  -- (11 × 3 − 2 × 6) / 3

σ_d : ℕ
σ_d = 1 + 3 + 8 + 24  -- 36

σ_d² : ℕ
σ_d² = 1 + 9 + 64 + 576  -- 650

gauss : ℕ
gauss = N_c * N_c + N_w * N_w  -- 13

D : ℕ
D = σ_d + χ  -- 42

-- §1 Force and spatial dimensions
force-exponent : N_c ∸ 1 ≡ 2
force-exponent = refl

spatial-dim : N_c ≡ 3
spatial-dim = refl

bertrand : N_c ∸ 1 ≡ 2
bertrand = refl

-- §2 Kepler's laws
kepler-exp : N_c ≡ 3
kepler-exp = refl

kepler-coeff : N_w * N_w ≡ 4
kepler-coeff = refl

spacetime-dim : N_c + 1 ≡ 4
spacetime-dim = refl

-- §3 Angular momentum
ang-mom-components : (N_c * (N_c ∸ 1)) ≡ 6
ang-mom-components = refl
-- Note: N_c(N_c-1)/2 = 6/2 = 3; Agda naturals don't have division,
-- so we prove N_c*(N_c-1) = 6, and 6/2 = 3 is arithmetic.

-- §4 Three-body phase space
phase-solvable : gauss ∸ N_c ≡ 10
phase-solvable = refl

phase-chaotic : (N_c * N_c) ∸ 1 ≡ 8
phase-chaotic = refl

phase-total : (gauss ∸ N_c) + ((N_c * N_c) ∸ 1) ≡ 18
phase-total = refl

-- §5 Lagrange points
lagrange-points : χ ∸ 1 ≡ 5
lagrange-points = refl

-- §6 GW radiation
gw-polarizations : N_c ∸ 1 ≡ 2
gw-polarizations = refl

einstein-16 : N_w * N_w * N_w * N_w ≡ 16
einstein-16 = refl

schwarzschild : N_c ∸ 1 ≡ 2
schwarzschild = refl

-- §7 Ryu-Takayanagi
rt-4 : N_w * N_w ≡ 4
rt-4 = refl

-- §8 Quadrupole
quadrupole-num : N_w * N_w * N_w * N_w * N_w ≡ 32
quadrupole-num = refl

quadrupole-den : χ ∸ 1 ≡ 5
quadrupole-den = refl

-- §9 Crystal invariants
chi-val : χ ≡ 6
chi-val = refl

beta0-val : β₀ ≡ 7
beta0-val = refl

sigma-d-val : σ_d ≡ 36
sigma-d-val = refl

sigma-d2-val : σ_d² ≡ 650
sigma-d2-val = refl

gauss-val : gauss ≡ 13
gauss-val = refl

tower-val : D ≡ 42
tower-val = refl

-- §10 Sector dimensions
d-colour : (N_c * N_c) ∸ 1 ≡ 8
d-colour = refl

d-weak : N_c ≡ 3
d-weak = refl

d-mixed : N_w * N_w * N_w * N_c ≡ 24
d-mixed = refl
