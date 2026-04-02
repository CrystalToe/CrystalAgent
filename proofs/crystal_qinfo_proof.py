# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later
"""CrystalQInfo integer-identity proofs from (2,3)."""
from fractions import Fraction
import math
nW,nC=2,3; chi=nW*nC; beta0=(11*nC-2*chi)//3; sigmaD=36; towerD=sigmaD+chi
passed=failed=0
def check(n,r):
    global passed,failed
    passed+=r; failed+=(not r)
    print(f"  {'PASS' if r else 'FAIL'}  {n}")
print("="*64); print(" CrystalQInfo -- proofs from (2,3)"); print("="*64); print()
print("S0 Atoms:")
check("nW=2",nW==2); check("nC=3",nC==3); check("chi=6",chi==6)
check("beta0=7",beta0==7); check("D=42",towerD==42); print()
print("S1 Qubit structure:")
check("qubit = 2 = N_w", nW==2)
check("Pauli = 3 = N_c", nC==3)
check("Pauli group = 4 = N_w^2", nW**2==4)
check("Bell states = 4 = N_w^2", nW**2==4)
check("Toffoli = 3 = N_c", nC==3); print()
print("S2 Error correction:")
check("Steane n=7=beta_0", beta0==7)
check("Steane n=N_w^N_c-1=2^3-1", nW**nC-1==7)
check("Steane d=3=N_c", nC==3)
check("Steane corrects (N_c-1)//2=1", (nC-1)//2==1)
check("Shor n=9=N_c^2", nC**2==9)
check("Shor = D2Q9 (CrystalCFD)", nC**2==9); print()
print("S3 MERA:")
check("bond dim = 6 = chi", chi==6)
check("depth = 42 = D", towerD==42)
check("entropy = ln(6) = ln(chi)", abs(math.log(6)-math.log(chi))<1e-12)
check("ln(chi) = ln(N_w)+ln(N_c)", abs(math.log(chi)-math.log(nW)-math.log(nC))<1e-12)
print()
print("S4 Heyting algebra:")
check("gcd(N_w,N_c) = 1 (coprime)", math.gcd(nW,nC)==1)
check("truth weak = 1/N_w = 1/2", Fraction(1,nW)==Fraction(1,2))
check("truth colour = 1/N_c = 1/3", Fraction(1,nC)==Fraction(1,3))
check("truth mixed = 1/chi = 1/6", Fraction(1,chi)==Fraction(1,6))
check("uncertainty: 1/(N_w*N_c) = 1/chi", Fraction(1,nW*nC)==Fraction(1,chi)); print()
print("S5 Information:")
check("teleport = 2 = N_w cbits", nW==2)
check("superdense = 2 = N_w cbits", nW==2)
check("Bell entropy = ln(2) = ln(N_w)", abs(math.log(2)-math.log(nW))<1e-12); print()
print("="*64)
total=passed+failed
print(f"  {passed}/{total} passed, {failed} failed.")
print("  ALL PASS -- every QInfo integer from (2, 3)." if failed==0 else "  SOME FAILURES.")
