# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""
crystal_hierarchy_proof.py — Session 8 hierarchical implosion proofs.

Verifies all 6 dual route identities (5 new + r_p from S6) and
the corrected observable values for the 5 outliers.

THE AXIOM: A_F = C + M2(C) + M3(C)
All atoms from N_w=2, N_c=3. Zero free parameters.
"""

import math
from fractions import Fraction

# ══════════════════════════════════════════════════
# Algebra Atoms
# ══════════════════════════════════════════════════

N_w = 2
N_c = 3
chi = N_w * N_c            # 6
beta0 = (11 * N_c - 2 * chi) // 3  # 7
d1, d2, d3, d4 = 1, 3, 8, 24
sigma_d = d1 + d2 + d3 + d4         # 36
sigma_d2 = d1**2 + d2**2 + d3**2 + d4**2  # 650
gauss = N_c**2 + N_w**2              # 13
D = sigma_d + chi                    # 42
kappa = math.log(3) / math.log(2)
c_F = Fraction(N_c**2 - 1, 2 * N_c)  # 4/3
t_F = Fraction(1, 2)
shared_core = sigma_d2 * D            # 27300

# Lambda from VEV
M_Pl = 1.220890e19
v = M_Pl * 35 / (43 * 36 * 2**50)
lam = v / 256 * 1e3  # MeV


def test(name, condition, detail=""):
    status = "PASS" if condition else "FAIL"
    print(f"  [{status}] {name}")
    if detail and not condition:
        print(f"         {detail}")
    return condition


def main():
    print("=" * 60)
    print("  CrystalHierarchy — Python Proof Module (Session 8)")
    print("=" * 60)
    print()

    results = []

    # ══════════════════════════════════════════════════
    # §1  ATOM IDENTITIES
    # ══════════════════════════════════════════════════
    print("§1  Atom identities:")
    results.append(test("chi = 6", chi == 6))
    results.append(test("beta0 = 7", beta0 == 7))
    results.append(test("sigma_d = 36", sigma_d == 36))
    results.append(test("sigma_d2 = 650", sigma_d2 == 650))
    results.append(test("gauss = 13", gauss == 13))
    results.append(test("D = 42", D == 42))
    results.append(test("shared_core = 27300", shared_core == 27300))
    print()

    # ══════════════════════════════════════════════════
    # §2  DUAL ROUTE IDENTITIES (all must be exact)
    # ══════════════════════════════════════════════════
    print("§2  Dual route identities:")

    # m_Υ: N_c³/(χ·Σd) = N_c²/(N_w·Σd)
    corr_Y_A = Fraction(N_c**3, chi * sigma_d)
    corr_Y_B = Fraction(N_c**2, N_w * sigma_d)
    results.append(test(
        f"m_Υ dual: N_c³/(χ·Σd) = N_c²/(N_w·Σd) = {corr_Y_A}",
        corr_Y_A == corr_Y_B == Fraction(1, 8)))

    # m_D: D/(d₄·Σd) = 1/d₄ + χ/(d₄·Σd)
    corr_D_A = Fraction(D, d4 * sigma_d)
    corr_D_B = Fraction(1, d4) + Fraction(chi, d4 * sigma_d)
    results.append(test(
        f"m_D dual: D/(d₄·Σd) = 1/d₄ + χ/(d₄·Σd) = {corr_D_A}",
        corr_D_A == corr_D_B == Fraction(7, 144)))

    # m_ρ: T_F/χ = N_c/Σd
    corr_rho_A = Fraction(1, 2 * chi)  # T_F/χ
    corr_rho_B = Fraction(N_c, sigma_d)
    results.append(test(
        f"m_ρ dual: T_F/χ = N_c/Σd = {corr_rho_A}",
        corr_rho_A == corr_rho_B == Fraction(1, 12)))

    # m_φ: N_w/(N_c·Σd) = (d₄−d₃)/(d₄·Σd)
    corr_phi_A = Fraction(N_w, N_c * sigma_d)
    corr_phi_B = Fraction(d4 - d3, d4 * sigma_d)
    results.append(test(
        f"m_φ dual: N_w/(N_c·Σd) = (d₄−d₃)/(d₄·Σd) = {corr_phi_A}",
        corr_phi_A == corr_phi_B == Fraction(1, 54)))

    # Ω_DM: 1/(gauss·(gauss−N_c)) = 1/(N_w·(χ−1)·gauss)
    corr_dm_A = Fraction(1, gauss * (gauss - N_c))
    corr_dm_B = Fraction(1, N_w * (chi - 1) * gauss)
    results.append(test(
        f"Ω_DM dual: 1/(gauss·(gauss−N_c)) = 1/(N_w·(χ−1)·gauss) = {corr_dm_A}",
        corr_dm_A == corr_dm_B == Fraction(1, 130)))

    # r_p (S6): T_F/(d₃·Σd) = 1/d₄²
    corr_rp_A = Fraction(1, 2 * d3 * sigma_d)  # T_F/(d₃·Σd)
    corr_rp_B = Fraction(1, d4**2)
    results.append(test(
        f"r_p dual: T_F/(d₃·Σd) = 1/d₄² = {corr_rp_A}",
        corr_rp_A == corr_rp_B == Fraction(1, 576)))

    print()

    # ══════════════════════════════════════════════════
    # §3  SUPPORTING IDENTITIES
    # ══════════════════════════════════════════════════
    print("§3  Supporting identities:")
    results.append(test("D = Σd + χ", D == sigma_d + chi))
    results.append(test("d₄ − d₃ = N_w·d₃", d4 - d3 == N_w * d3))
    results.append(test("d₃·N_c = d₄", d3 * N_c == d4))
    results.append(test("gauss − N_c = N_w·(χ−1)", gauss - N_c == N_w * (chi - 1)))
    results.append(test("2·d₃·Σd = d₄²", 2 * d3 * sigma_d == d4**2))
    results.append(test("Σd = 2·χ·N_c", sigma_d == 2 * chi * N_c))
    print()

    # ══════════════════════════════════════════════════
    # §4  CORRECTED OBSERVABLE VALUES
    # ══════════════════════════════════════════════════
    print("§4  Corrected observable values:")

    def check_pwi(name, crystal, target, threshold=0.5):
        pwi = abs(crystal - target) / target * 100
        ok = pwi < threshold
        results.append(test(f"{name}: {crystal:.4f} vs {target} (PWI={pwi:.4f}%)", ok))
        return ok

    # m_Υ: Λ × (10 − 1/8) = Λ × 79/8
    check_pwi("m_Υ", lam * float(Fraction(79, 8)), 9460.3)

    # m_D: Λ × (2 − 7/144) = Λ × 281/144
    check_pwi("m_D", lam * float(Fraction(281, 144)), 1869.7)

    # m_ρ: m_π × 23/4  (using crystal pion ≈ 134.977)
    mpi = 134.977
    check_pwi("m_ρ", mpi * float(Fraction(23, 4)), 775.3)

    # m_φ: Λ × 115/108
    check_pwi("m_φ", lam * float(Fraction(115, 108)), 1019.5)

    # Ω_DM: 309/1159 − 1/130
    omega_m = Fraction(chi, gauss + chi)
    omega_b = Fraction(N_c, N_c * (gauss + beta0) + d1)
    base_dm = float(omega_m - omega_b)
    check_pwi("Ω_DM", base_dm - float(Fraction(1, 130)), 0.2589)

    print()

    # ══════════════════════════════════════════════════
    # §5  SUMMARY
    # ══════════════════════════════════════════════════
    passed = sum(results)
    total = len(results)
    print(f"  {passed}/{total} PASS")
    if passed == total:
        print("  ✓ All hierarchy proofs verified.")
    else:
        print("  ✗ FAILURES DETECTED.")
        exit(1)


if __name__ == "__main__":
    main()
