"""83 — KMS Thermal Equilibrium at β = 2π"""
from crystal_topos import chi, sigma_d, crystal_energies
import math
print("KMS Equilibrium State")
print("=" * 55)
beta = 2*math.pi
dims = [1, 3, 8, 24]
lam = [1, 0.5, 1/3, 1/6]
en = crystal_energies()
names = ["Singlet","Weak","Colour","Mixed"]
weights = [d * l**beta for d, l in zip(dims, lam)]
Z = sum(weights)
probs = [w/Z for w in weights]
print(f"  KMS temperature: β = 2π (the unique thermal state)")
print(f"  T = 1/(2π) = {1/(2*math.pi):.6f}")
print(f"\n  Partition function: Z = Σ d_k × λ_k^β = {Z:.6f}")
print(f"\n  {'Sector':>10} {'d':>4} {'λ':>8} {'P(sector)':>10} {'Energy':>8}")
print(f"  {'─'*10} {'─'*4} {'─'*8} {'─'*10} {'─'*8}")
for i in range(4):
    print(f"  {names[i]:>10} {dims[i]:>4} {lam[i]:>8.4f} {probs[i]:>10.6f} {en[i]:>8.4f}")
F = -math.log(Z)/beta
print(f"\n  Free energy: F = −T ln Z = {F:.6f}")
print(f"  Internal energy: U = Σ P_k E_k = {sum(p*e for p,e in zip(probs,en)):.6f}")
print(f"  Entropy: S = β(U−F) = {beta*(sum(p*e for p,e in zip(probs,en))-F):.6f}")
print(f"\n  At KMS: 95.5% of probability in singlet (ground state)")
print(f"  The universe's thermal death = everything in the singlet.")
print(f"  But χ > 1 means it takes FOREVER to get there.")
