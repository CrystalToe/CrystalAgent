# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""78 — Verify Everything: Run All Crystal Checks"""
from crystal_topos import (
    QuantumState, n_w, n_c, chi, beta0, gauss, d_total,
    sigma_d, sigma_d2, crystal_kappa, crystal_max_entropy
)
import math, sys
passed = 0; failed = 0

def check(name, crystal, expected, tol=1e-6):
    global passed, failed
    ok = abs(crystal - expected) < tol
    status = "✓" if ok else "✗"
    if ok: passed += 1
    else: failed += 1
    print(f"  {status} {name}: {crystal} {'=' if ok else '≠'} {expected}")

print("Crystal Topos — Full Verification")
print("=" * 55)
check("N_w", n_w(), 2)
check("N_c", n_c(), 3)
check("χ", chi(), 6)
check("β₀", beta0(), 7)
check("gauss", gauss(), 13)
check("Σd", sigma_d(), 36)
check("Σd²", sigma_d2(), 650)
check("D", d_total(), 42)
check("κ", crystal_kappa(), math.log(3)/math.log(2), 1e-10)
check("S_max", crystal_max_entropy(), math.log(6), 1e-10)
check("χ² = Σd", chi()**2, sigma_d())
check("s-orbital", n_w(), 2)
check("p-orbital", n_w()*n_c(), 6)
check("d-orbital", n_w()*(chi()-1), 10)
check("f-orbital", n_w()*beta0(), 14)
check("DNA bases", n_w()**2, 4)
check("Codons", (n_w()**2)**n_c(), 64)
check("Amino acids", gauss()+beta0(), 20)
check("Signals", n_c()*beta0(), 21)
check("Helix turn", n_c()+n_c()/(chi()-1), 3.6)
check("Carnot", (chi()-1)/chi(), 5/6, 1e-10)
check("Stefan-Boltz", n_w()*n_c()*(gauss()+beta0()), 120)
check("Kolmogorov", (n_c()+n_w())/n_c(), 5/3, 1e-10)
check("von Kármán", n_w()/(n_c()+n_w()), 0.4, 1e-10)
check("Casimir", (n_c()**2-1)/(2*n_c()), 4/3, 1e-10)
check("BCS ratio", sigma_d()/chi()**2, 1)
psi = QuantumState.max_entangled()
check("Entanglement", psi.entanglement_entropy(), math.log(6), 0.01)
check("PPT entangled", 0 if psi.ppt_test() else 1, 1)
print(f"\n  {passed} passed, {failed} failed out of {passed+failed}")
if failed == 0: print("  ALL CHECKS PASS. The crystal is consistent.")
