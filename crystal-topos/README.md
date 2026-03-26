<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# crystal-topos

### Quantum Simulation from Two Primes — Rust Core + Python Bindings

> Every operator, every gate, every Hamiltonian derives from N_w = 2 and N_c = 3.
> No configuration. No calibration. The algebra IS the physics.

---

## Install

### As Python package (recommended)
```bash

pip install maturin
cd crystal-topos
PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1 maturin develop --features python
# maturin develop --features python

```

### As Rust library
```bash
cd crystal-topos
cargo build --release
cargo test   # 12 structural theorem tests
```

---

## Quick Start (Python)

```python
from crystal_topos import QuantumState, chi, crystal_max_entropy, crystal_energies

# The algebra tells you everything
print(f"Hilbert space: ℂ^{chi()}")           # ℂ⁶
print(f"Energies: {crystal_energies()}")      # [0, ln2, ln3, ln6]
print(f"Max entropy: {crystal_max_entropy()}")  # ln(6) = 1.7918

# Create a particle in the singlet (ground) state
psi = QuantumState.singlet()
print(psi)  # QuantumState(dim=6, entropy=0.0)

# Put it in superposition
psi = psi.hadamard()
print(psi.sector_probs())  # roughly equal across 6 sectors

# Time evolve under crystal Hamiltonian
psi = psi.evolve(1.0)
print(psi.sector_probs())  # phases have rotated

# Create maximally entangled 2-particle state
bell = QuantumState.max_entangled()
print(f"Entropy: {bell.entanglement_entropy():.4f}")  # 1.7918 = ln(6)
print(f"Entangled: {not bell.ppt_test()}")             # True
print(f"Concurrence: {bell.concurrence():.4f}")        # ~1.0
```

---

## What Makes This Different

| Feature | Qiskit/Cirq/QuTiP | crystal-topos |
|---------|-------------------|---------------|
| Hilbert space dim | You specify it | **Derived**: ℂ^χ = ℂ⁶ |
| Hamiltonian | You type it in | **Derived**: diag(0, ln2, ln3, ln6) |
| Gate set | You choose gates | **Derived**: U(6) from End(A_F) |
| Entanglement test | Approximate | **Exact**: PPT for ℂ²⊗ℂ³ (Horodecki) |
| Creation/annihilation | You define them | **Derived**: √(d_{k+1}/d_k) from sectors |
| Noise model | You calibrate | **Derived**: sector decay rates |
| Number of inputs | Dozens of params | **Two**: N_w=2, N_c=3 |

---

## API Reference

### QuantumState

```python
# Creation
QuantumState.singlet()       # |0⟩ — ground state (E=0)
QuantumState.weak()          # |1⟩ — weak sector (E=ln2)
QuantumState.colour()        # |2⟩ — colour sector (E=ln3)
QuantumState.mixed()         # |3⟩ — mixed sector (E=ln6)
QuantumState.superposition() # (1/√6)(|0⟩+|1⟩+...+|5⟩)
QuantumState.max_entangled() # (1/√6)Σ|k,k⟩ in ℂ³⁶
QuantumState.bell(a, b)      # (|a,b⟩+|b,a⟩)/√2

# Properties
psi.dim()                    # Hilbert space dimension (6 or 36)
psi.prob(k)                  # probability of sector k
psi.probs()                  # all Born probabilities
psi.sector_probs()           # 4 sector probabilities
psi.entropy()                # Von Neumann entropy

# Operators
psi.hadamard()               # crystal Hadamard (DFT on ℂ⁶)
psi.create()                 # â† — raise sector level
psi.annihilate()             # â — lower sector level
psi.evolve(dt)               # exp(-iHdt) time evolution

# Entanglement (2-particle states)
psi.entanglement_entropy()   # S = -Tr(ρ₁ ln ρ₁), max = ln(6)
psi.concurrence()            # 0 (product) to ~1 (max entangled)
psi.ppt_test()               # True = separable, False = entangled

# Algorithms
psi.grover(target)           # Grover search for sector target
psi.qft()                    # Quantum Fourier Transform
```

### Constants

