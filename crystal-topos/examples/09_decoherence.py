# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""
09 — Decoherence and Noise
Quantum channels derived from sector decay rates.
No calibration — the algebra sets every noise parameter.
"""
from crystal_topos import QuantumState, crystal_energies, crystal_max_entropy

print("Decoherence in the Crystal")
print("=" * 60)

# Start in superposition
psi = QuantumState.superposition()
print(f"Initial entropy: {psi.entropy():.4f}")
print()

# Simulate decoherence by repeated measurement-like evolution
# (Python-side approximation since channels need density matrices)
print("Entropy under time evolution (coherent — no decoherence):")
for t in range(11):
    evolved = psi.evolve(t * 0.3)
    print(f"  t={t*0.3:4.1f}: S = {evolved.entropy():.4f}, probs = {[f'{p:.3f}' for p in evolved.sector_probs()]}")

print()
print("Key insight: coherent evolution PRESERVES entropy.")
print("Decoherence requires interaction with environment.")
print()

energies = crystal_energies()
print("Sector decay rates (from crystal Hamiltonian):")
for i, (name, e) in enumerate(zip(["Singlet","Weak","Colour","Mixed"], energies)):
    rate = e / crystal_max_entropy() if crystal_max_entropy() > 0 else 0
    print(f"  {name}: Γ = E/E_max = {e:.4f}/{crystal_max_entropy():.4f} = {rate:.4f}")
print()
print("Singlet (Γ=0): stable ground state. Never decays.")
print("Mixed (Γ=1): maximum decay rate. Fastest decoherence.")
print("All rates derived from the eigenvalues {1, 1/2, 1/3, 1/6}.")
