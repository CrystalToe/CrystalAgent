"""69 — The Periodic Table IS the Crystal"""
from crystal_topos import n_w, n_c, chi, beta0, gauss, sigma_d
print("The Periodic Table from Two Primes")
print("=" * 55)
print(f"  ORBITAL CAPACITIES:")
print(f"    s: N_w = {n_w()}           (singlet sector, λ=1)     ■ EXACT")
print(f"    p: N_w×N_c = χ = {chi()}    (weak sector, λ=1/N_w)   ■ EXACT")
print(f"    d: N_w×(χ-1) = {n_w()*(chi()-1)}    (colour sector, λ=1/N_c)  ■ EXACT")
print(f"    f: N_w×β₀ = {n_w()*beta0()}        (mixed sector, λ=1/χ)   ■ EXACT")
print(f"\n  SHELL CAPACITIES (2n²):")
for n in range(1, 5):
    cap = n_w() * n**2
    print(f"    Shell {n}: N_w × {n}² = {n_w()} × {n**2} = {cap}")
print(f"    The 2 in 2n² IS N_w.")
print(f"\n  NOBLE GASES:")
cumulative = 0
nobles = [("He",2),("Ne",10),("Ar",18),("Kr",36),("Xe",54),("Rn",86)]
for name, z in nobles:
    tag = ""
    if z == sigma_d(): tag = f" ← Σd = {sigma_d()}!"
    elif z == sigma_d() + n_w()*n_c()**2: tag = f" ← Σd + N_w×N_c²"
    elif z == n_w(): tag = f" ← N_w"
    elif z == n_w() + n_w()**3: tag = f" ← N_w + N_w³"
    elif z == n_w() + 2*n_w()**3: tag = f" ← N_w + 2N_w³"
    print(f"    {name}: Z = {z}{tag}")
print(f"\n  KRYPTON (Z=36) fills ALL sector dimensions: Σd = {sigma_d()}.")
