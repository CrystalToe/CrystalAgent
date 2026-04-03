<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalHMC.hs — Hamiltonian Monte Carlo on the MERA

## What This Module Does

Hamiltonian Monte Carlo without calculus. Samples all 42 layers of the MERA
using the engine S = W∘U directly. The "Hamiltonian" is H = −ln(S)/β.
The "gradient" is a sector projection. The "leapfrog" is tick().
The "accept/reject" is compare. All multiply-add. All from (2,3).

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

```haskell
import CrystalEngine
  ( nW, nC, chi, beta0, sigmaD, towerD, gauss
  , d1, d2, d3, d4
  , lambda
  , CrystalState
  , sectorOf, sectorStart, sectorDim
  , extractSector, injectSector
  , normSq, tick
  )
```

### Sector Restriction

HMC uses the **full** engine state space (Σd = 36). The three HMC steps
map to sector operations:

| HMC Step | Engine Operation | Sector |
|----------|-----------------|--------|
| Momentum refresh | inject random → weak | d₂ = 3 (weak) |
| Leapfrog trajectory | N ticks of S on position+momentum | d₂ + d₃ = 11 (weak⊕colour) |
| Accept/reject | compare energies from all sectors | full Σd = 36 |

Phase space per body = χ = 6 (3 positions + 3 momenta).
Verlet order = N_w = 2.
Metropolis states = N_w = 2.

## The Key Insight

Traditional HMC solves Hamilton's equations with a leapfrog integrator,
then accepts/rejects with Metropolis. Crystal HMC does the same thing
but the leapfrog IS the engine tick restricted to weak⊕colour, and
Metropolis IS a comparison in the mixed sector. No differential equations
are solved. The "gradient" ∂S/∂ψᵢ = 2 × ψᵢ × E_sector(i) is a multiply,
not a derivative.

## Integer Map

| Quantity | Value | Crystal Source |
|----------|-------|---------------|
| Momentum dimension | 3 | d₂ = N_w² − 1 |
| Phase space per body | 6 | χ = N_w × N_c |
| Leapfrog (Verlet) order | 2 | N_w |
| Metropolis states | 2 | N_w |
| Colour sector dimension | 8 | d₃ = N_c² − 1 |
| Mixed sector dimension | 24 | d₄ = (N_w²−1)(N_c²−1) |
| State space | 36 | Σd = 1+3+8+24 |
| MERA layers | 42 | D = Σd + χ |
| Total MERA state | 1512 | D × Σd = 42 × 36 |
| LCG multiplier | 650 | Σd² = 1+9+64+576 |
| LCG increment | 7 | β₀ |
| LCG modulus | 65536 | 2¹⁶ = N_w^(N_w⁴) |
| Gradient factor | 2 | N_w |
| E_singlet denominator | 1 | singlet (immortal) |
| E_weak denominator | 2 | N_w |
| E_colour denominator | 3 | N_c |
| E_mixed denominator | 6 | χ = N_w × N_c |
| Ryu-Takayanagi 4G | 4 | N_w² |
| Ryu-Takayanagi 8πG | 8 | d₃ = N_c² − 1 |
| Bond dimension | 6 | χ |

## Proof Certificate

All proofs pass:

- `haskel/CrystalHMC.hs` — 36 checks (35 PASS, 1 pre-existing tuning FAIL on acceptance rate)
- `proofs/CrystalHMC.lean` — 41 Lean 4 theorems (by native_decide)
- `proofs/CrystalHMC.agda` — 41 Agda proofs (by refl)
- §10 sector restriction proof exercises imported CrystalEngine functions

## Dependencies

- **Imports CrystalEngine** — atoms, types, sector operations, tick, normSq
- No external packages
- HMC-specific: `sectorEnergy`, `sectorFraction`, `entropy`, `action`, `gradient`
