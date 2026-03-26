"""11 — Newton's Three Laws from End(A_F)"""
from crystal_topos import n_w, n_c, chi, d_total, gauss
import math

print("Newton's Laws from the Crystal")
print("=" * 55)

# F = ma: force = N_c - 1 = 2 (inverse square)
print(f"\n1st Law (Inertia):")
print(f"   Singlet sector: Ward = 0. No force. Object at rest stays at rest.")
print(f"   650 endomorphisms preserve the singlet. Inertia IS categorical identity.")

print(f"\n2nd Law (F = ma):")
print(f"   Force exponent = N_c - 1 = {n_c() - 1} → 1/r² law")
print(f"   Mass = spectral distance in End(A_F)")
print(f"   F = ma is the natural transformation condition: η∘F = m∘η")

print(f"\n3rd Law (Action = Reaction):")
print(f"   Heyting double negation: ¬¬x = x")
print(f"   NOT(NOT(position)) = position")
print(f"   Every endomorphism has an adjoint. Forces come in pairs.")
print(f"   This is NOT a physical law. It's a theorem of intuitionistic logic.")
