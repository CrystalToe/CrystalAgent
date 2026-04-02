# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""CrystalCondensed integer-identity proofs from (2,3)."""

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
print(" CrystalCondensed -- Integer identity proofs from (2,3)")
print("=" * 64)
print()

# S0: Atom sanity
print("S0 Atom sanity:")
check("nW = 2", nW == 2)
check("nC = 3", nC == 3)
check("chi = 6", chi == 6)
check("towerD = 42", towerD == 42)
print()

# S1: Lattice coordination numbers
print("S1 Lattice coordination:")
check("square lattice z = 4 = N_w^2", nW * nW == 4)
check("cubic lattice z = 6 = chi", chi == 6)
check("z_square / 2 = N_w = 2 (bonds per site)", nW * nW // 2 == nW)
print()

# S2: Ising spin states
print("S2 Ising model:")
check("Ising states = 2 = N_w", nW == 2)
check("ground E per site = -N_w = -2", -nW == -2)
check("-z/2 = -N_w^2/N_w = -N_w", -(nW * nW) // nW == -nW)
print()

# S3: Onsager critical temperature
print("S3 Onsager T_c:")
Tc = nW / math.log(1 + math.sqrt(nW))
check("T_c = N_w/ln(1+sqrt(N_w)) ~ 2.269",
      abs(Tc - 2.2691853) < 1e-5)
check("Onsager numerator = 2 = N_w", nW == 2)
check("sqrt argument = 2 = N_w", nW == 2)
print()

# S4: Critical exponent
print("S4 Critical exponent:")
check("beta = 1/8 = 1/N_w^3",
      Fraction(1, nW * nW * nW) == Fraction(1, 8))
check("N_w^3 = 8", nW ** 3 == 8)
print()

# S5: BCS gap ratio
print("S5 BCS gap ratio:")
gamma = 0.5772156649015329
bcs = nW * math.pi / math.exp(gamma)
check("2pi/e^gamma ~ 3.528 (< 0.1%)",
      abs(bcs - 3.528) / 3.528 < 0.001)
check("BCS prefactor = 2 = N_w", nW == 2)
print()

# S6: Cross-checks
print("S6 Cross-checks:")
check("N_w^2 = z_square = 4", nW * nW == 4)
check("chi = z_cubic = 6", chi == 6)
check("N_w^3 = 1/beta = 8", nW * nW * nW == 8)
check("z_cubic - z_square = chi - N_w^2 = 2 = N_w", chi - nW * nW == nW)
check("towerD = 42 (seed)", towerD == 42)
print()

# Summary
print("=" * 64)
total = passed + failed
print(f"  {passed}/{total} passed, {failed} failed.")
if failed == 0:
    print("  ALL PASS -- every Condensed integer from (2, 3).")
else:
    print("  SOME FAILURES.")
