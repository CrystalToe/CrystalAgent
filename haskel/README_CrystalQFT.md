<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalQFT — Quantum Field Dynamics from (2,3)

## Overview

Tree-level S-matrix, running couplings, and Feynman rules. Every QFT integer
traced to A_F: spacetime=4=N_w², Lorentz=6=χ, gluons=8=d₃, β₀=7.

## Integer Traces

| Physical quantity | Value | Crystal derivation |
|---|---|---|
| Spacetime dimension | 4 | N_w² |
| Lorentz generators | 6 | χ = d(d−1)/2 for d=N_w² |
| Dirac γ matrices | 4 | N_w² |
| Spin-1/2 components | 2 | N_w |
| Photon polarisations | 2 | N_c−1 |
| Gluon colours | 8 | N_c²−1 = d₃ |
| QCD β₀ | 7 | (11N_c−2χ)/3 |
| One-loop factor | 16 | N_w⁴ |
| Thomson 8/3 | 8/3 | d_colour/N_c |
| Propagator exponent | 2 | N_c−1 |
| σ(ee→μμ) factor | 4πα²/(3s) | N_w²·π·α²/(N_c·s) |
| Pair threshold | 2m | N_w·m |
| Phase space Φ₂ | 1/(8π) | 1/(d_colour·π) |

## Self-Test

α⁻¹=137.034 from Crystal, σ(ee→μμ)=0.869nb at 10GeV, Thomson=0.665b, QCD running.

```bash
ghc -O2 -main-is CrystalQFT CrystalQFT.hs 2>/dev/null && ./CrystalQFT
```

## Observable Count

13 new. All integers from (2,3).
