<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalFold.hs — Protein Folding from (2,3)

## Compile

```bash
ghc -O2 -main-is CrystalFold CrystalFold.hs && ./CrystalFold
```

## What This Module Is

A protein folding simulation where the fold dynamics come from the crystal algebra. Not a reimplementation of Rosetta or AlphaFold — this is folding as a MERA contraction on the spectral triple A_F.

The central idea: a protein is a chain of tiles, each tile is a CrystalState (36 amplitudes across 4 sectors). Folding = the tick operator applied iteratively, driving amplitudes from the mixed sector (d=24, lambda=1/6, fastest decay) toward the singlet sector (d=1, lambda=1, conserved). The fold IS the renormalization flow.

## Sector Layout Per Residue

Each residue maps to a 36-dimensional CrystalState:

| Sector | dim | lambda | Physical role |
|--------|-----|--------|---------------|
| Singlet (d_1=1) | 1 | 1 | Bond length — conserved topology |
| Weak (d_2=3) | 3 | 1/2 | Tile center of mass — hydrophobic collapse |
| Colour (d_3=8) | 8 | 1/3 | 4×(phi,psi) dihedrals — angle relaxation |
| Mixed (d_4=24) | 24 | 1/6 | 4×(x,y,z,scX,scY,scZ) — refinement |

The eigenvalue hierarchy lambda = {1, 1/2, 1/3, 1/6} gives natural timescale separation: topology freezes first, then collapse, then angles, then sidechains. This IS the Levinthal paradox solution — the folding funnel is the MERA contraction itself.

## The Fold Pipeline

```
sequence → condition (set initial amplitudes per amino acid)
         → extract dihedrals (colour sector → backbone angles)
         → fold (iterate tick on each tile)
         → reconstruct 3D coordinates
```

1. **Conditioning**: Each amino acid identity sets initial amplitudes in the 36-dim state. Hydrophobic residues get larger weak-sector amplitudes (driving collapse). Charged residues get larger mixed-sector amplitudes (driving sidechain placement).

2. **Tick iteration**: The tick operator multiplies each amplitude by its sector eigenvalue lambda. After n ticks, sector k has weight lambda_k^n. The mixed sector (1/6)^n vanishes fastest. The singlet (1)^n survives forever. This is natural coarse-graining.

3. **Long-range passes**: Every p steps, compute inter-tile interactions (hydrogen bonds between tiles i and j). This couples the tiles beyond nearest-neighbor and drives secondary structure formation.

4. **3D reconstruction**: Colour-sector amplitudes encode dihedral angles (phi, psi). Convert to 3D coordinates via standard backbone geometry (CA-C-N rotation matrices, bond lengths from CrystalProtein).

## Key Constants

- CA-CA distance: 3.8 Å (virtual bond)
- Helix dihedrals: phi = -60°, psi = -47° (from sector geometry)
- Sheet dihedrals: phi = -120°, psi = 120°
- Helix period: 18/5 = 3.6 residues/turn
- 9 DOF per residue × 4 residues per tile ≈ 36 = Sigma_d

## Why This Works

The Levinthal paradox says: a 100-residue protein has ~3^100 conformations, so random search would take longer than the age of the universe. But proteins fold in milliseconds. Why?

Because folding isn't random search. It's MERA contraction. The eigenvalue hierarchy {1, 1/2, 1/3, 1/6} means the search space collapses exponentially: after n tick steps, the effective dimensionality is dominated by the slow sectors (singlet + weak), not the fast ones (mixed). The 24-dimensional mixed sector decays as (1/6)^n — after 10 ticks it's at 1.7×10^-8 of its initial value. The "search" over sidechain conformations is not a search at all — it's a decay.

The folding funnel IS the eigenvalue spectrum of the spectral triple.

## Dependency

```
CrystalAtoms.hs       ← constants (N_w, N_c, d1-d4, etc.)
CrystalEigen.hs       ← lambda (sector eigenvalues)
CrystalSectors.hs     ← CrystalState, extractSector, injectSector
CrystalOperators.hs   ← tick, normSq
    |
CrystalFold.hs
```
