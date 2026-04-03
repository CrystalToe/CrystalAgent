<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalEngine — The Native Dynamics Engine

## One Rule

```
tick = applyW . applyU
```

That's it. S = W∘U on 36 dimensions. Every textbook integrator is a sector restriction.

## State Space

The full state is a 36-component vector partitioned by Wedderburn:

```
[1] ⊕ [3] ⊕ [8] ⊕ [24]  =  singlet ⊕ weak ⊕ colour ⊕ mixed  =  Σd = 36
```

Each sector contracts at its eigenvalue per tick:

| Sector | Dim | λ | √λ (W) | √λ (U) | Physics |
|--------|-----|---|--------|--------|---------|
| Singlet | 1 | 1 | 1 | 1 | Dark matter, photon (immortal) |
| Weak | 3 | 1/2 | 1/√2 | 1/√2 | Positions, Higgs |
| Colour | 8 | 1/3 | 1/√3 | 1/√3 | Momenta, gluons |
| Mixed | 24 | 1/6 | 1/√6 | 1/√6 | Full SM coupling |

λ_mixed = λ_weak × λ_colour = 1/6. Not free — forced by tensor structure.

## How Textbook Methods Emerge

The engine doesn't call Verlet or Yee. It applies S = W∘U on all 36 dimensions. Restrict to a sector and you recover the textbook method:

| Sector restriction | What you see | Textbook name |
|-------------------|-------------|---------------|
| Weak ⊕ Colour (dim 3+3) | kick-drift on (x,v) | Verlet |
| Colour (dim 3+3) | B-update then E-update | Yee FDTD |
| Colour (dim 9) | collide then stream | Lattice Boltzmann |
| Mixed (dim 24) | accept/reject then propose | Metropolis |
| Weak ⊕ Colour (dim 6) | momentum then coordinate | Leapfrog (GR) |
| Colour (dim 8) | force then integrate | Barnes-Hut |
| Weak (dim 3) | torque then rotate | Euler equations |

Every method has the same structure: W first (kick/update/collide), then U (drift/propagate/stream). The order is forced by the MERA causal cone.

## Crystal Constants in the Engine

Every integer in every method traces to (2, 3):

| Constant | Value | Crystal | Used by |
|----------|-------|---------|---------|
| Phase space per body | 6 | χ = N_w × N_c | Classical, GR |
| Force exponent | 2 | N_c − 1 | Newton, Coulomb |
| Spatial dimensions | 3 | N_c | All |
| Verlet order | 2 | N_w | Classical |
| EM components | 6 | χ (3E + 3B) | Yee FDTD |
| D2Q9 velocities | 9 | N_c² | LBM |
| Ising states | 2 | N_w | Metropolis |
| LJ attractive | 6 | χ | MD |
| LJ repulsive | 12 | 2χ | MD |
| LJ force coeff | 24 | d_mixed | MD |
| γ monatomic | 5/3 | (χ−1)/N_c | Thermo |
| Quadrupole | 32/5 | N_w⁵/(χ−1) | GW |
| 16πG | 16 | N_w⁴ | GR |
| Octree children | 8 | N_w³ | N-body |
| Quaternion components | 4 | N_w² | Rigid body |
| Fe-56 | 56 | d_colour × β₀ | Nuclear |

## What the Tests Prove

The Haskell module runs 28 checks:

1. Singlet is immortal — norm = 1 after 100 ticks (dark matter, photon)
2. Weak decays as (1/2)^t — verified at t = 10
3. Colour decays as (1/3)^t — verified at t = 10
4. Equal superposition → singlet dominates at late times (arrow of time)
5. Entropy decreases toward pure singlet (2nd law as sector extinction)
6. W∘U = tick verified component-by-component (all 36)
7. E_mixed = E_weak + E_colour (energy additivity)
8. All 10 textbook projection identities

## Files

| File | Location | Count | Method |
|------|----------|-------|--------|
| `CrystalEngine.hs` | `haskel/` | 28 checks | GHC runtime |
| `CrystalEngine.lean` | `proofs/` | 68 theorems | `native_decide` |
| `CrystalEngine.agda` | `proofs/` | 65 proofs | `refl` |

## Run

```bash
# Haskell (from haskel/)
ghc -O2 -main-is CrystalEngine CrystalEngine.hs && ./CrystalEngine

# Lean (from proofs/)
lean CrystalEngine.lean

# Agda (from proofs/)
agda CrystalEngine.agda
```

## Relationship to Other Modules

CrystalEngine is the roof. The 21 dynamics modules are windows:

```
                    CrystalEngine.hs
                    S = W∘U on Σd = 36
                   /    |    |    \
         Classical  EM   CFD  Thermo  ...21 total
         (Verlet)  (Yee) (LBM) (MC)
```

Each dynamics module (CrystalClassical, CrystalEM, CrystalCFD, etc.) implements one sector restriction with its own physics-specific state representation. CrystalEngine shows they all come from the same operator applied to the same space.

The CrystalMonadProof module proves this factorisation is unique. CrystalEngine builds it.