```python
from crystal_topos import (
    n_w, n_c, chi, beta0, sigma_d, sigma_d2,
    gauss, d_total, crystal_kappa, crystal_max_entropy,
    crystal_energies
)

n_w()                # 2
n_c()                # 3
chi()                # 6 = N_w × N_c
beta0()              # 7 = (11N_c − 2χ)/3
sigma_d()            # 36 = sum of sector dims
sigma_d2()           # 650 = sum of squared sector dims
gauss()              # 13 = N_c² + N_w²
d_total()            # 42 = Σd + χ
crystal_kappa()      # ln3/ln2 ≈ 1.585
crystal_max_entropy() # ln(6) ≈ 1.792
crystal_energies()   # [0.0, 0.693, 1.099, 1.792]
```

---

## Rust API

```rust
use crystal_topos::base::*;
use crystal_topos::entangle;
use crystal_topos::gates;
use crystal_topos::algorithms;

// Constants
assert_eq!(CHI, 6);
assert_eq!(D_TOTAL, 42);

// States
let psi = entangle::max_entangled();           // (1/√6)Σ|k,k⟩
let rho = entangle::partial_trace(&psi);       // reduced density matrix
let s = entangle::von_neumann_entropy(&rho);   // ln(6)

// Gates
let h = gates::gate_h();                       // crystal Hadamard
let cnot = gates::gate_cnot();                 // CNOT on ℂ³⁶
let psi2 = h.apply(&Vec_::basis(CHI, 0));      // |+⟩ state

// Algorithms
let found = algorithms::grover_search(2, &Vec_::equal(CHI));
let transformed = algorithms::qft(&psi2);
```

---

## Crate Structure

```
crystal-topos/
├── Cargo.toml                  ← dependencies: pyo3, num-complex, rand
├── pyproject.toml              ← maturin config for pip install
├── src/
│   ├── lib.rs                  ← entry point + PyO3 bindings (182 lines)
│   ├── base.rs                 ← Cx, Vec_, Mat, constants (224 lines)
│   ├── gates.rs                ← 27 gates (311 lines)
│   ├── channels.rs             ← 10 noise channels (130 lines)
│   ├── hamiltonians.rs         ← 12 Hamiltonians (118 lines)
│   ├── measure.rs              ← 8 measurements (101 lines)
│   ├── entangle.rs             ← 12 entanglement tools (165 lines)
│   ├── algorithms.rs           ← 15 algorithms (153 lines)
│   └── simulation.rs           ← 12 simulation methods (132 lines)
├── tests/
│   └── crystal_tests.rs        ← 12 theorem tests (98 lines)
└── examples/                   ← 10 Python examples
    ├── 01_hello_crystal.py
    ├── 02_sector_spectrum.py
    ├── 03_time_evolution.py
    ├── 04_creation_annihilation.py
    ├── 05_two_particles.py
    ├── 06_entanglement.py
    ├── 07_grover_search.py
    ├── 08_qft_phases.py
    ├── 09_decoherence.py
    └── 10_full_simulation.py
```

---

## The 10 Structural Theorems (verified by cargo test)

| # | Theorem | Rust test |
|---|---------|-----------|
| 1 | dim(H₂) = χ² = 36 = Σd | `test_two_particles_is_algebra` |
| 2 | S_max = ln(6) = arrow of time | `test_entanglement_is_arrow` |
| 3 | Fermions = 15 = dim(su(4)) | `test_fermion_is_su4` |
| 4 | PPT exact for ℂ²⊗ℂ³ | `test_ppt_decidable` |
| 5 | 650 endomorphisms = gates | `test_gate_count` |
| 6 | Fock → e⁶ ≈ 403 | `test_fock_limit` |
| 7 | ΔE₀₁ = ΔE₂₃ = ln(2) | `test_ladder_symmetric` |
| 8 | 30 = 2 × 15 interactions | `test_interactions_duality` |
| 9 | Pauli = Heyting | (structural, bounded H) |
| 10 | χ⁴ = 1296 = ν ratio | `test_cnot_neutrino` |

---

## License

MIT — Daland Montgomery, 2026
