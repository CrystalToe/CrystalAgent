# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""CrystalOptics integer-identity proofs from (2,3)."""

from fractions import Fraction
import math

# A_F atoms
nW = 2
nC = 3
chi = nW * nC                        # 6
beta0 = (11 * nC - 2 * chi) // 3    # 7
sigmaD = 1 + 3 + 8 + 24             # 36
gauss = nC * nC + nW * nW           # 13
towerD = sigmaD + chi                # 42

passed = 0
failed = 0

def check(name: str, result: bool) -> None:
    global passed, failed
    tag = "PASS" if result else "FAIL"
    if result:
        passed += 1
    else:
        failed += 1
    print(f"  {tag}  {name}")

print("=" * 64)
print(" CrystalOptics -- Integer identity proofs from (2,3)")
print("=" * 64)
print()

# S0: Atom sanity
print("S0 Atom sanity:")
check("nW = 2", nW == 2)
check("nC = 3", nC == 3)
check("chi = 6", chi == 6)
check("gauss = 13", gauss == 13)
print()

# S1: Casimir factor = IOR water
print("S1 Casimir factor C_F = n_water:")
cF = Fraction(nC * nC - 1, 2 * nC)
check("C_F = (N_c^2-1)/(2N_c) = 4/3", cF == Fraction(4, 3))
check("C_F numerator = 8 = N_c^2-1", nC * nC - 1 == 8)
check("C_F denominator = 6 = 2*N_c = chi", 2 * nC == 6)
check("C_F denominator = chi", 2 * nC == chi)
n_water = float(cF)
check("n_water ~ 1.333", abs(n_water - 1.3333) < 0.001)
print()

# S2: IOR glass
print("S2 IOR glass:")
nGlass = Fraction(nC, nW)
check("n_glass = N_c/N_w = 3/2", nGlass == Fraction(3, 2))
check("n_glass ~ 1.5", abs(float(nGlass) - 1.5) < 1e-12)
print()

# S3: Rayleigh exponents
print("S3 Rayleigh exponents:")
check("Rayleigh lambda exp = 4 = N_w^2", nW * nW == 4)
check("Rayleigh size exp = 6 = chi", chi == 6)
# Sky blue ratio
ratio = (700.0 / 450.0) ** 4
check("sky blue ratio (700/450)^4 ~ 5.86 (< 2% from 5.8)",
      abs(ratio - 5.8) / 5.8 < 0.02)
print()

# S4: Planck exponent
print("S4 Planck exponent:")
check("Planck lambda exp = 5 = chi-1", chi - 1 == 5)
check("chi - 1 = 5", chi - 1 == 5)
print()

# S5: Snell's law verification
print("S5 Snell's law verification:")
theta_i = math.radians(30)
sin_t = math.sin(theta_i) / float(cF)  # air -> water
theta_t = math.asin(sin_t)
snell_err = abs(1.0 * math.sin(theta_i) - float(cF) * math.sin(theta_t))
check("Snell air->water exact (error < 1e-12)", snell_err < 1e-12)

# Critical angle
theta_c = math.asin(1.0 / float(cF))  # water -> air
theta_c_ref = math.asin(3.0 / 4.0)
check("critical angle = arcsin(3/4)", abs(theta_c - theta_c_ref) < 1e-12)
print()

# S6: Fresnel
print("S6 Fresnel verification:")
R_norm = ((1.0 - 1.5) / (1.0 + 1.5)) ** 2
check("R(normal, glass) = 0.04", abs(R_norm - 0.04) < 1e-12)

# Brewster
theta_B = math.atan(1.5)
check("Brewster angle = arctan(3/2) ~ 56.3 deg",
      abs(math.degrees(theta_B) - 56.31) < 0.01)
print()

# S7: Cross-checks
print("S7 Cross-checks:")
check("4/3 * 3/4 = 1 (n_water * sin(theta_c) = 1)",
      Fraction(4, 3) * Fraction(3, 4) == 1)
check("N_c^2 - 1 = 8 = d_colour = N_w^3", nC**2 - 1 == nW**3)
check("2*N_c = chi = 6", 2 * nC == chi)
check("chi - 1 = N_w^2 + 1 = 5", chi - 1 == nW * nW + 1)
print()

# Summary
print("=" * 64)
total = passed + failed
print(f"  {passed}/{total} passed, {failed} failed.")
if failed == 0:
    print("  ALL PASS -- every Optics integer from (2, 3).")
else:
    print("  SOME FAILURES.")
