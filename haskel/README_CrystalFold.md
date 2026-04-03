<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalFold — Protein Folding from (2, 3)

## One Sentence

Protein folding is eigenvalue contraction on the mixed sector (d=24),
where d₄ = 4 × χ means each engine state holds exactly 4 residues at
6 degrees of freedom each, and the four decay rates {1, 1/2, 1/3, 1/6}
reproduce the folding funnel without solving a single differential equation.

## The Architecture

```
CrystalEngine.hs          tick = multiply by {1, 1/2, 1/3, 1/6}
       ↓
CrystalHMC.hs             hmcEngineTick = tick  (sampler, 36 multiplies)
       ↓
CrystalProtein.hs         Force field: 7 channels × 43 layers, all from A_F
       ↓
CrystalFold.hs            Fold harness: tile → tick → couple → repeat
       ↓
CrystalBio.hs             Validation: helix 3.6, Flory 0.4, sheets 3.5 Å
```

CrystalFold is not a dynamics module. It is an application built on the engine.

## How Folding Works

### Step 1: Tile the Chain

A protein of N residues is split into tiles of 4 residues each.
Each tile packs into the mixed sector (d₄ = 24 = 4 × 6) of one CrystalState.

```
Residue:  [x, y, z, φ, ψ, ω]     — 6 DOF = χ
Tile:     [res₁, res₂, res₃, res₄] — 24 DOF = d₄
Chain:    [tile₁, tile₂, ..., tile_N/4]
```

### Step 2: Tick

Each tile ticks independently. The engine multiplies every component in the
mixed sector by λ_mixed = 1/6. This is the intra-tile dynamics.

### Step 3: Couple

Neighbouring tiles interact through their boundary residues. Residue 4 of
tile k touches residue 1 of tile k+1. The interaction energy comes from
CrystalProtein's force field — VdW, H-bond, backbone angle, burial,
dihedral, electrostatic. All precomputed at init from A_F atoms.

### Step 4: Observe

After sufficient ticks, read out the 3D coordinates. Compute radius of
gyration, secondary structure, contact map, RMSD to known structure.

## Why the Folding Funnel Falls Out

The four eigenvalue rates create four timescales:

| τ | Rate | What | Analogy |
|---|------|------|---------|
| τ_backbone | 1/2 (weak) | Chain collapse, end-to-end | Hydrophobic collapse |
| τ_contacts | 1/3 (colour) | Side chain packing, core | Contact order |
| τ_cooperativity | 1/6 (mixed) | Long-range, allostery | Frustration |
| τ_topology | 1 (singlet) | Chain connectivity | Conservation |

Backbone collapses first (fast). Then contacts form (medium). Then long-range
order locks in (slow). Topology never changes (conserved). This IS the funnel.

Levinthal's paradox says random search of 3¹⁰⁰ conformations is impossible.
The engine doesn't search. It contracts four sectors at four rates. The backbone
eliminates most conformations in ~N ticks. The contacts eliminate most of the
rest. The cooperativity locks the answer. Total: ~3N ticks, not 3^N.

## Crystal Constants in Folding

| Constant | Value | Origin | Role |
|----------|-------|--------|------|
| Residues per tile | 4 | d₄/χ = 24/6 | Tiling |
| DOF per residue | 6 | χ = N_w × N_c | Phase space |
| Amino acids | 20 | N_w²(χ-1) | Alphabet size |
| Helix/turn | 3.6 | 18/5 = N_c²N_w/(χ-1) | Secondary structure |
| Helix rise | 1.5 Å | N_c/N_w = 3/2 | Pitch |
| Sheet spacing | 3.5 Å | β₀/N_w = 7/2 | β-structure |
| Flory exponent | 0.4 | N_w/(χ-1) = 2/5 | Polymer scaling |
| Ramachandran | 56.25% | Σd/4^N_c = 36/64 | Allowed φ,ψ |
| Fold energy | v/2⁴² | v/2^D | Energy scale |
| Backbone (weak) | 1/2 | λ_weak | Collapse rate |
| Contacts (colour) | 1/3 | λ_colour | Packing rate |
| Coupling (mixed) | 1/6 | λ_mixed | Refinement rate |
| Topology (singlet) | 1 | λ_singlet | Conserved |

## Files

| File | Location | Proofs | Method |
|------|----------|--------|--------|
| `CrystalFold.hs` | `haskel/` | self-test | GHC runtime |
| `CrystalFold.lean` | `proofs/` | 12 theorems | `native_decide` |
| `CrystalFold.agda` | `proofs/` | 12 proofs | `refl` |

## Run

```bash
# Haskell
ghc -O2 -main-is CrystalFold CrystalFold.hs && ./CrystalFold

# Lean proofs
lean CrystalFold.lean

# Agda proofs
agda CrystalFold.agda
```

## Dependencies

```
CrystalFold
  ├── CrystalEngine   (tick)
  ├── CrystalHMC      (sampler — hmcEngineTick = tick)
  ├── CrystalProtein   (force field — 7 channels × 43 layers)
  └── CrystalBio       (validation — structural constants)
```

## The Point

Protein folding is not a billion-body F=ma simulation.
It is 25 tiles of 4 residues each, ticking at {1, 1/2, 1/3, 1/6},
coupled through precomputed energy terms from a force field that has
zero free parameters. The folding funnel is not a metaphor. It is
four eigenvalue rails, and the protein slides down them fastest-first.
