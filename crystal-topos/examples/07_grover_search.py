"""
07 — Grover Search
Search over χ^n = 6^n states using crystal sector oracle.
O(√N) queries. The oracle is a sector projector — derived from the algebra.
"""
from crystal_topos import QuantumState, chi
import math

print("Grover Search in Crystal Space")
print("=" * 50)

# Start in equal superposition
psi = QuantumState.superposition()
print(f"Hilbert space: ℂ^{chi()}")
print(f"Initial state: equal superposition")
print(f"Initial probs: {[f'{p:.3f}' for p in psi.sector_probs()]}")
print()

# Search for each sector
for target in range(min(4, chi())):
    names = ["Singlet", "Weak", "Colour", "Mixed"]
    found = psi.grover(target)
    p_target = found.prob(target)
    print(f"Search for |{names[target]}⟩:")
    print(f"  P(target) = {p_target:.4f}")
    print(f"  Iterations needed: ~{max(1, round(math.pi/4 * math.sqrt(chi())))}")
    print()

print(f"Optimal iterations = π/4 × √χ = π/4 × √{chi()} = {math.pi/4 * math.sqrt(chi()):.1f}")
print("The crystal tells you how many steps. No tuning needed.")
