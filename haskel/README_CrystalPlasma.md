<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalPlasma — MHD (EM + CFD) from (2,3)

## Overview

Magnetohydrodynamics capstone combining EM and CFD sectors.
Alfvén wave FDTD integrator. Magnetic pressure and plasma beta.

## Integer Traces

| Physical quantity | Value | Crystal derivation |
|---|---|---|
| MHD wave types | 3 | N_c (slow, Alfvén, fast) |
| MHD state variables | 8 | N_w³ = d_colour |
| Propagating modes | 6 | χ = 2·N_c |
| Non-propagating modes | 2 | N_w (entropy + div-B) |
| Magnetic pressure factor | 2 | N_w |
| Plasma beta factor | 2 | N_w |
| EM components | 6 | χ (from CrystalEM) |
| CFD D2Q9 | 9 | N_c² (from CrystalCFD) |

## Self-Test

Alfvén wave energy conservation, periodicity, magnetic pressure, plasma beta, Alfvén speed.

```bash
ghc -O2 -main-is CrystalPlasma CrystalPlasma.hs 2>/dev/null && ./CrystalPlasma
```

## Observable Count

8 new (MHD = EM + CFD capstone). All integers from (2,3).
