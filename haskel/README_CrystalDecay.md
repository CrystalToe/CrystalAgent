<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalDecay — Particle Decay from (2,3)

## Overview

Monte Carlo phase-space integrator for particle decays.
Muon decay formula extracts G_F via betaConst = 192 = d_mixed × d_colour.
Neutron beta decay lifetime predicted from first principles.
PMNS neutrino oscillation from Crystal mixing angles.

## Integer Traces

| Physical quantity | Value | Crystal derivation |
|---|---|---|
| Beta constant | 192 | d_mixed × d_colour = 24 × 8 |
| d_colour | 8 | N_w³ |
| d_mixed | 24 | N_w³ × N_c |
| Weinberg angle sin²θ_W | 3/13 | N_c / gauss |
| PMNS sin²θ₁₂ | 3/π² | N_c / π² |
| PMNS sin²θ₂₃ | 6/11 | χ / (2χ−1) |
| sin²(2θ₂₃) | 120/121 | 4·(χ/(2χ−1))·((χ−1)/(2χ−1)) |
| Phase space dim | 3N−4 | N_c·N − (N_c+1) |

## Self-Test

Neutron lifetime ~878 s, PMNS oscillations, beta spectrum shape.

```bash
ghc -O2 -main-is CrystalDecay CrystalDecay.hs 2>/dev/null && ./CrystalDecay
```

## Observable Count

5 new (beta 192, Weinberg, θ₁₂, θ₂₃, phase dim). All integers from (2,3).
