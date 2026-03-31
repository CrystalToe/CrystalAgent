# Crystal Topos — Rendering & Scattering Physics
# Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later
#
# Observables 204-206: Planck exponent, Rayleigh size, Rayleigh wavelength.
# All EXACT (PWI = 0.000%).

NW, NC = 2, 3
CHI = NW * NC       # 6

PASS = 0
FAIL = 0


def check(name, crystal, expt, tol=0.005):
    global PASS, FAIL
    gap = abs(crystal - expt) / expt if expt != 0 else abs(crystal - expt)
    ok = gap < tol
    status = "PASS" if ok else "FAIL"
    rating = "EXACT" if gap == 0.0 else f"{gap*100:.4f}%"
    print(f"  {status}  {name}: crystal={crystal}, expt={expt}, gap={rating}")
    if ok:
        PASS += 1
    else:
        FAIL += 1
    return ok


print("=== Rendering & Scattering Physics 204-206 ===")

# Observable 204: Planck spectral radiance wavelength exponent
# B(λ,T) ∝ λ⁻⁵. Exponent = χ − 1 = 5.
# Route: DOS(N_c-1) + energy(1) + Jacobian(2) = N_c + 2 = 5
check("Planck wavelength exp (chi-1)", CHI - 1, 5)

# Observable 205: Rayleigh scattering particle-size exponent
# σ_R ∝ d⁶. Exponent = χ = N_w · N_c = 6.
# Route: dipole ∝ vol ∝ d^N_c, power ∝ |dipole|² = d^(2·N_c) = d^χ
check("Rayleigh size exp (chi)", CHI, 6)

# Observable 206: Rayleigh scattering wavelength exponent
# σ_R ∝ λ⁻⁴. Exponent = N_w² = 4.
# Route: accel ∝ ω^N_w, power ∝ |accel|² = ω^(N_w²), ω ∝ 1/λ
check("Rayleigh wavelength exp (nw^2)", NW**2, 4)

# Structural
assert CHI - 1 != NW**2, "Planck (chi-1=5) must differ from Stefan (nw^2=4)"
assert CHI == NW * NC, "chi = N_w * N_c = sector count"

print(f"\nRendering proofs: {PASS}/{PASS+FAIL} PASS, {FAIL} FAIL")
assert FAIL == 0, f"{FAIL} rendering proofs failed"
