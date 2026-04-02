<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->
# CrystalRigid — Rigid Body Dynamics from (2,3)
## Overview
Quaternion integrator + Euler equations. Every rigid-body constant from A_F.
I_sphere = 2/5 = Flory exponent from CrystalMD — same ratio in polymer scaling and solid mechanics.
## Integer Traces
| Physical quantity | Value | Crystal derivation |
|---|---|---|
| Rotation axes | 3 | N_c |
| Quaternion components | 4 | N_w² |
| Inertia tensor (indep) | 6 | χ (symmetric 3×3) |
| Rigid DOF | 6 | χ = N_c + N_c |
| Rotation matrix | 9 | N_c² |
| Euler angles | 3 | N_c |
| I_sphere | 2/5 | N_w/(χ−1) = Flory ν |
| I_rod | 1/12 | 1/(2χ) |
| I_disk | 1/2 | 1/N_w |
| I_shell | 2/3 | N_w/N_c |
## Self-Test
Energy + angular momentum conserved, quaternion norm = 1, symmetric top ω_z constant, all MOI exact.
```bash
ghc -O2 -main-is CrystalRigid CrystalRigid.hs 2>/dev/null && ./CrystalRigid
```
## Observable Count
11 new. All integers from (2,3).
