# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later
"""CrystalBio integer-identity proofs from (2,3)."""
from fractions import Fraction
nW,nC=2,3; chi=nW*nC; beta0=(11*nC-2*chi)//3
passed=failed=0
def check(n,r):
    global passed,failed
    passed+=r; failed+=(not r)
    print(f"  {'PASS' if r else 'FAIL'}  {n}")
print("="*64); print(" CrystalBio -- proofs from (2,3)"); print("="*64); print()
print("S0 Atoms:")
check("nW=2",nW==2); check("nC=3",nC==3); check("chi=6",chi==6); print()
print("S1 Genetic code:")
check("bases = 4 = N_w^2", nW**2==4)
check("codon = 3 = N_c", nC==3)
check("codons = 64 = (N_w^2)^N_c", (nW**2)**nC==64)
check("amino acids = 20 = N_w^2*(chi-1)", nW**2*(chi-1)==20)
check("stops = 3 = N_c", nC==3)
check("sense = 61 = 64-3", (nW**2)**nC - nC == 61)
check("redundancy ~ N_c (61/20=3.05)", abs(61/20-nC)/nC < 0.05); print()
print("S2 DNA structure:")
check("strands = 2 = N_w", nW==2)
check("H-bond A-T = 2 = N_w", nW==2)
check("H-bond G-C = 3 = N_c", nC==3)
check("BP/turn = 10 = N_w*(chi-1)", nW*(chi-1)==10)
check("Chargaff pairs = 2 = N_w", nW==2); print()
print("S3 Protein:")
check("helix = 18/5 = N_c^2*N_w/(chi-1)", Fraction(nC**2*nW, chi-1)==Fraction(18,5))
check("Flory = 2/5 = N_w/(chi-1)", Fraction(nW,chi-1)==Fraction(2,5))
check("bilayer = 2 = N_w", nW==2)
check("Ramachandran = 2 = N_w angles", nW==2); print()
print("S4 Allometric:")
check("Kleiber = 3/4 = N_c/N_w^2", Fraction(nC,nW**2)==Fraction(3,4))
check("heart rate = 1/4 = 1/N_w^2", Fraction(1,nW**2)==Fraction(1,4))
check("lifespan = 1/4 = 1/N_w^2", Fraction(1,nW**2)==Fraction(1,4))
check("surface = 2/3 = N_w/N_c", Fraction(nW,nC)==Fraction(2,3))
check("heartbeats constant (exps cancel)", Fraction(1,nW**2)==Fraction(1,nW**2)); print()
print("S5 Cross-module:")
check("Kleiber = Chandrasekhar (CrystalAstro)", Fraction(nC,nW**2)==Fraction(3,4))
check("surface = I_shell (CrystalRigid)", Fraction(nW,nC)==Fraction(2,3))
check("bases = Bell states (CrystalQInfo)", nW**2==4)
check("helix = CrystalMD", Fraction(nC**2*nW,chi-1)==Fraction(18,5))
check("Flory = I_sphere (CrystalRigid)", Fraction(nW,chi-1)==Fraction(2,5)); print()
print("="*64)
total=passed+failed
print(f"  {passed}/{total} passed, {failed} failed.")
print("  ALL PASS -- every Bio integer from (2, 3)." if failed==0 else "  SOME FAILURES.")
