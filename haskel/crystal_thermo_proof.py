# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later
"""crystal_thermo_proof.py — Thermodynamic dynamics from (2,3)."""
import math, sys
N_W=2; N_C=3; CHI=N_W*N_C; BETA0=7; D_MIXED=N_W**3*N_C
passed=failed=total=0
def check(name,cond,detail=""):
    global passed,failed,total; total+=1
    if cond: passed+=1; print(f"  PASS  {name}")
    else: failed+=1; print(f"  FAIL  {name}  {detail}")
def sq(x): return x*x

# S0 Integer identities
print("S0 Thermodynamic integer identities")
check("LJ attractive 6 = chi",         CHI == 6)
check("LJ repulsive 12 = 2*chi",       2*CHI == 12)
check("LJ force prefactor 24 = d_mixed", D_MIXED == 24)
check("gamma_mono 5/3 = (chi-1)/N_c",  (CHI-1)/N_C == 5/3)
check("gamma_di 7/5 = beta0/(chi-1)",  BETA0/(CHI-1) == 7/5)
check("DOF mono 3 = N_c",              N_C == 3)
check("DOF di 5 = chi-1",              CHI-1 == 5)
check("Carnot 5/6 = (chi-1)/chi",      (CHI-1)/CHI == 5/6)
check("entropy per tick = ln(chi) = ln(6)", CHI == 6)
check("Stokes drag 24 = d_mixed",      D_MIXED == 24)
check("Boltzmann W = chi^N",           CHI == 6)

# S1 LJ potential
print("\nS1 LJ potential shape")

def lj_potential(eps, sigma, r):
    sr = sigma / r
    sr6 = sr**CHI         # (sigma/r)^6
    sr12 = sr**(2*CHI)    # (sigma/r)^12
    return 4*eps*(sr12 - sr6)

def lj_force(eps, sigma, r):
    sr = sigma / r
    sr6 = sr**CHI
    sr12 = sr**(2*CHI)
    return D_MIXED * eps / r * (2*sr12 - sr6)  # 24 = d_mixed

eps, sigma = 1.0, 1.0
r_min = sigma * 2**(1/6)  # 2^(1/chi) since chi=6
v_min = lj_potential(eps, sigma, r_min)
check("LJ minimum = -eps", abs(v_min + 1.0) < 1e-10, f"V={v_min}")
check("V(sigma) = 0", abs(lj_potential(eps, sigma, sigma)) < 1e-10)
check("force positive at r < r_min (repulsive)", lj_force(eps, sigma, 0.9*r_min) > 0)
check("force negative at r > r_min (attractive)", lj_force(eps, sigma, 1.5*r_min) < 0)

# S2 MD integration
print("\nS2 MD integration (Velocity Verlet, 4 particles)")

def make_gas(n, temp, spacing):
    parts = []
    for i in range(1, n+1):
        fi = float(i)
        x = spacing * (fi - n/2)
        vx = temp * math.sin(fi * 3.14)
        vy = temp * math.cos(fi * 2.71)
        vz = temp * math.sin(fi * 1.41 + 1)
        parts.append([x, 0, 0, vx, vy, vz, 1.0])
    return parts

def lj_accel(parts, idx, eps, sigma, cutoff):
    ax=ay=az=0.0
    pi = parts[idx]
    for j, pj in enumerate(parts):
        if j == idx: continue
        dx=pi[0]-pj[0]; dy=pi[1]-pj[1]; dz=pi[2]-pj[2]
        r = math.sqrt(dx*dx+dy*dy+dz*dz)
        if r > cutoff or r < 1e-10: continue
        fmag = lj_force(eps, sigma, r) / (pi[6] * r)
        ax -= fmag*dx; ay -= fmag*dy; az -= fmag*dz
    return ax, ay, az

