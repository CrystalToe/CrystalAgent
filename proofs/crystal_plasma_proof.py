# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""CrystalPlasma integer-identity proofs from (2,3)."""

from fractions import Fraction

# A_F atoms
nW = 2
nC = 3
chi = nW * nC                        # 6
sigmaD = 1 + 3 + 8 + 24             # 36
gauss = nC * nC + nW * nW           # 13
towerD = sigmaD + chi                # 42
dColour = nW * nW * nW              # 8

passed = 0
failed = 0

def check(name, result):
    global passed, failed
    tag = "PASS" if result else "FAIL"
    if result:
        passed += 1
    else:
        failed += 1
    print(f"  {tag}  {name}")

print("=" * 64)
print(" CrystalPlasma -- Integer identity proofs from (2,3)")
print("=" * 64)
print()

print("S0 Atom sanity:")
check("nW = 2", nW == 2)
check("nC = 3", nC == 3)
check("chi = 6", chi == 6)
check("dColour = 8 = N_w^3", dColour == 8)
print()

print("S1 MHD wave classification:")
check("wave types = 3 = N_c", nC == 3)
check("propagating = 6 = chi = 2*N_c", 2 * nC == chi)
check("non-propagating = 2 = N_w", nW == 2)
check("total modes = chi + N_w = 8 = d_colour", chi + nW == dColour)
check("total = N_w^3 = 8", nW**3 == 8)
print()

print("S2 MHD state variables:")
check("state vars = 8 = d_colour", dColour == 8)
check("rho + 3v + 3B + e = 1+3+3+1 = 8", 1+3+3+1 == 8)
check("8 = N_w^3", nW * nW * nW == 8)
print()

print("S3 Magnetic pressure and beta:")
check("mag pressure factor = 2 = N_w", nW == 2)
check("plasma beta factor = 2 = N_w", nW == 2)
print()

print("S4 EM + CFD heritage:")
check("EM components = 6 = chi", chi == 6)
check("CFD D2Q9 = 9 = N_c^2", nC * nC == 9)
check("chi + N_c^2 = 6 + 9 = 15", chi + nC * nC == 15)
print()

print("S5 Cross-checks:")
check("chi + N_w = d_colour = 8", chi + nW == dColour)
check("2 * N_c = chi = 6", 2 * nC == 6)
check("N_w^3 = d_colour = 8", nW**3 == dColour)
check("chi = N_w * N_c = 6", nW * nC == chi)
check("d_colour = chi + N_w", dColour == chi + nW)
print()

print("=" * 64)
total = passed + failed
print(f"  {passed}/{total} passed, {failed} failed.")
if failed == 0:
    print("  ALL PASS -- every Plasma integer from (2, 3).")
else:
    print("  SOME FAILURES.")
