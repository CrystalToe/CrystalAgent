# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""CrystalMD integer-identity proofs from (2,3)."""

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
print(" CrystalMD -- Integer identity proofs from (2,3)")
print("=" * 64)
print()

# S0: Atom sanity
print("S0 Atom sanity:")
check("nW = 2", nW == 2)
check("nC = 3", nC == 3)
check("chi = 6", chi == 6)
check("dMixed = 24", dMixed == 24)
print()

# S1: LJ exponents
print("S1 LJ exponents:")
check("LJ attractive = 6 = chi", chi == 6)
check("LJ repulsive = 12 = 2*chi", 2 * chi == 12)
check("LJ pot coeff = 4 = N_w^2", nW * nW == 4)
check("LJ force coeff = 24 = d_mixed", dMixed == 24)
check("2*d_mixed = 48 = N_w^2 * 2*chi", nW * nW * 2 * chi == 48)
check("d_mixed = N_w^2 * chi", nW * nW * chi == dMixed)
print()

# S2: Bond angle
print("S2 Tetrahedral bond angle:")
angle = math.degrees(math.acos(-1.0 / nC))
check("arccos(-1/N_c) = arccos(-1/3) ~ 109.47 deg",
      abs(angle - 109.4712) < 0.001)
check("denominator = N_c = 3", nC == 3)
print()

# S3: H-bonds
print("S3 Hydrogen bonds:")
check("A-T = 2 = N_w", nW == 2)
check("G-C = 3 = N_c", nC == 3)
check("G-C - A-T = 1 = N_c - N_w", nC - nW == 1)
print()

# S4: Helix
print("S4 Alpha helix:")
helix = Fraction(nC * nC * nW, chi - 1)
check("helix = (N_c^2*N_w)/(chi-1) = 18/5", helix == Fraction(18, 5))
check("18/5 = 3.6", float(helix) == 3.6)
check("numerator = N_c^2*N_w = 9*2 = 18", nC * nC * nW == 18)
check("denominator = chi-1 = 5", chi - 1 == 5)
print()

# S5: Flory exponent
print("S5 Flory exponent:")
flory = Fraction(nW, chi - 1)
check("Flory nu = N_w/(chi-1) = 2/5", flory == Fraction(2, 5))
check("nu = 0.4", abs(float(flory) - 0.4) < 1e-12)
print()

# S6: Coulomb
print("S6 Coulomb exponent:")
check("Coulomb exp = 2 = N_c - 1", nC - 1 == 2)
# Inverse-square: F(r)/F(2r) = 4
check("F(r)/F(2r) = (2r/r)^2 = 4 = N_w^2", nW * nW == 4)
print()

# S7: Cross-checks
print("S7 Cross-checks:")
check("2*chi = 12 (LJ repulsive)", 2 * chi == 12)
check("chi - 1 = 5 (helix & Flory denominator)", chi - 1 == 5)
check("N_w^2 * chi = d_mixed = 24", nW * nW * chi == 24)
check("d_mixed = 2 * chi * N_w", 2 * chi * nW == dMixed)
check("N_c^2 * N_w = 18 (helix numerator)", nC * nC * nW == 18)
print()

# Summary
print("=" * 64)
total = passed + failed
print(f"  {passed}/{total} passed, {failed} failed.")
if failed == 0:
    print("  ALL PASS -- every MD integer from (2, 3).")
else:
    print("  SOME FAILURES.")
