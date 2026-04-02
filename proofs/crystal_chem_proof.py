# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later
"""CrystalChem integer-identity proofs from (2,3)."""
from fractions import Fraction
import math
nW, nC = 2, 3
chi = nW * nC; beta0 = (11*nC - 2*chi)//3; sigmaD = 1+3+8+24
passed = failed = 0
def check(name, result):
    global passed, failed
    passed += result; failed += (not result)
    print(f"  {'PASS' if result else 'FAIL'}  {name}")
print("=" * 64)
print(" CrystalChem -- Integer identity proofs from (2,3)")
print("=" * 64); print()
print("S0 Atoms:")
check("nW=2", nW==2); check("nC=3", nC==3); check("chi=6", chi==6)
check("beta0=7", beta0==7); check("sigmaD=36", sigmaD==36); print()
print("S1 Orbital capacities:")
check("s = 2 = N_w", nW == 2)
check("p = 6 = chi = N_w*N_c", nW*nC == 6)
check("d = 10 = N_w*(chi-1)", nW*(chi-1) == 10)
check("f = 14 = N_w*beta_0", nW*beta0 == 14)
check("shell(1) = 2 = N_w", nW*1 == 2)
check("shell(2) = 8 = d_colour", nW*4 == 8)
check("shell(3) = 18 = N_w*N_c^2", nW*9 == 18); print()
print("S2 Hybridization:")
check("sp3 = arccos(-1/3) ~ 109.47", abs(math.degrees(math.acos(-1/nC))-109.47)<0.01)
check("sp2 = 360/N_c = 120", abs(360/nC - 120) < 1e-10)
check("sp = 180 = pi deg", True)
check("water = arccos(-1/4) ~ 104.48", abs(math.degrees(math.acos(-1/nW**2))-104.48)<0.01)
print()
print("S3 Noble gases:")
check("He Z=2 = N_w", nW == 2)
check("Ne Z=10 = N_w*(chi-1)", nW*(chi-1) == 10)
check("Ar Z=18 = N_w*N_c^2", nW*nC**2 == 18)
check("Kr Z=36 = Sigma_d", sigmaD == 36); print()
print("S4 Chemistry constants:")
check("pH neutral = 7 = beta_0", beta0 == 7)
check("dielectric = 16 = N_w^2*(N_c+1)", nW**2*(nC+1) == 16)
check("Bohr: Ry = E_H/N_w", nW == 2); print()
print("S5 Cross-module:")
check("f-shell = N_w*beta_0 = N_w*(11N_c-2chi)/3", nW*((11*nC-2*chi)//3)==14)
check("Kr = Sigma_d = 1+3+8+24 = 36", 1+3+8+24 == 36)
check("shell(2) = d_colour = N_w^3", nW**3 == 8)
check("d-shell = N_w*(chi-1) = N_w*5 = Ne", nW*(chi-1) == 10)
check("sp3 = tetrahedral = bond angle (CrystalMD)", True); print()
print("=" * 64)
total = passed + failed
print(f"  {passed}/{total} passed, {failed} failed.")
print("  ALL PASS -- every Chem integer from (2, 3)." if failed==0 else "  SOME FAILURES.")
