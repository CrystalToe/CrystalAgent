# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""
03 — Time Evolution
Watch a superposition state evolve under the crystal Hamiltonian.
Each sector rotates at its own energy: e^(-iE_k t).
"""
from crystal_topos import QuantumState

# Start in equal superposition
psi = QuantumState.superposition()
print("Time evolution of |+⟩ under H = diag(0, ln2, ln3, ln6)")
print("=" * 60)
print(f"{'t':>6}  {'Singlet':>8}  {'Weak':>8}  {'Colour':>8}  {'Mixed':>8}  {'S_vN':>8}")
print("-" * 60)

for step in range(21):
    t = step * 0.5
    evolved = psi.evolve(t)
    p = evolved.sector_probs()
    s = evolved.entropy()
    print(f"{t:6.1f}  {p[0]:8.4f}  {p[1]:8.4f}  {p[2]:8.4f}  {p[3]:8.4f}  {s:8.4f}")

print()
print("The singlet probability stays constant (E=0, no rotation).")
print("The others oscillate. Interference creates structure from nothing.")
