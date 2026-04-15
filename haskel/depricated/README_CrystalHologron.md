<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalHologron — PROOF OF CONCEPT (NOT NATIVE MERA)

## ⚠️ STATUS: PROOF OF CONCEPT ONLY

**This module is NOT part of the crystal universe.**

It does NOT use native MERA operations. It does NOT import CrystalMonad.hs
or CrystalMERA.hs. It does NOT use `tick`, `applyW`, `applyU`, `evolveRecord`,
or the ascending superoperator. It does NOT operate on the 650 endomorphisms.

**What it actually does:** pastes crystal NUMBERS ({1, 1/2, 1/3, 1/6}, N_c=3)
into standard physics formulas (Boltzmann weighting, power-law potentials).
The dynamics come from `exp(-V(x))` — standard statistical mechanics — not
from the monad.

**What it should do:** import CrystalMonad, define a multi-site lattice state,
apply actual `tick` operations (W∘U) across the lattice, and watch attraction
EMERGE from the isometry. The potential should be a CONSEQUENCE of the monad,
not an INPUT.

**The gap:** `applyU = id` for single sites. U only acts on pairs. A real
hologron module needs multi-site U (the disentangler acting on neighboring
sites) so that spatial dynamics can emerge from entanglement redistribution.

## What This Module Demonstrates (proof of concept only)

That crystal numbers, when inserted into standard gravitational formulas,
produce the correct scaling dimensions and force laws. This is necessary
but not sufficient. The real test is whether the monad PRODUCES these
formulas without being told them.

## The Correct Architecture (not yet built)

```
CrystalMonad.hs    →  tick, applyW, applyU (native operations)
CrystalMERA.hs     →  multi-site lattice, geodesic depth, entanglement
                        ↓
CrystalHologron.hs →  SHOULD import both, define multi-site state,
                       insert defect, apply ticks, measure attraction
                       using ONLY native monad operations
```

## Key Numbers (correctly from (2,3), but pasted in, not derived by monad)

| Quantity | Formula | Value | Status |
|----------|---------|-------|--------|
| Scaling dim Δ_weak | ln2/ln6 | 0.3869 | Correct number, pasted in |
| Force exponent | N_c − 1 | 2 | Correct, already proved in CrystalGravity |
| Potential (3D) | N_c − 2 | 1 | Correct, already proved in CrystalGravity |
| Spatial dim | N_c | 3 | Correct |

## Connection to Literature

Sahay, Lukin, Cotler (Harvard) — **Phys Rev X 15, 021078 (2025)**:
showed MERA tensor networks produce "hologrons" with attractive interactions.
They use actual MERA tensor operations. This module does NOT — it uses
the crystal's numbers but not its operations. A native implementation
would follow their methodology using CrystalMonad's `tick` and
CrystalMERA's layer structure.

## What Needs to Happen

1. Multi-site CrystalState (array of sector amplitudes across lattice sites)
2. Multi-site U (disentangler acting on PAIRS of neighboring sites)
3. Multi-site W (isometry compressing pairs to singles)
4. Insert defect = excite one site to non-singlet sector
5. Apply `tick` across entire lattice
6. Measure: does the defect's probability distribution shift?
7. The attraction must EMERGE from steps 2-5, not be pasted in

## Build

```bash
ghc -O2 -main-is CrystalHologron CrystalHologron.hs -o hologron && ./hologron
```

## Observable Count

0 new. Proof of concept. NOT part of the crystal universe until rewritten
with native MERA operations.
