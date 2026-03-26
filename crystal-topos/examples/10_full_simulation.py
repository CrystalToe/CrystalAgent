"""
10 — Full Quantum Simulation
Complete multi-particle protocol: prepare, entangle, evolve, measure.
Every step from N_w=2, N_c=3. Nothing else.
"""
from crystal_topos import (
    QuantumState, chi, sigma_d, crystal_max_entropy,
    crystal_energies, n_w, n_c
)

print("╔══════════════════════════════════════════════════════╗")
print("║  CRYSTAL TOPOS — Full Quantum Simulation Protocol   ║")
print("║  A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ)  ·  N_w=2  ·  N_c=3   ║")
print("╚══════════════════════════════════════════════════════╝")
print()

# ─── Step 1: Initialise ───
print("Step 1: Initialise particle in |Weak⟩ sector")
psi = QuantumState.weak()
print(f"  State: {psi}")
print(f"  Probs: {psi.sector_probs()}")
print()

# ─── Step 2: Apply crystal Hadamard ───
print("Step 2: Apply crystal Hadamard (DFT on ℂ⁶)")
psi = psi.hadamard()
print(f"  Probs: {[f'{p:.4f}' for p in psi.sector_probs()]}")
print(f"  Entropy: {psi.entropy():.4f}")
print()

# ─── Step 3: Time evolve ───
print("Step 3: Evolve under H = diag(0, ln2, ln3, ln6) for t=2.0")
psi = psi.evolve(2.0)
print(f"  Probs: {[f'{p:.4f}' for p in psi.sector_probs()]}")
print(f"  Entropy: {psi.entropy():.4f} (preserved — unitary evolution)")
print()

# ─── Step 4: Create two-particle entangled state ───
print("Step 4: Create maximally entangled two-particle state")
bell = QuantumState.max_entangled()
print(f"  dim(H₂) = {bell.dim()} = χ² = Σd = {sigma_d()}")
print(f"  Entanglement entropy: {bell.entanglement_entropy():.4f}")
print(f"  Max possible: {crystal_max_entropy():.4f} = ln(χ) = ln(6)")
print(f"  PPT separable: {bell.ppt_test()} (False = entangled)")
print(f"  Concurrence: {bell.concurrence():.4f}")
print()

# ─── Step 5: Evolve entangled state ───
print("Step 5: Evolve entangled state")
for t in [0.0, 1.0, 2.0, 5.0, 10.0]:
    evolved = bell.evolve(t)
    S = evolved.entanglement_entropy()
    C = evolved.concurrence()
    print(f"  t={t:5.1f}: S={S:.4f}, C={C:.4f}, PPT={evolved.ppt_test()}")
print("  (Entanglement preserved under unitary evolution)")
print()

# ─── Step 6: Creation ladder ───
print("Step 6: Creation ladder from singlet")
state = QuantumState.singlet()
labels = ["singlet", "â†→weak", "â†→colour", "â†→mixed"]
for i, label in enumerate(labels):
    if i > 0: state = state.create()
    print(f"  {label:>15}: probs = {[f'{p:.3f}' for p in state.sector_probs()]}")
print()

# ─── Step 7: Grover search ───
print("Step 7: Grover search for |Colour⟩")
uniform = QuantumState.superposition()
found = uniform.grover(2)
print(f"  P(colour) before: {uniform.prob(2):.4f}")
print(f"  P(colour) after:  {found.prob(2):.4f}")
print()

# ─── Step 8: QFT ───
print("Step 8: Quantum Fourier Transform")
qft_result = QuantumState.singlet().qft()
print(f"  QFT(|singlet⟩) probs: {[f'{p:.4f}' for p in qft_result.probs()[:6]]}")
print(f"  (Uniform: QFT turns delta into flat)")
print()

# ─── Summary ───
print("═" * 55)
print("SIMULATION COMPLETE")
print(f"  Algebra:       ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ)")
print(f"  Inputs:        N_w={n_w()}, N_c={n_c()}")
print(f"  Hilbert space: ℂ^{chi()} (single) / ℂ^{chi()**2} (two)")
print(f"  Energies:      {crystal_energies()}")
print(f"  Gate set:      U({chi()}), dim = {chi()**2}")
print(f"  Entanglement:  PPT-decidable (unique to {n_w()}×{n_c()})")
print(f"  Everything from two primes. Nothing else.")
print("═" * 55)
