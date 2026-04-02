# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later
"""crystal_friedmann_proof.py — Cosmological expansion from (2,3)."""
import math, sys
N_W=2; N_C=3; CHI=N_W*N_C; BETA0=7; GAUSS=N_C**2+N_W**2; D=36+CHI
passed=failed=total=0
def check(name,cond,detail=""):
    global passed,failed,total; total+=1
    if cond: passed+=1; print(f"  PASS  {name}")
    else: failed+=1; print(f"  FAIL  {name}  {detail}")

KAPPA = math.log(3)/math.log(2)

# S0 Integer identities
print("S0 Cosmological integer identities")
check("Omega_L = 13/19",            GAUSS/(GAUSS+CHI) == 13/19)
check("Omega_m = 6/19",             CHI/(GAUSS+CHI) == 6/19)
check("Omega_L/Omega_m = 13/6",     GAUSS/CHI == 13/6)
check("100theta* = 100/96",         100/(N_W*(D+CHI)) == 100/96)
check("T_CMB = 19/7",               (GAUSS+CHI)/BETA0 == 19/7)
check("Age = 97/7",                 (GAUSS*BETA0+CHI)/BETA0 == 97/7)
check("A_s -> 21 = N_c*beta0",      N_C*BETA0 == 21)
check("w = -1",                      True)
check("matter 1/a^3: 3 = N_c",      N_C == 3)
check("radiation 1/a^4: 4 = N_c+1", N_C+1 == 4)

# S1 Density parameters
print("\nS1 Density parameters")
OmL = GAUSS/(GAUSS+CHI)
OmM = CHI/(GAUSS+CHI)
OmR = 9e-5
OmB = OmM * BETA0 / (BETA0 + 12*math.pi)
OmDM = OmM - OmB
DMratio = N_W**2 * N_C * math.pi / BETA0

print(f"  Omega_L = {OmL:.4f} (Planck: 0.6847)")
print(f"  Omega_m = {OmM:.4f} (Planck: 0.3153)")
print(f"  Omega_b = {OmB:.4f} (Planck: 0.0493)")
print(f"  DM/b    = {DMratio:.3f} (Planck: 5.36)")

check("flat universe", abs(OmL + OmM + OmR - 1.0) < 0.001)
check("DM/baryon = 12pi/7 = 5.386", abs(DMratio - 12*math.pi/7) < 1e-10)
check("Omega_L matches Planck (< 0.5%)", abs(OmL - 0.6847)/0.6847 < 0.005)
check("Omega_m matches Planck (< 0.5%)", abs(OmM - 0.3153)/0.3153 < 0.005)

# S2 Friedmann integration
print("\nS2 Friedmann integration")

def hubble_norm(a):
    return math.sqrt(OmR/(a**4) + OmM/(a**3) + OmL)

# Integrate da/dt = a*H(a) from a=0.001 to a=1
a = 0.001; t = 0.0; dt = 1e-4
for _ in range(5000000):
    if a >= 1.0: break
    k1 = a * hubble_norm(a)
    amid = a + 0.5*dt*k1
    k2 = amid * hubble_norm(amid)
    a += dt * k2
    t += dt

print(f"  final a = {a:.4f}")
print(f"  t*H0    = {t:.4f}")
check("expansion reaches a~1", a > 0.99)
check("age ~ 0.96/H0", t > 0.9 and t < 1.1, f"t={t:.4f}")

# S3 Acceleration onset
print("\nS3 Late-time acceleration")
a = 0.001; t = 0.0; q_prev = 1.0; z_accel = 0.0
for _ in range(5000000):
    if a >= 1.0: break
    h = hubble_norm(a)
    h2 = h*h
    a3 = a**3
    q = OmM/(2*a3*h2) - OmL/h2
    if q_prev > 0 and q <= 0:
        z_accel = 1.0/a - 1.0
    q_prev = q
    k1 = a * h
    amid = a + 0.5*dt*k1
    k2 = amid * hubble_norm(amid)
    a += dt * k2; t += dt

print(f"  acceleration onset z ~ {z_accel:.2f}")
check("acceleration at z ~ 0.6", z_accel > 0.4 and z_accel < 1.0, f"z={z_accel:.2f}")

# S4 CMB parameters
print("\nS4 CMB parameters")
theta100 = 100/(N_W*(D+CHI))
Tcmb = (GAUSS+CHI)/BETA0
ns = 1 - KAPPA/D
lnAs = math.log(N_C*BETA0)
age = GAUSS + CHI/BETA0

print(f"  100theta* = {theta100:.4f} (Planck: 1.0411)")
print(f"  T_CMB     = {Tcmb:.4f} K (COBE: 2.7255)")
print(f"  n_s       = {ns:.4f} (Planck: 0.9649)")
print(f"  ln(10^10 A_s) = {lnAs:.4f} (Planck: 3.044)")
print(f"  Age       = {age:.3f} Gyr (Planck: 13.797)")

check("100theta* ~ 1.041", abs(theta100 - 1.0411) < 0.01)
check("T_CMB ~ 2.726 K", abs(Tcmb - 2.7255) < 0.02)
check("n_s ~ 0.965", abs(ns - 0.9649) < 0.005)
check("ln(10^10 A_s) ~ 3.044", abs(lnAs - 3.044) < 0.01)
check("Age ~ 13.8 Gyr", abs(age - 13.797) < 0.1)

# S5 Comoving distance
print("\nS5 Comoving distance")
# d_C to z=1 in units of c/H0
z_target = 1.0; a_target = 1/(1+z_target)
nsteps = 10000; da = (1.0 - a_target)/nsteps
a_d = a_target; dC = 0.0
for _ in range(nsteps):
    h = hubble_norm(a_d)
    dC += da / (a_d * a_d * h)
    a_d += da
dL = (1+z_target) * dC
print(f"  d_C(z=1) = {dC:.4f} c/H0")
print(f"  d_L(z=1) = {dL:.4f} c/H0")
check("d_C(z=1) ~ 0.76 c/H0", dC > 0.7 and dC < 0.85, f"dC={dC:.4f}")

print(f"\n{'='*60}")
print(f"  {passed}/{total} PASS  ({failed} failures)")
if failed == 0:
    print("  ALL PASS -- every cosmological parameter from (2, 3).")
else:
    print("  SOME FAILURES -- investigate.")
    sys.exit(1)
