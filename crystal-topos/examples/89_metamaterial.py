"""89 — Metamaterial Design: Custom Refractive Index"""
from crystal_topos import n_w, n_c, chi
print("Metamaterial Design from Sector Mixing")
print("=" * 55)
eigenvalues = [
    ("Singlet", 1, 1.0),
    ("Weak",    n_w(), 1/n_w()),
    ("Colour",  n_c(), 1/n_c()),
    ("Mixed",   chi(), 1/chi()),
]
print(f"  Sector eigenvalues ARE refractive indices:")
for name, dim, lam in eigenvalues:
    print(f"    {name:>8}: d={dim}, λ={lam:.4f}, n={lam:.4f}")
print(f"\n  TO DESIGN A METAMATERIAL:")
print(f"    1. Choose target n (refractive index)")
print(f"    2. Find sector mixture: n = Σ w_k λ_k")
print(f"    3. Engineer material with that sector weight")
print(f"\n  EXAMPLES:")
print(f"    n = 0 (invisibility): equal mix of all sectors")
print(f"      w₁=1/{chi()}, w₂=1/{chi()}, w₃=1/{chi()}, w₄=1/{chi()}")
print(f"    n < 0 (negative refraction): swap sector phases")
print(f"    n > 1 (slow light): singlet-dominated material")
print(f"    n < 1 (fast light): mixed-sector-dominated material")
print(f"\n  The crystal gives you the RECIPE for any desired n.")
