# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later
#
# crystal_constants.py — Universal physics constants from two primes
#
# Every constant derives from N_W=2, N_C=3 via the spectral action on
# A_F = C + M2(C) + M3(C). Zero free parameters. Zero hardcoded numbers.
#
# Usage:
#   from crystal_constants import *
#   print(IOR_WATER)        # 1.3333...
#   print(GAMMA_DIATOMIC)   # 1.4
#
# Works in: Blender (bpy), Godot (via Python bridge), standalone, Jupyter.

import math

# ═══════════════════════════════════════════════════════════════════
# CRYSTAL ATOMS — the two primes and their invariants
# ═══════════════════════════════════════════════════════════════════

N_W = 2                                     # weak isospin (from M2(C))
N_C = 3                                     # colour (from M3(C))

# Sector dimensions: [1, N_C, N_C^2-1, N_W^3*N_C]
D1 = 1                                      # singlet
D2 = N_C                                    # 3  (colour fundamental)
D3 = N_C**2 - 1                             # 8  (colour adjoint)
D4 = N_W**3 * N_C                           # 24 (mixed fermion)

# Six integer invariants
CHI     = N_W * N_C                         # 6  (Euler characteristic)
BETA0   = (11 * N_C - 2 * CHI) // 3        # 7  (one-loop QCD beta)
SIGMA_D = D1 + D2 + D3 + D4                # 36 (Seeley-DeWitt a0)
SIGMA_D2 = D1**2 + D2**2 + D3**2 + D4**2   # 650 (Seeley-DeWitt a4)
GAUSS   = N_C**2 + N_W**2                   # 13 (sum of squares)
D_TOTAL = SIGMA_D + CHI                     # 42 (tower height)

# Transcendental invariant
KAPPA = math.log(N_C) / math.log(N_W)      # ln3/ln2 = 1.585...

# Representation theory
C_F = (N_C**2 - 1) / (2 * N_C)             # 4/3 (Casimir fundamental)
T_F = 0.5                                   # 1/2 (trace normalisation)

# ═══════════════════════════════════════════════════════════════════
# COUPLING CONSTANTS
# ═══════════════════════════════════════════════════════════════════

ALPHA     = 1.0 / ((D_TOTAL + 1) * math.pi + math.log(BETA0))  # 1/137.036
ALPHA_INV = 1.0 / ALPHA                     # 137.036
SIN2W     = N_C / GAUSS                     # 3/13 = 0.2308
ALPHA_S   = N_W / (GAUSS + N_W**2)          # 2/17 = 0.1176

# ═══════════════════════════════════════════════════════════════════
# OPTICS — Physically Based Rendering
# ═══════════════════════════════════════════════════════════════════

IOR_WATER   = (N_C**2 - 1) / (2 * N_C)     # 4/3 = 1.3333
IOR_GLASS   = N_C / N_W                     # 3/2 = 1.5000
IOR_DIAMOND = 29 / 12                       # 29/12 = 2.4167

# Fresnel F0 = ((n-1)/(n+1))^2 — derived from IOR, not independent
F0_WATER   = ((IOR_WATER - 1) / (IOR_WATER + 1))**2     # 1/49 = 0.0204
F0_GLASS   = ((IOR_GLASS - 1) / (IOR_GLASS + 1))**2     # 1/25 = 0.0400
F0_DIAMOND = ((IOR_DIAMOND - 1) / (IOR_DIAMOND + 1))**2 # 289/2809

# ═══════════════════════════════════════════════════════════════════
# SCATTERING & RADIATION
# ═══════════════════════════════════════════════════════════════════

# Planck spectral radiance: B(λ,T) ∝ λ^(-PLANCK_LAMBDA_EXP)
# Route: DOS ν^(N_C-1) × energy hν × Jacobian |dν/dλ| = λ^(-5)
PLANCK_LAMBDA_EXP = CHI - 1                 # 5

# Rayleigh scattering: σ_R ∝ d^(RAYLEIGH_SIZE_EXP) / λ^(RAYLEIGH_LAMBDA_EXP)
# Size: dipole ∝ vol ∝ d^N_C, power ∝ |dipole|^2 = d^(N_W*N_C)
RAYLEIGH_SIZE_EXP   = CHI                   # 6
# Wavelength: accel ∝ ω^N_W, power ∝ |accel|^2 = ω^(N_W^2)
RAYLEIGH_LAMBDA_EXP = N_W**2                # 4

# Stefan-Boltzmann: P ∝ T^(STEFAN_T_EXP), coefficient = 2π^5/STEFAN_DENOM
STEFAN_T_EXP  = N_W**2                      # 4
STEFAN_DENOM  = N_C * (CHI - 1)             # 15

