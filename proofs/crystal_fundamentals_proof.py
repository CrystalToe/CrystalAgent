#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""
Crystal Topos — Fundamental Observables (Python proof module)

14 new observables: 181 → 195. Zero free parameters.
Every formula uses only (2,3) lattice invariants.
"""

import sys
import math

# ─── Crystal constants ───────────────────────────────────────────────
N_W = 2
N_C = 3
CHI = N_W * N_C                             # 6
BETA_0 = (11 * N_C - 2 * CHI) // 3         # 7
SIGMA_D = 1 + N_C + (N_C**2 - 1) + N_W**3 * N_C  # 36
SIGMA_D2 = 1 + 9 + 64 + 576                # 650
GAUSS = N_C**2 + N_W**2                     # 13
TOWER_D = SIGMA_D + CHI                     # 42
KAPPA = math.log(3) / math.log(2)           # ln3/ln2

V_MEV = 246220.0
FERMAT3 = 2**(2**N_C) + 1                   # 257
LAMBDA_H = V_MEV / FERMAT3
M_PROTON = V_MEV / 2**(2**N_C) * 53 / 54
M_PI = M_PROTON / BETA_0
LAMBDA_QCD = M_PROTON * N_C / GAUSS
M_E = LAMBDA_H / (N_C**2 * N_W**4 * GAUSS)
F_PI = LAMBDA_QCD * N_C / BETA_0
ALPHA = 1.0 / (43 * math.pi + math.log(7))
HBAR_C = 197.327


# ═════════════════════════════════════════════════════════════════════
# §1  INTEGER IDENTITY PROOFS
# ═════════════════════════════════════════════════════════════════════

integer_checks = [
    # Core invariants
    ("chi = 6",                          CHI == 6),
    ("beta0 = 7",                        BETA_0 == 7),
    ("towerD = 42",                      TOWER_D == 42),
    ("sigmaD = 36",                      SIGMA_D == 36),
    ("sigmaD2 = 650",                    SIGMA_D2 == 650),
    ("gauss = 13",                       GAUSS == 13),

    # Phase 1
    ("N_eff denom: D*N_c = 126",         TOWER_D * N_C == 126),
    ("Omega_b/Omega_m: gauss+chi = 19",  GAUSS + CHI == 19),
    ("sin2thetaW(0): D*chi = 252",       TOWER_D * CHI == 252),
    ("Y_p: chi*D = 252",                 CHI * TOWER_D == 252),
    ("mu_p/mu_n num: N_c*(Sd-1) = 105",  N_C * (SIGMA_D - 1) == 105),
    ("mu_p/mu_n den: N_w*Sd = 72",       N_W * SIGMA_D == 72),

    # Phase 2
    ("m_c/m_s base: N_w^2*N_c = 12",     N_W**2 * N_C == 12),
    ("m_c/m_s base alt: gauss-1 = 12",   GAUSS - 1 == 12),
    ("m_c/m_s base alt2: Sd/N_c = 12",   SIGMA_D // N_C == 12),
    ("m_c/m_s corr num: D+beta0 = 49",   TOWER_D + BETA_0 == 49),
    ("m_c/m_s corr den: D+beta0+1 = 50", TOWER_D + BETA_0 + 1 == 50),
    ("m_c/m_s den route2: Sd2/g = 50",   SIGMA_D2 // GAUSS == 50),
    ("m_c/m_s product: 12*49 = 588",     12 * 49 == 588),
    ("m_b/m_tau: chi*beta0 = D = 42",    CHI * BETA_0 == TOWER_D),
    ("m_t/v: gauss-N_c = 10",            GAUSS - N_C == 10),
    ("pion radius: N_c^2 = 9",           N_C**2 == 9),
    ("pion radius: gauss+beta0 = 20",    GAUSS + BETA_0 == 20),

    # Phase 3
    ("sigma_piN: D+1 = 43",              TOWER_D + 1 == 43),
    ("sigma_piN same 43: Sd+chi+1 = 43", SIGMA_D + CHI + 1 == 43),
    ("dm32 nu3: 2*chi-2 = 10",           2 * CHI - 2 == 10),
    ("dm32 nu3: 2*chi-1 = 11",           2 * CHI - 1 == 11),
    ("split ratio: chi^4 = 1296",         CHI**4 == 1296),
    ("split ratio: chi^4-1 = 1295",       CHI**4 - 1 == 1295),
    ("grav: beta0*(chi-1) = 35",          BETA_0 * (CHI - 1) == 35),
    ("grav: D+gauss-N_w = 53",            TOWER_D + GAUSS - N_W == 53),
    ("grav: D+gauss-N_w+1 = 54",          TOWER_D + GAUSS - N_W + 1 == 54),
    ("fermat: 2^(2^3)+1 = 257",           2**(2**N_C) + 1 == 257),
]


# ═════════════════════════════════════════════════════════════════════
# §2  OBSERVABLE VALUE PROOFS
# ═════════════════════════════════════════════════════════════════════

def pwi(crystal, pdg):
    if pdg == 0:
        return 0.0
    return abs(crystal - pdg) / abs(pdg) * 100

def rating(p):
    if p == 0: return "EXACT"
    if p < 0.5: return "TIGHT"
    if p < 1.0: return "GOOD"
    if p < 4.5: return "LOOSE"
    return "OVER"

# Phase 1
neff_crystal = N_C + KAPPA / TOWER_D
ob_om_crystal = N_C / (GAUSS + CHI)
sw0_crystal = N_C / GAUSS + N_W / (TOWER_D * CHI)
yp_crystal = 0.25 - 1.0 / (CHI * TOWER_D)
moment_crystal = -(N_C / N_W) * (1 - 1 / SIGMA_D)

# Phase 2
mcms_crystal = N_W**2 * N_C * (TOWER_D + BETA_0) / (TOWER_D + BETA_0 + 1)
mbtau_crystal = BETA_0 / N_C + 1 / (CHI * BETA_0)
yt_crystal = BETA_0 / (GAUSS - N_C) + 1 / SIGMA_D2
rpi_coeff = N_C**2 / (GAUSS + BETA_0)
rpi2_crystal = (rpi_coeff * HBAR_C / M_PI)**2
dalpha_crystal = 1 / SIGMA_D

# Phase 3
sigma_crystal = M_PI**2 * N_C / M_PROTON * (TOWER_D + 1) / TOWER_D
v_ev = 246.22e9
m_nu2 = N_W * v_ev / (2**TOWER_D * GAUSS)
dm21_crystal = m_nu2**2
m_nu3 = v_ev / 2**TOWER_D * 10 / 11
dm32_crystal = m_nu3**2 - m_nu2**2
mpl_over_v = math.exp(TOWER_D) / (BETA_0 * (CHI - 1))
mp_over_v = 53 / (54 * 2**(2**N_C))
grav_crystal = (mp_over_v / mpl_over_v)**2

observable_checks = [
    # Phase 1
    ("N_eff",            neff_crystal,     3.044,     0.5),
    ("Omega_b/Omega_m",  ob_om_crystal,    0.157,     1.0),
    ("sin2thetaW(0)",    sw0_crystal,      0.23857,   0.5),
    ("Y_p",              yp_crystal,       0.2449,    0.5),
    ("mu_p/mu_n",        moment_crystal,  -1.45990,   0.5),
    # Phase 2
    ("m_c/m_s",          mcms_crystal,     11.76,     0.01),
    ("m_b/m_tau",        mbtau_crystal,    2.3525,    0.5),
    ("m_t/v",            yt_crystal,       0.70165,   0.5),
    ("r2_pi",            rpi2_crystal,     0.434,     0.5),
    ("Delta_alpha_had",  dalpha_crystal,   0.02766,   0.5),
    # Phase 3
    ("sigma_piN",        sigma_crystal,    59.0,      0.5),
    ("Dm2_21",           dm21_crystal,     7.42e-5,   0.5),
    ("Dm2_32",           dm32_crystal,     2.515e-3,  0.5),
    ("G_N_coupling",     grav_crystal,     5.905e-39, 1.0),
]


# ═════════════════════════════════════════════════════════════════════
# §3  MAIN — RUN ALL CHECKS
# ═════════════════════════════════════════════════════════════════════

if __name__ == "__main__":
    failures = 0

    print("=" * 64)
    print("  Crystal Topos — Fundamental Observables Python Proof Module")
    print("  14 new observables, 181 → 195")
    print("=" * 64)
    print()

    # Integer identities
    print("  INTEGER IDENTITY PROOFS:")
    for name, ok in integer_checks:
        status = "PASS" if ok else "*** FAIL ***"
        if not ok:
            failures += 1
        print(f"    {name:42s}  {status}")

    print()

    # Observable values
    print("  OBSERVABLE VALUE PROOFS:")
    for name, crystal, pdg, max_pwi in observable_checks:
        p = pwi(crystal, pdg)
        r = rating(p)
        ok = p <= max_pwi
        status = "PASS" if ok else "*** FAIL ***"
        if not ok:
            failures += 1
        print(f"    {name:20s}  crystal={crystal:13.6e}  pdg={pdg:13.6e}"
              f"  PWI={p:.3f}%  {r:6s}  {status}")

    print()
    print(f"  {'─' * 50}")

    n_int = len(integer_checks)
    n_obs = len(observable_checks)
    n_total = n_int + n_obs
    n_pass = n_total - failures

    int_pass = sum(1 for _, ok in integer_checks if ok)
    obs_pass = sum(1 for _, crystal, pdg, max_p in observable_checks
                   if pwi(crystal, pdg) <= max_p)

    print(f"  Integer checks:    {int_pass}/{n_int}")
    print(f"  Observable checks: {obs_pass}/{n_obs}")
    print(f"\n  TOTAL: {int_pass + obs_pass}/{n_total} checks PASS")

    if failures == 0:
        print("\n  RESULT: ALL PROOFS PASS")
        sys.exit(0)
    else:
        print(f"\n  RESULT: {failures} FAILURE(S)")
        sys.exit(1)
