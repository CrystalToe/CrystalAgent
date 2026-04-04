<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalDynamicEngine — Component 10: Dynamics

## One Sentence

The heartbeat: tick loop, sector projections, and HMC sampler — all from
one operation S = W∘U on 36 dimensions, with callers choosing tick (diagonal)
or tickFull (with D_F mixing).

## What It Owns

1. **TickFn type** — callers choose `tick` (fast, diagonal) or `tickFull` (complete, with mixing)
2. **Sector projections** — Verlet (classical), Yee (EM), Metropolis (thermal)
3. **HMC sampler** — Hamiltonian Monte Carlo accepting a TickFn parameter
4. **MERA sampling** — 42-layer multi-scale sweep
5. **State templates** — equalState, singletState, photonState, weakState, colourState

## The Key Design Decision

`hmcStep` accepts a `TickFn` parameter:

```haskell
type TickFn = CrystalState -> CrystalState

hmcStep :: TickFn -> Int -> Double -> Seed -> CrystalState -> (CrystalState, Bool, Seed)

-- Diagonal (fast, sectors independent):
hmcStep tick     20 0.01 seed state

-- Full D_F (with cross-sector mixing):
hmcStep tickFull 20 0.01 seed state
```

Result: diagonal tick gives ~100% acceptance (trivial landscape).
tickFull gives ~42% acceptance (non-trivial — the mixing creates real dynamics).

## Dependency

```
CrystalAtoms.hs           <- imports nothing (root)
    |
CrystalOperators.hs       <- imports CrystalAtoms
    |
CrystalDynamicEngine.hs   <- imports both Atoms and Operators
```

CrystalEngine.hs and CrystalHMC.hs remain UNTOUCHED. Parallel design.

## Files

| File | Purpose |
|------|---------|
| haskel/CrystalDynamicEngine.hs | The module (self-testing, ~490 lines) |
| haskel/README_CrystalDynamicEngine.md | This file |

## Run

```bash
cd haskel
export LANG=C.UTF-8
ghc -O2 -main-is CrystalDynamicEngine CrystalDynamicEngine.hs && ./CrystalDynamicEngine
```

## What's Next

The 21 dynamics modules can now migrate from CrystalEngine to CrystalDynamicEngine.
Start with CrystalFold.hs (the RMSD question). One at a time. Measure each.
