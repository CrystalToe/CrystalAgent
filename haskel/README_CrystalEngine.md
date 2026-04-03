<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalEngine.hs — The Native Dynamics Engine

## The One-Sentence Summary

Every physical dynamics in the Crystal Topos — classical mechanics, electromagnetism, fluid dynamics, quantum evolution, statistical mechanics, gravity — is the same operation S = W∘U restricted to a different slice of a 36-dimensional state vector.

---

## What The Engine Is

CrystalEngine defines a single time-evolution rule called `tick`. One call to `tick` is one discrete step of the universe. There are no differential equations, no integrands, no Runge-Kutta. The state is a vector of 36 real numbers. The tick multiplies each component by a contraction factor determined by which of four sectors that component belongs to. That's it.

Everything else — Verlet integrators, Yee FDTD, lattice Boltzmann, Metropolis sampling, split-operator quantum, Lindblad channels — emerges when you restrict the tick to a subset of those 36 dimensions and interpret the components as physical quantities.

---

## The State Space: 36 = 1 + 3 + 8 + 24

The algebra A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ) has four irreducible sectors. Their real dimensions are:

| Sector | Name | Dimension | Formula | What Lives Here |
|--------|------|-----------|---------|-----------------|
| 0 | Singlet | 1 | d₁ = 1 | Dark matter, photon propagation, conserved quantities |
| 1 | Weak | 3 | d₂ = N_w² − 1 | Positions, spatial coordinates, Bloch vectors |
| 2 | Colour | 8 | d₃ = N_c² − 1 | Momenta, E/B fields, fluid variables, gauge links |
| 3 | Mixed | 24 | d₄ = (N_w²−1)(N_c²−1) | Thermal states, density matrices, quantum amplitudes |

Total: Σd = 1 + 3 + 8 + 24 = 36.

The state is a flat list of 36 Doubles. Components 0 is the singlet. Components 1–3 are the weak sector. Components 4–11 are the colour sector. Components 12–35 are the mixed sector.

```haskell
type CrystalState = [Double]    -- length 36

extractSector :: Int -> CrystalState -> [Double]
extractSector 0 st = take 1 st                      -- [s₀]
extractSector 1 st = take 3 (drop 1 st)             -- [w₁, w₂, w₃]
extractSector 2 st = take 8 (drop 4 st)             -- [c₁, ..., c₈]
extractSector 3 st = take 24 (drop 12 st)           -- [m₁, ..., m₂₄]
```

---

## The Eigenvalues: {1, 1/2, 1/3, 1/6}

Each sector has a contraction eigenvalue λ_k. These are not chosen — they are forced by the algebra:

| Sector | λ_k | Energy E_k = −ln(λ_k) | Meaning |
|--------|-----|------------------------|---------|
| Singlet | 1 | 0 | Survives forever. Massless. Dark matter. |
| Weak | 1/N_w = 1/2 | ln 2 | Decays by half each tick. Mass scale. |
| Colour | 1/N_c = 1/3 | ln 3 | Decays faster. Confinement. |
| Mixed | 1/χ = 1/6 | ln 6 = ln 2 + ln 3 | Decays fastest. Thermal equilibrium. |

The mixed eigenvalue factorises: λ_mixed = λ_weak × λ_colour. This is not a coincidence — it reflects the tensor product structure of the algebra.

---

## The Monad: S = W ∘ U

The tick is the composition of two maps. Both act by multiplying each component by the square root of its sector eigenvalue:

```haskell
-- U: disentangler (horizontal — removes short-range entanglement)
applyU :: CrystalState -> CrystalState
applyU st = zipWith (\i x -> sqrt(λ_{sectorOf i}) * x) [0..] st

-- W: isometry (vertical — coarse-grains to next MERA layer)
applyW :: CrystalState -> CrystalState
applyW st = zipWith (\i x -> sqrt(λ_{sectorOf i}) * x) [0..] st

-- S = W ∘ U: one tick
tick :: CrystalState -> CrystalState
tick = applyW . applyU
```

The net effect on sector k after one tick: each component is multiplied by √λ_k × √λ_k = λ_k. So:

- Singlet components: unchanged (× 1)
- Weak components: halved (× 1/2)
- Colour components: thirded (× 1/3)
- Mixed components: sixthed (× 1/6)

After n ticks, the norm squared in sector k is (λ_k)^n times the initial norm squared.

