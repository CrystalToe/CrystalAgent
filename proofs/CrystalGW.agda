-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

module CrystalGW where

open import Data.Nat using (ℕ; _+_; _*_; _∸_)
open import Agda.Builtin.Equality using (_≡_; refl)

N_w : ℕ
N_w = 2
N_c : ℕ
N_c = 3
χ : ℕ
χ = N_w * N_c

-- Quadrupole 32/5
quad-32 : N_w * N_w * N_w * N_w * N_w ≡ 32
quad-32 = refl
quad-5 : χ ∸ 1 ≡ 5
quad-5 = refl

-- Decay 64/5
decay-64 : N_w * N_w * N_w * N_w * N_w * N_w ≡ 64
decay-64 = refl

-- Chirp coeff 96/5
chirp-96 : N_c * (N_w * N_w * N_w * N_w * N_w) ≡ 96
chirp-96 = refl

-- Merger time 5/256
merger-256 : N_w * N_w * N_w * N_w * N_w * N_w * N_w * N_w ≡ 256
merger-256 = refl

-- Amplitude 4
amplitude : N_w * N_w ≡ 4
amplitude = refl

-- Polarizations 2
polar : N_c ∸ 1 ≡ 2
polar = refl

-- GW doubling
doubling : N_w ≡ 2
doubling = refl

-- ISCO
isco : χ ≡ 6
isco = refl

-- Kolmogorov in chirp
kolm-5 : χ ∸ 1 ≡ 5
kolm-5 = refl
kolm-3 : N_c ≡ 3
kolm-3 = refl

-- d_colour in chirp 8/3
dcol : (N_c * N_c) ∸ 1 ≡ 8
dcol = refl

-- 11/3 exponent
chirp-11 : N_c * N_c + N_w ≡ 11
chirp-11 = refl
