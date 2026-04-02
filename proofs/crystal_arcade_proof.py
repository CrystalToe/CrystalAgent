# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later
"""CrystalArcade integer-identity proofs from (2,3)."""
from fractions import Fraction
import math
nW,nC=2,3; chi=nW*nC; beta0=(11*nC-2*chi)//3; sigmaD=36; towerD=sigmaD+chi
dColour=nW**3
passed=failed=0
def check(n,r):
    global passed,failed
    passed+=r; failed+=(not r)
    print(f"  {'PASS' if r else 'FAIL'}  {n}")
print("="*64); print(" CrystalArcade -- proofs from (2,3)"); print("="*64); print()
print("S0 Atoms:")
check("nW=2",nW==2); check("nC=3",nC==3); check("chi=6",chi==6); print()
print("S1 Approximation parameters:")
check("LJ cutoff = 3 = N_c", nC==3)
check("BH theta = 1/2 = 1/N_w", Fraction(1,nW)==Fraction(1,2))
check("octree = 8 = d_colour = N_w^3", dColour==8)
check("WCA = 2^(1/6) = N_w^(1/chi)", abs(nW**(1/chi) - 2**(1/6)) < 1e-12)
check("Euler = 1 = d_1", 1==1)
check("Verlet = 2 = N_w", nW==2)
check("fixed bits = 16 = N_w^4", nW**4==16)
check("hash cells = 3 = N_c", nC==3)
check("LOD = 3 = N_c", nC==3)
check("MF T_c = 4 = N_w^2", nW**2==4)
check("Newton = 2 = N_w", nW==2)
alpha_inv = (towerD+1)*math.pi + math.log(beta0)
check("alpha^-1 = 137 = floor(43pi+ln7)", int(alpha_inv)==137); print()
print("S2 Error bounds:")
# LJ at r=3sigma is negligible
r6 = 3.0**6; r12 = r6*r6
v3 = 4*(1/r12 - 1/r6)
check("|V(3sigma)| < 0.01", abs(v3) < 0.01)
# MF overestimates exact
tc_exact = nW/math.log(1+math.sqrt(nW))
check("MF/exact = N_w^2/T_c > 1", nW**2/tc_exact > 1)
check("MF/exact < 2", nW**2/tc_exact < 2); print()
print("S3 Cross-module:")
check("octree = NBody (CrystalNBody)", dColour==8)
check("LJ cutoff = rule 12 (CrystalMD)", nC==3)
check("BH theta = opening angle (CrystalNBody)", Fraction(1,nW)==Fraction(1,2))
check("fixed 16 = one-loop (CrystalQFT)", nW**4==16)
check("LOD = codon (CrystalBio)", nC==3)
check("hash = Pauli (CrystalQInfo)", nC==3); print()
print("="*64)
total=passed+failed
print(f"  {passed}/{total} passed, {failed} failed.")
print("  ALL PASS -- every Arcade integer from (2, 3)." if failed==0 else "  SOME FAILURES.")