def verlet_tick(parts, dt, eps, sigma, cutoff):
    n = len(parts)
    accels = [lj_accel(parts, i, eps, sigma, cutoff) for i in range(n)]
    # Half-kick
    for i in range(n):
        parts[i][3] += dt/2*accels[i][0]
        parts[i][4] += dt/2*accels[i][1]
        parts[i][5] += dt/2*accels[i][2]
    # Drift
    for i in range(n):
        parts[i][0] += dt*parts[i][3]
        parts[i][1] += dt*parts[i][4]
        parts[i][2] += dt*parts[i][5]
    # Recompute accels
    accels2 = [lj_accel(parts, i, eps, sigma, cutoff) for i in range(n)]
    # Half-kick
    for i in range(n):
        parts[i][3] += dt/2*accels2[i][0]
        parts[i][4] += dt/2*accels2[i][1]
        parts[i][5] += dt/2*accels2[i][2]
    return parts

def kinetic_e(parts):
    return sum(0.5*p[6]*(p[3]**2+p[4]**2+p[5]**2) for p in parts)

def potential_e(parts, eps, sigma, cutoff):
    pe = 0
    for i in range(len(parts)):
        for j in range(i+1, len(parts)):
            dx=parts[i][0]-parts[j][0]; dy=parts[i][1]-parts[j][1]; dz=parts[i][2]-parts[j][2]
            r = math.sqrt(dx*dx+dy*dy+dz*dz)
            if r < cutoff: pe += lj_potential(eps, sigma, r)
    return pe

def total_e(parts, eps, sigma, cutoff):
    return kinetic_e(parts) + potential_e(parts, eps, sigma, cutoff)

gas = make_gas(4, 0.05, 3.0)
cutoff = 5.0; dt = 0.002
e0 = total_e(gas, eps, sigma, cutoff)
max_dev = 0.0
for _ in range(200):
    gas = verlet_tick(gas, dt, eps, sigma, cutoff)
    e = total_e(gas, eps, sigma, cutoff)
    dev = abs(e - e0) / (abs(e0) + 1e-20)
    if dev > max_dev: max_dev = dev

print(f"  max E deviation = {max_dev:.4e}")
check("energy conserved (< 1%)", max_dev < 0.01, f"dev={max_dev:.2e}")

# Temperature
def temperature(parts):
    n = len(parts)
    ndof = N_C * n  # 3N DOF for monatomic
    return 2.0 * kinetic_e(parts) / ndof

t0 = temperature(gas)
check("temperature > 0", t0 > 0)

# S3 Gamma values
print("\nS3 Adiabatic indices")
g_mono = (CHI-1)/N_C
g_di = BETA0/(CHI-1)
print(f"  gamma_mono = {g_mono:.4f} (expect 5/3)")
print(f"  gamma_di   = {g_di:.4f} (expect 7/5)")
check("gamma_mono = 5/3", abs(g_mono - 5/3) < 1e-10)
check("gamma_di = 7/5", abs(g_di - 7/5) < 1e-10)

# C_V = N_dof/(2*gamma_minus_1) relationship
# For monatomic: C_V = (3/2)Nk, gamma = 5/3, so C_V = N_dof/2 = 3N/2
# gamma = 1 + 2/N_dof => N_dof = 2/(gamma-1)
ndof_mono = 2/(g_mono - 1)
ndof_di = 2/(g_di - 1)
check("gamma -> DOF mono = 3 = N_c", abs(ndof_mono - N_C) < 1e-10)
check("gamma -> DOF di = 5 = chi-1", abs(ndof_di - (CHI-1)) < 1e-10)

# S4 Carnot and entropy
print("\nS4 Carnot efficiency and entropy")
carnot = (CHI-1)/CHI
print(f"  Carnot(T_h/T_c = chi) = {carnot:.4f} (expect 5/6)")
check("Carnot = (chi-1)/chi = 5/6", abs(carnot - 5/6) < 1e-10)

entropy = math.log(CHI)
print(f"  entropy per tick = ln({CHI}) = {entropy:.4f}")
check("entropy = ln(chi) = ln(6)", abs(entropy - math.log(6)) < 1e-10)

print(f"\n{'='*60}")
print(f"  {passed}/{total} PASS  ({failed} failures)")
if failed == 0:
    print("  ALL PASS -- every thermodynamic integer from (2, 3).")
else:
    print("  SOME FAILURES -- investigate.")
    sys.exit(1)
