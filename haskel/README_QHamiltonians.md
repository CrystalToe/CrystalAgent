<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalQHamiltonians.hs — 12 Quantum Hamiltonians from (2,3)

## What This Module Does

12 Hamiltonians: free particle, Ising, Heisenberg, Hubbard (Bose + Fermi),
Jaynes-Cummings, XXZ, toric code vertex, Schwinger, VQE ansatz, QAOA mixer.
All coupling constants and spectra from sector eigenvalues.

## Engine Wiring

**This module imports CrystalEngine.** No local atom redefinitions.

### Sector: mixed sector (d = 24)

| Hamiltonian | Crystal Source |
|-------------|---------------|
| Free H_0 | diag(0, ln2, ln3, ln6) |
| Ising J | sector energy product |
| Heisenberg | isotropic Ising J_x=J_y=J_z |
| Hubbard t,U | creation/annihilation from dims |
| JC omega,g | field = sector levels |
| XXZ Delta | kappa = ln3/ln2 |
| Schwinger m | mass gap = ln2 |
| Bose dim | chi(chi+1)/2 = 21 |
| Fermi dim | chi(chi-1)/2 = 15 |

## Proof Certificate

- `haskel/CrystalQHamiltonians.hs` — 14 checks (14 PASS)
- `proofs/CrystalQHamiltonians.lean` — Lean 4 integer identity proofs
- `proofs/CrystalQHamiltonians.agda` — Agda integer identity proofs

## Dependencies

- **Imports CrystalEngine** (qualified as CE) via CrystalQBase
- CrystalQBase — complex arithmetic, crystal constants
