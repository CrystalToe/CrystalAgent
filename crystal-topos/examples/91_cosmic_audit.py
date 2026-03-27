"""91 — The Complete Cosmic Audit"""
from crystal_topos import n_w, n_c, chi, gauss, beta0, d_total
import math
print("The Complete Cosmic Audit")
print("=" * 55)
D = d_total()
omega_L = gauss()/(gauss()+chi())
omega_m = chi()/(gauss()+chi())
omega_b = n_c()/(n_c()*(gauss()+beta0())+1)
omega_DM = omega_m - omega_b
total = omega_L + omega_m
print(f"  Ω_Λ + Ω_m = {gauss()}/{gauss()+chi()} + {chi()}/{gauss()+chi()} = {total:.1f}")
print(f"  The universe sums to 1.  ■ EXACT")
print(f"\n  {'Component':>15} {'Formula':>20} {'Crystal':>8} {'Planck':>8} {'PWI%':>6}")
print(f"  {'─'*15} {'─'*20} {'─'*8} {'─'*8} {'─'*6}")
data = [
    ("Dark energy",  "gauss/(gauss+χ)", omega_L, 0.6847),
    ("Total matter", "χ/(gauss+χ)",     omega_m, 0.3153),
    ("Baryons",      "3/61",            omega_b, 0.0493),
    ("Dark matter",  "309/1159",        omega_DM, 0.2589),
]
for name, formula, crystal, planck in data:
    pwi = abs(crystal-planck)/planck*100
    print(f"  {name:>15} {formula:>20} {crystal:8.5f} {planck:8.4f} {pwi:6.2f}")
print(f"\n  HIERARCHY:")
print(f"    M_Pl/v = exp(D)/(β₀(χ-1)) = e^{D}/35")
print(f"    = {math.exp(D)/35:.3e}")
print(f"    = {math.exp(D)/(beta0()*(chi()-1)):.3e}")
print(f"    Gravity is weak because D = {D} is large.")
print(f"    The hierarchy IS the complexity budget for life.")
