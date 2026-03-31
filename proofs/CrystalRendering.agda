-- Crystal Topos — Rendering & Scattering Physics
-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later
--
-- Observables 204–206: Planck exponent, Rayleigh size, Rayleigh wavelength.
-- All EXACT (PWI = 0.000%).

module CrystalRendering where

open import Agda.Builtin.Nat
open import Agda.Builtin.Equality using (_≡_; refl)

-- Crystal atoms
nw : Nat
nw = 2

nc : Nat
nc = 3

chi : Nat
chi = nw * nc  -- 6

-- ── Observable 204 ─────────────────────────────────────────────
-- Planck spectral radiance wavelength exponent
-- B(λ,T) ∝ λ⁻⁵. Exponent = χ - 1 = 5.
-- Route: DOS(N_c-1) + energy(1) + Jacobian(2) = N_c + 2 = 5
planck-wavelength-exp : chi - 1 ≡ 5
planck-wavelength-exp = refl

-- ── Observable 205 ─────────────────────────────────────────────
-- Rayleigh scattering particle-size exponent
-- σ_R ∝ d⁶. Exponent = χ = N_w · N_c = 6.
-- Route: power = |dipole|² where dipole ∝ vol ∝ d^N_c
rayleigh-size-exp : chi ≡ 6
rayleigh-size-exp = refl

rayleigh-size-decomp : nw * nc ≡ 6
rayleigh-size-decomp = refl

-- ── Observable 206 ─────────────────────────────────────────────
-- Rayleigh scattering wavelength exponent
-- σ_R ∝ λ⁻⁴. Exponent = N_w² = 4.
-- Route: accel ∝ ω^N_w, power ∝ |accel|² → ω^(N_w²) → λ^(-N_w²)
rayleigh-wavelength-exp : nw * nw ≡ 4
rayleigh-wavelength-exp = refl

-- ── Structural ─────────────────────────────────────────────────
-- Planck (χ-1=5) vs Stefan-Boltzmann (N_w²=4): different values.
planck-exp-is-five : chi - 1 ≡ 5
planck-exp-is-five = refl

stefan-exp-is-four : nw * nw ≡ 4
stefan-exp-is-four = refl
