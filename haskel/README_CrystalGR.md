<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalGR.hs — General Relativistic Orbits from (2,3)

## What This Module Does

Extends CrystalClassical.hs to curved spacetime. Schwarzschild geodesic
integration via symplectic leapfrog. Perihelion precession, light bending,
ISCO, Shapiro delay — all from (2,3).

## The GR Integer Map

| Quantity | Value | Crystal Source | Physical Meaning |
|----------|-------|---------------|-----------------|
| r_s = 2GM | 2 | N_c - 1 | Schwarzschild radius coefficient |
| Precession 6piGM/... | 6 | chi = N_w*N_c | Perihelion advance |
| Light bending 4GM/b | 4 | N_w^2 | = Ryu-Takayanagi 4 |
| ISCO = 6GM | 6 | chi | Innermost stable orbit |
| ISCO = 3 r_s | 3 | N_c | In units of r_s |
| E_ISCO^2 = 8/9 | 8,9 | d_colour, N_c^2 | ISCO binding energy |
| Shapiro delay | 2,4 | N_c-1, N_w^2 | Time delay coefficients |
| Spacetime dim | 4 | N_c + 1 | |
| 16piG | 16 | N_w^4 | Einstein equation |

## Key Results

- Mercury precession: 42.98 arcsec/century (analytic, exact)
- Numerical precession: 4.1% error at a = 100 r_s (strong field)
- Light bending: 1.751 arcsec at Sun limb (exact)
- ISCO: r = 3 r_s = 6 GM (exact integers)
- Hamiltonian conserved to < 4e-6 over 50000 steps (symplectic)

## Proof Certificate

- `proofs/crystal_gr_proof.py` — 26/26 PASS
- `proofs/CrystalGR.lean` — 18 theorems by native_decide
- `proofs/CrystalGR.agda` — 13 proofs by refl
