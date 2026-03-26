# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""
08 — Quantum Fourier Transform
Crystal QFT: χ-point DFT with ω = e^(2πi/6).
Extracts sector phases. Used in QPE and Shor-like algorithms.
"""
from crystal_topos import QuantumState, chi
import math

print("Crystal QFT (χ-point DFT)")
print("=" * 50)

# QFT of singlet
psi = QuantumState.singlet()
qft_psi = psi.qft()
print(f"|Singlet⟩ → QFT:")
print(f"  Probs: {[f'{p:.4f}' for p in qft_psi.probs()[:6]]}")
print(f"  (should be uniform: 1/χ = 1/{chi()} = {1/chi():.4f})")
print()

# QFT of superposition
psi2 = QuantumState.superposition()
qft_psi2 = psi2.qft()
print(f"|+⟩ → QFT:")
print(f"  Probs: {[f'{p:.4f}' for p in qft_psi2.probs()[:6]]}")
print(f"  (QFT of uniform = delta: all weight on |0⟩)")
print()

# QFT of each sector
names = ["Singlet", "Weak", "Colour", "Mixed"]
for i in range(4):
    state = [QuantumState.singlet, QuantumState.weak,
             QuantumState.colour, QuantumState.mixed][i]()
    transformed = state.qft()
    print(f"|{names[i]}⟩ → QFT: entropy = {transformed.entropy():.4f}")

print()
print(f"The QFT root of unity: ω = e^(2πi/{chi()}) = e^(πi/3)")
print("This is the same root that generates the hexagonal lattice.")
print("The crystal's Fourier space IS the (2,3) lattice dual.")
