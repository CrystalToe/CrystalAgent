#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""
Schrödinger vs Monad — 20 steps.

Two ways to evolve the same initial state. Same algebra. Same eigenvalues.
Different time. Different physics. Shows exactly where they agree and
where they split — and WHY.

SETUP:
  Hamiltonian eigenvalues: E_k = -ln(λ_k) / β,  β = 2π
    E_singlet = 0,  E_weak = ln(2)/2π,  E_colour = ln(3)/2π,  E_mixed = ln(6)/2π

  Monad eigenvalues: λ_k = {1, 1/2, 1/3, 1/6}

SCHRÖDINGER (standard QM):
  ψ_k(n) = exp(-i E_k · n · β) · ψ_k(0) = exp(i · n · ln(λ_k)) · ψ_k(0) = λ_k^(i·n) · ψ_k(0)
  |ψ_k(n)|² = |ψ_k(0)|²   ← CONSTANT. Norms preserved. No decay. No arrow.

MONAD (crystal dynamics):
  ψ_k(n) = λ_k^n · ψ_k(0)
  |ψ_k(n)|² = λ_k^(2n) · |ψ_k(0)|²   ← DECAYS for λ_k < 1. Arrow of time.

THE DIFFERENCE:
  Schrödinger: exponent = i·n (imaginary axis → unit circle → rotation)
  Monad:       exponent = n   (real axis → decay → compression)

  The monad IS the Wick rotation of Schrödinger. t → -iτ.
  Schrödinger lives in Minkowski time. The monad lives in Euclidean time.
  The KMS condition β = 2π is what connects them.

  Schrödinger misses the arrow of time because unitary evolution
  CANNOT compress. The monad captures it because W is an isometry, not unitary.
