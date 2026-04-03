<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalSchrodinger — Quantum Mechanics from (2,3)

## The Punchline

The split-operator method IS S = W∘U. Textbooks call it "Strang splitting."
We call it the monad. Same thing. W = potential kick. U = kinetic drift.
No Schrödinger equation is solved. The tick replaces it.

## S = W∘U Decomposition

| Operator | What it does | Implementation | Crystal constant |
|----------|-------------|----------------|-----------------|
| **W** | Potential kick: ψⱼ → e^(−iVⱼdt/2ℏ) ψⱼ | Diagonal multiply | V from sector |
| **U** | Kinetic drift: ψⱼ → ψⱼ + hop(neighbours) | Nearest-neighbour add | hopping = N_w |
| **S = W∘U** | Half-kick, drift, half-kick | Strang splitting | order = N_w = 2 |

The cos/sin in the potential kick generate phase rotation entries ONCE.
They are not dynamics. The dynamics are multiply-add on the lattice.

## ℏ = 1/N_w

The minimum uncertainty in the Heyting lattice is 1/N_w = 1/2. This IS ℏ.

```
meet(1/N_w, 1/N_c) = 1/χ = 1/6  (position AND momentum → fuzzy)
join(1/N_w, 1/N_c) = 1     (position OR momentum → certain)
¬(1/N_w) = 1/N_c           (NOT position = momentum)
```

The uncertainty principle is not a physical law added to the theory.
It is the INCOMPARABILITY of weak and colour sectors in the Heyting lattice.

## Every Integer from (2,3)

| Quantity | Value | Crystal |
|----------|-------|---------|
| ℏ | 1/2 | 1/N_w |
| Spin states | 2 | N_w |
| Pauli matrices | 3 | N_c |
| Bell states | 4 | N_w² |
| Spatial dim | 3 | N_c |
| Phase space | 6 | χ |
| s-shell | 2 | N_w |
| p-shell | 6 | χ |
| d-shell | 10 | N_w(χ−1) |
| f-shell | 14 | N_wβ₀ |
| Balmer denominator | 4 | N_w² |
| Hopping neighbours (1D) | 2 | N_w |
| Hopping neighbours (3D) | 6 | χ |
| Split-operator order | 2 | N_w |
| Pauli exclusion | 1 | N_w(N_w−1)/2 |

## What the Tests Prove

1. **Norm conservation** — harmonic oscillator, 1000 ticks, deviation < 1%
2. **Energy conservation** — same test, energy drift < 5%
3. **Tunneling** — wavepacket through square barrier, probability transmits
4. **Ehrenfest** — free wavepacket with momentum k moves ⟨x⟩ as expected
5. **Shell structure** — s+p = d_colour = 8, total shells = 32 = N_w⁵
6. **Sector restriction** — weak=positions, colour=momenta, mixed=entanglement

## No Calculus

| Traditional | Crystal |
|------------|---------|
| iℏ ∂ψ/∂t = Hψ | ψ(t+1) = tick(ψ(t)) |
| H = −ℏ²∇²/(2m) + V | T = hopping matrix, V = diagonal |
| ∇² = ∂²/∂x² | Laplacian = hop(j−1) − 2×hop(j) + hop(j+1) |
| Path integral | Discrete sum over lattice |
| WKB approximation | Eigenvalue decay per sector |

The discrete Laplacian is NOT a second derivative approximated on a grid.
It IS the physics. The lattice comes first. The continuum is the approximation.

## Files

| File | Location | Count | Method |
|------|----------|-------|--------|
| `CrystalSchrodinger.hs` | `haskel/` | 42 checks | GHC runtime |
| `CrystalSchrodinger.lean` | `proofs/` | 38 theorems | `native_decide` |
| `CrystalSchrodinger.agda` | `proofs/` | 36 proofs | `refl` |

## Run

```bash
# Haskell (from haskel/)
ghc -O2 -main-is CrystalSchrodinger CrystalSchrodinger.hs && ./CrystalSchrodinger

# Lean (from proofs/)
lean CrystalSchrodinger.lean

# Agda (from proofs/)
agda CrystalSchrodinger.agda
```

## Relationship to Other Modules

```
CrystalEngine.hs          S = W∘U on Σd = 36
    ↓ all sectors
CrystalSchrodinger.hs     split-operator on lattice  ← YOU ARE HERE
    ↓ shares
CrystalMonad.hs           ℏ = 1/N_w from Heyting
CrystalChem.hs            shells [2,6,10,14]
CrystalCondensed.hs       spin = N_w = 2 = Ising
CrystalQInfo.hs           Bell = N_w² = 4, Steane = β₀ = 7
CrystalLatticeGauge.hs    plaquette = N_w² = Bell states
```

The split-operator lives in all 4 sectors because a wavefunction has
amplitude everywhere. When you restrict to the weak sector alone, you
get classical position. When you restrict to colour, you get momentum.
The full quantum state requires the full engine.
