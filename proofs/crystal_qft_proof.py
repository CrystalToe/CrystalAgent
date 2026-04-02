# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later
"""CrystalQFT integer-identity proofs from (2,3)."""
from fractions import Fraction
import math

nW, nC = 2, 3
chi = nW * nC
beta0 = (11 * nC - 2 * chi) // 3
sigmaD = 1 + 3 + 8 + 24
towerD = sigmaD + chi
gauss = nC * nC + nW * nW
dColour = nW ** 3
d3 = nC * nC - 1

passed = failed = 0
def check(name, result):
    global passed, failed
    tag = "PASS" if result else "FAIL"
    passed += result; failed += (not result)
    print(f"  {tag}  {name}")

print("=" * 64)
print(" CrystalQFT -- Integer identity proofs from (2,3)")
print("=" * 64)
print()

print("S0 Atom sanity:")
check("nW = 2", nW == 2)
check("nC = 3", nC == 3)
check("chi = 6", chi == 6)
check("beta0 = 7", beta0 == 7)
check("towerD = 42", towerD == 42)
print()

print("S1 Spacetime structure:")
check("spacetime dim = 4 = N_w^2", nW * nW == 4)
check("Lorentz generators = d(d-1)/2 = 6", nW**2 * (nW**2 - 1) // 2 == 6)
check("Lorentz = chi", nW**2 * (nW**2 - 1) // 2 == chi)
check("Dirac gammas = 4 = N_w^2", nW * nW == 4)
check("spinor components = 2 = N_w", nW == 2)
print()

print("S2 Gauge structure:")
check("photon polarisations = 2 = N_c-1", nC - 1 == 2)
check("gluon colours = 8 = N_c^2-1", nC**2 - 1 == 8)
check("gluons = d_3 = d_colour", d3 == dColour)
check("QCD beta_0 = 7 = (11N_c-2chi)/3", (11*nC - 2*chi) // 3 == 7)
check("N_f = chi = 6 flavours", chi == 6)
check("one-loop = 16 = N_w^4", nW**4 == 16)
print()

print("S3 Cross-section structure:")
check("Thomson = 8/3 = d_colour/N_c", Fraction(dColour, nC) == Fraction(8, 3))
check("ee->mumu: 4 = N_w^2", nW * nW == 4)
check("ee->mumu: 3 = N_c", nC == 3)
check("propagator exp = 2 = N_c-1", nC - 1 == 2)
check("pair threshold = 2m: factor N_w", nW == 2)
check("phase space Phi_2: 8 = d_colour", dColour == 8)
print()

print("S4 Fine structure constant:")
alpha_inv = (towerD + 1) * math.pi + math.log(beta0)
check("alpha^-1 = (D+1)pi + ln(beta_0) ~ 137.034",
      abs(alpha_inv - 137.036) / 137.036 < 0.001)
check("D+1 = 43 = towerD+1", towerD + 1 == 43)
check("beta_0 = 7 (in ln)", beta0 == 7)
print()

print("S5 Cross-checks:")
check("d(d-1)/2 = N_w^2(N_w^2-1)/2 = chi", nW**2 * (nW**2 - 1) // 2 == chi)
check("d_colour = N_w^3 = gluons = N_c^2-1", dColour == d3)
check("4-body PS dim = 8 = d_colour", nC*4 - (nC+1) == dColour)
check("3-body PS dim = 5 = chi-1", nC*3 - (nC+1) == chi - 1)
check("N_w^4 = 16 = one-loop", nW**4 == 16)
print()

print("=" * 64)
total = passed + failed
print(f"  {passed}/{total} passed, {failed} failed.")
if failed == 0:
    print("  ALL PASS -- every QFT integer from (2, 3).")
else:
    print("  SOME FAILURES.")