**Why two maps, not one?** Because in the MERA (multi-scale entanglement renormalisation ansatz), each RG layer has two distinct operations: U removes entanglement within a layer, W maps to the next coarser layer. The composition is the renormalisation group step. The physical interpretation:

- **U = drift** (update positions from momenta, or E from B, or propose a Monte Carlo move)
- **W = kick** (update momenta from forces, or B from E, or accept/reject)

The order matters for causality. W∘U means: disentangle first, then coarse-grain. U∘W gives the same eigenvalues (they commute as scalars) but the wrong causal structure.

---

## What Happens Over Time

Start with any state. Apply tick repeatedly.

1. **Singlet survives.** Its eigenvalue is 1. A photon in the singlet sector propagates forever with no decay. This is why light has no mass — it lives in the sector that doesn't contract.

2. **Everything else decays.** The weak sector halves each tick. The colour sector thirds. The mixed sector sixths. After 50 ticks, a state that started as equal superposition across all 36 dimensions is 99%+ singlet.

3. **This is the arrow of time.** The monad is not unitary — it contracts. The entropy (Shannon entropy of sector probabilities) decreases monotonically toward the pure singlet. The second law is not added by hand; it IS the monad.

4. **The energy spectrum is discrete.** E_k = −ln(λ_k) gives {0, ln 2, ln 3, ln 6}. The mass gap is E_weak − E_singlet = ln 2. This is the smallest nonzero energy the engine can produce.

---

## How Textbook Methods Emerge

Each dynamics module proves that its domain-specific tick is the engine tick restricted to a sector. The restriction works like this:

1. **Map domain state into CrystalState** (inject into the right sector, zero the rest)
2. **Apply tick**
3. **Extract the sector** back to domain state

The domain tick and the engine tick must agree on the sector components. This is what `proveSectorRestriction` checks in every wired module.

### Classical Mechanics (CrystalClassical)

**Sector:** weak (d=3, positions) ⊕ colour (first 3 of d=8, velocities)

The Verlet leapfrog integrator is S restricted to 6 of the 36 dimensions:

- Position lives in the weak sector (3 components)
- Velocity lives in the first 3 components of the colour sector
- W = kick (update velocity from force) with contraction √λ_weak
- U = drift (update position from velocity) with contraction √λ_colour
- Phase space per body = 3 + 3 = χ = 6

The Verlet integrator is second-order (N_w = 2). The force law is 1/r² (exponent = N_c − 1 = 2). The Lagrange points number χ − 1 = 5. These are not inputs — they are consequences of which sector classical mechanics lives in.

### Electromagnetism (CrystalEM)

**Sector:** colour (d=8, E and B fields)

The Yee FDTD scheme is S restricted to the colour sector:

- E-field: first 3 components of colour
- B-field: next 3 components of colour
- W = Faraday (B-kick from E)
- U = Ampère (E-drift from B)
- Courant number = 1/N_w = 0.5

The 6 field components (3E + 3B) = χ = 6. The remaining 2 colour dimensions carry gauge/constraint information.

### Lattice Boltzmann (CrystalCFD)

**Sector:** colour (d=8, fluid + EM merged)

D2Q9 has 9 velocities = N_c² = 9. The collision operator contracts at rate λ_colour = 1/3. The lattice coordination number = χ = 6 (hexagonal).

### Hamiltonian Monte Carlo (CrystalHMC)

**Sector:** full engine (Σd = 36)

HMC is the engine used as a sampling machine. It doesn't restrict to a sector — it samples the full 36-dimensional state space using the engine's own eigenvalues as the energy landscape.

- Momentum sector = weak (d=3): the HMC auxiliary momenta
- Position sector = weak ⊕ colour (d=11): the configuration being sampled
- Full state = Σd = 36: every tick is a leapfrog step in the MERA
- MERA layers sampled = towerD = 42

The leapfrog integrator inside HMC IS the engine tick. The accept/reject step uses the energy E_k = −ln(λ_k) from the eigenvalues. The proposal is U (disentangle), the accept/reject is W (coarse-grain). HMC on the MERA is the engine sampling itself.

### Metropolis / Ising (CrystalCondensed)

**Sector:** mixed (d=24, thermal states)

The simpler case: Metropolis on a lattice. N_w = 2 states per site (Ising up/down). Coordination z = χ = 6 (cubic). Contraction λ_mixed = 1/6 drives toward thermal equilibrium. This is HMC restricted to the mixed sector — a projection of the full sampling engine.

