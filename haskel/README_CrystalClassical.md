<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalClassical.hs — From Monad to Orbits

## What This Module Does

Bridges the quantum monad S = W∘U to classical orbital mechanics.
One Haskell module. Satellite around Earth. Slingshot around Moon. Hohmann transfer.
All from (2,3). No imported physics. Symplectic integrator (not RK4).

## The Key Insight

The monad is discrete and structure-preserving. The correct classical limit
is a symplectic integrator, not RK4. Specifically, Störmer-Verlet leapfrog:

```
v_{n+1/2} = v_n + (Δt/2) × a(x_n)       -- W: half-kick
x_{n+1}   = x_n + Δt × v_{n+1/2}         -- U: full drift
v_{n+1}   = v_{n+1/2} + (Δt/2) × a(x_{n+1})  -- W: half-kick
```

The leapfrog IS S = W∘U∘W in the classical limit.

## Integer Map

| Quantity | Value | Crystal Source |
|----------|-------|---------------|
| Force exponent (1/r²) | 2 | N_c − 1 |
| Spatial dimensions | 3 | N_c |
| Kepler exponent (T² ∝ r³) | 3 | N_c |
| Kepler coefficient (4π²) | 4 | N_w² |
| Angular momentum components | 3 | N_c(N_c−1)/2 |
| Lagrange points | 5 | χ − 1 |
| Phase space (3-body solvable) | 10 | gauss − N_c |
| Phase space (3-body chaotic) | 8 | N_c² − 1 |
| Phase space (total) | 18 | 10 + 8 |
| Quadrupole coefficient | 32/5 | N_w⁵/(χ−1) |
| 16πG coefficient | 16 | N_w⁴ |
| Spacetime dimensions | 4 | N_c + 1 |

## Proof Certificate

All proofs pass:

- `proofs/crystal_classical_proof.py` — 48/48 Python checks (PASS)
- `proofs/CrystalClassical.lean` — ~25 Lean 4 theorems (by native_decide)
- `proofs/CrystalClassical.agda` — ~20 Agda proofs (by refl)

## Dependencies

- No external packages
- Self-contained A_F atoms (no imports required, but compatible with CrystalAxiom)
- Observable count: 0 new (infrastructure)
