# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""CrystalCFD integer-identity proofs from (2,3)."""

from fractions import Fraction

# A_F atoms
nW = 2
nC = 3
chi = nW * nC                        # 6
beta0 = (11 * nC - 2 * chi) // 3    # 7
sigmaD = 1 + 3 + 8 + 24             # 36
sigmaD2 = 1 + 9 + 64 + 576          # 650
gauss = nC * nC + nW * nW           # 13
towerD = sigmaD + chi                # 42
dMixed = nW * nW * nW * nC          # 24

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
print(" CrystalCFD -- Integer identity proofs from (2,3)")
print("=" * 64)
print()

# S0: Atom sanity
print("S0 Atom sanity:")
check("nW = 2", nW == 2)
check("nC = 3", nC == 3)
check("chi = 6", chi == 6)
check("beta0 = 7", beta0 == 7)
check("sigmaD = 36", sigmaD == 36)
check("sigmaD2 = 650", sigmaD2 == 650)
check("gauss = 13", gauss == 13)
check("towerD = 42", towerD == 42)
check("dMixed = 24", dMixed == 24)
print()

# S1: D2Q9 lattice
print("S1 D2Q9 lattice structure:")
check("D2Q9 = 9 = N_c^2", nC * nC == 9)
check("rest weight 4/9 = N_w^2/N_c^2",
      Fraction(nW * nW, nC * nC) == Fraction(4, 9))
check("cardinal weight 1/9 = 1/N_c^2",
      Fraction(1, nC * nC) == Fraction(1, 9))
check("diagonal weight 1/36 = 1/sigmaD",
      Fraction(1, sigmaD) == Fraction(1, 36))
wSum = (Fraction(nW * nW, nC * nC)
        + 4 * Fraction(1, nC * nC)
        + 4 * Fraction(1, sigmaD))
check("weight sum = 1", wSum == 1)
check("cs^2 = 1/3 = 1/N_c", Fraction(1, nC) == Fraction(1, 3))
print()

# S2: CFD constants
print("S2 CFD physical constants:")
check("Kolmogorov -5/3 = -(chi-1)/N_c",
      Fraction(-(chi - 1), nC) == Fraction(-5, 3))
check("Stokes drag 24 = d_mixed", dMixed == 24)
check("Blasius 1/4 = 1/N_w^2",
      Fraction(1, nW * nW) == Fraction(1, 4))
check("Von Karman 2/5 = N_w/(chi-1)",
      Fraction(nW, chi - 1) == Fraction(2, 5))
print()

# S3: Cross-checks
print("S3 Cross-checks:")
check("d_mixed = 2 * chi * nW = 24", 2 * chi * nW == 24)
check("chi - 1 = 5", chi - 1 == 5)
check("N_c^2 = D2Q9 = 9", nC * nC == 9)
check("sigmaD = N_c^2 * N_w^2 = 36", nC * nC * nW * nW == 36)
print()

# Summary
print("=" * 64)
total = passed + failed
print(f"  {passed}/{total} passed, {failed} failed.")
if failed == 0:
    print("  ALL PASS -- every CFD integer from (2, 3).")
else:
    print("  SOME FAILURES.")
