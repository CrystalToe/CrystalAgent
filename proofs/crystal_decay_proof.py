# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""CrystalDecay integer-identity proofs from (2,3)."""

from fractions import Fraction
import math

# A_F atoms
nW = 2
nC = 3
chi = nW * nC                        # 6
beta0 = (11 * nC - 2 * chi) // 3    # 7
sigmaD = 1 + 3 + 8 + 24             # 36
sigmaD2 = 1 + 9 + 64 + 576          # 650
gauss = nC * nC + nW * nW           # 13
towerD = sigmaD + chi                # 42
dColour = nW * nW * nW              # 8
dMixed = nW * nW * nW * nC          # 24
betaConst = dMixed * dColour         # 192

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
print(" CrystalDecay -- Integer identity proofs from (2,3)")
print("=" * 64)
print()

# S0: Atom sanity
print("S0 Atom sanity:")
check("nW = 2", nW == 2)
check("nC = 3", nC == 3)
check("chi = 6", chi == 6)
check("gauss = 13", gauss == 13)
check("dColour = 8 = nW^3", dColour == 8)
check("dMixed = 24 = nW^3*nC", dMixed == 24)
print()

# S1: Beta constant
print("S1 Beta constant:")
check("betaConst = 192 = dMixed*dColour", betaConst == 192)
check("192 = 24 * 8", 24 * 8 == 192)
check("192 = nW^3 * nC * nW^3", nW**3 * nC * nW**3 == 192)
print()

# S2: Weinberg angle
print("S2 Weinberg angle:")
check("sin^2 theta_W = 3/13 = N_c/gauss",
      Fraction(nC, gauss) == Fraction(3, 13))
sw2 = nC / gauss
check("3/13 ~ 0.2308 (< 0.002 from 0.23122)",
      abs(sw2 - 0.23122) < 0.002)
print()

# S3: PMNS mixing angles
print("S3 PMNS mixing angles:")
check("sin^2 theta_23 = 6/11 = chi/(2chi-1)",
      Fraction(chi, 2*chi - 1) == Fraction(6, 11))
s23 = chi / (2 * chi - 1)
check("6/11 ~ 0.5455 (< 1% from 0.545)",
      abs(s23 - 0.545) / 0.545 < 0.01)

s12 = nC / (math.pi * math.pi)
check("sin^2 theta_12 = 3/pi^2 ~ 0.3040 (< 2% from 0.307)",
      abs(s12 - 0.307) / 0.307 < 0.02)

# sin^2(2 theta_23)
sin22 = Fraction(4, 1) * Fraction(chi, 2*chi-1) * Fraction(chi-1, 2*chi-1)
check("sin^2(2 theta_23) = 120/121", sin22 == Fraction(120, 121))
print()

# S4: Phase space dimension
print("S4 Phase space dimension (3N-4 = N_c*N - (N_c+1)):")
for n in [2, 3, 4, 5]:
    crystal = nC * n - (nC + 1)
    standard = 3 * n - 4
    check(f"N={n}: nC*{n}-(nC+1) = {crystal} = 3*{n}-4 = {standard}",
          crystal == standard)
print()

# S5: Cross-checks
print("S5 Cross-checks:")
check("dColour = nW^3 = 2^3 = 8", nW**3 == 8)
check("dMixed = 2 * chi * nW = 24", 2 * chi * nW == 24)
check("gauss = nC^2 + nW^2 = 9 + 4 = 13", nC**2 + nW**2 == 13)
check("2*chi - 1 = 11", 2 * chi - 1 == 11)
check("chi - 1 = 5", chi - 1 == 5)
check("betaConst / dColour = dMixed = 24", betaConst // dColour == 24)
check("betaConst / dMixed = dColour = 8", betaConst // dMixed == 8)
print()

# Summary
print("=" * 64)
total = passed + failed
print(f"  {passed}/{total} passed, {failed} failed.")
if failed == 0:
    print("  ALL PASS -- every Decay integer from (2, 3).")
else:
    print("  SOME FAILURES.")
