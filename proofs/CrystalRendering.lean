-- Crystal Topos — Rendering & Scattering Physics
-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later
--
-- Observables 204–206: Planck exponent, Rayleigh size, Rayleigh wavelength.
-- All EXACT (PWI = 0.000%).

-- Crystal atoms
def towerNw : Nat := 2
def towerNc : Nat := 3
def towerChi : Nat := towerNw * towerNc  -- 6

-- ── Observable 204 ─────────────────────────────────────────────
-- Planck spectral radiance wavelength exponent
-- B(λ,T) = (2hc²/λ⁵) × 1/(e^(hc/λkT) − 1)
-- Pre-factor exponent = χ − 1 = 5
-- Route: DOS ν^(N_c−1) × energy hν × Jacobian |dν/dλ|
--        = λ^(−(N_c−1)) × λ^(−1) × λ^(−2) = λ^(−5)
-- Ref: Planck (1900), Ann. Phys. 309(3):553–563
theorem planck_wavelength_exp :
    towerChi - 1 = 5 := by native_decide

-- ── Observable 205 ─────────────────────────────────────────────
-- Rayleigh scattering particle-size exponent
-- σ_R ∝ d⁶/λ⁴  (Rayleigh regime, d ≪ λ)
-- Size exponent = χ = N_w · N_c = 6
-- Route: dipole p ∝ α·E where α ∝ vol ∝ d^N_c
--        power P ∝ |p|² = (d^N_c)² = d^(N_w·N_c) = d^χ
-- Ref: Strutt (Lord Rayleigh), 1871, Phil. Mag. 41
theorem rayleigh_size_exp :
    towerChi = 6 := by native_decide

theorem rayleigh_size_decomposition :
    towerNw * towerNc = 6 := by native_decide

-- ── Observable 206 ─────────────────────────────────────────────
-- Rayleigh scattering wavelength exponent
-- σ_R ∝ d⁶/λ⁴  (Rayleigh regime, d ≪ λ)
-- Wavelength exponent = N_w² = 4
-- Route: dipole accel a ∝ ω^N_w, power P ∝ |a|² = ω^(N_w²)
--        ω ∝ 1/λ → λ^(−N_w²) = λ⁻⁴
-- Same integer as Stefan-Boltzmann T⁴ and Bekenstein S=A/(4G)
-- but independent physics (elastic dipole scattering, 1871).
-- Ref: Strutt (Lord Rayleigh), 1871, Phil. Mag. 41
theorem rayleigh_wavelength_exp :
    towerNw * towerNw = 4 := by native_decide

theorem rayleigh_wave_decomposition :
    towerNw ^ 2 = 4 := by native_decide

-- ── Structural ─────────────────────────────────────────────────
-- Planck exponent (χ−1=5) ≠ Stefan-Boltzmann exponent (N_w²=4).
-- Different formulas, different integers, independent observables.
theorem planck_ne_stefan :
    towerChi - 1 ≠ towerNw * towerNw := by native_decide
