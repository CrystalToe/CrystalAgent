<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalWACAScan.hs

**2046 lines · Zero hardcoded numbers · 103 observables · 19 sections**

## The Hadron Scale
```
Λ_h = v/(2^(2^N_c) + 1) = v/257 = 958.05 MeV
```
257 is the third Fermat prime. Every heavy hadron factorises through it.

## Sections

| § | Domain | Observables |
|---|--------|-------------|
| 0 | Crystal constants | (derived invariants) |
| 1–12 | Mesons, baryons, quarks, tau, splittings, EW, cosmology, nuclear, moments, gravity, thermo | 44 |
| 13a–m | Fluid, biology, chemistry, genetics, superconductivity, optics, epigenetics, dark sector, three-body, proton radius, cosmology deep | 42 |
| 14 | Master audit | (aggregation) |
| 15 | Key discoveries | (documentation) |
| 16 | Fundamentals Phase 1 — Easy 5 | 5 |
| 17 | Fundamentals Phase 2 — Medium 5 | 5 |
| 18 | Fundamentals Phase 3 — Hard 4 | 4 |
| 19 | Rendering & Scattering Physics | 3 |
| | **Total in wacaScanResults** | **103** |

## Highlights

| Observable | Formula | PWI |
|-----------|---------|-----|
| m_c/m_s | N_w²·N_c × (D+β₀)/(D+β₀+1) = 11.76 | 0.000% |
| Δα_had | 1/Σd = 1/36 | 0.043% |
| Planck λ exponent | χ−1 = 5 | 0.000% |
| Rayleigh size exp | χ = 6 | 0.000% |
| Rayleigh λ exponent | N_w² = 4 | 0.000% |
| η' meson | Λ_h itself | 0.029% |
| m_τ | Λ_h × gauss/β₀ | 0.134% |
| M_Pl/v | e^D/(β₀(χ−1)) = e⁴²/35 | 0.209% |
| μ_p/μ_N | N_w×β₀/(χ−1) = 14/5 | 0.258% |
| γ (Euler-Masch) | β₀/(gauss−1)−1/(gauss²−N_w) | 0.025% |

## §19 — Rendering & Scattering (new)

Three EXACT observables for game engine and rendering physics:

| # | Observable | Formula | Value | Physics |
|---|-----------|---------|-------|---------|
| 204 | Planck λ exponent | χ−1 | 5 | B(λ,T) ∝ λ⁻⁵ — fire, stars, lava |
| 205 | Rayleigh size exp | χ = N_w·N_c | 6 | σ_R ∝ d⁶ — fog, dust, haze |
| 206 | Rayleigh λ exponent | N_w² | 4 | σ_R ∝ λ⁻⁴ — skybox, atmosphere |

Crystal routes:
- **Planck 5:** DOS ν^(N_c−1) × energy hν × Jacobian |dν/dλ| = λ^(−5). More fundamental than Stefan-Boltzmann T⁴ (which derives from integrating this).
- **Rayleigh 6:** Dipole ∝ volume ∝ d^N_c. Power ∝ |dipole|² = d^(N_w·N_c) = d^χ.
- **Rayleigh 4:** Acceleration ∝ ω^N_w. Power ∝ |accel|² = ω^(N_w²). Same integer as Stefan-Boltzmann but independent physics (elastic dipole scattering, 1871).

## Derivation Chain
21 steps from (2, 3, v, π, ln) → all 103 observables. Zero bare numbers in executable code.

## Combined Catalogue (with CrystalFullTest.hs)

| Source | Count |
|--------|-------|
| Original (Main.hs modules) | 92 |
| Extended (CrystalWACAScan) | 103 |
| S4–S6 (corrected constants) | 3 |
| **Total** | **198** |

## Dependencies
Standalone (redefines constants internally for independence).
