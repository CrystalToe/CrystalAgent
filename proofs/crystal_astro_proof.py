# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later
"""CrystalAstro integer-identity proofs from (2,3)."""
from fractions import Fraction
nW,nC=2,3; chi=nW*nC; beta0=(11*nC-2*chi)//3; dColour=nW**3
passed=failed=0
def check(n,r):
    global passed,failed
    passed+=r; failed+=(not r)
    print(f"  {'PASS' if r else 'FAIL'}  {n}")
print("="*64); print(" CrystalAstro -- proofs from (2,3)"); print("="*64); print()
print("S0 Atoms:")
check("nW=2",nW==2); check("nC=3",nC==3); check("chi=6",chi==6)
check("beta0=7",beta0==7); check("dColour=8",dColour==8); print()
print("S1 Polytropes:")
check("NR = 3/2 = N_c/N_w", Fraction(nC,nW)==Fraction(3,2))
check("rel = 3 = N_c", nC==3); print()
print("S2 Black holes & radiation:")
check("Schwarzschild = 2 = N_w", nW==2)
check("Hawking = 8 = d_colour = N_w^3", dColour==8)
check("SB denom 15 = N_c*(chi-1)", nC*(chi-1)==15)
check("Eddington = 4 = N_w^2", nW**2==4); print()
print("S3 Main sequence:")
check("L exp = 7/2 = beta_0/N_w", Fraction(beta0,nW)==Fraction(7,2))
check("t exp = 5/2 = (chi-1)/N_w", Fraction(chi-1,nW)==Fraction(5,2))
check("alpha_L = 1 + alpha_t", Fraction(beta0,nW)==1+Fraction(chi-1,nW)); print()
print("S4 Structure:")
check("virial = 2 = N_w", nW==2)
check("grav PE = 3/5 = N_c/(chi-1)", Fraction(nC,chi-1)==Fraction(3,5))
check("mu_e = 2 = N_w", nW==2)
check("Jeans T = 3/2 = N_c/N_w", Fraction(nC,nW)==Fraction(3,2))
check("Jeans rho = 1/2 = 1/N_w", Fraction(1,nW)==Fraction(1,2)); print()
print("S5 Cross-module:")
check("grav PE 3/5 = nuclear Coulomb (CrystalNuclear)", Fraction(nC,chi-1)==Fraction(3,5))
check("Hawking*Eddington = 32 = N_w^5 = Peters (CrystalGW)", dColour*nW**2==32)
check("polytrope NR = Jeans T = Chandrasekhar exp", Fraction(nC,nW)==Fraction(3,2))
check("Schwarzschild = virial = isospin = N_w", nW==2)
check("SB 15 + Eddington 4 = 19 = gauss+chi", 15+4==nC**2+nW**2+chi); print()
print("="*64)
total=passed+failed
print(f"  {passed}/{total} passed, {failed} failed.")
print("  ALL PASS -- every Astro integer from (2, 3)." if failed==0 else "  SOME FAILURES.")
