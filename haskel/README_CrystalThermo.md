<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalThermo — Thermodynamic Dynamics from (2,3)

## What This Module Does

CrystalThermo is a Lennard-Jones molecular dynamics integrator. It simulates
particles interacting via the LJ pair potential and extracts every
thermodynamic constant from the two A_F atoms (N_w=2, N_c=3).

### Lennard-Jones Potential

V(r) = 4ε [(σ/r)^12 − (σ/r)^6]

The exponents are not free parameters — they are forced by the crystal:

- **6 = χ = N_w × N_c** — the attractive (van der Waals) exponent.
  Induced dipole-dipole interaction falls as r^{−6} because there are
  χ = 6 polarisation degrees of freedom.
- **12 = 2χ** — the repulsive (Pauli) exponent. Short-range exchange
  repulsion is the square of the attraction, doubling the exponent.
- **24 = d_mixed** — the LJ force prefactor F = (24ε/r)[2(σ/r)^12 − (σ/r)^6].
  The number 24 is the dimension of the mixed sector. It is also the
  Stokes drag coefficient for a sphere (F = 24μa v / Re at Re→0).

### Velocity Verlet Integrator

Each tick follows the W-U-W (kick-drift-kick) Verlet pattern from
CrystalClassical:

1. **Half-kick (W):** v ← v + (dt/2) a(x), using LJ forces.
2. **Full drift (U):** x ← x + dt v.
3. **Recompute forces** at new positions.
4. **Half-kick (W):** v ← v + (dt/2) a(x_new).

This is symplectic and time-reversible, giving O(dt²) energy conservation.
The positions live in N_c = 3 spatial dimensions per particle.

### Thermodynamic Constants

Every thermodynamic number in this module traces to (2,3):

| Quantity | Value | Crystal derivation |
|---|---|---|
| LJ attractive exponent | 6 | χ = N_w N_c |
| LJ repulsive exponent | 12 | 2χ |
| LJ force prefactor | 24 | d_mixed = (N_w²−1)(N_c²−1) |
| γ_monatomic | 5/3 | (χ−1)/N_c |
| γ_diatomic | 7/5 | β₀/(χ−1) |
| DOF monatomic | 3 | N_c |
| DOF diatomic | 5 | χ−1 |
| Carnot efficiency | 5/6 | (χ−1)/χ  (for T_h/T_c = χ) |
| Stokes drag | 24 | d_mixed |
| ΔS per tick | ln 6 | ln χ |

Temperature is computed from equipartition: T = 2 KE / (N_dof k_B),
with N_dof = N_c per monatomic particle.

## Engine Wiring

**Status: WIRED.** Module #17 on the Engine Wiring Work List.

### What Changed

1. **`import CrystalEngine`** — all atoms (nW, nC, chi, beta0, sigmaD, d1–d4,
   lambda, tick, extractSector, injectSector, etc.) imported from engine.
2. **Deleted local atoms** — the old local `Integer` definitions of nW, nC, chi,
   beta0, sigmaD, sigmaD2, gauss, towerD, dMixed are gone. `dMixed` is now
   defined as `d4` from the engine. All types changed from `Integer` to `Int`
   to match the engine.
3. **`toCrystalState` / `fromCrystalState`** — maps particle state into the
   mixed sector (d=24). Layout: 4 particles × 6 DOF (x,y,z,vx,vy,vz) = 24.
   This packing works because 4 × χ = 4 × 6 = 24 = d_mixed.
4. **`proveSectorRestriction`** — demonstrates that injecting a vector into
   the mixed sector, ticking via the engine, and extracting gives the same
   result as scaling by λ_mixed = 1/6. This proves the domain tick equals
   the engine tick on the mixed sector.
5. **Self-test sections S6–S8** verify engine wiring, round-trip mapping,
   and sector restriction numerically.

### Sector

**Mixed (d=24).** Thermodynamic state has no spatial/gravitational (weak)
or gauge-field (colour) content — temperature, entropy, and LJ forces
are Lorentz scalars and gauge singlets. The 24 mixed-sector slots hold
the complete phase space of 4 particles at 6 DOF each.

### Sector Restriction

λ_mixed = 1/(N_w N_c) = 1/6. The engine tick S = W∘U scales each
mixed-sector component by √λ × √λ = λ = 1/6. This is verified
numerically in `proveSectorRestriction` and proved symbolically in the
Lean and Agda proofs (lambda_mixed_denom, lambda_factorises).

## Self-Test

```bash
ghc -O2 -main-is CrystalThermo CrystalThermo.hs && ./CrystalThermo
```

Tests:
- S1: 10 integer identity checks (all PASS).
- S2: LJ potential shape — minimum at r = 2^(1/6)σ, V(σ) = 0.
- S3: MD integration — 4 particles, 200 Verlet steps, energy conserved < 1%.
- S4: Temperature positive after evolution.
- S5: γ_mono = 5/3, γ_di = 7/5 to machine precision.
- S6: Engine wiring — d_mixed=24, χ=6, Σd=36, tick accessible.
- S7: Round-trip toCrystalState/fromCrystalState = identity.
- S8: Sector restriction — maxdiff < 10⁻¹² on two test vectors.

## Proof Certificate

- `proofs/CrystalThermo.lean` — 27 theorems (12 original + 15 engine wiring)
- `proofs/CrystalThermo.agda` — 27 proofs (11 original + 16 engine wiring)
- `proofs/crystal_thermo_proof.py` — 23/23 PASS (pre-existing)

## Observable Count

0 new (infrastructure). Every number from (2,3).
