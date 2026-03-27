"""86 — Refractive Index = Sector Eigenvalue"""
from crystal_topos import n_w, n_c, chi, gauss
import math
print("Refractive Index from the Crystal")
print("=" * 55)
materials = [
    ("Vacuum",     "1",                1.0,             1.000,  "singlet"),
    ("Water",      "C_F=(N_c²-1)/(2N_c)", (n_c()**2-1)/(2*n_c()), 1.333, "Casimir"),
    ("Glass",      "N_c/N_w",          n_c()/n_w(),     1.500,  "colour/weak"),
    ("Diamond",    "(2gauss+N_c)/(N_w²N_c)", (2*gauss()+n_c())/(n_w()**2*n_c()), 2.417, "sector sum"),
]
print(f"  {'Material':>10} {'Formula':>25} {'Crystal':>8} {'Exp':>6} {'PWI%':>6} {'Sector'}")
print(f"  {'─'*10} {'─'*25} {'─'*8} {'─'*6} {'─'*6} {'─'*12}")
for name, formula, crystal, exp, sector in materials:
    pwi = abs(crystal-exp)/exp*100 if exp > 0 else 0
    rating = "■" if pwi < 0.001 else ("●" if pwi < 0.5 else "○")
    print(f"  {name:>10} {formula:>25} {crystal:8.4f} {exp:6.3f} {pwi:6.3f} {sector}")
print(f"\n  n(water) = 4/3 = Casimir factor.")
print(f"  The number that CONFINES QUARKS also BENDS LIGHT IN WATER.")