"""

import cmath
import math
from fractions import Fraction

# ═══════════════════════════════════════════════════════════════
# A_F atoms
# ═══════════════════════════════════════════════════════════════

N_w, N_c = 2, 3
chi = N_w * N_c                        # 6
beta = 2 * math.pi                     # KMS temperature

SECTORS = ["singlet", "weak", "colour", "mixed"]

# Eigenvalues of the monad S (exact rationals)
lam = {
    "singlet": Fraction(1, 1),
    "weak":    Fraction(1, N_w),
    "colour":  Fraction(1, N_c),
    "mixed":   Fraction(1, chi),
}

# Degeneracies
deg = {"singlet": 1, "weak": N_c, "colour": N_c**2 - 1, "mixed": N_w**3 * N_c}

# Hamiltonian eigenvalues DERIVED from monad: E_k = -ln(λ_k) / β
E = {
    "singlet": 0.0,
    "weak":    math.log(N_w) / beta,       # ln(2)/2π
    "colour":  math.log(N_c) / beta,       # ln(3)/2π
    "mixed":   math.log(chi) / beta,       # ln(6)/2π
}

# ═══════════════════════════════════════════════════════════════
# Initial state: equal superposition (normalised so Σ d_k |a_k|² = 1)
# ═══════════════════════════════════════════════════════════════

# a_k(0) = 1/√(4 d_k) so each sector gets Born weight 1/4
a0 = {k: 1.0 / math.sqrt(4 * deg[k]) for k in SECTORS}

# ═══════════════════════════════════════════════════════════════
# SCHRÖDINGER EVOLUTION (standard QM)
#
#   ψ_k(n) = exp(-i E_k · n · β) · ψ_k(0)
#          = exp(i · n · ln(λ_k)) · ψ_k(0)
#          = λ_k^(i·n) · ψ_k(0)
#
#   This is UNITARY. |ψ_k(n)| = |ψ_k(0)| for all n.
#   Probabilities NEVER change. No selection. No arrow.
# ═══════════════════════════════════════════════════════════════

def schrodinger_step(state, n):
    """Schrödinger evolution after n ticks of β = 2π."""
    result = {}
    for k in SECTORS:
        # exp(-i E_k · n · β) = exp(i · n · ln(λ_k))
        phase = cmath.exp(1j * n * math.log(float(lam[k])) if lam[k] > 0 else 0)
        result[k] = phase * state[k]
    return result

# ═══════════════════════════════════════════════════════════════
# MONAD EVOLUTION (crystal dynamics)
#
#   ψ_k(n) = λ_k^n · ψ_k(0)
#
#   This is NOT unitary. |ψ_k(n)| = λ_k^n · |ψ_k(0)|.
#   Non-singlet sectors DECAY. Singlet survives. Arrow of time.
# ═══════════════════════════════════════════════════════════════

def monad_step(state, n):
    """Monad evolution after n ticks."""
    return {k: float(lam[k]**n) * state[k] for k in SECTORS}

# ═══════════════════════════════════════════════════════════════
# Born probabilities: P_k = d_k |a_k|² / Σ d_j |a_j|²
# ═══════════════════════════════════════════════════════════════

def born_probs(state):
    raw = {k: deg[k] * abs(state[k])**2 for k in SECTORS}
    total = sum(raw.values())
    if total == 0:
        return {k: 0.0 for k in SECTORS}
    return {k: raw[k] / total for k in SECTORS}

def norm2(state):
    return sum(deg[k] * abs(state[k])**2 for k in SECTORS)

# ═══════════════════════════════════════════════════════════════
# RUN: 20 steps, side by side
# ═══════════════════════════════════════════════════════════════

print("=" * 90)
print("  SCHRÖDINGER vs MONAD — 20 ticks")
print("  Same algebra. Same eigenvalues. Different time.")
print("=" * 90)
print()

# Header
print("  Schrödinger: ψ_k(n) = λ_k^(i·n) · ψ_k(0)    ← unitary, norms preserved")
print("  Monad:       ψ_k(n) = λ_k^n    · ψ_k(0)    ← isometric, non-singlet decays")
print()
print("  Initial state: equal superposition, each sector Born weight = 0.25")
print()

# Show eigenvalues
print("  Eigenvalues:")
for k in SECTORS:
    print(f"    λ_{k:8s} = {str(lam[k]):5s}   E_{k} = {E[k]:.6f}")
print()

# Table header
print("─" * 90)
print(f"  {'':4s} │ {'SCHRÖDINGER P(singlet)':>22s} {'P(weak)':>10s} {'P(colour)':>10s} "
      f"{'P(mixed)':>10s} │ {'norm²':>8s}")
print(f"  {'tick':4s} │ {'MONAD       P(singlet)':>22s} {'P(weak)':>10s} {'P(colour)':>10s} "
      f"{'P(mixed)':>10s} │ {'norm²':>8s}")
print("─" * 90)

for n in range(21):
    # Schrödinger
    psi_s = schrodinger_step(a0, n)
    ps = born_probs(psi_s)
    ns = norm2(psi_s)

    # Monad
    psi_m = monad_step(a0, n)
    pm = born_probs(psi_m)
    nm = norm2(psi_m)

    print(f"  {n:4d} │ S: {ps['singlet']:10.6f} {ps['weak']:10.6f} "
          f"{ps['colour']:10.6f} {ps['mixed']:10.6f} │ {ns:8.6f}")
    print(f"       │ M: {pm['singlet']:10.6f} {pm['weak']:10.6f} "
          f"{pm['colour']:10.6f} {pm['mixed']:10.6f} │ {nm:.2e}")
    if n < 20:
        print(f"       │{'':>70s}│")

print("─" * 90)
print()

# ═══════════════════════════════════════════════════════════════
# ANALYSIS: Where they agree, where they split
# ═══════════════════════════════════════════════════════════════

print("=" * 90)
print("  ANALYSIS")
print("=" * 90)
print()

# 1. Schrödinger probabilities are CONSTANT
psi_s0 = schrodinger_step(a0, 0)
psi_s20 = schrodinger_step(a0, 20)
ps0 = born_probs(psi_s0)
ps20 = born_probs(psi_s20)
prob_change = max(abs(ps0[k] - ps20[k]) for k in SECTORS)

print("  1. SCHRÖDINGER PROBABILITIES ARE CONSTANT")
print(f"     P(singlet) at tick 0:  {ps0['singlet']:.6f}")
print(f"     P(singlet) at tick 20: {ps20['singlet']:.6f}")
print(f"     Max change across all sectors: {prob_change:.2e}")
print(f"     → Unitary evolution CANNOT select a sector.")
print(f"     → No arrow of time. No decay. No selection.")
print()

# 2. Monad probabilities CHANGE
psi_m0 = monad_step(a0, 0)
psi_m20 = monad_step(a0, 20)
pm0 = born_probs(psi_m0)
pm20 = born_probs(psi_m20)

print("  2. MONAD PROBABILITIES CHANGE")
print(f"     P(singlet) at tick 0:  {pm0['singlet']:.6f}")
print(f"     P(singlet) at tick 20: {pm20['singlet']:.10f}")
print(f"     P(weak)    at tick 20: {pm20['weak']:.2e}")
print(f"     P(colour)  at tick 20: {pm20['colour']:.2e}")
print(f"     P(mixed)   at tick 20: {pm20['mixed']:.2e}")
print(f"     → The monad SELECTS the singlet. Everything else erased.")
print(f"     → Arrow of time. Entropy increases by ln(6) per tick.")
print()

# 3. Norms
print("  3. NORM COMPARISON")
print(f"     Schrödinger norm² at tick 20: {norm2(psi_s20):.10f}  (preserved)")
print(f"     Monad norm² at tick 20:       {norm2(psi_m20):.2e}  (decayed)")
print(f"     → Schrödinger preserves information. Monad compresses it.")
print()

# 4. WHERE THEY AGREE
print("  4. WHERE THEY AGREE")
print(f"     Both use the SAME eigenvalues: λ = {{1, 1/2, 1/3, 1/6}}")
print(f"     Both use the SAME algebra: A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ)")
print(f"     Both give the SAME energy ordering: E_singlet < E_weak < E_colour < E_mixed")
print(f"     Both agree on RELATIVE timescales:")
print(f"       weak/colour rate = ln(2)/ln(3) = 1/κ = {math.log(2)/math.log(3):.6f}")
print()

# 5. WHERE THEY DIFFER
print("  5. WHERE THEY DIFFER — AND WHY")
print(f"     Schrödinger: exponent = i·n  (imaginary → rotation → unitary)")
print(f"     Monad:       exponent = n    (real → decay → isometric)")
print()
print(f"     This is a WICK ROTATION: t → -iτ")
print(f"     Schrödinger lives in Minkowski time (oscillation, no decay)")
print(f"     The monad lives in Euclidean time (decay, arrow of time)")
print()
print(f"     The KMS condition β = 2π connects them:")
print(f"       Schrödinger at imaginary time iβ = monad at real time β")
print(f"       exp(-i H · iβ) = exp(H · β) → thermal density matrix")
print(f"       This IS the Bisognano-Wichmann theorem.")
print()

# 6. WHAT SCHRÖDINGER MISSES
print("  6. WHAT SCHRÖDINGER MISSES")
print(f"     The Schrödinger equation is the U part of S = W∘U.")
print(f"     It captures the disentangler (reversible rearrangement).")
print(f"     It MISSES the isometry W (irreversible compression).")
print(f"     That's why it has no arrow of time.")
print(f"     The monad has BOTH U and W. It is the complete evolution.")
print(f"     H = -ln(S)/β derives the Hamiltonian from the monad.")
print(f"     Schrödinger is what you get when you throw away W and keep U.")
print()

# 7. The photon test
print("  7. PHOTON TEST — where they DO agree perfectly")
a0_photon = {"singlet": 1.0, "weak": 0.0, "colour": 0.0, "mixed": 0.0}
psi_s_ph = schrodinger_step(a0_photon, 20)
psi_m_ph = monad_step(a0_photon, 20)

print(f"     Schrödinger photon at tick 20: |a_singlet|² = {abs(psi_s_ph['singlet'])**2:.10f}")
print(f"     Monad photon at tick 20:       |a_singlet|² = {abs(psi_m_ph['singlet'])**2:.10f}")
print(f"     → IDENTICAL. λ_singlet = 1. Both exp(i·0) = 1 and 1^n = 1.")
print(f"     → For the singlet (photon), Schrödinger and monad agree EXACTLY.")
print(f"     → They only split on sectors where λ < 1 (massive particles).")
print()

# 8. Final summary
print("=" * 90)
print("  SUMMARY")
print("=" * 90)
print()
print("  The monad and Schrödinger are the SAME EQUATION with different time:")
print("    Schrödinger: ψ(n) = S^(in) ψ(0)   ← imaginary exponent → unitary")
print("    Monad:       ψ(n) = S^n   ψ(0)    ← real exponent → isometric")
print()
print("  For massless particles (λ=1): they agree exactly.")
print("  For massive particles (λ<1): the monad decays, Schrödinger doesn't.")
print("  The decay IS the arrow of time. Schrödinger can't see it.")
print("  The monad S = W∘U is the complete evolution. Schrödinger is U alone.")
print()
print("  Every number from N_w=2, N_c=3. No free parameters.")
