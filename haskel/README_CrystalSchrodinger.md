<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalSchrodinger — Quantum Mechanics from (2,3)

## What This Module Does

CrystalSchrodinger evolves a quantum wavefunction on a 1D lattice using the
split-operator method. The split-operator decomposition IS the engine's
S = W∘U factorisation: W is the potential kick (diagonal multiply), U is
the kinetic drift (nearest-neighbour hopping). No Schrödinger equation is
solved — the lattice hopping matrix replaces the Laplacian, and the time
step is a matrix multiply, not an ODE integration.

### Split-Operator = S = W∘U

Each tick applies Strang splitting:

1. **Half-kick W (potential):** ψ_j → exp(−iV_j dt/2ℏ) × ψ_j. Diagonal
   phase rotation at each lattice site. The exp(−iθ) = cosθ − i sinθ is
   computed once per site per step — it generates rotation matrix entries,
   not dynamics.

2. **Full drift U (kinetic):** discrete Laplacian via nearest-neighbour
   hopping. (Tψ)_j = −ℏ²/(2m dx²) × (ψ_{j+1} − 2ψ_j + ψ_{j-1}). This
   is add-neighbours-subtract-centre. Pure multiply-add. No derivative.

3. **Half-kick W (potential):** same as step 1. Symmetric splitting gives
   second-order accuracy (Strang splitting order = N_w = 2).

### Integer Traces

| Quantity | Value | Crystal derivation |
|---|---|---|
| ℏ | 1/2 | 1/N_w (Heyting minimum uncertainty) |
| Spin states | 2 | N_w |
| Pauli matrices | 3 | N_c (σ_x, σ_y, σ_z) |
| Bell states | 4 | N_w² |
| Spatial dimensions | 3 | N_c |
| Phase space | 6 | χ = N_w N_c |
| Bohr factor | 2 | N_w |
| Uncertainty denom | 4 | N_w² (Δx Δp ≥ ℏ/2 = 1/4) |
| s-shell | 2 | N_w |
| p-shell | 6 | χ |
| d-shell | 10 | N_w(χ−1) |
| f-shell | 14 | N_w β₀ |
| Split order | 2 | N_w (Strang = second-order) |
| 1D hopping neighbours | 2 | N_w (left + right) |
| 3D hopping neighbours | 6 | χ |

## Engine Wiring

**Status: WIRED.** Module #18 on the Engine Wiring Work List.

### What Changed

1. **`import CrystalEngine`** — all atoms imported from engine.
2. **Deleted local atoms** — nW, nC, chi, beta0, sigmaD, d1–d4 removed.
3. **Renamed `normSq` → `psiNormSq`** — avoids conflict with engine's `normSq`.
4. **`toCrystalState` / `fromCrystalState`** — packs leading 16 complex
   amplitudes (32 reals) into colour (d₃=8) + mixed (d₄=24) sectors.
5. **`proveSectorRestriction`** — round-trip test on 16-amplitude Psi.
6. **Self-test §11–§12** — engine wiring checks and mapping verification.

### Sector

**Colour⊕mixed (d=32).** The wavefunction's spectral content maps to colour
(8 reals = 4 complex amplitudes for momentum/spin) and mixed (24 reals =
12 complex for entangled DOF). No weak-sector coupling — the wavefunction
has no gravitational degrees of freedom.

## Self-Test

```bash
ghc -O2 -main-is CrystalSchrodinger CrystalSchrodinger.hs && ./CrystalSchrodinger
```

Tests: integer identities, shell capacities, norm conservation (1000 ticks,
< 1%), energy conservation (< 5%), tunnelling, wavepacket motion (Ehrenfest),
engine wiring, crystal state round-trip.

## Proof Certificate

- `proofs/CrystalSchrodinger.lean` — original + engine wiring theorems
- `proofs/CrystalSchrodinger.agda` — original + engine wiring proofs
