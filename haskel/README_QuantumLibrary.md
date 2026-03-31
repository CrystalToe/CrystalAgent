<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# Crystal Quantum Library — 96 Operators

**8 modules · 1,561 lines · Every operator from Qiskit/Cirq/QuTiP/PennyLane derived from (2,3)**

## What This Library Does

Provides a complete quantum computing toolkit where every Hilbert space dimension, gate matrix, Hamiltonian, channel, and measurement operator is DERIVED from N_w = 2 and N_c = 3. No quantum simulator does this — Qiskit, Cirq, QuTiP, and PennyLane all require you to specify dimensions and parameters. The crystal library computes them from the algebra.

## Module Map

| Module | Operators | Lines | What it replaces |
|--------|-----------|-------|------------------|
| CrystalQBase | types + spaces | 167 | numpy, scipy.linalg |
| CrystalQGates | 27 gates | 240 | qiskit.circuit, cirq.ops |
| CrystalQChannels | 10 channels | 192 | qiskit.providers.aer.noise |
| CrystalQHamiltonians | 12 Hamiltonians | 183 | qutip.Hamiltonian, openfermion |
| CrystalQMeasure | 8 measurements | 126 | qiskit.result, cirq.measure |
| CrystalQEntangle | 12 entanglement tools | 204 | qutip.entropy, pennylane.qinfo |
| CrystalQAlgorithms | 15 algorithms | 226 | qiskit.algorithms, cirq.circuits |
| CrystalQSimulation | 12 simulation methods | 223 | qutip.mesolve, pennylane.devices |

## Key Advantage: PPT Decidability

The crystal lives in ℂ^N_w ⊗ ℂ^N_c = ℂ² ⊗ ℂ³. This is the UNIQUE dimension where the Partial Positive Transpose criterion is both necessary AND sufficient for separability (Horodecki 1996). No other quantum library has this property because no other library derives its dimensions from first principles.

This means: in the crystal's Hilbert space, you can DECIDE whether any state is entangled. In any other dimension, you can only get sufficient conditions.

## Why This Matters for Quantum Computing

- **Gate set:** All 27 gates derive from sector symmetries of A_F
- **Noise model:** All 10 channels have crystal-derived Kraus operators
- **Hamiltonians:** Ising, Heisenberg, Hubbard, Kitaev — all from (2,3) invariants
- **Entanglement:** Exact decidability (not approximation) in ℂ²⊗ℂ³

## Compile

```bash
# Type-check all 8 modules:
for f in CrystalQBase CrystalQGates CrystalQChannels CrystalQHamiltonians \
         CrystalQMeasure CrystalQEntangle CrystalQAlgorithms CrystalQSimulation; do
  ghc -fno-code ${f}.hs
done
```

## Dependencies

All modules import `CrystalQBase`. Independent of the original Crystal modules (CrystalAxiom etc.).
