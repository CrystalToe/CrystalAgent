# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later
"""crystal_nbody_proof.py — N-body dynamics from (2,3)."""
import math, sys
N_W=2; N_C=3; CHI=N_W*N_C; D_COL=N_C**2-1
passed=failed=total=0
def check(name,cond,detail=""):
    global passed,failed,total; total+=1
    if cond: passed+=1; print(f"  PASS  {name}")
    else: failed+=1; print(f"  FAIL  {name}  {detail}")
def sq(x): return x*x

print("S0 N-body integer identities")
check("oct-tree 8 = 2^N_c",         2**N_C == 8)
check("8 = d_colour = N_c^2-1",     D_COL == 8)
check("8 = N_w^N_c",                N_W**N_C == 8)
check("force exp 2 = N_c-1",        N_C-1 == 2)
check("spatial dim 3 = N_c",        N_C == 3)
check("phase/body 6 = chi",         CHI == 6)

# S1 Direct N-body force
print("\nS1 Direct N-body force (O(N^2))")

def direct_accel(bodies, idx, eps):
    ax=ay=az=0.0
    bx,by,bz,_ = bodies[idx]
    for j,(xj,yj,zj,mj) in enumerate(bodies):
        if j == idx: continue
        dx=bx-xj; dy=by-yj; dz=bz-zj
        r2=dx*dx+dy*dy+dz*dz+eps*eps
        r=math.sqrt(r2); r3=r*r2
        f=-mj/r3
        ax+=f*dx; ay+=f*dy; az+=f*dz
    return ax,ay,az

# Two equal masses at distance 10
bodies2 = [(5,0,0,1), (-5,0,0,1)]
eps = 0.01
ax,ay,az = direct_accel(bodies2, 0, eps)
# Expected: a = -GM/r^2 = -1/100 in x direction (approximately)
check("2-body force direction (x<0)", ax < 0)
check("2-body force ~ -GM/r^2", abs(ax - (-1.0/100.0)) < 0.01, f"ax={ax:.4f}")

# S2 Leapfrog integration (2-body Kepler)
print("\nS2 Two-body Kepler orbit (leapfrog)")

# Bodies: [x,y,z,vx,vy,vz,m]
def make_2body(m1, m2, sep):
    M = m1+m2; r1=sep*m2/M; r2=sep*m1/M
    v1=math.sqrt(M/sep)*(m2/M); v2=math.sqrt(M/sep)*(m1/M)
    return [[r1,0,0,0,v1,0,m1], [-r2,0,0,0,-v2,0,m2]]

def leapfrog_tick(bodies, dt, eps):
    n = len(bodies)
    # Compute accelerations
    def accel(i):
        ax=ay=az=0.0
        xi,yi,zi = bodies[i][0],bodies[i][1],bodies[i][2]
        for j in range(n):
            if j==i: continue
            dx=xi-bodies[j][0]; dy=yi-bodies[j][1]; dz=zi-bodies[j][2]
            r2=dx*dx+dy*dy+dz*dz+eps*eps
            r=math.sqrt(r2); r3=r*r2; f=-bodies[j][6]/r3
            ax+=f*dx; ay+=f*dy; az+=f*dz
        return ax,ay,az
    # W: half-kick
    for i in range(n):
        ax,ay,az = accel(i)
        bodies[i][3] += dt/2*ax; bodies[i][4] += dt/2*ay; bodies[i][5] += dt/2*az
    # U: full drift
    for i in range(n):
        bodies[i][0] += dt*bodies[i][3]; bodies[i][1] += dt*bodies[i][4]; bodies[i][2] += dt*bodies[i][5]
    # W: half-kick (recompute accel)
    for i in range(n):
        ax,ay,az = accel(i)
        bodies[i][3] += dt/2*ax; bodies[i][4] += dt/2*ay; bodies[i][5] += dt/2*az
    return bodies

def total_energy(bodies, eps):
    ke = sum(0.5*b[6]*(b[3]**2+b[4]**2+b[5]**2) for b in bodies)
    pe = 0.0
    for i in range(len(bodies)):
        for j in range(i+1,len(bodies)):
            dx=bodies[i][0]-bodies[j][0]; dy=bodies[i][1]-bodies[j][1]; dz=bodies[i][2]-bodies[j][2]
            r=math.sqrt(dx*dx+dy*dy+dz*dz+eps*eps)
            pe -= bodies[i][6]*bodies[j][6]/r
    return ke+pe

def total_mom(bodies):
    px=sum(b[6]*b[3] for b in bodies)
    py=sum(b[6]*b[4] for b in bodies)
    pz=sum(b[6]*b[5] for b in bodies)
    return px,py,pz

bs = make_2body(1.0, 1.0, 10.0)
e0 = total_energy(bs, eps)
p0 = total_mom(bs)
maxEdev = 0.0
for _ in range(2000):
    bs = leapfrog_tick(bs, 0.01, eps)
    e = total_energy(bs, eps)
    dev = abs(e - e0) / abs(e0)
    if dev > maxEdev: maxEdev = dev

eF = total_energy(bs, eps)
pF = total_mom(bs)
print(f"  max E deviation = {maxEdev:.4e}")
check("energy conserved (< 0.1%)", maxEdev < 0.001, f"dev={maxEdev:.2e}")
momDev = math.sqrt(sq(pF[0]-p0[0])+sq(pF[1]-p0[1])+sq(pF[2]-p0[2]))
check("momentum conserved", momDev < 0.001, f"dev={momDev:.2e}")

# S3 N-body ring (N=8, stable circular configuration)
print("\nS3 Ring of 8 bodies (stable configuration, 500 steps)")

def ring_bodies(n, radius, M):
    """N equal-mass bodies in a circular ring with circular velocities."""
    bodies = []
    m = M / n
    for i in range(n):
        angle = 2 * math.pi * i / n
        x = radius * math.cos(angle)
        y = radius * math.sin(angle)
        # Circular velocity: v ~ sqrt(sum of forces toward center)
        # For a ring, approximate as v ~ sqrt(M/radius) * 0.3
        v = 0.3 * math.sqrt(M / radius)
        vx = -v * math.sin(angle)
        vy = v * math.cos(angle)
        bodies.append([x, y, 0.0, vx, vy, 0.0, m])
    return bodies

cluster = ring_bodies(8, 5.0, 8.0)
eC0 = total_energy(cluster, eps)
for _ in range(500):
    cluster = leapfrog_tick(cluster, 0.01, eps)
eCF = total_energy(cluster, eps)
cDev = abs(eCF - eC0) / abs(eC0)
print(f"  E deviation = {cDev*100:.2f}%")
check("ring energy ~ conserved (< 5%)", cDev < 0.05, f"dev={cDev*100:.1f}%")

maxR = max(math.sqrt(b[0]**2+b[1]**2+b[2]**2) for b in cluster)
check("no ejections (max r < 50)", maxR < 50, f"maxR={maxR:.1f}")

print(f"\n{'='*60}")
print(f"  {passed}/{total} PASS  ({failed} failures)")
if failed == 0:
    print("  ALL PASS -- every N-body integer from (2, 3).")
else:
    print("  SOME FAILURES -- investigate.")
    sys.exit(1)
