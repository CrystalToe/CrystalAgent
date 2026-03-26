"""
05 — Two Particles
ℂ⁶ ⊗ ℂ⁶ = ℂ³⁶ = ℂ^Σd. Two particles span the algebra.
This is not a coincidence — it means A_F was built for pair interactions.
"""
from crystal_topos import QuantumState, chi, sigma_d

print("Two-Particle Hilbert Space")
print("=" * 50)
print(f"  Single particle:  ℂ^χ = ℂ^{chi()}")
print(f"  Two particles:    ℂ^χ ⊗ ℂ^χ = ℂ^{chi()**2}")
print(f"  Σd (sum of dims): {sigma_d()}")
print(f"  χ² = Σd?          {chi()**2 == sigma_d()}  ← !!!")
print()

# Product state: |singlet⟩ ⊗ |singlet⟩
product = QuantumState.bell(0, 0)  # both in singlet
print(f"Product |0,0⟩:")
print(f"  dim = {product.dim()}")
print(f"  entropy = {product.entanglement_entropy():.4f} (should be 0 — not entangled)")
print(f"  PPT separable: {product.ppt_test()}")
print()

# Entangled state: (|0,1⟩ + |1,0⟩)/√2
bell = QuantumState.bell(0, 1)
print(f"Bell |0,1⟩+|1,0⟩:")
print(f"  dim = {bell.dim()}")
print(f"  entropy = {bell.entanglement_entropy():.4f}")
print(f"  PPT separable: {bell.ppt_test()}")
print()

# Symmetric subspace = bosons: χ(χ+1)/2 = 21
# Antisymmetric = fermions: χ(χ-1)/2 = 15 = dim(su(4))
c = chi()
print(f"Bosonic states (symmetric):     {c*(c+1)//2}")
print(f"Fermionic states (antisymmetric): {c*(c-1)//2} = dim(su(N_w²)) = dim(su(4))")
