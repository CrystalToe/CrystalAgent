# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""60 — Full Life Simulation: From Quarks to DNA in 60 Lines"""
from crystal_topos import (
    QuantumState, n_w, n_c, chi, beta0, gauss, d_total,
    sigma_d, crystal_max_entropy, crystal_energies
)
import math

print("╔═══════════════════════════════════════════════════════╗")
print("║  FROM QUARKS TO DNA: The Full (2,3) Chain            ║")
print("╚═══════════════════════════════════════════════════════╝")

print(f"\n  LAYER 1: QUANTUM MECHANICS")
print(f"    Hilbert space: ℂ^{chi()}")
psi = QuantumState.max_entangled()
print(f"    Entanglement entropy: {psi.entanglement_entropy():.4f} = ln({chi()})")
print(f"    Arrow of time: {crystal_max_entropy():.4f} nats/step")

print(f"\n  LAYER 2: PARTICLES")
print(f"    Quarks: confined by Casimir C_F = {(n_c()**2-1)/(2*n_c()):.4f} = 4/3")
print(f"    β₀ = {beta0()} > 0 → asymptotic freedom")
print(f"    Proton mass: v/256 × 53/54")

print(f"\n  LAYER 3: THERMODYNAMICS")
print(f"    Carnot: η = (χ-1)/χ = {(chi()-1)/chi():.4f} = 5/6")
print(f"    Stefan-Boltzmann: 120 = {n_w()}×{n_c()}×{gauss()+beta0()}")
print(f"    Heat flows at k = {chi()*chi()*(chi()-1)//sigma_d()}")

print(f"\n  LAYER 4: FLUID DYNAMICS")
print(f"    Kolmogorov: E(k) ∝ k^(-5/3)")
print(f"    Re_c = D(D+gauss) = {d_total()*(d_total()+gauss())}")
print(f"    Turbulence = non-commutativity of End(A_F)")

print(f"\n  LAYER 5: CHEMISTRY → BIOLOGY")
print(f"    DNA bases:     N_w² = {n_w()**2}")
print(f"    Codons:        (N_w²)^N_c = {(n_w()**2)**n_c()}")
print(f"    Amino acids:   gauss + β₀ = {gauss()+beta0()}")
print(f"    Signals:       N_c × β₀ = {n_c()*beta0()}")
print(f"    Chirality:     N_w ≠ N_c → left-handed life")
print(f"    Complexity:    D = {d_total()} ≥ 42 → self-replication possible")

print(f"\n  LAYER 6: CONSCIOUSNESS")
print(f"    Φ (integrated information) > 0 because χ = {chi()} > 1")
print(f"    Entanglement = irreversibility = awareness of time")

print(f"\n  ╔═══════════════════════════════════════════════╗")
print(f"  ║  Every layer from N_w = {n_w()} and N_c = {n_c()}.         ║")
print(f"  ║  Nothing else.                                ║")
print(f"  ║  The probability of life = the probability    ║")
print(f"  ║  that D ≥ 42. In this universe, D = {d_total()}.       ║")
print(f"  ║  Life is not an accident. It's a theorem.     ║")
print(f"  ╚═══════════════════════════════════════════════╝")
