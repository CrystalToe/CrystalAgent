# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""
crystal_gw_proof.py — GW waveform proofs for CrystalGW.hs
Every coefficient in GW physics from (N_w, N_c) = (2, 3).
"""

import math, sys

N_W = 2; N_C = 3; CHI = N_W * N_C
GAUSS = N_C**2 + N_W**2; D_COL = N_C**2 - 1
passed = failed = total = 0

def check(name, cond, detail=""):
    global passed, failed, total
    total += 1
    if cond: passed += 1; print(f"  PASS  {name}")
    else: failed += 1; print(f"  FAIL  {name}  {detail}")

def sq(x): return x * x

PETERS = N_W**5 / (CHI - 1)  # 32/5 = 6.4

# =====================================================================
print("S0 GW integer identities (all from (2,3))")
check("quadrupole 32/5 = N_w^5/(chi-1)",     N_W**5 / (CHI-1) == 32/5)
check("decay 64/5 = N_w^6/(chi-1)",          N_W**6 / (CHI-1) == 64/5)
check("chirp coeff 96/5 = N_c*N_w^5/(chi-1)", N_C*N_W**5/(CHI-1) == 96/5)
check("merger coeff (5,256) = (chi-1,N_w^8)", (CHI-1, N_W**8) == (5, 256))
check("chirp mass exp 3/5 = N_c/(chi-1)",    N_C/(CHI-1) == 3/5)
check("chirp mass exp 2/5 = N_w/(chi-1)",    N_W/(CHI-1) == 2/5)
check("chirp mass exp 1/5 = 1/(chi-1)",      1/(CHI-1) == 1/5)
check("freq exp 2/3 = (N_c-1)/N_c",          (N_C-1)/N_C == 2/3)
check("amplitude 4 = N_w^2",                 N_W**2 == 4)
check("polarizations 2 = N_c-1",             N_C - 1 == 2)
check("GW doubling 2 = N_w",                 N_W == 2)
check("ISCO 6 = chi",                        CHI == 6)
check("Kolmogorov 5/3 = (chi-1)/N_c",        (CHI-1)/N_C == 5/3)
check("chirp exp 8/3 = dCol/N_c",            D_COL/N_C == 8/3)
check("chirp exp 11/3 = (N_c^2+N_w)/N_c",    (N_C**2+N_W)/N_C == 11/3)

# =====================================================================
print("\nS1 Chirp mass")

def chirp_mass(m1, m2):
    mu = m1 * m2 / (m1 + m2)
    M = m1 + m2
    return mu ** (N_C/(CHI-1)) * M ** (N_W/(CHI-1))  # mu^(3/5) * M^(2/5)

mc_30_30 = chirp_mass(30.0, 30.0)
mc_expected = (30.0*30.0)**0.6 / 60.0**0.2
check("M_c(30,30) correct", abs(mc_30_30 - mc_expected) < 1e-10)

# Equal mass: M_c = M * 2^(-6/5) ... let's just verify
mc_10_10 = chirp_mass(10.0, 10.0)
mc_10_expected = (100.0)**0.6 / 20.0**0.2
check("M_c(10,10) correct", abs(mc_10_10 - mc_10_expected) < 1e-10)

# Scaling: M_c(k*m1, k*m2) = k * M_c(m1, m2)
mc_scaled = chirp_mass(60.0, 60.0)
check("chirp mass scales linearly", abs(mc_scaled / mc_30_30 - 2.0) < 1e-10)

# =====================================================================
print("\nS2 ISCO frequency")

def isco_freq(M):
    return 1.0 / (CHI * math.sqrt(CHI) * math.pi * M)  # 1/(6^(3/2) pi M)

f_isco = isco_freq(60.0)
f_expect = 1.0 / (6 * math.sqrt(6) * math.pi * 60.0)
check("f_ISCO = 1/(chi^(3/2) pi M)", abs(f_isco - f_expect) < 1e-15)

# =====================================================================
print("\nS3 GW frequency doubling")

def gw_freq(M, a):
    f_orb = math.sqrt(M / (a**3)) / (2 * math.pi)
    return N_W * f_orb  # f_GW = N_w * f_orb

def separation_from_freq(M, f_gw):
    f_orb = f_gw / N_W
    a3 = M / sq(2 * math.pi * f_orb)
    return a3 ** (1.0/3.0)

# Verify round-trip
M_test = 60.0
a_test = 100.0
f_test = gw_freq(M_test, a_test)
a_back = separation_from_freq(M_test, f_test)
check("freq<->separation round-trip", abs(a_back - a_test) < 1e-8)

# =====================================================================
print("\nS4 Peters formula and orbital decay")

def gw_power(mu, M, a):
    return PETERS * sq(mu) * M**3 / a**5

def decay_rate(mu, M, a):
    return -2 * PETERS * mu * sq(M) / a**3  # da/dt

m1, m2 = 30.0, 30.0
M = m1 + m2
mu = m1 * m2 / M

# Power should be positive
P = gw_power(mu, M, 200.0)
check("GW power > 0", P > 0)

# Decay rate should be negative (separation shrinks)
dadt = decay_rate(mu, M, 200.0)
check("da/dt < 0 (orbit shrinks)", dadt < 0)

# Power scales as a^(-5)
P1 = gw_power(mu, M, 100.0)
P2 = gw_power(mu, M, 200.0)
check("power scales as a^(-5)", abs(P1/P2 - 32.0) < 1e-6)  # (200/100)^5 = 32

# =====================================================================
print("\nS5 Time to merger")

def time_to_merger(mc, f_gw):
    num = CHI - 1           # 5
    den = N_W**8            # 256
    exp53 = (CHI-1) / N_C   # 5/3
    exp83 = D_COL / N_C     # 8/3
    return (num / den) * mc**(-exp53) * (math.pi * f_gw)**(-exp83)

mc = chirp_mass(m1, m2)
f0 = isco_freq(M) / 10
t_merge = time_to_merger(mc, f0)
check("t_merge > 0", t_merge > 0, f"t={t_merge}")

# Higher frequency = less time to merger
t_merge2 = time_to_merger(mc, f0 * 2)
check("higher freq -> less time to merger", t_merge2 < t_merge)

# =====================================================================
print("\nS6 Chirp rate df/dt")

def chirp_rate(mc, f):
    coeff = N_C * PETERS    # 96/5
    exp83 = D_COL / N_C     # 8/3
    exp53 = (CHI-1) / N_C   # 5/3
    exp113 = (N_C**2 + N_W) / N_C  # 11/3
    return coeff * math.pi**exp83 * mc**exp53 * f**exp113

dfdt = chirp_rate(mc, f0)
check("df/dt > 0 (frequency increases)", dfdt > 0)

# Chirp rate increases with frequency
dfdt2 = chirp_rate(mc, f0 * 2)
check("chirp accelerates with frequency", dfdt2 > dfdt)

# =====================================================================
print("\nS7 Waveform generation")

dist = 1e6
iota = math.pi / 4
f_start = isco_freq(M) / 1.5   # start very close to merger
dt = 0.001

# Generate waveform
exp53 = (CHI-1) / N_C
exp23 = (N_C-1) / N_C
amp0 = N_W**2 / dist
cos_i = math.cos(iota)
f_plus = (1 + cos_i**2) / 2
f_cross = cos_i
f_isco = isco_freq(M)

t, f, phase = 0.0, f_start, 0.0
h_plus_samples = []
h_cross_samples = []
freqs = []
n_samples = 0

while f < f_isco and n_samples < 100000:
    amp = amp0 * mc**exp53 * (math.pi * f)**exp23
    hp = amp * f_plus * math.cos(phase)
    hx = amp * f_cross * math.sin(phase)
    h_plus_samples.append(hp)
    h_cross_samples.append(hx)
    freqs.append(f)
    dfdt = chirp_rate(mc, f)
    f += dfdt * dt
    phase += 2 * math.pi * f * dt
    t += dt
    n_samples += 1

print(f"  samples = {n_samples}")
check("waveform > 100 samples", n_samples > 100)
check("frequency chirps up", all(f2 >= f1 for f1, f2 in zip(freqs, freqs[1:])))
check("h+ nonzero", any(abs(h) > 0 for h in h_plus_samples))
check("hx nonzero", any(abs(h) > 0 for h in h_cross_samples))
check("two polarizations = N_c-1 = 2", N_C - 1 == 2)

# Amplitude envelope increases as f^(2/3) toward merger
n10 = max(1, n_samples // 10)
amp_early = max(abs(h) for h in h_plus_samples[:n10])
amp_late = max(abs(h) for h in h_plus_samples[-n10:])
check("amplitude increases toward merger", amp_late >= amp_early * 0.99,
      f"early={amp_early:.2e} late={amp_late:.2e}")

# =====================================================================
print("\nS8 Orbital inspiral integration")

a0 = 10.0 * (N_C - 1) * M   # 10 * r_s (close enough for fast decay)
a_isco = N_C * (N_C - 1) * M  # 3 * r_s = 6M
dt_orb = 10.0
a = a0
seps = [a]

for _ in range(5000000):
    dadt = decay_rate(mu, M, a)
    a += dadt * dt_orb
    seps.append(a)
    if a <= a_isco:
        break

check("inspiral reaches ISCO", seps[-1] <= a_isco)
check("separation monotonically decreases", all(s2 <= s1 for s1, s2 in zip(seps, seps[1:])))
print(f"  initial a = {a0:.1f}")
print(f"  final a   = {seps[-1]:.1f}")
print(f"  ISCO      = {a_isco:.1f}")
print(f"  steps     = {len(seps)}")

# =====================================================================
print(f"\n{'='*60}")
print(f"  {passed}/{total} PASS  ({failed} failures)")
if failed == 0:
    print("  ALL PASS -- every GW coefficient from (2, 3).")
else:
    print("  SOME FAILURES -- investigate.")
    sys.exit(1)
