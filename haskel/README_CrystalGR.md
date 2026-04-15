<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalGR.hs — General Relativistic Orbits from (2,3)

## THE DYNAMICS IS THE TICK ON THE 36.

Each geodesic = one CrystalState. S = W∘U. U disentangler = Schwarzschild curvature.

## Build

```bash
cd haskel/
ghc -O2 -main-is CrystalGR CrystalGR.hs && ./CrystalGR

cd proofs/
agda CrystalGR.agda
lean CrystalGR.lean
```

## Sector Assignment

| Data | Sector | Dim | λ |
|------|--------|-----|---|
| E² marker | singlet [1] | 1 | 1 |
| r, φ, τ | weak [3] | 3 | 1/2 |
| v_r, φ̇, ṫ, F_r, L, E, V_eff, metric | colour [8] | 8 | 1/3 |

## HOW THE DYNAMICS WORKS

```
U step: curvature disentangler
  F_r = −GM/r² + L²/r³ − N_c·GM·L²/r⁴
  φ̇ = L/r²
  ṫ = E/(1−r_s/r)
  → stored in colour sector

W step: per-geodesic sector tick
  v_r' = v_r + wK₁ × F_r
  r' = r + uK₂ × v_r'
  φ' = φ + uK₂ × φ̇
```

```haskell
grTick rs = wStepGR . uStepGR rs
```

## Integer Map

| Quantity | Value | Source |
|----------|-------|--------|
| r_s = 2GM | 2 | N_c − 1 |
| Precession 6πGM | 6 | χ |
| Light bending 4GM/b | 4 | N_w² |
| ISCO = 6GM | 6 | χ |
| ISCO = 3r_s | 3 | N_c |
| Photon sphere = 3GM | 3 | N_c |
| E²_ISCO = 8/9 | 8,9 | d_colour, N_c² |
| Spacetime dim | 4 | N_c + 1 |
| 16πG | 16 | N_w⁴ |
| GR correction −3GML²/r⁴ | 3 | N_c |
| Shadow = 3√3 GM | 3,√3 | N_c, √N_c |
| Shapiro 2r_s ln(4r₁r₂/b²) | 2,4 | N_c−1, N_w² |

## Cool Stuff for Three.js

- `diskRings` — accretion disk ring geometry with temperature color
- `vEffCurve` — effective potential "rubber sheet" visualization
- `shadowRadius` — black hole shadow circle for rendering
- `trajPositions3D` — orbit paths in 3D Cartesian
- `trajRedshift` — gravitational redshift for color mapping along orbit
- `plungingOrbit` — particle spiraling into black hole
- `photonOrbit` — photon deflection / capture
- `diskColor` — temperature → RGBA for accretion glow