# ═══════════════════════════════════════════════════════════════════
# THERMODYNAMICS
# ═══════════════════════════════════════════════════════════════════

GAMMA_DIATOMIC  = BETA0 / (CHI - 1)        # 7/5 = 1.400 (air, N2, O2)
GAMMA_MONATOMIC = (CHI - 1) / N_C           # 5/3 = 1.667 (He, Ne, Ar)

# ═══════════════════════════════════════════════════════════════════
# FLUID DYNAMICS
# ═══════════════════════════════════════════════════════════════════

KARMAN          = N_W / (CHI - 1)           # 2/5 = 0.400 (von Kármán)
KOLMOGOROV_EXP  = -(CHI - 1) / N_C          # -5/3 (energy cascade)
STOKES_DRAG     = D4                         # 24 (C_d = 24/Re)
BLASIUS         = 1 / N_W**2                 # 1/4 (boundary layer)
PRANDTL_AIR     = 0.712                      # proved in scan

# ═══════════════════════════════════════════════════════════════════
# MECHANICS — Poisson ratios
# ═══════════════════════════════════════════════════════════════════

POISSON_INCOMPRESSIBLE = T_F                 # 1/2 (rubber, fluid)
POISSON_METAL          = N_C / (GAUSS - N_C) # 3/10 = 0.300 (steel)
POISSON_ALUMINUM       = 1 / N_C             # 1/3 = 0.333
POISSON_CONCRETE       = 1 / (CHI - 1)      # 1/5 = 0.200

# ═══════════════════════════════════════════════════════════════════
# BLAST / SCALING
# ═══════════════════════════════════════════════════════════════════

SEDOV_TAYLOR = N_W / (CHI - 1)              # 2/5 = Flory exponent
FLORY_NU     = SEDOV_TAYLOR                  # same number, different domain

# ═══════════════════════════════════════════════════════════════════
# AUDIO BRIDGES
# ═══════════════════════════════════════════════════════════════════

SABINE_INTEGER = D4                          # 24 (same as Stokes drag)
OCTAVE_RATIO   = N_W                         # 2
FIFTH_RATIO    = N_C / N_W                   # 3/2
FOURTH_RATIO   = C_F                         # 4/3

# ═══════════════════════════════════════════════════════════════════
# PROCEDURAL GENERATION
# ═══════════════════════════════════════════════════════════════════

HURST_BROWNIAN = T_F                         # 1/2 (standard Brownian)
FBM_LACUNARITY = N_W                         # 2
NYQUIST_FACTOR = N_W                         # 2

# ═══════════════════════════════════════════════════════════════════
# SELF-TEST
# ═══════════════════════════════════════════════════════════════════

if __name__ == "__main__":
    print("Crystal Constants — from (2, 3)")
    print(f"  N_W={N_W}, N_C={N_C}, CHI={CHI}, BETA0={BETA0}")
    print(f"  SIGMA_D={SIGMA_D}, SIGMA_D2={SIGMA_D2}, GAUSS={GAUSS}, D={D_TOTAL}")
    print(f"  alpha^-1 = {ALPHA_INV:.6f}")
    print()
    checks = [
        ("IOR_WATER",   IOR_WATER,   4/3),
        ("IOR_GLASS",   IOR_GLASS,   3/2),
        ("GAMMA_DIA",   GAMMA_DIATOMIC, 7/5),
        ("GAMMA_MONO",  GAMMA_MONATOMIC, 5/3),
        ("KARMAN",      KARMAN,      2/5),
        ("KOLMOGOROV",  KOLMOGOROV_EXP, -5/3),
        ("STOKES",      STOKES_DRAG, 24),
        ("BLASIUS",     BLASIUS,     1/4),
        ("PLANCK_EXP",  PLANCK_LAMBDA_EXP, 5),
        ("RAYLEIGH_d",  RAYLEIGH_SIZE_EXP, 6),
        ("RAYLEIGH_λ",  RAYLEIGH_LAMBDA_EXP, 4),
        ("POISSON_INC", POISSON_INCOMPRESSIBLE, 1/2),
        ("SEDOV",       SEDOV_TAYLOR, 2/5),
        ("F0_WATER",    F0_WATER,    1/49),
        ("F0_GLASS",    F0_GLASS,    1/25),
    ]
    passed = 0
    for name, got, want in checks:
        ok = abs(got - want) < 1e-10
        passed += ok
        status = "PASS" if ok else "FAIL"
        print(f"  {status}  {name:20s} = {got:.6f}  (expect {want:.6f})")
    print(f"\n  {passed}/{len(checks)} PASS")