### Quantum Evolution (CrystalSchrodinger, CrystalQuantum)

**Sector:** colour ⊕ mixed (d=32, complex amplitudes)

A complex amplitude needs 2 reals. 16 complex amplitudes = 32 reals = d₃ + d₄ = 8 + 24. The Hilbert space is ℂ^χ = ℂ⁶. The split-operator method splits the Hamiltonian into kinetic (colour) and potential (mixed).

### Hologron / Gravity (CrystalHologron)

**Sector:** full engine (Σd = 36)

Gravity uses all 36 dimensions. Two hologrons (defects in the MERA) attract because the monad preferentially preserves lower-energy configurations. No F=ma is written. The force law 1/r² emerges because N_c = 3 spatial dimensions, and the potential V(r) ∝ 1/r emerges because N_c − 2 = 1.

---

## The Sector Restriction Proof

Every wired dynamics module contains:

```haskell
-- Map domain state into engine state
toCrystalState :: DomainState -> CrystalState

-- Extract domain state from engine state
fromCrystalState :: CrystalState -> DomainState

-- THE PROOF: domain tick = engine tick on sector
proveSectorRestriction :: DomainState -> Bool
proveSectorRestriction ds =
  let engineResult = fromCrystalState (tick (toCrystalState ds))
      domainResult = domainTick ds
  in approxEqual engineResult domainResult
```

This is the theorem. If `proveSectorRestriction` returns True for test states, the domain-specific integrator is demonstrably a projection of the single engine tick.

---

## Operations the Engine Exports

| Function | Type | Purpose |
|----------|------|---------|
| `tick` | `CrystalState -> CrystalState` | One step of S = W∘U |
| `evolve` | `Int -> CrystalState -> [CrystalState]` | n ticks, returns trajectory |
| `applyW` | `CrystalState -> CrystalState` | Isometry (vertical, kick) |
| `applyU` | `CrystalState -> CrystalState` | Disentangler (horizontal, drift) |
| `extractSector` | `Int -> CrystalState -> [Double]` | Pull out sector k |
| `injectSector` | `Int -> [Double] -> CrystalState -> CrystalState` | Write into sector k |
| `normSq` | `CrystalState -> Double` | Total norm squared |
| `sectorWeight` | `Int -> CrystalState -> Double` | Norm squared in sector k |
| `energy` | `CrystalState -> Double` | Expected energy from eigenvalues |
| `entropy` | `CrystalState -> Double` | Shannon entropy of sectors |
| `lambda` | `Int -> Double` | Eigenvalue of sector k |
| `sectorDim` | `Int -> Int` | Dimension of sector k |
| `sectorStart` | `Int -> Int` | Start index of sector k |
| `sectorOf` | `Int -> Int` | Which sector does component i belong to? |

## Atoms the Engine Exports

| Atom | Value | Formula |
|------|-------|---------|
| `nW` | 2 | Input |
| `nC` | 3 | Input |
| `chi` | 6 | N_w × N_c |
| `beta0` | 7 | (11N_c − 2χ)/3 |
| `d1` | 1 | Singlet |
| `d2` | 3 | N_w² − 1 |
| `d3` | 8 | N_c² − 1 |
| `d4` | 24 | (N_w²−1)(N_c²−1) |
| `sigmaD` | 36 | d₁+d₂+d₃+d₄ |
| `towerD` | 42 | Σd + χ |
| `gauss` | 13 | N_w² + N_c² |

---

## No Calculus in the Engine

The tick function contains: scalar multiplication, function composition. No sin, cos, exp, log, sqrt in the tick loop. The square roots in `wK` and `uK` are precomputed constants (√(1/2), √(1/3)), not called per-step on variable data. Transcendentals appear only in observables (`energy`, `entropy`) which are diagnostic — they don't feed back into the tick.

This is rule 25 of the WACA LLM: calculus is banned in dynamics. The engine is multiply-add. The universe does not integrate differential equations. It applies the monad.

---

## Compile and Run

```bash
ghc -O2 -main-is CrystalEngine CrystalEngine.hs && ./CrystalEngine
```

Self-test covers: sector structure, singlet immortality, weak/colour decay rates, equal-superposition convergence to singlet, factorisation S = W∘U, causal ordering, all sector projection identities (Verlet, Yee, LBM, Metropolis, LJ, quadrupole), arrow of time, energy spectrum.

---

## Dependencies

None. CrystalEngine imports nothing. It is the source of truth.
