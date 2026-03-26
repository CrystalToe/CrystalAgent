<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# Crystal Quantum Library — 96 Operators

**8 modules · 1,561 lines · Every operator from Qiskit/Cirq/QuTiP/PennyLane**

The crystal derives its own quantum mechanics. No physics is typed in. Every operator traces to N_w = 2 and N_c = 3.

## Module Map

| Module | Operators | Lines | Replaces |
|--------|-----------|-------|----------|
| CrystalQBase | — (types) | 167 | numpy, scipy.linalg |
| CrystalQGates | 27 gates | 240 | qiskit.circuit, cirq.ops |
| CrystalQChannels | 10 channels | 192 | qiskit.providers.aer.noise |
| CrystalQHamiltonians | 12 models | 183 | qutip.Hamiltonian, openfermion |
| CrystalQMeasure | 8 measurements | 126 | qiskit.result, cirq.measure |
| CrystalQEntangle | 12 tools | 204 | qutip.entropy, pennylane.qinfo |
| CrystalQAlgorithms | 15 algorithms | 226 | qiskit.algorithms, cirq.circuits |
| CrystalQSimulation | 12 methods | 223 | qutip.mesolve, pennylane.devices |

## What Makes This Different
Every quantum simulator (Qiskit, Cirq, QuTiP, PennyLane) requires you to SPECIFY the Hilbert space dimension, Hamiltonian, gate set, and interaction terms. The crystal DERIVES all of them from 2 and 3. You tell it the algebra. It tells you how particles behave.

## Key Advantage: PPT Decidability
The crystal lives in ℂ² ⊗ ℂ³ — the unique dimension where entanglement is exactly decidable. No other quantum library has this property because no other library derives its dimensions from first principles.

## Dependencies
All modules import `CrystalQBase`. Independent of the original 10 Crystal modules.
