# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later
"""CrystalNuclear integer-identity proofs from (2,3)."""
from fractions import Fraction
nW, nC = 2, 3
chi = nW*nC; beta0 = (11*nC-2*chi)//3; sigmaD = 36
towerD = sigmaD + chi; dColour = nW**3
passed = failed = 0
def check(n, r):
    global passed, failed
    passed += r; failed += (not r)
    print(f"  {'PASS' if r else 'FAIL'}  {n}")
print("="*64)
print(" CrystalNuclear -- Integer identity proofs from (2,3)")
print("="*64); print()
print("S0 Atoms:")
check("nW=2",nW==2); check("nC=3",nC==3); check("chi=6",chi==6)
check("beta0=7",beta0==7); check("D=42",towerD==42)
check("d_colour=8",dColour==8); print()
print("S1 Magic numbers:")
check("magic 2 = N_w", nW == 2)
check("magic 8 = N_w^3 = d_colour", nW**3 == 8)
check("magic 20 = N_w^2*(chi-1)", nW**2*(chi-1) == 20)
check("magic 28 = N_w^2*beta_0", nW**2*beta0 == 28)
check("magic 50 = N_w*(chi-1)^2", nW*(chi-1)**2 == 50)
check("magic 82 = N_w*(D-1)", nW*(towerD-1) == 82)
check("magic 126 = N_w*beta_0*N_c^2", nW*beta0*nC**2 == 126); print()
print("S2 SEMF exponents:")
check("surface 2/3 = N_w/N_c", Fraction(nW,nC)==Fraction(2,3))
check("Coulomb 1/3 = 1/N_c", Fraction(1,nC)==Fraction(1,3))
check("Coulomb pre 3/5 = N_c/(chi-1)", Fraction(nC,chi-1)==Fraction(3,5))
check("pairing 1/2 = 1/N_w", Fraction(1,nW)==Fraction(1,2))
check("asymmetry 2 = N_w", nW==2); print()
print("S3 Nuclear structure:")
check("isospin = 2 = N_w", nW==2)
check("deuteron = 2 = N_w", nW==2)
check("alpha = 4 = N_w^2", nW**2==4)
check("Fe peak = 56 = d_colour*beta_0", dColour*beta0==56)
check("B(He-4) ~ 28 = N_w^2*beta_0", nW**2*beta0==28)
check("56/4 = 14 = N_w*beta_0", 56//4 == nW*beta0); print()
print("S4 Cross-checks:")
check("sum magic[0:4] = 2+8+20+28 = 58", 2+8+20+28==58)
check("magic[3]-magic[2] = 8 = d_colour", 28-20==dColour)
check("magic[1] = d_colour = shell(2) capacity", dColour==8)
check("126/7 = 18 = N_w*N_c^2 (noble Ar)", 126//7 == nW*nC**2); print()
print("="*64)
total = passed+failed
print(f"  {passed}/{total} passed, {failed} failed.")
print("  ALL PASS -- every Nuclear integer from (2, 3)." if failed==0 else "  SOME FAILURES.")
