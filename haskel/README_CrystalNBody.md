<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalNBody.hs — N-Body Gravitational Dynamics from (2,3)

## What This Module Does

Barnes-Hut octree for O(N log N) gravitational force computation.
Symplectic leapfrog (W-U-W) for time integration. Scales to 1000+ bodies.

## Integer Map

| Quantity | Value | Crystal Source |
|----------|-------|---------------|
| Oct-tree children | 8 | 2^N_c = N_w^N_c = d_colour |
| Force exponent | 2 | N_c - 1 |
| Spatial dim | 3 | N_c |
| Phase space/body | 6 | 2*N_c = chi |

Key surprise: oct-tree has 8 = d_colour children. The number of octants
in 3D space IS the dimension of the colour adjoint representation of SU(3).

## Proof Certificate

- `proofs/crystal_nbody_proof.py` — 12/12 PASS
- `proofs/CrystalNBody.lean` — 6 theorems
- `proofs/CrystalNBody.agda` — 5 proofs
