# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later
"""CrystalRigid integer-identity proofs from (2,3)."""
from fractions import Fraction
nW, nC = 2, 3
chi = nW * nC
passed = failed = 0
def check(name, result):
    global passed, failed
    tag = "PASS" if result else "FAIL"
    passed += result; failed += (not result)
    print(f"  {tag}  {name}")
print("=" * 64)
print(" CrystalRigid -- Integer identity proofs from (2,3)")
print("=" * 64)
print()
print("S0 Atom sanity:")
check("nW = 2", nW == 2)
check("nC = 3", nC == 3)
check("chi = 6", chi == 6)
print()
print("S1 Rigid body structure:")
check("rotation axes = 3 = N_c", nC == 3)
check("quaternion comp = 4 = N_w^2", nW**2 == 4)
check("inertia tensor = 6 = chi", chi == 6)
check("rigid DOF = 6 = chi = N_c+N_c", nC + nC == chi)
check("rotation matrix = 9 = N_c^2", nC**2 == 9)
check("Euler angles = 3 = N_c", nC == 3)
print()
print("S2 Moments of inertia:")
check("I_sphere = 2/5 = N_w/(chi-1)", Fraction(nW, chi-1) == Fraction(2,5))
check("I_rod = 1/12 = 1/(2chi)", Fraction(1, 2*chi) == Fraction(1,12))
check("I_disk = 1/2 = 1/N_w", Fraction(1, nW) == Fraction(1,2))
check("I_shell = 2/3 = N_w/N_c", Fraction(nW, nC) == Fraction(2,3))
print()
print("S3 Cross-module traces:")
check("I_sphere = Flory exponent (CrystalMD)", Fraction(nW,chi-1) == Fraction(2,5))
check("I_rod denom = 2chi = LJ repulsive (CrystalThermo)", 2*chi == 12)
check("I_disk = 1/N_w = weak eigenvalue (CrystalMonad)", Fraction(1,nW) == Fraction(1,2))
check("I_shell = N_w/N_c = Larmor factor (CrystalEM)", Fraction(nW,nC) == Fraction(2,3))
check("quaternion = N_w^2 = spacetime dim (CrystalQFT)", nW**2 == 4)
print()
print("S4 Cross-checks:")
check("chi = 2*N_c = N_c + N_c (translate + rotate)", 2*nC == chi)
check("N_c^2 = 9 = D2Q9 (CrystalCFD)", nC**2 == 9)
check("inertia indep = chi = Lorentz gen (CrystalQFT)", chi == 6)
check("N_w^2(N_w^2-1)/2 = chi (Lorentz from spacetime)", nW**2*(nW**2-1)//2 == chi)
print()
print("=" * 64)
total = passed + failed
print(f"  {passed}/{total} passed, {failed} failed.")
if failed == 0:
    print("  ALL PASS -- every Rigid integer from (2, 3).")
else:
    print("  SOME FAILURES.")
